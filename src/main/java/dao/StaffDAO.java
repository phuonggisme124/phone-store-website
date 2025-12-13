/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.security.MessageDigest;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Staff;
import utils.DBContext;

/**
 *
 * @author ADMIN
 */

public class StaffDAO extends DBContext {


    public StaffDAO() {
        super();
    }

    // ==============================

    private Staff map(ResultSet rs) throws SQLException {
        return new Staff(
                rs.getInt("StaffID"),
                rs.getString("FullName"),
                rs.getString("Email"),
                rs.getString("Phone"),
                rs.getString("Password"),
                rs.getInt("Role"),
                rs.getString("Status"),
                rs.getTimestamp("CreatedAt")

        );
    }

    // ==============================
    // Password MD5
    public String md5(String pass) {
        try {
            MessageDigest m = MessageDigest.getInstance("MD5");
            byte[] digest = m.digest(pass.getBytes());
            StringBuilder sb = new StringBuilder();

            for (byte b : digest) sb.append(String.format("%02x", b));

            return sb.toString();
        } catch (Exception e) {
            return "";
        }
    }

    // ==============================
    // LOGIN STAFF (email + password)
    public Staff login(String email, String password) {

        String sql = "SELECT * FROM Staff WHERE Email = ? AND Password = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, md5(password));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return map(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null; // login failed
    }

    // ==============================
    // Lấy staff theo email
    public Staff getStaffByEmail(String email) {
        String sql = "SELECT * FROM Staff WHERE Email = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();


            if (rs.next()) return map(rs);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ==============================
    // Lấy staff theo ID
    public Staff getStaffByID(int id) {
        String sql = "SELECT * FROM Staff WHERE StaffID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();


            if (rs.next()) return map(rs);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    public List<Staff> getAllShippers() {
        String sql = "SELECT *\n"
                + "  FROM [PhoneStore].[dbo].[Staff]\n"
                + "  Where Role = 3";
        List<Staff> list = new ArrayList<>();

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int staffID = rs.getInt("StaffID");
                String fullName = rs.getString("FullName");
                String email = rs.getString("Email");
                String phone = rs.getString("Phone");
                String password = rs.getString("Password");
                int role = rs.getInt("Role");
                String status = rs.getString("Status");
                Timestamp createAt = rs.getTimestamp("CreatedAt");
                list.add(new Staff(staffID, fullName, email, phone, password, role, status, createAt));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public List<Staff> getAllStaff() {
        String sql = "SELECT *\n"
                + "  FROM [PhoneStore].[dbo].[Staff]\n"
                + "  Where Role = 2";
        List<Staff> list = new ArrayList<>();

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int staffID = rs.getInt("StaffID");
                String fullName = rs.getString("FullName");
                String email = rs.getString("Email");
                String phone = rs.getString("Phone");
                String password = rs.getString("Password");
                int role = rs.getInt("Role");
                String status = rs.getString("Status");
                Timestamp createAt = rs.getTimestamp("CreatedAt");
                list.add(new Staff(staffID, fullName, email, phone, password, role, status, createAt));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

    public List<Staff> getAllStaffs() {
        String sql = "SELECT *\n"
                + "  FROM [PhoneStore].[dbo].[Staff]\n";
        List<Staff> list = new ArrayList<>();

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int staffID = rs.getInt("StaffID");
                String fullName = rs.getString("FullName");
                String email = rs.getString("Email");
                String phone = rs.getString("Phone");
                String password = rs.getString("Password");
                int role = rs.getInt("Role");
                String status = rs.getString("Status");
                Timestamp createAt = rs.getTimestamp("CreatedAt");
                list.add(new Staff(staffID, fullName, email, phone, password, role, status, createAt));
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return list;
    }

}
