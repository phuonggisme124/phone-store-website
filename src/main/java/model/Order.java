package model;

import java.time.LocalDateTime;

/**
 * LỚP MODEL ORDER (ĐÃ VIẾT LẠI TỪ ĐẦU)
 * Khớp chính xác với cấu trúc database (ảnh image_8f1bdb.png).
 * Đã sửa lỗi UnsupportedOperationException và các kiểu dữ liệu NULL.
 * VẪN GIỮ CÁC CONSTRUCTOR CŨ để không làm hỏng PaymentServlet.
 */
public class Order {

    // --- 1. CÁC TRƯỜNG KHỚP VỚI CỘT DATABASE ---
    // (Dựa trên image_8f1bdb.png)
    
    private int orderID;                 // int (Primary Key, Not Null)
    private Integer userID;              // int (Allow Nulls -> Integer)
    private LocalDateTime orderDate;     // datetime (Allow Nulls -> LocalDateTime)
    private String status;               // nvarchar(20) (Allow Nulls -> String)
    private String paymentMethod;        // nvarchar(20) (Allow Nulls -> String)
    private String shippingAddress;      // nvarchar(255) (Allow Nulls -> String)
    private double totalAmount;          // decimal(15, 2) (Not Null -> double)
    private Boolean isInstalment;        // bit (Allow Nulls -> Boolean)
    private String receiverName;         // nvarchar(50) (Allow Nulls -> String)
    private String receiverPhone;        // nvarchar(50) (Allow Nulls -> String)
    private Integer staffID;             // int (Allow Nulls -> Integer)
    private Integer shipperID;           // int (Allow Nulls -> Integer)


    // --- 2. CÁC TRƯỜNG QUAN HỆ (ĐỂ JOIN) ---
    private Customer buyer;    // Đối tượng User (Khách hàng)
    private Customer shippers; // Đối tượng User (Shipper)
    
    // --- 3. TRƯỜNG CŨ (BỊ DƯ, TỪ CODE CŨ CỦA BẠN) ---
    // (Chúng ta giữ lại để các constructor cũ không bị lỗi)

    private int interestRateID;
    private String buyerName; // Tên cũ của ReceiverName
    private String buyerPhone; // Tên cũ của ReceiverPhone


    // --- 4. CONSTRUCTORS ---
    
    /**
     * Constructor rỗng (mặc định)
     */
    public Order() {
    }

    /**
     * * @param orderID
     * @param userID
     * @param orderDate
     * @param status
     * @param paymentMethod
     * @param shippingAddress
     * @param totalAmount
     * @param isInstalment
     * @param receiverName
     * @param receiverPhone
     * @param staffID
     * @param shipperID 
     */
    public Order(int orderID, Integer userID, LocalDateTime orderDate, String status,
                   String paymentMethod, String shippingAddress, double totalAmount,
                   Boolean isInstalment, String receiverName, String receiverPhone,
                   Integer staffID, Integer shipperID) {
        this.orderID = orderID;
        this.userID = userID;
        this.orderDate = orderDate;
        this.status = status;
        this.paymentMethod = paymentMethod;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.isInstalment = isInstalment;
        this.receiverName = receiverName;
        this.receiverPhone = receiverPhone;
        this.staffID = staffID;
        this.shipperID = shipperID;
    }

    // --- CÁC CONSTRUCTOR CŨ (ĐÃ SỬA LỖI) ---
    // (Giữ lại để không làm hỏng DAO cũ và PaymentServlet)

    /**
     * SỬA LỖI (Thay thế cho constructor 6 tham số bị lỗi)
     * Dùng cho mapResultSetToProduct
     */
    public Order(int orderID, Customer buyer, String shippingAddress, double totalAmount, String status, LocalDateTime orderDate) {
        this.orderID = orderID;
        this.buyer = buyer;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.status = status;
        this.orderDate = orderDate;
    }

    /**
     * (Giữ nguyên - Dùng cho Staff)
     */
    public Order(int orderID, Customer buyer, Customer shippers, String shippingAddress, double totalAmount, LocalDateTime orderDate, String status) {
        this.orderID = orderID;
        this.buyer = buyer;
        this.shippers = shippers;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.status = status;
        this.orderDate = orderDate;
    }

    /**
     * SỬA LỖI (Thay thế cho constructor 10 tham số)
     * (Dùng cho Admin DAO cũ)
     */
    public Order(int orderID, int userID, String paymentMethod, String shippingAddress, double totalAmount, String status, LocalDateTime orderDate, byte isInstalment, String buyerName, String buyerPhone) {
        this.orderID = orderID;
        this.userID = userID;
        this.paymentMethod = paymentMethod;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.status = status;
        this.orderDate = orderDate;
        this.isInstalment = (isInstalment == 1); // Chuyển byte sang boolean
        this.receiverName = buyerName;   // Ánh xạ tên cũ
        this.receiverPhone = buyerPhone; // Ánh xạ tên cũ
    }


    /**
     * (Giữ nguyên - Dùng cho PaymentServlet)
     */
    public Order(int userID, String paymentMethod, String shippingAddress, double totalAmount, String status, byte isInstalment, Customer buyer) {
        this.userID = userID;
        this.paymentMethod = paymentMethod;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.status = status;
        this.isInstalment = (isInstalment == 1); // Chuyển byte sang boolean
        this.buyer = buyer;
        // Gán luôn ReceiverName/Phone (nếu PaymentServlet cần)
        if(buyer != null){
            this.receiverName = buyer.getFullName();
            this.receiverPhone = buyer.getPhone();
        }
    }

    /**
     * SỬA LỖI (Thay thế cho constructor 9 tham số bị lỗi)
     * (Dùng cho Customer DAO cũ - getOrdersByStatus)
     */
    public Order(int userID, int oderID, String paymentMethod, String shippingAddress, double totalAmount, String status, byte isInstalment, LocalDateTime orderDate, Customer buyer) {
        this.userID = userID;
        this.orderID = oderID;
        this.paymentMethod = paymentMethod;
        this.shippingAddress = shippingAddress;
        this.totalAmount = totalAmount;
        this.status = status;
        this.isInstalment = (isInstalment == 1); // Chuyển byte sang boolean
        this.orderDate = orderDate;
        this.buyer = buyer;
        
        if (buyer != null) {
            this.receiverName = buyer.getFullName();
            this.receiverPhone = buyer.getPhone();
        }
    }


    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public Integer getUserID() {
        return userID;
    }

    public void setUserID(Integer userID) {
        this.userID = userID;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Boolean getIsInstalment() {
        return isInstalment;
    }

    public void setIsInstalment(Boolean isInstalment) {
        this.isInstalment = isInstalment;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getReceiverPhone() {
        return receiverPhone;
    }

    public void setReceiverPhone(String receiverPhone) {
        this.receiverPhone = receiverPhone;
    }

// --- SỬA LẠI 2 HÀM NÀY ĐỂ TRÁNH LỖI NULL POINTER ---

    public int getStaffID() {
        // Nếu staffID là null thì trả về 0, ngược lại trả về giá trị thực
        return (staffID == null) ? 0 : staffID;
    }

    public void setStaffID(Integer staffID) {
        this.staffID = staffID;
    }

    public int getShipperID() {
        // Nếu shipperID là null thì trả về 0
        return (shipperID == null) ? 0 : shipperID;
    }

    public void setShipperID(Integer shipperID) {
        this.shipperID = shipperID;
    }

    // Getters/Setters cho các đối tượng quan hệ
    
    public Customer getBuyer() {
        return buyer;
    }

    public void setBuyer(Customer buyer) {
        this.buyer = buyer;
    }

    public Customer getShippers() {
        return shippers;
    }

    public void setShippers(Customer shippers) {
        this.shippers = shippers;
    }
    
    // Getters/Setters cho các trường cũ (để không hỏng code cũ)

    public String getBuyerName() {
        return this.receiverName; // Ánh xạ
    }

    public void setBuyerName(String buyerName) {
        this.receiverName = buyerName; // Ánh xạ
    }

    public String getBuyerPhone() {
        return this.receiverPhone; // Ánh xạ
    }

    public void setBuyerPhone(String buyerPhone) {
        this.receiverPhone = buyerPhone; // Ánh xạ
    }
    
    public int getInterestRateID() {
        return interestRateID;
    }

    public void setInterestRateID(int interestRateID) {
        this.interestRateID = interestRateID;
    }
}