package controller;

import dao.AddressDAO;
import dao.CartDAO;
import dao.InterestRateDAO;
import dao.OrderDAO;
import dao.OrderDetailDAO;
import dao.InstallmentDetailDAO;
import dao.CustomerDAO;
import dao.VariantsDAO;
import dao.VouchersDAO;

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
import java.time.LocalDate;

import model.Address;
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
        } else if (action != null && (action.equalsIgnoreCase("checkout") || action.equalsIgnoreCase("applyVoucher") || action.equalsIgnoreCase("removeVoucher"))) {
            List<Carts> carts = (List<Carts>) session.getAttribute("cartCheckout");

            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String addressIDRaw = request.getParameter("addressID");
            String city = (String) request.getAttribute("city");
            session.setAttribute("receiverName", receiverName);
            session.setAttribute("receiverPhone", receiverPhone);
            session.setAttribute("addressID", addressIDRaw);
            String address = (String) request.getAttribute("address");

            String saveAddress = (String) request.getAttribute("saveAddress");

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
            if (fullAddress.contains(",")) {
                city = fullAddress.substring(fullAddress.lastIndexOf(",") + 1).trim();
                address = fullAddress.substring(0, fullAddress.lastIndexOf(",")).trim();
            }

            String specificAddress = address + ", " + city;

            // --- LOGIC KIỂM TRA ĐỊA CHỈ ---
            // Chỉ kiểm tra DB nếu chưa có text địa chỉ cụ thể
            if (specificAddress == null) {
                // Thử lấy từ param
                specificAddress = request.getParameter("specificAddress");
                if (city == null) {
                    city = request.getParameter("city");
                }
                if (address == null) {
                    address = request.getParameter("address");
                }
                if (saveAddress == null) {
                    saveAddress = request.getParameter("saveAddress");
                }
            }
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

            request.setAttribute("tempTotal", tempTotal);       // Tổng gốc
            request.setAttribute("discountAmount", discountAmount); // Số tiền được giảm
            request.setAttribute("finalTotal", finalTotal); // tổng tiền thanh toán

            session.setAttribute("cartCheckout", carts);
            request.setAttribute("iRList", iRList);
            request.setAttribute("receiverName", receiverName);
            request.setAttribute("receiverPhone", receiverPhone);
            request.setAttribute("specificAddress", specificAddress);
            request.setAttribute("addressID", addressIDRaw);
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
        } else if (action != null && action.equalsIgnoreCase("removeVoucher")) {
            // 1. Xóa voucher khỏi session
            session.removeAttribute("appliedVoucher");

            // 2. Xóa các thông báo cũ (để giao diện sạch sẽ)
            session.removeAttribute("voucherMsg");

            // 4. Quan trọng: Gọi hàm này để load lại trang và tính lại tiền (về giá gốc)
            forwardCheckoutData(request, response);
            return;
        }
        if ("createOrder".equalsIgnoreCase(action)) {

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

            int userID = u.getCustomerID();
            OrderDAO oDAO = new OrderDAO();
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
            if (finalOrderPrice < 0) {
                finalOrderPrice = 0;
            }

//            double totalPrice = (totalPriceStr != null && !totalPriceStr.isEmpty())
//                    ? Double.parseDouble(totalPriceStr) : 0;

            /* ================= INSTALLMENT ================= */
            if (paymentMethod != null && paymentMethod.startsWith("INSTALLMENT_")) {

                int term = Integer.parseInt(request.getParameter("installmentTerm"));
                byte isInstalment = 1;

                InterestRateDAO iRDAO = new InterestRateDAO();
                InterestRate iR = iRDAO.getInterestRatePercentByIstalmentPeriod(term);
                // da sua cho vouhcer
                double totalIfInstalment = finalOrderPrice + ((finalOrderPrice * iR.getPercent()) / 100);

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
//                    double unitPrice = c.getVariant().getDiscountPrice()
//                            + ((c.getVariant().getDiscountPrice() * iR.getPercent()) / 100);
                    double originalItemPrice = c.getVariant().getDiscountPrice();
                    double itemPriceAfterVoucher = originalItemPrice;
                    if (appliedV != null) {
                        itemPriceAfterVoucher = originalItemPrice * (100 - appliedV.getPercentDiscount()) / 100.0;
                    }
                    double unitPrice = itemPriceAfterVoucher + ((itemPriceAfterVoucher * iR.getPercent()) / 100);
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
                // da sua cho voucher
                Order o = new Order(
                        userID,
                        paymentMethod,
                        specificAddress,
                        finalOrderPrice,
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
            session.removeAttribute("appliedVoucher");
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

        // Lấy dữ liệu từ form gửi lên
        String receiverName = request.getParameter("receiverName");
        String receiverPhone = request.getParameter("receiverPhone");
        String city = request.getParameter("city");
        String address = request.getParameter("address");
        String saveAddress = request.getParameter("saveAddress");
        String addressID = request.getParameter("addressID");
        String specificAddress = request.getParameter("specificAddress");
        request.setAttribute("addressID", addressID);

        // [FIX CHÍNH] Ghép lại thành specificAddress
        // Nếu không ghép, khi JSP load lại, ô địa chỉ sẽ bị trống (do specificAddress == null)
        if (specificAddress == null || specificAddress.isEmpty()) {
            if (address != null && city != null) {
                specificAddress = address + ", " + city;
            }
        }
        request.setAttribute("receiverName", receiverName);
        request.setAttribute("receiverPhone", receiverPhone);
        request.setAttribute("city", city);
        request.setAttribute("address", address);
        request.setAttribute("saveAddress", saveAddress);
        request.setAttribute("specificAddress", specificAddress);

        // Gọi lại doGet của chính Servlet này để tính toán lại tiền và render
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Payment Servlet";
    }
}
