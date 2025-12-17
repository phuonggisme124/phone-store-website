package model;

import java.sql.Timestamp;
import java.sql.Date;
import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;

public class Customer {

    private int customerID;
    private String fullName;
    private String email;
    private String phone;
    private String password;
    private String address;
    private Timestamp createdAt;
    private String status;
    private String cccd;
    private Date yob;
    private int point;

    public Customer() {
    }

    // Full constructor
    public Customer(int customerID, String fullName, String email, String phone, String password,
            String address, Timestamp createdAt, String status,
            String cccd, Date yob, int point) {
        this.customerID = customerID;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.address = address;
        this.createdAt = createdAt;
        this.status = status;
        this.cccd = cccd;
        this.yob = yob;
        this.point = point;
    }

    // Constructor dùng cho dropdown hoặc select list
    public Customer(int customerID, String fullName, String phone) {
        this.customerID = customerID;
        this.fullName = fullName;
        this.phone = phone;
    }

    public Customer(String name, String phone) {
        this.fullName = name;
        this.phone = phone;
    }

    // ===================== GETTERS & SETTERS =====================
    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCccd() {
        return cccd;
    }

    public void setCccd(String cccd) {
        this.cccd = cccd;
    }

    public Date getYob() {
        return yob;
    }

public int getAge() {
        if (yob == null) {
            return 0;
        }
        LocalDate birthDate = new java.sql.Date(yob.getTime()).toLocalDate();
        LocalDate currentDate = LocalDate.now();
        return Period.between(birthDate, currentDate).getYears();
    }

    public void setYob(Date yob) {
        this.yob = yob;
    }

    public int getPoint() {
        return point;
    }

    public void setPoint(int point) {
        this.point = point;
    }

    // Customers luôn mặc định role = 1
    public int getRole() {
        return 1;
    }

    @Override
    public String toString() {
        return "Customer{"
                + "customerID=" + customerID
                + ", fullName='" + fullName + '\''
                + ", email='" + email + '\''
                + ", phone='" + phone + '\''
                + ", password='***'"
                + ", address='" + address + '\''
                + ", createdAt=" + createdAt
                + ", status='" + status + '\''
                + ", cccd='" + cccd + '\''
                + ", yob=" + yob
                + ", point=" + point
                + '}';
    }
}
