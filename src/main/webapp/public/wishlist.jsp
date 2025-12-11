<%-- 
    Document   : wishlist
    Created on : Dec 9, 2025, 2:52:31 PM
    Author     : Nhung Hoa
--%>
<%@ page import="dao.WishlistDAO" %>
<%@page import="java.util.List"%>
<%@page import="model.Products"%>
<%@ page import="model.Variants" %>
<%@ page import="model.Users" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/layout/header.jsp" %>

<%
    Users currentUser = (Users) session.getAttribute("user");
    if(currentUser == null){
        response.sendRedirect("login.jsp");
        return;
    }

    WishlistDAO wdao = new WishlistDAO();
    List<Products> wishlist = null;
    try {
        wishlist = wdao.getWishlistByUser(currentUser.getUserId());
    } catch(Exception e){
        e.printStackTrace();
    }
%>




<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>My Wishlist | Phone Store</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="format-detection" content="telephone=no">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="author" content="">
        <meta name="keywords" content="">
        <meta name="description" content="">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" type="text/css" href="css/order.css">
        <link rel="stylesheet" type="text/css" href="css/profile.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@300;400;500&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    </head>

    <style>
        body {
            background: white;
            min-height: 100vh;
            font-family: 'Jost', sans-serif;
            padding-top: 80px;
        }

        .profile-container {
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .profile-wrapper {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 30px;
            margin-bottom: 50px;
        }

        .profile-sidebar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            padding: 40px 30px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            height: fit-content;
            position: sticky;
            top: 100px;
        }

        .profile-sidebar h3 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 35px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e2e8f0;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            padding: 16px 20px;
            margin-bottom: 12px;
            border-radius: 12px;
            text-decoration: none;
            color: #4a5568;
            font-weight: 500;
        }

        .sidebar-link:hover {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
            transform: translateX(5px);
        }

        .profile-content {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            padding: 50px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
        }

        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .profile-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }

        .wishlist-card {
            background: white;
            border-radius: 16px;
            padding: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: 0.3s;
        }

        .wishlist-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .wishlist-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            border-radius: 12px;
        }

        .wishlist-card h5 {
            font-size: 16px;
            margin: 12px 0 6px;
            font-weight: 600;
        }

        .wishlist-card .price {
            font-weight: 600;
            color: #667eea;
        }

        .remove-btn {
            border: none;
            background: none;
            color: #e53e3e;
            font-size: 14px;
            margin-top: 8px;
            cursor: pointer;
        }

    </style>

    <body>
        <section id="billboard" class="bg-light-blue overflow-hidden padding-large" >
            <div class="profile-container">
                <div class="profile-wrapper">

                    <!-- Sidebar -->
                    <aside class="profile-sidebar">
                        <h3>Hello, <%= user.getFullName()%></h3>

                        <a href="product?action=viewWishlist" class="sidebar-link">
                            <i class="fas fa-heart"></i>
                            <span>My Wishlist</span>
                        </a>

                        <a href="user?action=transaction" class="sidebar-link">
                            <i class="fas fa-shopping-bag"></i>
                            <span>My Orders</span>
                        </a>
                        <a href="user?action=payInstallment" class="sidebar-link">
                            <i class="fas fa-receipt"></i>
                            <span>Installment Paying</span>
                        </a>

                        <a href="user" class="sidebar-link">
                            <i class="fas fa-user"></i>
                            <span>Profile & Address</span>
                        </a>

                        <a href="user?action=changePassword" class="sidebar-link">
                            <i class="fas fa-lock"></i>
                            <span>Change Password</span>
                        </a>

                        <form action="logout" method="post">
                            <button type="submit" class="logout-btn">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </button>
                        </form>
                    </aside>

                    <!-- CONTENT -->
                    <main class="profile-content">
                        <div class="profile-header">
                            <h1>My Wishlist</h1>
                            <p>Your favorite products</p>
                        </div>


                        <% if (wishlist != null && !wishlist.isEmpty()) { %>
                        <div class="wishlist-grid">
                            <% for (Products p : wishlist) { 
       Variants v = null;
       if(p.getVariants() != null && !p.getVariants().isEmpty()){
           v = p.getVariants().get(0);
       }
                            %>

                            <div class="wishlist-card">
                                <% if(v != null) { %>
                                <img src="images/<%= v.getImageUrl() %>" alt="<%= p.getName() %>">
                                <h5><%= p.getName() %> - <%= v.getColor() %> / <%= v.getStorage() %></h5>

                                <div class="price">
                                    <% 
                                        Double discount = v.getDiscountPrice();
                                        double finalPrice = (discount != null) ? discount : v.getPrice();
                                    %>
                                    <span class="final-price"><%= String.format("%,.0f₫", finalPrice) %></span>
                                </div>

                                <% } else { %>
                                <img src="images/no-image.png">
                                <h5><%= p.getName() %></h5>
                                <div class="price">N/A</div>
                                <% } %>

                            </div>
                            <% } %>
                        </div>

                        <% } else { %>
                        <p style="text-align:center; color:#999;">Your wishlist is empty 🤍</p>
                        <% } %>
                    </main>

                </div>
            </div>
        </section>

        <script src="js/jquery-1.11.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
