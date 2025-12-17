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

            /* ================= CHECKOUT / PREPARE PAYMENT PAGE ================= */
        } else if (action != null && (action.equalsIgnoreCase("checkout") || action.equalsIgnoreCase("applyVoucher") || action.equalsIgnoreCase("removeVoucher"))) {
            List<Carts> carts = (List<Carts>) session.getAttribute("cartCheckout");

            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String addressIDRaw = request.getParameter("addressID");
            String city = (String) request.getAttribute("city");
            
            // Lưu tạm vào session để không bị mất khi reload
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

            /* ===== TÁCH ADDRESS & CITY ===== */
            String fullAddress = selectedAddress.getAddress();
            if (fullAddress.contains(",")) {
                city = fullAddress.substring(fullAddress.lastIndexOf(",") + 1).trim();
                address = fullAddress.substring(0, fullAddress.lastIndexOf(",")).trim();
            }

            String specificAddress = address + ", " + city;

            // --- LOGIC KIỂM TRA ĐỊA CHỈ TỪ PARAM NẾU CÓ ---
            if (specificAddress == null) {
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
            
            // 2. Lấy voucher từ Session
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

            // 4. Lấy danh sách voucher của User để hiển thị
            if (u != null) {
                VouchersDAO vDAO = new VouchersDAO();
                List<Vouchers> myVouchers = vDAO.getVouchersByCustomerID(u.getCustomerID());
                request.setAttribute("myVouchers", myVouchers);
            }

            request.setAttribute("tempTotal", tempTotal);       // Tổng gốc
            request.setAttribute("discountAmount", discountAmount); // Số tiền được giảm
            request.setAttribute("finalTotal", finalTotal); // Tổng tiền thanh toán

            session.setAttribute("cartCheckout", carts);
            request.setAttribute("iRList", iRList);
            request.setAttribute("receiverName", receiverName);
            request.setAttribute("receiverPhone", receiverPhone);
            request.setAttribute("specificAddress", specificAddress);
            request.setAttribute("addressID", addressIDRaw);
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

        // ================= XỬ LÝ APPLY VOUCHER ================= 
        if (action != null && action.equalsIgnoreCase("applyVoucher")) {
            String code = request.getParameter("voucherCode");
            VouchersDAO vDAO = new VouchersDAO();
            LocalDate today = LocalDate.now();

            String msg = "";
            Vouchers v = vDAO.getVoucherByCode(code);

            // Check 1: Voucher tồn tại không?
            if (v == null) {
                msg = "Voucher code does not exist!";
                session.removeAttribute("appliedVoucher");
            } 
            // Check 2: Status
            else if (!"Active".equalsIgnoreCase(v.getStatus())) {
                msg = "This voucher program has been stopped!";
                session.removeAttribute("appliedVoucher");
            } 
            // Check 3: Quantity
            else if (v.getQuantity() <= 0) {
                msg = "Opps! This voucher is fully redeemed (Out of stock)!";
                session.removeAttribute("appliedVoucher");
            } 
            // Check 4: Date
            else if (today.isBefore(v.getStartDay().toLocalDate())) {
                msg = "This voucher is not active yet!";
                session.removeAttribute("appliedVoucher");
            } else if (today.isAfter(v.getEndDay().toLocalDate())) {
                msg = "Voucher has expired!";
                session.removeAttribute("appliedVoucher");
            } 
            // Check 5: Khách đã lưu chưa / đã dùng chưa?
            else {
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
                    msg = "Your voucher is not valid to use.";
                    session.removeAttribute("appliedVoucher");
                }
            }

            request.setAttribute("voucherMsg", msg);
            forwardCheckoutData(request, response);
            return;
        } 
        
        // ================= XỬ LÝ REMOVE VOUCHER ================= 
        else if (action != null && action.equalsIgnoreCase("removeVoucher")) {
            session.removeAttribute("appliedVoucher");
            session.removeAttribute("voucherMsg");
            forwardCheckoutData(request, response);
            return;
        }

        // ================= XỬ LÝ TẠO ĐƠN HÀNG (CREATE ORDER) ================= 
        if ("createOrder".equalsIgnoreCase(action)) {

            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String specificAddress = request.getParameter("specificAddress");
            String paymentMethod = request.getParameter("paymentMethod");
            // String saveAddress = request.getParameter("saveAddress"); // Dùng nếu muốn lưu địa chỉ mặc định

            if (receiverPhone == null || receiverPhone.trim().isEmpty()) {
                request.setAttribute("error", "Phone number is required");
                forwardCheckoutData(request, response);
                return;
            }

            int userID = u.getCustomerID();
            OrderDAO oDAO = new OrderDAO();
            
            // 1. TÍNH LẠI TIỀN (Server-Side Calculation)
            double finalOrderPrice = 0; // Giá gốc chưa giảm
            if (carts != null) {
                for (Carts c : carts) {
                    finalOrderPrice += c.getVariant().getDiscountPrice() * c.getQuantity();
                }
            }

            // 2. ÁP DỤNG VOUCHER (NẾU CÓ)
            Vouchers appliedV = (Vouchers) session.getAttribute("appliedVoucher");
            if (appliedV != null) {
                VouchersDAO vDAO = new VouchersDAO();
                boolean voucherUsedSuccess = vDAO.useVoucher(appliedV.getVoucherID(), u.getCustomerID());

                if (voucherUsedSuccess) {
                    // Trừ tiền tổng đơn hàng
                    double discount = finalOrderPrice * appliedV.getPercentDiscount() / 100.0;
                    finalOrderPrice = finalOrderPrice - discount;
                } else {
                    request.setAttribute("error", "Rất tiếc! Voucher này vừa hết lượt sử dụng.");
                    forwardCheckoutData(request, response);
                    return;
                }
            }
            if (finalOrderPrice < 0) {
                finalOrderPrice = 0;
            }

            /* ================= TRƯỜNG HỢP 1: TRẢ GÓP (INSTALLMENT) ================= */
            if (paymentMethod != null && paymentMethod.startsWith("INSTALLMENT_")) {

                int term = Integer.parseInt(request.getParameter("installmentTerm"));
                byte isInstalment = 1;

                InterestRateDAO iRDAO = new InterestRateDAO();
                InterestRate iR = iRDAO.getInterestRatePercentByIstalmentPeriod(term);
                
                // Tính tổng tiền sau lãi (Dựa trên giá đã trừ voucher)
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

                // INSERT INSTALLMENT DETAILS
                pmDAO.insertNewPayment(o, term, iR.getInterestRateID());

                OrderDetailDAO oDDAO = new OrderDetailDAO();
                for (Carts c : carts) {
                    // Logic: Giá gốc -> Trừ Voucher -> Cộng Lãi
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

            /* ================= TRƯỜNG HỢP 2: THANH TOÁN THƯỜNG ================= */
            } else {

                byte isInstalment = 0;
                
                Order o = new Order(
                        userID,
                        paymentMethod,
                        specificAddress,
                        finalOrderPrice, // Giá chốt (đã trừ voucher)
                        "Pending",
                        isInstalment,
                        new Customer(receiverName, receiverPhone)
                );

                int newOrderID = oDAO.addNewOrder(o);

                OrderDetailDAO oDDAO = new OrderDetailDAO();
                for (Carts c : carts) {
                    // Logic: Giá gốc -> Trừ Voucher
                    double unitPrice = c.getVariant().getDiscountPrice();
                    
                    if (appliedV != null) {
                        unitPrice = unitPrice * (100 - appliedV.getPercentDiscount()) / 100.0;
                    }

                    OrderDetails oD = new OrderDetails(
                            newOrderID,
                            c.getVariant().getVariantID(),
                            c.getQuantity(),
                            unitPrice
                    );
                    oDDAO.insertNewOrderDetail(oD);
                }
            }

            /* ================= CLEAR CART & UPDATE PHONE ================= */
            CartDAO cartDAO = new CartDAO();
            String buyFrom = (String) session.getAttribute("buyFrom");

            if ("buyNowFromCart".equalsIgnoreCase(buyFrom)) {
                for (Carts c : carts) {
                    cartDAO.removeItem(userID, c.getVariant().getVariantID());
                }
                session.setAttribute("cart", cartDAO.getCartByCustomerID(userID));
            }

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
     * Hàm hỗ trợ: Giữ lại thông tin giao hàng khi reload
     */
    private void forwardCheckoutData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String receiverName = request.getParameter("receiverName");
        String receiverPhone = request.getParameter("receiverPhone");
        String city = request.getParameter("city");
        String address = request.getParameter("address");
        String saveAddress = request.getParameter("saveAddress");
        String addressID = request.getParameter("addressID");
        String specificAddress = request.getParameter("specificAddress");
        
        request.setAttribute("addressID", addressID);

        // Ghép lại thành specificAddress nếu bị null
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

        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Payment Servlet";
    }
}
