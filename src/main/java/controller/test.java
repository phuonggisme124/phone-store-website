/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.OrderDAO;
import dao.PromotionsDAO;
import dao.SupplierDAO;
import dao.UsersDAO;
import dao.VariantsDAO;
import java.util.List;
import model.Order;
import model.Promotions;
import model.Sale;
import model.Suppliers;
import model.Users;
import model.Variants;

/**
 *
 * @author duynu
 */
public class test {

    public static void main(String[] args) {
        // Khởi tạo DAO
        OrderDAO odao = new OrderDAO();
        UsersDAO udao = new UsersDAO();

        // Lấy dữ liệu
        List<Order> listOrder = odao.getAllOrders();
        List<Users> listUsers = udao.getAllUsers();
        List<Sale> listSales = udao.getAllSales();
        
        // In ra để kiểm tra
        System.out.println("===== 🧾 DANH SÁCH ORDERS =====");
        for (Order o : listOrder) {
            System.out.println("OrderID: " + o.getOrderID() + 
                               " | UserID: " + o.getUserID() + 
                               " | Total: " + o.getTotalAmount() + 
                               " | Instalment: " + o.isIsInstallment());
        }

        System.out.println("\n===== 👤 DANH SÁCH USERS =====");
        for (Users u : listUsers) {
            System.out.println("UserID: " + u.getUserId()+ 
                               " | Name: " + u.getFullName() + 
                               " | Role: " + u.getRole());
        }

        System.out.println("\n===== 💸 DANH SÁCH SALES =====");
        for (Sale s : listSales) {
            System.out.println("SaleID: " + s.getSaleID() + 
                               " | Order: " + s.getOrderID()+ 
                               " | Staff: " + s.getStaffID());
        }
    }
}
