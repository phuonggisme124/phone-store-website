/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.SupplierDAO;
import dao.UsersDAO;
import java.util.List;
import model.Suppliers;
import model.Users;

/**
 *
 * @author duynu
 */
public class test {

    public static void main(String[] args) {
        SupplierDAO dao = new SupplierDAO();
        List<Suppliers> list = dao.getAllSupplier();

        if (list == null) {
            System.out.println("⚠️ listSupplier is NULL — kiểm tra lại DB connection!");
            return;
        }

        if (list.isEmpty()) {
            System.out.println("⚠️ listSupplier is EMPTY — không có dữ liệu trong bảng Suppliers!");
            return;
        }

        System.out.println("✅ Lấy thành công danh sách Supplier:");
        for (Suppliers s : list) {
            System.out.println("ID: " + s.getSupplierID()
                    + " | Name: " + s.getName()
                    + " | Address: " + s.getAddress()
                    + " | Phone: " + s.getPhone());
        }
    }

}
