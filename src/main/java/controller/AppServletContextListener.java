package controller;

import dao.ProductDAO;
import dao.VariantsDAO;
import model.Products;
import model.Variants;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.List;

/**
 * THỊNH ĐẸP TRAI
 * Class ServletContextListener.
 * Tự động chạy khi ứng dụng mở.
 * tải dữ liệu dùng chung 
 * lưu vào Application Scope
 */
// annotation đăng kí server
@WebListener 
public class AppServletContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {       
        try {
            ProductDAO pDAO = new ProductDAO();
            VariantsDAO vDAO = new VariantsDAO();
            
            // Tải list để sreach        
            List<Products> productList = pDAO.getAllProduct(); 
            List<Variants> variantsList = vDAO.getAllVariant(); 

            // tạo application scope (biến toàn cục)
            ServletContext context = sce.getServletContext();
            
            // Lưu list này vào application scope
            context.setAttribute("globalProductList", productList);
            context.setAttribute("globalVariantsList", variantsList);
            
            System.out.println("tải dữ liệu lên trước");


        } catch (Exception e) {
            System.err.println("lỗi");
            e.printStackTrace();
        }
    }

   // hàm chạy  khi server tắt
   // xóa mọi thứ  
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        context.removeAttribute("globalProductList");
        context.removeAttribute("globalVariantsList");
        System.out.println("xóa dữ liệu");
    }
}