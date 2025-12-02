package controller;

import dao.CartDAO;
import dao.InterestRateDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.PaymentsDAO;
import dao.UsersDAO;
import dao.VariantsDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Carts;
import model.InterestRate;
import model.Order;
import model.OrderDetails;
import model.Users;
import model.Variants;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Carts cart = null;
        HttpSession session = request.getSession();
        Users u = (Users) session.getAttribute("user");

        // Trong doGet, sửa lại nhánh "buyNowFromProductDetail"
        if (action != null && action.equalsIgnoreCase("buyNowFromProductDetail")) {
            try {
                // BƯỚC 1: KIỂM TRA ĐĂNG NHẬP
                session.setAttribute("buyFrom", action);
                model.Users user = (model.Users) session.getAttribute("user");
                Integer userID = user.getUserId();
                if (userID == null) {
                    // Nếu chưa đăng nhập, bắt họ đăng nhập trước khi mua
                    response.sendRedirect("login.jsp");
                    return;
                }

                int variantID = Integer.parseInt(request.getParameter("variantID"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                VariantsDAO vDAO = new VariantsDAO();
                Variants variant = vDAO.getVariantByID(variantID);

                // BƯỚC 2: KIỂM TRA SẢN PHẨM CÓ TỒN TẠI KHÔNG
                if (variant == null) {
                    // Nếu sản phẩm không tồn tại, báo lỗi và quay về trang chủ
                    response.sendRedirect("homepage?error=product_not_found");
                    return;
                }

                cart = new Carts(userID, variant, quantity);
                cart.setCartID(userID);
                List<Carts> carts = new ArrayList<>();
                carts.add(cart);

                session.setAttribute("cartCheckout", carts);
                request.getRequestDispatcher("customer/payment.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                // BƯỚC 3: XỬ LÝ LỖI URL KHÔNG HỢP LỆ
                System.err.println("Lỗi NumberFormatException: " + e.getMessage());
                response.sendRedirect("homepage?error=invalid_parameter");
            }
        } else if (action.equalsIgnoreCase("buyNowFromCart")) {
            session.setAttribute("buyFrom", action);
            List<Carts> carts = (List<Carts>) session.getAttribute("cart");

            String idsParam = request.getParameter("selectedIds");
            List<Integer> selectedIDInt = new ArrayList<>();
            if (idsParam != null && !idsParam.isEmpty()) {
                String[] selectedIds = idsParam.split(",");
                for (String id : selectedIds) {
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

        } else {
            List<Carts> carts = (List<Carts>) session.getAttribute("cartCheckout");

            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String city = request.getParameter("city");
            String address = request.getParameter("address");
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
        if (action.equalsIgnoreCase("createOrder")) {
            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String specificAddress = request.getParameter("specificAddress");
            String totalPriceStr = request.getParameter("totalAmount");
            String paymentMethod = request.getParameter("paymentMethod");

            OrderDAO oDAO = new OrderDAO();
            Users u = (Users) session.getAttribute("user");
            int userID = u.getUserId();
            if (paymentMethod != null && paymentMethod.startsWith("INSTALLMENT_")) {
                String installmentTerm = request.getParameter("installmentTerm");
                String paymentMethodArr[] = paymentMethod.split("_");
                int term = Integer.parseInt(installmentTerm);
                byte isInstalment = 1;
                double totalPrice = 0;
                if (totalPriceStr != null && !totalPriceStr.isEmpty()) {
                    totalPrice = Double.parseDouble(totalPriceStr);
                }
                InterestRateDAO iRDAO = new InterestRateDAO();
                InterestRate iR = iRDAO.getInterestRatePercentByIstalmentPeriod(term);

                double totalPriceIfInstalment = totalPrice + ((totalPrice * iR.getPercent()) / 100);
                Order o = new Order(userID, paymentMethodArr[0], specificAddress, totalPriceIfInstalment, "Pending", isInstalment, new Users(receiverName, receiverPhone));
                PaymentsDAO pmDAO = new PaymentsDAO();

                int newOrderID = oDAO.addNewOrder(o);

                o.setOrderID(newOrderID);
                o.setOrderDate(LocalDateTime.now());
                pmDAO.insertNewPayment(o, term);
                OrderDetailDAO oDDAO = new OrderDetailDAO();

                for (Carts c : carts) {
                    double unitPriceIfInstalment = c.getVariant().getDiscountPrice() + ((c.getVariant().getDiscountPrice() * iR.getPercent()) / 100);
                    OrderDetails oD = new OrderDetails(
                            newOrderID,
                            c.getVariant().getVariantID(),
                            c.getQuantity(),
                            unitPriceIfInstalment,
                            iR.getInterestRateID(),
                            unitPriceIfInstalment / iR.getInstalmentPeriod(),
                            0,
                            iR.getPercent()
                    );
                    oDDAO.insertNewOrderDetail(oD, isInstalment);

                }

            } else {
                byte isInstalment = 0;
                double totalPrice = 0;
                if (totalPriceStr != null && !totalPriceStr.isEmpty()) {
                    totalPrice = Double.parseDouble(totalPriceStr);
                }
                Order o = new Order(userID, paymentMethod, specificAddress, totalPrice, "Pending", isInstalment, new Users(receiverName, receiverPhone));
                int newOrderID = oDAO.addNewOrder(o);
                o.setOrderID(newOrderID);
 
                OrderDetailDAO oDDAO = new OrderDetailDAO();
                for (Carts c : carts) {
                    OrderDetails oD = new OrderDetails(
                            newOrderID, 
                            c.getVariant().getVariantID(),
                            c.getQuantity(),
                            c.getVariant().getDiscountPrice()
                    );
                    oDDAO.insertNewOrderDetail(oD, isInstalment);
                }
            }
            CartDAO cartDAO = new CartDAO();
            String buyFrom = (String) session.getAttribute("buyFrom");

            if (buyFrom != null && buyFrom.equalsIgnoreCase("buyNowFromCart")) {
                for (Carts c : carts) {
                    cartDAO.removeCartItem(userID, c.getVariant().getVariantID());
                }
                
                List<Carts> updatedCart = cartDAO.getItemIntoCartByUserID(userID);
                session.setAttribute("cart", updatedCart);
            }
            UsersDAO uDAO  = new UsersDAO();
            if(u.getPhone() == null || u.getPhone().isEmpty()) {      
                uDAO.insertPhone(u.getUserId(), receiverPhone);
                u.setPhone(receiverPhone);
            }
            boolean updateAddressBasedOnAPI = "true".equals(request.getParameter("updateAddressBasedOnAPI"));
            if(u.getAddress() == null || u.getAddress().isEmpty() || updateAddressBasedOnAPI) {
                uDAO.insertAddress(userID, specificAddress);
                u.setAddress(specificAddress);
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
