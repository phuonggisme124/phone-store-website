/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import model.Customer;
import model.Users;

/**
 *
 * @author ADMIN
 */
public class UserCustomerDTO {

    private Users user;
    private Customer customer;

    public UserCustomerDTO(Users user, Customer customer) {
        this.user = user;
        this.customer = customer;
    }

    public Users getUser() {
        return user;
    }

    public void setUser(Users user) {
        this.user = user;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

}
