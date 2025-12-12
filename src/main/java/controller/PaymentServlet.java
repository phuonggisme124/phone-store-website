package controller;

import dao.CartDAO;
import dao.InterestRateDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.PaymentsDAO;
import dao.CustomerDAO;
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

        if (action != null && action.equalsIgnoreCase("buyNowFromProductDetail")) {
            // ... (Giữ nguyên logic buyNowFromProductDetail cũ) ...
            try {
                session.setAttribute("buyFrom", action);
                if (u == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }
                Integer userID = u.getCustomerID();
                int variantID = Integer.parseInt(request.getParameter("variantID"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                VariantsDAO vDAO = new VariantsDAO();
                Variants variant = vDAO.getVariantByID(variantID);

                if (variant == null) {
                    response.sendRedirect("homepage?error=product_not_found");
                    return;
                }

                Carts cart = new Carts(userID, variant, quantity);
                cart.setCartID(userID);
                List<Carts> carts = new ArrayList<>();
                carts.add(cart);

                session.setAttribute("cartCheckout", carts);
                request.getRequestDispatcher("customer/payment.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                System.err.println("Lỗi NumberFormatException: " + e.getMessage());
                response.sendRedirect("homepage?error=invalid_parameter");
            }
            
        } else if (action != null && action.equalsIgnoreCase("buyNowFromCart")) {
            // ... (Giữ nguyên logic buyNowFromCart cũ) ...
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

        } else if (action != null && action.equalsIgnoreCase("checkout")) {
            // --- PHẦN NÀY ĐÃ ĐƯỢC SỬA ---
            List<Carts> carts = (List<Carts>) session.getAttribute("cartCheckout");

            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String city = request.getParameter("city");
            String address = request.getParameter("address");
            // 1. Lấy biến saveAddress từ form
            String saveAddress = request.getParameter("saveAddress"); 

            if (receiverPhone == null || receiverPhone.trim().isEmpty()) {
                request.setAttribute("error", "Phone number is required");
                request.getRequestDispatcher("customer/payment.jsp").forward(request, response);
                return;
            }
            
            if (city == null || city.trim().isEmpty()) {
                request.setAttribute("error", "Please select province/city");
                request.getRequestDispatcher("customer/payment.jsp").forward(request, response);
                return;
            }
            
            if (address == null || address.trim().isEmpty()) {
                request.setAttribute("error", "Specific address is required");
                request.getRequestDispatcher("customer/payment.jsp").forward(request, response);
                return;
            }
            
            String specificAddress = address.trim() + ", " + city.trim();
            InterestRateDAO iRDAO = new InterestRateDAO();
            List<InterestRate> iRList = iRDAO.getInInterestRate();

            session.setAttribute("cartCheckout", carts);
            request.setAttribute("iRList", iRList);
            request.setAttribute("receiverName", receiverName);
            request.setAttribute("receiverPhone", receiverPhone);
            request.setAttribute("specificAddress", specificAddress);
            // 2. Truyền biến saveAddress sang trang checkout (để giữ trạng thái checkbox)
            request.setAttribute("saveAddress", saveAddress); 

            request.getRequestDispatcher("customer/payment_checkout.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        List<Carts> carts = (List<Carts>) session.getAttribute("cartCheckout");
        
        if (action != null && action.equalsIgnoreCase("createOrder")) {
            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String specificAddress = request.getParameter("specificAddress");
            String totalPriceStr = request.getParameter("totalAmount");
            String paymentMethod = request.getParameter("paymentMethod");
            // 3. Nhận lại biến saveAddress từ trang checkout (cần input hidden bên JSP)
            String saveAddress = request.getParameter("saveAddress"); 

            if (receiverPhone == null || receiverPhone.trim().isEmpty()) {
                request.setAttribute("error", "Phone number is required");
                request.getRequestDispatcher("customer/payment_checkout.jsp").forward(request, response);
                return;
            }
            
            if (specificAddress == null || specificAddress.trim().isEmpty()) {
                request.setAttribute("error", "Address is required");
                request.getRequestDispatcher("customer/payment_checkout.jsp").forward(request, response);
                return;
            }

            OrderDAO oDAO = new OrderDAO();
            Customer u = (Customer) session.getAttribute("user");
            int userID = u.getCustomerID();
            
            // --- XỬ LÝ THANH TOÁN (Giữ nguyên) ---
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
                Order o = new Order(userID, paymentMethodArr[0], specificAddress, totalPriceIfInstalment, "Pending", isInstalment, new Customer(receiverName, receiverPhone));
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
                
                Order o = new Order(userID, paymentMethod, specificAddress, totalPrice, "Pending", isInstalment, new Customer(receiverName, receiverPhone));
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

            // --- XỬ LÝ GIỎ HÀNG (Giữ nguyên) ---
            CartDAO cartDAO = new CartDAO();
            String buyFrom = (String) session.getAttribute("buyFrom");

            if (buyFrom != null && buyFrom.equalsIgnoreCase("buyNowFromCart")) {
                for (Carts c : carts) {
                    cartDAO.removeItem(userID, c.getVariant().getVariantID());
                }
                List<Carts> updatedCart = cartDAO.getCartByCustomerID(userID);
                session.setAttribute("cart", updatedCart);
            }

            // --- XỬ LÝ CẬP NHẬT THÔNG TIN USER (LOGIC MỚI) ---
            CustomerDAO uDAO = new CustomerDAO();
            boolean userInfoUpdated = false;

            // TRƯỜNG HỢP 1: Người dùng CHỦ ĐỘNG tick "Lưu địa chỉ"
            if ("true".equals(saveAddress)) {
                // Cập nhật địa chỉ (nếu khác địa chỉ cũ)
                if (specificAddress != null && !specificAddress.trim().isEmpty()) {
                    if (u.getAddress() == null || !specificAddress.trim().equals(u.getAddress().trim())) {
                        uDAO.updateAddress(userID, specificAddress.trim());
                        u.setAddress(specificAddress.trim());
                        userInfoUpdated = true;
                    }
                }
                // Cập nhật SĐT (nếu khác SĐT cũ)
                if (receiverPhone != null && !receiverPhone.trim().isEmpty()) {
                    if (u.getPhone() == null || !receiverPhone.trim().equals(u.getPhone().trim())) {
                        uDAO.updatePhone(u.getCustomerID(), receiverPhone.trim());
                        u.setPhone(receiverPhone.trim());
                        userInfoUpdated = true;
                    }
                }
            } 
            // TRƯỜNG HỢP 2: Không tick lưu, nhưng hồ sơ đang TRỐNG (cập nhật tự động lần đầu cho tiện)
            else {
                // Nếu User chưa có địa chỉ -> Tự động lưu
                if ((u.getAddress() == null || u.getAddress().isEmpty()) &&
                    specificAddress != null && !specificAddress.trim().isEmpty()) {
                    uDAO.updateAddress(userID, specificAddress.trim());
                    u.setAddress(specificAddress.trim());
                    userInfoUpdated = true;
                }
                
                // Nếu User chưa có SĐT -> Tự động lưu
                if ((u.getPhone() == null || u.getPhone().isEmpty()) && 
                    receiverPhone != null && !receiverPhone.trim().isEmpty()) {
                    uDAO.updatePhone(u.getCustomerID(), receiverPhone.trim());
                    u.setPhone(receiverPhone.trim());
                    userInfoUpdated = true;
                }
            }
            
            if (userInfoUpdated) {
                session.setAttribute("user", u);
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