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
        // Create a VariantsDAO instance to access the database
        VariantsDAO dao = new VariantsDAO();

        // Predefined test data 
        int productID = 3;
        String storage = "128GB";
        String color = "blue";

        // Fetch all variants with the given product ID and storage capacity
        List<Variants> vr = dao.getAllVariantByStorage(productID, storage);

        // Check if the retrieved list is not null and not empty
        if (vr != null && !vr.isEmpty()) {
            // Loop through each variant and print its details to the console
            for (Variants v : vr) {
                System.out.println("Variant found!--------");
                System.out.println("Variant ID: " + v.getVariantID());
                System.out.println("Product ID: " + v.getProductID());
                System.out.println("Color: " + v.getColor());
                System.out.println("Storage: " + v.getStorage());
                System.out.println("Price: " + v.getPrice());
                System.out.println("Discount Price: " + v.getDiscountPrice());
                System.out.println("Stock: " + v.getStock());
                System.out.println("Description: " + v.getDescription());
                System.out.println("Image URL: " + v.getImageUrl());
            }

        } else {
            // If no variant matches the search conditions
            System.out.println("No matching variant found!");
        }

    }
}
