package controller;

import dao.AddressDAO;
import dao.CartDAO;
import dao.InterestRateDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.InstallmentDetailDAO;
import dao.CustomerDAO;
import dao.VariantsDAO;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Address;
import model.Carts;
import model.InterestRate;
import model.Order;
import model.OrderDetails;
import model.Customer;
import model.Variants;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Customer u = (Customer) session.getAttribute("user");

        if (u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        AddressDAO aDAO = new AddressDAO();

        /* ================= LOAD ADDRESS LIST ================= */
        List<Address> addresses = aDAO.getAddressList(u.getCustomerID());
        Address defaultAddress = null;
        List<Address> otherAddresses = new ArrayList<>();

        if (addresses != null) {
            for (Address a : addresses) {
                if (a.isDefault()) {
                    defaultAddress = a;
                } else {
                    otherAddresses.add(a);
                }
            }
        }

        if (defaultAddress == null && !otherAddresses.isEmpty()) {
            defaultAddress = otherAddresses.remove(0);
        }

        request.setAttribute("defaultAddress", defaultAddress);
        request.setAttribute("otherAddresses", otherAddresses);

        /* ================= BUY NOW FROM PRODUCT DETAIL ================= */
        if ("buyNowFromProductDetail".equalsIgnoreCase(action)) {
            try {
                session.setAttribute("buyFrom", action);

                int variantID = Integer.parseInt(request.getParameter("variantID"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                VariantsDAO vDAO = new VariantsDAO();
                Variants variant = vDAO.getVariantByID(variantID);

                if (variant == null) {
                    response.sendRedirect("homepage?error=product_not_found");
                    return;
                }

                Carts cart = new Carts(u.getCustomerID(), variant, quantity);
                cart.setCartID(u.getCustomerID());

                List<Carts> carts = new ArrayList<>();
                carts.add(cart);

                session.setAttribute("cartCheckout", carts);
                request.getRequestDispatcher("customer/payment.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                response.sendRedirect("homepage?error=invalid_parameter");
            }

            /* ================= BUY NOW FROM CART ================= */
        } else if ("buyNowFromCart".equalsIgnoreCase(action)) {

            session.setAttribute("buyFrom", action);
            List<Carts> carts = (List<Carts>) session.getAttribute("cart");

            String idsParam = request.getParameter("selectedIds");
            List<Integer> selectedIDInt = new ArrayList<>();

            if (idsParam != null && !idsParam.isEmpty()) {
                for (String id : idsParam.split(",")) {
                    selectedIDInt.add(Integer.valueOf(id));
                }
            }

            List<Carts> cartSelectedItemsList = new ArrayList<>();
            if (carts != null) {
                for (Carts c : carts) {
                    if (selectedIDInt.contains(c.getVariant().getVariantID())) {
                        cartSelectedItemsList.add(c);
                    }
                }
            }

            session.setAttribute("cartCheckout", cartSelectedItemsList);
            request.getRequestDispatcher("customer/payment.jsp").forward(request, response);

            /* ================= CHECKOUT ================= */
        } else if ("checkout".equalsIgnoreCase(action)) {

            List<Carts> carts = (List<Carts>) session.getAttribute("cartCheckout");

            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String addressIDRaw = request.getParameter("addressID");
            session.setAttribute("receiverName", receiverName);
            session.setAttribute("receiverPhone", receiverPhone);
            session.setAttribute("addressID", addressIDRaw);
            if (receiverPhone == null || receiverPhone.trim().isEmpty()) {
                request.setAttribute("error", "Phone number is required");
                request.getRequestDispatcher("customer/payment.jsp").forward(request, response);
                return;
            }

            if (addressIDRaw == null || addressIDRaw.isEmpty()) {
                request.setAttribute("error", "Please select a shipping address");
                request.getRequestDispatcher("customer/payment.jsp").forward(request, response);
                return;
            }

            int addressID = Integer.parseInt(addressIDRaw);
            Address selectedAddress = aDAO.getAddressByID(addressID);

            if (selectedAddress == null) {
                request.setAttribute("error", "Invalid address selected");
                request.getRequestDispatcher("customer/payment.jsp").forward(request, response);
                return;
            }

            /* ===== TÁCH ADDRESS & CITY (GIỮ LOGIC CŨ) ===== */
            String fullAddress = selectedAddress.getAddress();
            String city = "";
            String address = fullAddress;

            if (fullAddress.contains(",")) {
                city = fullAddress.substring(fullAddress.lastIndexOf(",") + 1).trim();
                address = fullAddress.substring(0, fullAddress.lastIndexOf(",")).trim();
            }

            String specificAddress = address + ", " + city;

            InterestRateDAO iRDAO = new InterestRateDAO();
            List<InterestRate> iRList = iRDAO.getInInterestRate();

            session.setAttribute("cartCheckout", carts);
            request.setAttribute("iRList", iRList);
            request.setAttribute("receiverName", receiverName);
            request.setAttribute("receiverPhone", receiverPhone);
            request.setAttribute("specificAddress", specificAddress);

            request.getRequestDispatcher("customer/payment_checkout.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        List<Carts> carts = (List<Carts>) session.getAttribute("cartCheckout");

        if ("createOrder".equalsIgnoreCase(action)) {

            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String specificAddress = request.getParameter("specificAddress");
            String totalPriceStr = request.getParameter("totalAmount");
            String paymentMethod = request.getParameter("paymentMethod");

            if (receiverPhone == null || receiverPhone.trim().isEmpty()) {
                request.setAttribute("error", "Phone number is required");
                request.getRequestDispatcher("customer/payment_checkout.jsp").forward(request, response);
                return;
            }

            Customer u = (Customer) session.getAttribute("user");
            int userID = u.getCustomerID();
            OrderDAO oDAO = new OrderDAO();

            double totalPrice = (totalPriceStr != null && !totalPriceStr.isEmpty())
                    ? Double.parseDouble(totalPriceStr) : 0;

            /* ================= INSTALLMENT ================= */
            if (paymentMethod != null && paymentMethod.startsWith("INSTALLMENT_")) {

                int term = Integer.parseInt(request.getParameter("installmentTerm"));
                byte isInstalment = 1;

                InterestRateDAO iRDAO = new InterestRateDAO();
                InterestRate iR = iRDAO.getInterestRatePercentByIstalmentPeriod(term);

                double totalIfInstalment = totalPrice + ((totalPrice * iR.getPercent()) / 100);

                Order o = new Order(
                        userID,
                        paymentMethod.split("_")[0],
                        specificAddress,
                        totalIfInstalment,
                        "Pending",
                        isInstalment,
                        new Customer(receiverName, receiverPhone)
                );

                InstallmentDetailDAO pmDAO = new InstallmentDetailDAO();

                int newOrderID = oDAO.addNewOrder(o);
                o.setOrderID(newOrderID);
                o.setOrderDate(LocalDateTime.now());

                pmDAO.insertNewPayment(o, term, iR.getInterestRateID());

                OrderDetailDAO oDDAO = new OrderDetailDAO();
                for (Carts c : carts) {
                    double unitPrice = c.getVariant().getDiscountPrice()
                            + ((c.getVariant().getDiscountPrice() * iR.getPercent()) / 100);

                    OrderDetails oD = new OrderDetails(
                            newOrderID,
                            c.getVariant().getVariantID(),
                            c.getQuantity(),
                            unitPrice
                    );
                    oDDAO.insertNewOrderDetail(oD);
                }

                /* ================= NORMAL PAYMENT ================= */
            } else {

                byte isInstalment = 0;

                Order o = new Order(
                        userID,
                        paymentMethod,
                        specificAddress,
                        totalPrice,
                        "Pending",
                        isInstalment,
                        new Customer(receiverName, receiverPhone)
                );

                int newOrderID = oDAO.addNewOrder(o);

                OrderDetailDAO oDDAO = new OrderDetailDAO();
                for (Carts c : carts) {
                    OrderDetails oD = new OrderDetails(
                            newOrderID,
                            c.getVariant().getVariantID(),
                            c.getQuantity(),
                            c.getVariant().getDiscountPrice()
                    );
                    oDDAO.insertNewOrderDetail(oD);
                }
            }

            /* ================= CLEAR CART ================= */
            CartDAO cartDAO = new CartDAO();
            String buyFrom = (String) session.getAttribute("buyFrom");

            if ("buyNowFromCart".equalsIgnoreCase(buyFrom)) {
                for (Carts c : carts) {
                    cartDAO.removeItem(userID, c.getVariant().getVariantID());
                }
                session.setAttribute("cart", cartDAO.getCartByCustomerID(userID));
            }

            /* ================= UPDATE USER PHONE ================= */
            CustomerDAO uDAO = new CustomerDAO();
            if ((u.getPhone() == null || u.getPhone().isEmpty())
                    && receiverPhone != null && !receiverPhone.trim().isEmpty()) {
                uDAO.updatePhone(userID, receiverPhone.trim());
                u.setPhone(receiverPhone.trim());
            }

            session.removeAttribute("cartCheckout");
            session.removeAttribute("buyFrom");

            request.getRequestDispatcher("homepage").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Payment Servlet";
    }
}