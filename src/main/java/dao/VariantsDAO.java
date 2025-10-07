/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Variants;

/**
 *
 * @author USER
 */
public class VariantsDAO {

    private Connection conn;

    public VariantsDAO(Connection conn) {
        this.conn = conn;
    }

    public VariantsDAO() {
    }

    public List<Variants> getAllVariants() throws SQLException {
        List<Variants> list = new ArrayList<>();
        String sql = "SELECT * FROM variants";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int variantID = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String color = rs.getString("Color");
                String storage = rs.getString("Storage");
                double price = rs.getDouble("Price");

                // Kiểm tra DiscountPrice có null không
                Double discountPrice = (rs.getObject("DiscountPrice") != null)
                        ? rs.getDouble("DiscountPrice")
                        : null;

                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String imageUrl = rs.getString("ImageURL");

                list.add(new Variants(
                        variantID,
                        productID,
                        color,
                        storage,
                        price,
                        discountPrice,
                        stock,
                        description,
                        imageUrl
                ));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }
      public List<Variants> getAllVariantByProductID(int id) {
        String sql = "Select * from Variants where ProductID = ?";
        List<Variants> list = new ArrayList<>();
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int variantId = rs.getInt("VariantID");
                int productID = rs.getInt("ProductID");
                String color = rs.getString("Color");
                String storage = rs.getString("Storage");
                double price = rs.getDouble("Price");
                double discountPrice = rs.getDouble("DiscountPrice");
                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String img = rs.getString("ImageURL");
list.add(new Variants(variantId, productID, color, storage, price, discountPrice, stock, description, img));
            }
                    }catch(Exception e){
            System.out.println(e.getMessage());
        }
        
        return list;
    }

}
