package controller;

import dao.AddressDAO;
import model.Address;
import model.Customer;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AddressServlet", urlPatterns = {"/address"})
public class AddressServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Customer user = (Customer) session.getAttribute("user");
        
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");
        AddressDAO aDAO = new AddressDAO();
        int customerID = user.getCustomerID();

        try {
            if ("add".equals(action)) {
                String city = request.getParameter("city");
                String specific = request.getParameter("specificAddress");
                boolean isDefault = Boolean.parseBoolean(request.getParameter("isDefault"));
                String fullAddress = specific + ", " + city;

                Address newAddr = new Address(0, customerID, fullAddress, isDefault);
                aDAO.insertAddress(newAddr);

            } else if ("edit".equals(action)) {
                int addressID = Integer.parseInt(request.getParameter("addressID"));
                String city = request.getParameter("city");
                String specific = request.getParameter("specificAddress");
                boolean isDefault = Boolean.parseBoolean(request.getParameter("isDefault"));
                String fullAddress = specific + ", " + city;

                Address addr = new Address(addressID, customerID, fullAddress, isDefault);
                aDAO.updateAddress(addr);

            } else if ("delete".equals(action)) {
                int addressID = Integer.parseInt(request.getParameter("addressID"));
                aDAO.deleteAddress(addressID);
            }
            
            response.setStatus(HttpServletResponse.SC_OK);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}