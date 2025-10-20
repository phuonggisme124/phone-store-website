/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.ReviewDAO;
import dao.VariantsDAO;
import java.util.List;
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
        int pID = 2;
        String storage = "128GB";
        List<Variants> listVariantRating = vdao.getAllVariantByStorage(pID, storage);
        List<Review> listReview = rdao.getReview();
        
        //for(int i= 5; i > 0 ; i--){
        double rating = rdao.getPercentRating(listVariantRating, listReview, 5);
        System.out.println(rating);
        //}
        
    }
}
