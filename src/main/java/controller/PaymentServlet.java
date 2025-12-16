package controller;

import dao.CartDAO;
import dao.InterestRateDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.PaymentsDAO;
import dao.CustomerDAO;
import dao.VariantsDAO;
import dao.VouchersDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Carts;
import model.InterestRate;
import model.Order;
import model.OrderDetails;
import model.Customer;
import model.Variants;
import model.Vouchers;

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

        } else if (action != null && (action.equalsIgnoreCase("checkout") || action.equalsIgnoreCase("applyVoucher") || action.equalsIgnoreCase("removeVoucher"))) {
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
            // 1. Tính tổng tiền hàng tạm tính
            double tempTotal = 0;
            if (carts != null) {
                for (Carts c : carts) {
                    tempTotal += c.getVariant().getDiscountPrice() * c.getQuantity();
                }
            }
            // 2. Lấy voucher
            Vouchers appliedVoucher = (Vouchers) session.getAttribute("appliedVoucher");
            double discountAmount = 0;
            double finalTotal = tempTotal;
            // 3. Kiểm tra tính hợp lệ của Voucher
            if (appliedVoucher != null) {
                VouchersDAO vDAO = new VouchersDAO();
                Vouchers checkV = vDAO.getVoucherByCode(appliedVoucher.getCode());
                LocalDate today = LocalDate.now();

                // Logic: Phải tìm thấy + Còn số lượng + Ngày hiện tại nằm trong khoảng Start/End
                if (checkV != null && checkV.getQuantity() > 0
                        && !today.isBefore(checkV.getStartDay().toLocalDate())
                        && !today.isAfter(checkV.getEndDay().toLocalDate())) {

                    // Tính tiền giảm giá
                    discountAmount = tempTotal * checkV.getPercentDiscount() / 100.0;
                    finalTotal = tempTotal - discountAmount;
                } else {
                    // Nếu voucher hết hạn hoặc hết số lượng -> Xóa khỏi session
                    session.removeAttribute("appliedVoucher");
                }
            }
            
            // lấy list voucher
            if (u != null) {
                VouchersDAO vDAO = new VouchersDAO();
                // Hàm này bạn đã viết ở bước trước trong VouchersDAO
                // Nó trả về List<Vouchers> join với bảng VoucherCustomers
                List<Vouchers> myVouchers = vDAO.getVouchersByCustomerID(u.getCustomerID());
                request.setAttribute("myVouchers", myVouchers);
            }
            request.setAttribute("tempTotal", tempTotal);
            request.setAttribute("tempTotal", tempTotal);       // Tổng gốc
            request.setAttribute("discountAmount", discountAmount); // Số tiền được giảm
            request.setAttribute("finalTotal", finalTotal); // tổng tiền thanh toán

            session.setAttribute("cartCheckout", carts);
            request.setAttribute("iRList", iRList);
            request.setAttribute("receiverName", receiverName);
            request.setAttribute("receiverPhone", receiverPhone);
            request.setAttribute("specificAddress", specificAddress);
            // 2. Truyền biến saveAddress sang trang checkout (để giữ trạng thái checkbox)
            request.setAttribute("saveAddress", saveAddress);
            request.setAttribute("city", city);
            request.setAttribute("address", address);

            request.getRequestDispatcher("customer/payment_checkout.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        List<Carts> carts = (List<Carts>) session.getAttribute("cartCheckout");
        Customer u = (Customer) session.getAttribute("user");
        // XỬ LÝ NÚT APPLY VÀ REMOVE VOUCHER 
        if (action != null && action.equalsIgnoreCase("applyVoucher")) {
            String code = request.getParameter("voucherCode");
            VouchersDAO vDAO = new VouchersDAO();
            LocalDate today = LocalDate.now();

            String msg = "";

            // 1. Lấy thông tin Voucher gốc (Global)
            Vouchers v = vDAO.getVoucherByCode(code);

            // --- CHECK 1: VOUCHER GỐC CÓ HỢP LỆ KHÔNG? ---
            if (v == null) {
                msg = "Voucher code does not exist!";
                session.removeAttribute("appliedVoucher");
            } // Kiểm tra trạng thái Voucher gốc (Do Admin khóa)
            else if (!"Active".equalsIgnoreCase(v.getStatus())) {
                msg = "This voucher program has been stopped!";
                session.removeAttribute("appliedVoucher");
            } // Kiểm tra số lượng còn lại (Logic: Quantity là số lượng còn lại trong kho)
            else if (v.getQuantity() <= 0) {
                msg = "Opps! This voucher is fully redeemed (Out of stock)!";
                session.removeAttribute("appliedVoucher");
            } // Kiểm tra ngày hiệu lực
            else if (today.isBefore(v.getStartDay().toLocalDate())) {
                msg = "This voucher is not active yet!";
                session.removeAttribute("appliedVoucher");
            } else if (today.isAfter(v.getEndDay().toLocalDate())) {
                msg = "Voucher has expired!";
                session.removeAttribute("appliedVoucher");
            } // --- CHECK 2: KHÁCH HÀNG ĐÃ LƯU VÀ CHƯA DÙNG? ---
            else {

                // Gọi hàm DAO mới viết ở trên
                String userStatus = vDAO.getUserVoucherStatus(v.getVoucherID(), u.getCustomerID());

                if (userStatus == null) {
                    msg = "You haven't saved this voucher yet!";
                    session.removeAttribute("appliedVoucher");
                } else if ("Used".equalsIgnoreCase(userStatus)) {
                    msg = "You have already used this voucher!";
                    session.removeAttribute("appliedVoucher");
                } else if ("Active".equalsIgnoreCase(userStatus)) {
                    // --- THÀNH CÔNG ---
                    session.setAttribute("appliedVoucher", v);
                    msg = "Applied successfully!";
                } else {
                    // Trường hợp status lạ (Expired, Locked...)
                    msg = "Your voucher is not valid to use.";
                    session.removeAttribute("appliedVoucher");
                }
            }

            request.setAttribute("voucherMsg", msg);
            forwardCheckoutData(request, response);
            return;
        }

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
            int userID = u.getCustomerID();
            //  TÍNH LẠI TIỀN VÀ TRỪ SỐ LƯỢNG VOUCHER 
            double finalOrderPrice = 0; // Biến giá chốt cuối cùng

            // 1. Tính lại tổng gốc từ giỏ hàng (Server-side calculation)
            if (carts != null) {
                for (Carts c : carts) {
                    finalOrderPrice += c.getVariant().getDiscountPrice() * c.getQuantity();
                }
            }

            // 2. Áp dụng giảm giá (nếu có)
            Vouchers appliedV = (Vouchers) session.getAttribute("appliedVoucher");
            boolean voucherUsedSuccess = false;
            if (appliedV != null) {
                VouchersDAO vDAO = new VouchersDAO();

                voucherUsedSuccess = vDAO.useVoucher(appliedV.getVoucherID(), u.getCustomerID());

                if (voucherUsedSuccess) {
                    // Trừ tiền
                    double discount = finalOrderPrice * appliedV.getPercentDiscount() / 100.0;
                    finalOrderPrice = finalOrderPrice - discount;
                    // ... Tiếp tục tạo đơn hàng
                } else {
                    // Nếu hàm trả về false -> Nghĩa là vừa hết hàng xong
                    request.setAttribute("error", "Rất tiếc! Voucher này vừa hết lượt sử dụng.");
                    forwardCheckoutData(request, response);
                    return;
                }
            }

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
                // QUAN TRỌNG: Sử dụng finalOrderPrice (đã trừ voucher) để lưu vào DB
                Order o = new Order(userID, paymentMethod, specificAddress, finalOrderPrice, "Pending", isInstalment, new Customer(receiverName, receiverPhone));
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
            } // TRƯỜNG HỢP 2: Không tick lưu, nhưng hồ sơ đang TRỐNG (cập nhật tự động lần đầu cho tiện)
            else {
                // Nếu User chưa có địa chỉ -> Tự động lưu
                if ((u.getAddress() == null || u.getAddress().isEmpty())
                        && specificAddress != null && !specificAddress.trim().isEmpty()) {
                    uDAO.updateAddress(userID, specificAddress.trim());
                    u.setAddress(specificAddress.trim());
                    userInfoUpdated = true;
                }

                // Nếu User chưa có SĐT -> Tự động lưu
                if ((u.getPhone() == null || u.getPhone().isEmpty())
                        && receiverPhone != null && !receiverPhone.trim().isEmpty()) {
                    uDAO.updatePhone(u.getCustomerID(), receiverPhone.trim());
                    u.setPhone(receiverPhone.trim());
                    userInfoUpdated = true;
                }
            }

            if (userInfoUpdated) {
                session.setAttribute("user", u);
            }
            session.removeAttribute("appliedVoucher");
            session.removeAttribute("discountAmount");
            session.removeAttribute("voucherMsg");
            session.removeAttribute("cartCheckout");
            session.removeAttribute("buyFrom");
            request.getRequestDispatcher("homepage").forward(request, response);
        }
    }

    /**
     * Hàm hỗ trợ: Giữ lại thông tin giao hàng (Tên, SĐT, Đ/c) mà khách đã nhập
     * khi trang web reload (sau khi bấm Apply/Remove Voucher). Tránh việc khách
     * hàng phải nhập lại thông tin từ đầu.
     */
    private void forwardCheckoutData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ form gửi lên và set lại vào request để hiển thị lại
        request.setAttribute("receiverName", request.getParameter("receiverName"));
        request.setAttribute("receiverPhone", request.getParameter("receiverPhone"));
        request.setAttribute("city", request.getParameter("city"));
        request.setAttribute("address", request.getParameter("address"));
        request.setAttribute("saveAddress", request.getParameter("saveAddress"));

        // Gọi lại doGet của chính Servlet này để render lại trang
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Payment Servlet";
    }
}
