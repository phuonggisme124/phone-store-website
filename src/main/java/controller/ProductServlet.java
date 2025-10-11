/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ProductDAO;
import dao.VariantsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Category;
import model.Products;
import model.Variants;

/**
 *
 * @author duynu
 */
@WebServlet(name = "ProductServlet", urlPatterns = {"/product"})
public class ProductServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ProductServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ProductDAO pdao = new ProductDAO();
        VariantsDAO vdao = new VariantsDAO();

        // === Case 1: View product details ===
        if (action.equals("viewDetail")) {
            int productID = Integer.parseInt(request.getParameter("pID"));
            List<Category> listCategory = pdao.getAllCategory();
            List<String> listStorage = vdao.getAllStorage(productID);
            Products p = pdao.getProductByID(productID);
            int cID = p.getCategoryID();
            List<Variants> listVariants = vdao.getAllVariantByProductID(productID);

            // Default variant: first combination of storage and color
            Variants variants = vdao.getVariant(
                    productID,
                    listVariants.get(0).getStorage(),
                    listVariants.get(0).getColor()
            );

            // Pass data to JSP
            request.setAttribute("categoryID", cID);
            request.setAttribute("productID", productID);
            request.setAttribute("listStorage", listStorage);
            request.setAttribute("listVariants", listVariants);
            request.setAttribute("variants", variants);
            request.setAttribute("listCategory", listCategory);

            // Forward to product detail page
            request.getRequestDispatcher("productdetail.jsp").forward(request, response);

            // === Case 2: Change storage variant ===
        } else if (action.equals("selectStorage")) {
            int pID = Integer.parseInt(request.getParameter("pID"));
            int cID = Integer.parseInt(request.getParameter("cID"));
            String storage = request.getParameter("storage");
            String color = request.getParameter("color");

            Variants variants;
            List<Products> listProducts = pdao.getAllProduct();
            List<Variants> listVariants = vdao.getAllVariantByProductID(pID);
            List<Variants> listVariantDetail = vdao.getAllVariantByStorage(pID, storage);
            List<String> listStorage = vdao.getAllStorage(pID);
            List<Category> listCategory = pdao.getAllCategory();

            // Retrieve specific variant
            variants = vdao.getVariant(pID, storage, color);
            if (variants == null) {
                // If color not found, select first available variant
                variants = vdao.getVariant(pID, storage, listVariantDetail.get(0).getColor());
            }

            // Send data to JSP
            request.setAttribute("productID", pID);
            request.setAttribute("categoryID", cID);
            request.setAttribute("variants", variants);
            request.setAttribute("listProducts", listProducts);
            request.setAttribute("listVariants", listVariants);
            request.setAttribute("listVariantDetail", listVariantDetail);
            request.setAttribute("listStorage", listStorage);
            request.setAttribute("listCategory", listCategory);

            // Forward to product detail page
            request.getRequestDispatcher("productdetail.jsp").forward(request, response);

            // === Case 3: Filter by category ===
        } else if (action.equals("category")) {
            int cID = Integer.parseInt(request.getParameter("cID"));
            List<Products> listProduct = pdao.getAllProductByCategory(cID);
            List<Variants> listVariant = vdao.getAllVariantByCategory(cID);
            List<Category> listCategory = pdao.getAllCategory();

            // Set attributes for category page
            request.setAttribute("listVariant", listVariant);
            request.setAttribute("categoryID", cID);
            request.setAttribute("listCategory", listCategory);
            request.setAttribute("listProduct", listProduct);

            // Forward to category JSP
            request.getRequestDispatcher("category.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        VariantsDAO vdao = new VariantsDAO();
        if (action.equals("viewVariantColor")) {
            int pID = Integer.parseInt(request.getParameter("pID"));

            String storage = request.getParameter("storage");
            if (storage == null) {
                request.getRequestDispatcher("homepage.jsp").forward(request, response);
                return;
            }
            String color = request.getParameter("color");
            if (color == null) {
                request.getRequestDispatcher("homepage.jsp").forward(request, response);
                return;
            }
            List<Variants> listVariants = vdao.getAllVariantByColor(pID, color);

            Variants variants = vdao.getVariant(pID, storage, color);
            if (listVariants.isEmpty()) {
                request.getRequestDispatcher("homepage.jsp").forward(request, response);
                return;
            }
            request.setAttribute("variants", variants);
            request.setAttribute("listVariants", listVariants);
            request.getRequestDispatcher("homepage.jsp").forward(request, response);
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
