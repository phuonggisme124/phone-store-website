/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Suppliers;
import utils.DBContext;

/**
 * @author duynu
 * 
 * This class provides data access methods for managing supplier records.
 * It handles CRUD operations (Create, Read, Update, Delete) on the Suppliers table.
 */
public class SupplierDAO extends DBContext {

    /**
     * Default constructor initializing the database connection.
     */
    public SupplierDAO() {
        super();
    }

    /**
     * Retrieves all suppliers from the database.
     *
     * @return A list containing all supplier records.
     */
    public List<Suppliers> getAllSupplier() {
        String sql = "Select * from Suppliers";
        List<Suppliers> list = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            // Iterate through the result set and build supplier objects
            while (rs.next()) {
                int id = rs.getInt("SupplierID");
                String name = rs.getString("Name");
                String phone = rs.getString("Phone");
                String email = rs.getString("Email");
                String address = rs.getString("Address");

                // Add each supplier to the list
                list.add(new Suppliers(id, name, phone, email, address));
            }

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    /**
     * Retrieves a supplier by its unique ID.
     *
     * @param supplierID The ID of the supplier to find.
     * @return A Suppliers object if found, otherwise null.
     */
    public Suppliers getSupplierByID(int supplierID) {
        String sql = "SELECT * FROM Suppliers where SupplierID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, supplierID);
            ResultSet rs = ps.executeQuery();

            // If a record exists, build a supplier object
            if (rs.next()) {
                int id = rs.getInt("SupplierID");
                String name = rs.getString("Name");
                String phone = rs.getString("Phone");
                String email = rs.getString("Email");
                String address = rs.getString("Address");

                return new Suppliers(id, name, phone, email, address);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     * Updates the information of an existing supplier.
     *
     * @param sID The supplier's ID.
     * @param name The updated supplier name.
     * @param phone The updated phone number.
     * @param email The updated email address.
     * @param address The updated address.
     */
    public void updateSupplier(int sID, String name, String phone, String email, String address) {
        String sql = "UPDATE Suppliers\n"
                + "SET Name = ?,\n"
                + "    Phone = ?,\n"
                + "    Email = ?,\n"
                + "    Address = ?\n"
                + "WHERE SupplierID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            // Set updated field values
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, address);
            ps.setInt(5, sID);

            // Execute the update query
            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    /**
     * Creates a new supplier record in the database.
     *
     * @param name Supplier name.
     * @param phone Supplier phone number.
     * @param email Supplier email address.
     * @param address Supplier address.
     */
    public void createSupplier(String name, String phone, String email, String address) {
        String sql = "INSERT INTO Suppliers (Name, Phone, Email, Address) "
                + "VALUES (?, ?, ?, ?)";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            // Insert new supplier information
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

    /**
     * Deletes a supplier from the database based on its ID.
     *
     * @param sID The ID of the supplier to be deleted.
     */
    public void deleteSupplier(int sID) {
        String sql = "DELETE FROM Suppliers\n"
                + "WHERE SupplierID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);

            // Set the supplier ID to delete
            ps.setInt(1, sID);

            // Execute the delete operation
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
