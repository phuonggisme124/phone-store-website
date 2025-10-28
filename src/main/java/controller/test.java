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
        System.out.println("ccccccccccccccccccccccccccccc");
        int rating = 0;
        int productID = 2;
        String storage = "128GB";

        List<Review> listReview = null;
        if (rating == 0) {
            List<Variants> listVariant = vdao.getAllVariantByStorage(productID, storage);
            listReview = rdao.getAllReviewByListVariant(listVariant);
        } else {
            List<Variants> listVariant = vdao.getAllVariantByStorage(productID, storage);
            listReview = rdao.getAllReviewByListVariantAndRating(listVariant, rating);
        }

        if (listReview != null || !listReview.isEmpty()) {
            for (Review r : listReview) {
                System.out.println("rID " + r.getReviewID());
            }
        }else{
            System.out.println("danh sach trong");
        }
        System.out.println("danh sach trong");
        //}
    }
}
