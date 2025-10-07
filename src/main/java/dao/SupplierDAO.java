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
import model.Suppliers;
import utils.DBContext;

/**
 *
 * @author duynu
 */
public class SupplierDAO extends DBContext{

    public SupplierDAO() {
    }

    public List<Suppliers> getAllSupplier() {
        String sql = "Select * from Suppliers";
        List<Suppliers> list = new ArrayList<>();
        try{
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("SupplierID");
                
                String name = rs.getString("Name");
                String phone = rs.getString("Phone");
                String email = rs.getString("Email");
                String address = rs.getString("Address");
                
                
                
                
                list.add(new Suppliers(id, name, phone, email, address));
            }
            
        }catch(Exception e){
            System.out.println(e.getMessage());
        }
        
        return list;
    }
    
}
