package model;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author USER
 */
public class Suppliers {
    private int suppliersID;
    private String name;
    private String phone;
    private String email;
    private String address;

    public Suppliers() {
    }

    public Suppliers(int suppliersID, String name, String phone, String email, String address) {
        this.suppliersID = suppliersID;
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.address = address;
    }

    public int getSuppliersID() {
        return suppliersID;
    }

    public void setSuppliersID(int suppliersID) {
        this.suppliersID = suppliersID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Override
    public String toString() {
        return "Suppliers{" + "suppliersID=" + suppliersID + ", name=" + name + ", phone=" + phone + ", email=" + email + ", address=" + address + '}';
    }
    
    
}
