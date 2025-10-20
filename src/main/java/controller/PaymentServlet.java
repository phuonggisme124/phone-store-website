package controller;

import dao.CartDAO;
import dao.InterestRateDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.VariantsDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.CartItems;
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
        HttpSession session;

        // Trong doGet, sửa lại nhánh "buyNowFromProductDetail"
        if (action != null && action.equalsIgnoreCase("buyNowFromProductDetail")) {
            try {
                session = request.getSession();

                // BƯỚC 1: KIỂM TRA ĐĂNG NHẬP
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

                // Nếu mọi thứ ổn, tiếp tục tạo cart
                Carts cartCheckout = new Carts();
                cartCheckout.setCartID(userID); // Giờ userID chắc chắn không null

                CartItems cartItem = new CartItems(variant);
                cartItem.setQuantity(quantity);
                List<CartItems> cartItemsList = new ArrayList<>();
                cartItemsList.add(cartItem);
                cartCheckout.setListCartItems(cartItemsList);

                session.setAttribute("cartCheckout", cartCheckout);
                request.getRequestDispatcher("payment.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                // BƯỚC 3: XỬ LÝ LỖI URL KHÔNG HỢP LỆ
                System.err.println("Lỗi NumberFormatException: " + e.getMessage());
                response.sendRedirect("homepage?error=invalid_parameter");
            }
        } else if (action.equalsIgnoreCase("buyNowFromCart")) {
            session = request.getSession();
            cart = (Carts) session.getAttribute("cart");
            Carts cartSelectedItems = new Carts();

            if (cart != null) {
                cartSelectedItems.setCartID(cart.getCartID());
            }

            String idsParam = request.getParameter("selectedIds");
            List<Integer> selectedIDInt = new ArrayList<>();
            if (idsParam != null && !idsParam.isEmpty()) {
                String[] selectedIds = idsParam.split(",");
                for (String id : selectedIds) {
                    selectedIDInt.add(Integer.valueOf(id));
                }
            }
            List<CartItems> cartSelectedItemsList = new ArrayList<>();
            if (cart != null) {
                for (CartItems ci : cart.getListCartItems()) {
                    if (selectedIDInt.contains(ci.getVariants().getVariantID())) {
                        cartSelectedItemsList.add(ci);
                    }
                }
            }
            cartSelectedItems.setListCartItems(cartSelectedItemsList);

            // Lưu vào cartCheckout, KHÔNG ghi đè cart gốc
            session.setAttribute("cartCheckout", cartSelectedItems);

            request.getRequestDispatcher("payment.jsp").forward(request, response);

        } else {
            session = request.getSession();
            cart = (Carts) session.getAttribute("cartCheckout");
            request.setAttribute("cart", cart);

            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String city = request.getParameter("city");
            String address = request.getParameter("address");
            String specificAddress = address + ", " + city;
            InterestRateDAO iRDAO = new InterestRateDAO();
            List<InterestRate> iRList = iRDAO.getInInterestRate();

            request.setAttribute("iRList", iRList);
            request.setAttribute("receiverName", receiverName);
            request.setAttribute("receiverPhone", receiverPhone);
            request.setAttribute("specificAddress", specificAddress);

            request.getRequestDispatcher("payment_checkout.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action.equalsIgnoreCase("createOrder")) {
            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String specificAddress = request.getParameter("specificAddress");
            String totalPriceStr = request.getParameter("totalAmount");
            String paymentMethod = request.getParameter("paymentMethod");
            HttpSession session = request.getSession();
            Carts cart = (Carts) session.getAttribute("cartCheckout");
            OrderDAO oDAO = new OrderDAO();
            int userID = cart.getCartID();
            if (paymentMethod != null && paymentMethod.startsWith("INSTALLMENT_")) {
                String installmentTerm = request.getParameter("installmentTerm");
                int term = Integer.parseInt(installmentTerm);
                byte isInstalment = 1;
                double totalPrice = 0;
                if (totalPriceStr != null && !totalPriceStr.isEmpty()) {
                    totalPrice = Double.parseDouble(totalPriceStr);
                }

                InterestRateDAO iRDAO = new InterestRateDAO();
                
                
                InterestRate iR = iRDAO.getInterestRatePercentByIstalmentPeriod(term);
                double totalPriceIfInstalment = totalPrice + ((totalPrice * iR.getPercent()) / 100);
                // Thêm OrderDetails với OrderID MỚI TẠO
                Order o = new Order(userID, "COD", specificAddress, totalPriceIfInstalment, "Pending", isInstalment, new Users(receiverName, receiverPhone));
                int newOrderID = oDAO.addNewOrder(o);
                o.setOrderID(newOrderID);
                OrderDetailDAO oDDAO = new OrderDetailDAO();
                if (iR != null) {
                    for (CartItems ci : cart.getListCartItems()) {
                        // SỬA QUAN TRỌNG: Dùng newOrderID thay vì userID
                        double unitPriceIfInstalment = ci.getVariants().getDiscountPrice() + ((ci.getVariants().getDiscountPrice() * iR.getPercent()) / 100);
                        OrderDetails oD = new OrderDetails(
                                newOrderID, // OrderID mới tạo (VD: 156, 157, 158...)
                                ci.getVariants().getVariantID(),
                                ci.getQuantity(),
                                unitPriceIfInstalment,
                                iR.getInstalmentPeriod(),
                                unitPriceIfInstalment / iR.getInstalmentPeriod(),
                                0,
                                iR.getPercent()
                        );
                        oDDAO.insertNewOrderDetail(oD, isInstalment);
                    }
                }

            } else {
                byte isInstalment = 0;
                double totalPrice = 0;
                if (totalPriceStr != null && !totalPriceStr.isEmpty()) {
                    totalPrice = Double.parseDouble(totalPriceStr);
                }

                // SỬA: Lấy từ cartCheckout thay vì cart
                // Tạo Order và LẤY OrderID được tự động sinh
                Order o = new Order(userID, "COD", specificAddress, totalPrice, "Pending", isInstalment, new Users(receiverName, receiverPhone));

                int newOrderID = oDAO.addNewOrder(o);
                o.setOrderID(newOrderID);
                // Thêm OrderDetails với OrderID MỚI TẠO
                OrderDetailDAO oDDAO = new OrderDetailDAO();
                for (CartItems ci : cart.getListCartItems()) {
                    // SỬA QUAN TRỌNG: Dùng newOrderID thay vì userID
                    OrderDetails oD = new OrderDetails(
                            newOrderID, // OrderID mới tạo (VD: 156, 157, 158...)
                            ci.getVariants().getVariantID(),
                            ci.getQuantity(),
                            ci.getVariants().getDiscountPrice()
                    );
                    oDDAO.insertNewOrderDetail(oD, isInstalment);
                }
            }
            CartDAO cartDAO = new CartDAO();
            for (CartItems ci : cart.getListCartItems()) {
                cartDAO.removeCartItem(userID, ci.getVariants().getVariantID());
            }

            cart.setListCartItems(cartDAO.getItemIntoCartByUserID(userID));
            session.setAttribute("cart", cart);
            session.removeAttribute("cartCheckout");

            response.sendRedirect("homepage");
        }
    }

    @Override
    public String getServletInfo() {
        return "Payment Servlet";
    }
}
