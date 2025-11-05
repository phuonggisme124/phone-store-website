/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ProductDAO;
import dao.SupplierDAO;
import dao.VariantsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import model.Products;
import model.Suppliers;
import model.Variants;
import utils.DBContext;

/**
 * This servlet handles variant-related requests from the client. It connects to
 * the database using DBContext, retrieves all product variants from the
 * VariantsDAO, and forwards the data to the JSP for rendering.
 *
 * @author USER
 */
@MultipartConfig
@WebServlet(name = "VariantsServlet", urlPatterns = {"/variants"})
public class VariantsServlet extends HttpServlet {

    /**
     * Default process method for both GET and POST requests. This is usually
     * used as a placeholder for testing purposes.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* Basic HTML output for quick servlet testing */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet VariantsServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VariantsServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods.">
    /**
     * Handles HTTP GET requests. Retrieves all product variants from the
     * database and forwards them to homepage.jsp.
     *
     * @param request HTTP request object
     * @param response HTTP response object
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        SupplierDAO sldao = new SupplierDAO();
        ProductDAO pdao = new ProductDAO();
        VariantsDAO vdao = new VariantsDAO();
        String action = request.getParameter("action");
        if (action == null) {
            action = "homepage";
        }

        if (action.equals("homepage")) {
            try {
                VariantsDAO dao = new VariantsDAO();
                List<Variants> variants = dao.getAllVariants();
                request.setAttribute("variants", variants);
                request.getRequestDispatcher("homepage.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Không thể tải dữ liệu sản phẩm: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        } else if (action.equals("createVariant")) {
            int pID = Integer.parseInt(request.getParameter("pID"));
            Products product = pdao.getProductByID(pID);

            request.setAttribute("product", product);
            request.setAttribute("pID", pID);
            request.getRequestDispatcher("admin_manageproduct_createvariant.jsp").forward(request, response);
        } else if (action.equals("editVariant")) {
            int vid = Integer.parseInt(request.getParameter("vid"));
            int pID = Integer.parseInt(request.getParameter("pID"));

            Variants variant = vdao.getVariantByID(vid);
            Products product = pdao.getProductByID(pID);
            List<Suppliers> listSupplier = sldao.getAllSupplier();
            request.setAttribute("variant", variant);
            request.setAttribute("product", product);
            request.setAttribute("listSupplier", listSupplier);

            request.getRequestDispatcher("admin_manageproduct_editvariant.jsp").forward(request, response);
        }

    }

    /**
     * Handles HTTP POST requests. Forwards POST requests to processRequest
     * (default behavior for testing).
     *
     * @param request HTTP request object
     * @param response HTTP response object
     * @throws ServletException if servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        ProductDAO pdao = new ProductDAO();
        VariantsDAO vdao = new VariantsDAO();
        String action = request.getParameter("action");
        if (action == null) {
            action = "homepage";
        }

        if (action.equals("homepage")) {
            try {
                VariantsDAO dao = new VariantsDAO();
                List<Variants> variants = dao.getAllVariants();
                request.setAttribute("variants", variants);
                request.getRequestDispatcher("homepage.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Không thể tải dữ liệu sản phẩm: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        } else if (action.equals("createVariant")) {
            int pID = Integer.parseInt(request.getParameter("pID"));
            int ctID = Integer.parseInt(request.getParameter("ctID"));
            String pName = request.getParameter("pName");
            String color = request.getParameter("color");
            String storage = request.getParameter("storage");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String description = request.getParameter("description");
            Variants variant;
            if (ctID == 1 || ctID == 3) {
                variant = vdao.getVariant(pID, storage, color);
            } else {
                variant = vdao.getVariantByProductIDAndColor(pID, color);
            }

            if (variant != null) {
                session.setAttribute("existVariant", pName + " " + (storage == null ? "" : storage) + " " + color + " already exists");
                response.sendRedirect("variants?action=createVariant&pID=" + pID);

            } else {
                vdao.createVariant(pID, color, storage, price, stock, description);

                String filePath = request.getServletContext().getRealPath("images");
                System.out.println("duong dan: " + filePath);
                String basePath = filePath.substring(0, filePath.indexOf("\\target"));
                String uploadDir = basePath + File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + "images";

                File uploadFolder = new File(uploadDir);
                if (!uploadFolder.exists()) {
                    uploadFolder.mkdirs();
                }

                File targetFolder = new File(filePath);
                if (!targetFolder.exists()) {
                    targetFolder.mkdirs();
                }
                int currentVariantID = vdao.getCurrentVariantID();
                String img = "";
                for (Part part : request.getParts()) {
                    if ("photos".equals(part.getName()) && part.getSize() > 0) {
                        String fileName = currentVariantID + "_" + Paths.get(part.getSubmittedFileName()).getFileName().toString();
                        img += fileName + "#";
                        String srcFile = uploadDir + File.separator + fileName;
                        part.write(srcFile);

                        File srcFileImages = new File(srcFile);
                        File targetFile = new File(filePath + File.separator + fileName);
                        Files.copy(srcFileImages.toPath(), targetFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    }
                }

                if (!img.isEmpty()) {
                    img = img.substring(0, img.length() - 1);
                    vdao.updateImageVariant(currentVariantID, img);
                }

                vdao.updateDiscountPrice();
                response.sendRedirect("product?action=productDetail&pID=" + pID);
            }

        } else if (action.equals("updateVariant")) {

            int vID = Integer.parseInt(request.getParameter("vID"));
            int pID = Integer.parseInt(request.getParameter("pID"));
            int ctID = Integer.parseInt(request.getParameter("ctID"));
            String pName = request.getParameter("pName");
            //String brand = request.getParameter("brand");
            String color = request.getParameter("color");
            String storage = request.getParameter("storage");
            double price = Double.parseDouble(request.getParameter("price"));
            //int warrantyPeriod = Integer.parseInt(request.getParameter("warrantyPeriod"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            //int supplierID = Integer.parseInt(request.getParameter("supplierID"));
            String description = request.getParameter("description");
            Variants variant = vdao.getVariantByID(vID);

            Variants updateVariant;
            boolean isUpdate = false;
            if (ctID == 1 || ctID == 3) {
                if (variant.getColor().equalsIgnoreCase(color) && variant.getStorage().equalsIgnoreCase(storage)) {
                    isUpdate = true;
                } else {
                    updateVariant = vdao.getVariant(pID, storage, color);
                    if (updateVariant == null) {
                        isUpdate = true;
                    }
                }

            } else {
                if (variant.getColor().equalsIgnoreCase(color)) {
                    isUpdate = true;
                } else {
                    updateVariant = vdao.getVariantByProductIDAndColor(pID, color);
                    if (updateVariant == null) {
                        isUpdate = true;
                    }
                }

            }

            if (isUpdate) {
                //update images
                //
                String filePath = request.getServletContext().getRealPath("images");
                String basePath = filePath.substring(0, filePath.indexOf("\\target"));
                String uploadDir = basePath + File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + "images";
                File uploadFolder = new File(uploadDir);
                if (!uploadFolder.exists()) {
                    uploadFolder.mkdirs();
                }

                File targetFolder = new File(filePath);
                if (!targetFolder.exists()) {
                    targetFolder.mkdirs();
                }
                //Lấy ảnh mới
                List<String> listNewImages = new ArrayList<>();
                for (Part part : request.getParts()) {
                    if ("photos".equals(part.getName()) && part.getSize() > 0) {
                        String fileName = vID + "_" + Paths.get(part.getSubmittedFileName()).getFileName().toString();
                        listNewImages.add(fileName);
                        String srcFile = uploadDir + File.separator + fileName;
                        part.write(srcFile);

                        File srcFileImages = new File(srcFile);
                        File targetFile = new File(filePath + File.separator + fileName);
                        Files.copy(srcFileImages.toPath(), targetFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    }
                }
                //xóa ảnh có sẵn            

                List<String> listAllImages = vdao.getImages(variant.getImageUrl());
                String imagesToDelete = request.getParameter("imagesToDelete");
                if (imagesToDelete != null && !imagesToDelete.isEmpty()) {
                    List<String> listImagesDelete = vdao.getImages(imagesToDelete);
                    if (listAllImages != null) {
                        listAllImages.removeAll(listImagesDelete);
                    }

                    for (String imageDelete : listImagesDelete) {
                        File file = new File(uploadDir + File.separator + imageDelete);
                        if (file.exists()) {
                            file.delete();
                        }
                    }
                }

                List<String> finalListImages = new ArrayList<>();
                if (listAllImages != null) {
                    finalListImages.addAll(listAllImages);
                }

                finalListImages.addAll(listNewImages);

                String img = "";
                if (!finalListImages.isEmpty()) {

                    img = String.join("#", finalListImages);

                }

                vdao.updateImageVariant(vID, img);

                vdao.updateVariant(vID, color, storage, price, stock, description);

                vdao.updateDiscountPrice();
                response.sendRedirect("product?action=productDetail&pID=" + pID);
            } else {
                session.setAttribute("existVariant", pName + " " + (storage == null ? "" : storage) + " " + color + " already exists");
                response.sendRedirect("variants?action=editVariant&pID=" + pID + "&vid=" + vID);
            }

        } else if (action.equals("deleteVariant")) {
            int vID = Integer.parseInt(request.getParameter("vID"));
            int pID = Integer.parseInt(request.getParameter("pID"));
            vdao.deleteVariantByID(vID);

            response.sendRedirect("product?action=productDetail&pID=" + pID);
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
