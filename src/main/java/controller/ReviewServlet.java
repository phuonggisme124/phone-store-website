/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.ProductDAO;
import dao.ReviewDAO;
import dao.VariantsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.Collection;

/**
 *
 * @author duynu
 */

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB mỗi file
    maxRequestSize = 1024 * 1024 * 50     // 50 MB tổng dung lượng request
)

@WebServlet(name="ReviewServlet", urlPatterns={"/review"})
public class ReviewServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet ReviewServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReviewServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        ProductDAO pdao = new ProductDAO();
        VariantsDAO vdao = new VariantsDAO();
        ReviewDAO rdao = new ReviewDAO();
        
        if(action == null){
            action = "review";
        }
        
        if(action.equals("review")){
            String filePath = request.getServletContext().getRealPath("");
            String cutFilePart = filePath.substring(0, filePath.indexOf("\\target"));
            System.out.println(cutFilePart);
            String upLoad = cutFilePart + File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + "images_review"; 
            int vID = Integer.parseInt(request.getParameter("vID"));
            int uID = Integer.parseInt(request.getParameter("uID"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            
            rdao.createReview(uID, vID, rating, comment);
            
            
            String img = "";
            int currentReviewID = rdao.getCurrentReviewID();
            for(Part part : request.getParts()){
                if(("photos").equals(part.getName())){
                    String fileName = currentReviewID + "_" + Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    img += fileName + "#";
                    part.write(upLoad+ File.separator + fileName);
                }
            }
            
            img = img.substring(0, img.length() -1);
            
            System.out.println("image: " + img);
            System.out.println("currentReviewID: " + currentReviewID);
            rdao.updateImageReview(currentReviewID, img);
            response.sendRedirect("homepage");
        }else if(action.equals("deleteReview")){
            int rID = Integer.parseInt(request.getParameter("rID")); 
            
            rdao.deleteReview(rID);
            response.sendRedirect("homepage");
        }
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
