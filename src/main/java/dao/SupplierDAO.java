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

    public Suppliers getSupplierByID(int supplierID) {
        String sql = "SELECT * FROM Suppliers where SupplierID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, supplierID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("SupplierID");
                String name = rs.getString("Name");
                
                String phone = rs.getString("Phone");
                String email = rs.getString("Email");
                String address = rs.getString("Address");

                return (new Suppliers(id, name, phone, email, address));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public void updateSupplier(int sID, String name, String phone, String email, String address) {
        String sql = "UPDATE Suppliers\n"
                + "SET Name = ?,\n"
                + "    Phone = ?,\n"
                + "    Email = ?,\n"
                + "	Address = ?\n"
                + "WHERE SupplierID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, address);
            ps.setInt(5, sID);
            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void createSupplier(String name, String phone, String email, String address) {
        String sql = "INSERT INTO Suppliers (Name, Phone, Email, Address) "
                + "VALUES (?, ?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            
            ps.setString(4, address);

            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void deleteSupplier(int sID) {
        String sql = "DELETE FROM Suppliers\n"
                + "WHERE SupplierID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, sID);

            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
            
        }
    }
    
}
