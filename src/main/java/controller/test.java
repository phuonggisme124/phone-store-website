/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.OrderDAO;
import dao.ReviewDAO;
import dao.VariantsDAO;
import java.util.List;
import model.Order;
import model.Review;
import model.Variants;

/**
 *
 * @author duynu
 */
public class test {
    public static void main(String[] args) {
        ReviewDAO rdao = new ReviewDAO();
        VariantsDAO vdao = new VariantsDAO();
        OrderDAO odao = new OrderDAO();
        
        List<Order> list = odao.getAllOrder();
        
        for (Order o : list){
            System.out.println("OrderID: "+ o.getOrderID());
        }
        //}
        
    }
}
