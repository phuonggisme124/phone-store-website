/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import model.Profit;
import model.Variants;
import utils.DBContext;

/**
 *
 * @author
 */
public class ProfitDAO extends DBContext {

    public ProfitDAO() {
        super();
    }

    public void createProfit(int currentVariantID, Double discountPrice, double cost, int stock) {
        String sql = "INSERT INTO Profits (VariantID, Quantity, SellingPrice, CostPrice) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, currentVariantID);
            ps.setInt(2, stock);
            ps.setDouble(3, discountPrice);
            ps.setDouble(4, cost);

            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public int getMaxProfitID(int VariantID) {
        String sql = "SELECT MAX(ProfitID) AS ProfitID\n"
                + "FROM Profits\n"
                + "Where VariantID = ?";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, VariantID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("ProfitID");
                return id;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public void updateSellPriceByVariantID(int currentVariantID) {
        VariantsDAO vdao = new VariantsDAO();
        Variants variant = vdao.getVariantByID(currentVariantID);
        LocalDateTime now = LocalDateTime.now();
        int monthValue = now.getMonthValue();
        int yearValue = now.getYear();
        int profitID = getMaxProfitID(currentVariantID);

        Profit profit = getProfitByID(profitID);

        if (profit != null) {
            int monthProfit = profit.getCalculatedDate().getMonthValue();
            int yearProfit = profit.getCalculatedDate().getYear();
            System.out.println("Tháng của profit có VariantID = " + currentVariantID + " là: " + monthProfit);
            System.out.println("Năm của profit có VariantID = " + currentVariantID + " là: " + yearProfit);
            if (monthProfit == monthValue && yearProfit == yearValue) {
                if (variant.getDiscountPrice() != profit.getSellingPrice()) {
                    updateSelling(variant.getDiscountPrice(), variant.getVariantID(), profit.getCalculatedDate(), profit.getQuantity(), profit.getCostPrice(), profitID);
                }

            } 

        } else {
            System.out.println("khong update duoc");
        }

    }

    public Profit getProfitByID(int profitID) {
        String sql = "SELECT * FROM Profits where ProfitID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, profitID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int pfID = rs.getInt("ProfitID");
                int variantID = rs.getInt("VariantID");
                int quantity = rs.getInt("quantity");

                double sell = rs.getDouble("SellingPrice");
                double cost = rs.getDouble("CostPrice");
                Timestamp calculatedDateTimestamp = rs.getTimestamp("CalculatedDate");
                LocalDateTime calculatedDate = (calculatedDateTimestamp != null)
                        ? calculatedDateTimestamp.toLocalDateTime()
                        : null;

                return new Profit(pfID, variantID, quantity, sell, cost, calculatedDate);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    public void updateSelling(Double discountPrice, int variantID, LocalDateTime calculatedDate, int quantity, double costPrice, int profitID) {
        int quantitySold = getQuantitySoldOfVariant(variantID, calculatedDate);
        LocalDateTime now = LocalDateTime.now();
        int monthValue = now.getMonthValue();
        int yearValue = now.getYear();

        int monthProfit = calculatedDate.getMonthValue();
        int yearProfit = calculatedDate.getYear();
        System.out.println("tháng trong updateSelling: " + monthProfit);
        System.out.println("Năm trong updateSelling: " + yearProfit);
        if (monthProfit == monthValue && yearProfit == yearValue) {
            System.out.println("cùng tháng cùng năm ");
            if (quantitySold != 0) {
                int newQuantity = quantity - quantitySold;
                String sql = "UPDATE Profits\n"
                        + "SET Quantity = ?\n"
                        + "Where ProfitID = ?;";

                try {
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, quantitySold);
                    ps.setInt(2, profitID);

                    ps.executeUpdate();

                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }

                createProfit(variantID, discountPrice, costPrice, newQuantity);
            } else {
                String sql = "UPDATE Profits\n"
                        + "SET SellingPrice = ?\n"
                        + "Where ProfitID = ?;";

                try {
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setDouble(1, discountPrice);
                    ps.setInt(2, profitID);
                    ps.executeUpdate();

                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }

        } else {
            String sql = "UPDATE Profits\n"
                    + "SET SellingPrice = ?\n"
                    + "Where ProfitID = ?;";

            try {
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setDouble(1, discountPrice);
                ps.setInt(2, profitID);
                ps.executeUpdate();

            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }

    }

    public int getQuantitySoldOfVariant(int variantID, LocalDateTime calculatedDate) {
        String sql = "SELECT SUM(od.Quantity) AS QuantitySold\n"
                + "FROM OrderDetails AS od\n"
                + "JOIN Orders AS o ON od.OrderID = o.OrderID\n"
                + "WHERE \n"
                + "    o.OrderDate >= ? \n"
                + "    AND od.VariantID = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setTimestamp(1, Timestamp.valueOf(calculatedDate));
            ps.setInt(2, variantID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int quantity = rs.getInt("QuantitySold");
                return quantity;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public void deleteProfitByVariantID(int vID) {
        String sql = "DELETE FROM Profits WHERE VariantID = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, vID);
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public List<Double> getAllIncomeOfYear(int yearSelect) {
        DecimalFormat df = new DecimalFormat("#.00");
        List<Double> list = new ArrayList<>();
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        int currentMonth;
        if (yearSelect < currentYear) {
            currentMonth = 12;
        } else {
            currentMonth = Calendar.getInstance().get(Calendar.MONTH);
        }

        for (int i = 1; i <= currentMonth; i++) {
            double cost = getCostByMonthAndYear(i, yearSelect);
            double revenue = getRevenueByMonthAndYear(i, yearSelect);
            double income = (revenue - cost)/1000000;
            String formatted = df.format(income);
            double finalIncome = Double.parseDouble(formatted.replace(",", "."));
            System.out.println("Tháng " + i + " lợi nhận : " + income);
            list.add(finalIncome);
        }

        return list;
    }

    public double getCostByMonthAndYear(int month, int yearSelect) {
        String sql = " SELECT \n"
                + "    SUM(CostPrice * Quantity) AS TotalCostPrice\n"
                + "FROM \n"
                + "    Profits\n"
                + "WHERE \n"
                + "    YEAR(CalculatedDate) = ?\n"
                + "    AND MONTH(CalculatedDate) = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, yearSelect);
            ps.setInt(2, month);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                double cost = rs.getDouble("TotalCostPrice");
                return cost;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public double getRevenueByMonthAndYear(int month, int yearSelect) {
        String sql = "SELECT \n"
                + "    SUM(od.UnitPrice * od.Quantity) AS TotalOrderValue\n"
                + "FROM \n"
                + "    OrderDetails od\n"
                + "JOIN \n"
                + "    Orders o ON od.OrderID = o.OrderID\n"
                + "WHERE \n"
                + "    YEAR(o.OrderDate) = ?\n"
                + "    AND MONTH(o.OrderDate) = ?; ";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, yearSelect);
            ps.setInt(2, month);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                double revenue = rs.getDouble("TotalOrderValue");
                
                return revenue;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public List<Integer> getAllOrderOfYear(int yearSelect) {
        List<Integer> list = new ArrayList<>();
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        int currentMonth;
        if (yearSelect < currentYear) {
            currentMonth = 12;
        } else {
            currentMonth = Calendar.getInstance().get(Calendar.MONTH);
        }

        for (int i = 1; i <= currentMonth; i++) {
            int order = getOrderByMonthAndYear(i, yearSelect);
            System.out.println("Tháng " + i + " số sản phẩm bán ra : " + order);
            list.add(order);
        }
        return list;
    }

    public int getOrderByMonthAndYear(int month, int yearSelect) {
        String sql = "SELECT \n"
                + "    COUNT(*) AS TotalOrders\n"
                + "    \n"
                + "FROM \n"
                + "    Orders\n"
                + "WHERE \n"
                + "    YEAR(OrderDate) = ?\n"
                + "    AND MONTH(OrderDate) = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, yearSelect);
            ps.setInt(2, month);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int order = rs.getInt("TotalOrders");
                return order;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int getImportByMonthAndYear(int monthSelect, int yearSelect) {
        String sql = "SELECT \n"
                + "    SUM(Quantity) AS TotalImportedProducts\n"
                + "FROM Profits\n"
                + "WHERE YEAR(CalculatedDate) = ?\n"
                + "  AND MONTH(CalculatedDate) = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, yearSelect);
            ps.setInt(2, monthSelect);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int imported = rs.getInt("TotalImportedProducts");
                return imported;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public double getRevenueTargetByMonthAndYear(int monthSelect, int yearSelect) {
        String sql = "SELECT \n"
                + "    SUM(SellingPrice * Quantity) AS TotalRevenue\n"
                + "FROM \n"
                + "    Profits\n"
                + "WHERE \n"
                + "    YEAR(CalculatedDate) = ?\n"
                + "    AND MONTH(CalculatedDate) = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, yearSelect);
            ps.setInt(2, monthSelect);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                double revenue = rs.getDouble("TotalRevenue");
                
                return revenue;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public int getSoldByMonthAndYear(int monthSelect, int yearSelect) {
        String sql = "SELECT \n"
                + "    SUM(od.Quantity) AS TotalQuantitySold\n"
                + "FROM \n"
                + "    OrderDetails od\n"
                + "    INNER JOIN Orders o ON od.OrderID = o.OrderID\n"
                + "WHERE \n"
                + "YEAR(o.OrderDate) = ?\n"
                + "    AND MONTH(o.OrderDate) = ?;";

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, yearSelect);
            ps.setInt(2, monthSelect);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int sold = rs.getInt("TotalQuantitySold");

                return sold;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    public void updateQuantityOfProfit(int vID, int quantity) {
        VariantsDAO vdao = new VariantsDAO();
        Variants variant = vdao.getVariantByID(vID);
        LocalDateTime now = LocalDateTime.now();
        int monthValue = now.getMonthValue();
        int yearValue = now.getYear();
        int profitID = getMaxProfitID(vID);

        Profit profit = getProfitByID(profitID);

        if (profit != null) {
            int monthProfit = profit.getCalculatedDate().getMonthValue();
            int yearProfit = profit.getCalculatedDate().getYear();
            System.out.println("Tháng của profit có VariantID = " + vID + " là: " + monthProfit);
            System.out.println("Năm của profit có VariantID = " + vID + " là: " + yearProfit);
            if (monthProfit == monthValue && yearProfit == yearValue) {
                int totalQuantity = profit.getQuantity() + quantity;
                String sql = "UPDATE Profits\n"
                        + "SET Quantity = ?\n"
                        + "Where ProfitID = ?;";

                try {
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setDouble(1, totalQuantity);
                    ps.setInt(2, profitID);
                    ps.executeUpdate();

                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }else {
                
                if (quantity != 0) {
                    createProfit(vID, variant.getDiscountPrice(), profit.getCostPrice(), quantity);
                }

                

            }
        } else {
            System.out.println("khong update duoc");
        }

    }

    public void updateProfit() {

    }

}
