/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.UsersDAO;
import java.util.List;
import model.Users;

/**
 *
 * @author duynu
 */
public class test {

    public static void main(String[] args) {
        UsersDAO udao = new UsersDAO();
        List<Users> listUsers = udao.getAllUsers();
        Users u = udao.getUserByID(1);
        if (u == null) {
            System.out.println("❌ Không có user nào trong database!");
        } else {
            System.out.println("✅ Danh sách người dùng:");

            System.out.println(
                    "ID: " + u.getUserId()
                    + " | Name: " + u.getFullName()
                    + " | Email: " + u.getEmail()
            );

        }
    }
}
