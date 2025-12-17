package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Address;
import utils.DBContext;

public class AddressDAO extends DBContext {

    public List<Address> getAddressList(int customerID) {
        String sql = "SELECT * FROM Addresses WHERE CustomerID = ?";
        List<Address> addresses = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                addresses.add(new Address(
                        rs.getInt("AddressID"),
                        customerID,
                        rs.getString("Address"),
                        rs.getBoolean("isDefault")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return addresses;
    }

    public void removeDefaultAddress(int customerID) {
        String sql = "UPDATE Addresses SET isDefault = 0 WHERE CustomerID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean insertAddress(Address a) {
        if (a.isDefault()) {
            removeDefaultAddress(a.getCustomerID());
        }
        String sql = "INSERT INTO Addresses (CustomerID, Address, isDefault) VALUES (?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, a.getCustomerID());
            ps.setString(2, a.getAddress());
            ps.setBoolean(3, a.isDefault());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAddress(Address a) {
        if (a.isDefault()) {
            removeDefaultAddress(a.getCustomerID());
        }
        String sql = "UPDATE Addresses SET Address = ?, isDefault = ? WHERE AddressID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, a.getAddress());
            ps.setBoolean(2, a.isDefault());
            ps.setInt(3, a.getAddressID());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteAddress(int addressID) {
        String sql = "DELETE FROM Addresses WHERE AddressID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, addressID);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Address getAddressByID(int addressID) {
        String sql = "SELECT * FROM Addresses WHERE AddressID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, addressID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Address(
                        addressID,
                        rs.getInt("CustomerID"),
                        rs.getString("Address"),
                        rs.getBoolean("isDefault")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public static void main(String[] args) {
        AddressDAO dao = new AddressDAO();
        
        // 1. CÀI ĐẶT ID KHÁCH HÀNG ĐỂ TEST (Đổi số này thành ID user có thật trong DB)
        int TEST_CUSTOMER_ID = 1; 

        System.out.println("========== BẮT ĐẦU TEST ==========");

        // --- TEST 1: LẤY DANH SÁCH BAN ĐẦU ---
        System.out.println("\n1. Danh sách địa chỉ ban đầu:");
        printAddressList(dao, TEST_CUSTOMER_ID);

        // --- TEST 2: THÊM MỚI (INSERT) ---
        // Thử thêm một địa chỉ làm mặc định (isDefault = true)
        System.out.println("\n2. Thêm địa chỉ mới '123 Đường Test, Hà Nội' (Đặt làm mặc định):");
        // ID để là 0 vì vào DB sẽ tự tăng, isDefault = true
        Address newAddr = new Address(0, TEST_CUSTOMER_ID, "123 Đường Test, Hà Nội", true);
        boolean insertResult = dao.insertAddress(newAddr);
        System.out.println("Kết quả thêm: " + (insertResult ? "Thành công" : "Thất bại"));
        
        // In lại để xem địa chỉ cũ có bị mất default không
        System.out.println("-> Danh sách sau khi thêm:");
        printAddressList(dao, TEST_CUSTOMER_ID);

        // --- TEST 3: LẤY ĐỊA CHỈ VỪA THÊM ĐỂ UPDATE/DELETE ---
        // (Vì ta không biết ID tự tăng là bao nhiêu, nên phải query lại để tìm)
        List<Address> list = dao.getAddressList(TEST_CUSTOMER_ID);
        Address addressToTest = null;
        // Lấy địa chỉ cuối cùng trong danh sách (thường là cái vừa thêm)
        if (!list.isEmpty()) {
            addressToTest = list.get(list.size() - 1); 
        }

        if (addressToTest != null) {
            // --- TEST 4: GET BY ID ---
            System.out.println("\n3. Test GetByID với ID = " + addressToTest.getAddressID());
            Address foundAddr = dao.getAddressByID(addressToTest.getAddressID());
            System.out.println("Tìm thấy: " + (foundAddr != null ? foundAddr.getAddress() : "Không thấy"));

            // --- TEST 5: UPDATE ---
            System.out.println("\n4. Test Update: Đổi tên thành '456 Đường Đã Sửa' và bỏ mặc định");
            addressToTest.setAddress("456 Đường Đã Sửa, TP.HCM");
            addressToTest.setIsDefault(false); // Bỏ mặc định
            
            boolean updateResult = dao.updateAddress(addressToTest);
            System.out.println("Kết quả update: " + (updateResult ? "Thành công" : "Thất bại"));
            
            System.out.println("-> Danh sách sau khi sửa:");
            printAddressList(dao, TEST_CUSTOMER_ID);

            // --- TEST 6: DELETE ---
            System.out.println("\n5. Test Delete: Xóa địa chỉ ID = " + addressToTest.getAddressID());
            boolean deleteResult = dao.deleteAddress(addressToTest.getAddressID());
            System.out.println("Kết quả xóa: " + (deleteResult ? "Thành công" : "Thất bại"));
            
            System.out.println("-> Danh sách sau khi xóa (Phải mất dòng 456 Đường Đã Sửa):");
            printAddressList(dao, TEST_CUSTOMER_ID);
        } else {
            System.out.println("Lỗi: Không tìm thấy địa chỉ nào để test sửa/xóa.");
        }
        
        System.out.println("\n========== KẾT THÚC TEST ==========");
    }

    // Hàm phụ để in danh sách cho gọn
    private static void printAddressList(AddressDAO dao, int customerID) {
        List<Address> list = dao.getAddressList(customerID);
        if (list.isEmpty()) {
            System.out.println("   (Danh sách rỗng)");
        } else {
            for (Address a : list) {
                System.out.println("   - ID: " + a.getAddressID() 
                        + " | " + a.getAddress() 
                        + " | Default: " + a.isDefault());
            }
        }
    }
}



