/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CategoryDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;

/**
 *
 * @author Hoa Hong Nhung - CE182244
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CategoryDAO cdao = new CategoryDAO();
        List<Category> listCategory = cdao.getAllCategories();
        request.setAttribute("listCategory", listCategory);


        HttpSession session = (HttpSession) request.getSession(false);
        if (session != null) {
            request.setAttribute("user", session.getAttribute("user"));
        }

        RequestDispatcher rd = (RequestDispatcher) request.getRequestDispatcher("customer/profile.jsp");
        rd.forward(request, response);
    }
}
