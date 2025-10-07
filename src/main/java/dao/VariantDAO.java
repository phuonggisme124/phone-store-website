/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Products;
import model.Variants;
import utils.DBContext;

/**
 *
 * @author duynu
 */
public class VariantDAO extends DBContext{

    public VariantDAO() {
    }

    public List<Variants> getAllVariant() {
        String sql = "Select * from Products";
        List<Variants> list = new ArrayList<>();
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("ProductID");
                int productID = rs.getInt("ProductID");
                String color = rs.getString("Color");
                String storage = rs.getString("Storage");
                double price = rs.getDouble("Price");
                double discountPrice = rs.getDouble("DiscountPrice");
                int stock = rs.getInt("Stock");
                String description = rs.getString("Description");
                String img = rs.getString("ImageURL");
                
                           
                list.add(new Variants(id, productID, color, storage, price, discountPrice, stock, description, img));
            }
                    }catch(Exception e){
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
