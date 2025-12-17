<%@page import="model.Customer"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/layout/header.jsp" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>My Profile | MiniStore</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
        
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/edit_profile.css">    
    </head>

    <body>
        <%
            // 1. Ưu tiên lấy user từ Session (để tránh lỗi khi redirect)
            Customer userC = (Customer) session.getAttribute("user");
            
            // 2. Nếu Session chưa có (hiếm khi xảy ra nếu đã login), thử lấy từ Request
            if (userC == null) {
                userC = (Customer) request.getAttribute("user");
            }

            // 3. Nếu cả 2 đều null -> Chưa đăng nhập
            if (userC == null) {
        %>
            <div class="profile-container">
                <h2 style="color:red; text-align:center; margin-top:80px;">
                    ❌ Không tìm thấy thông tin người dùng.
                    <br>Vui lòng <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập lại</a>.
                </h2>
            </div>
        <%
                return; // Dừng xử lý trang
            }
        %>

        <div class="profile-container">
            <div class="profile-wrapper">
                <%@ include file="sidebar.jsp" %>

                <main class="profile-content">
                    <div class="profile-header">
                        <h1>My Profile</h1>
                        <p>Manage your account information</p>
                    </div>

                    <div class="row">
                        <div class="col-lg-4">
                            <div class="avatar-section">
                                <div class="avatar-wrapper">
                                    <img src="${pageContext.request.contextPath}/images/avatar.png" alt="User Avatar">
                                </div>
                                <h5><%= userC.getFullName()%></h5>
                                <span class="user-id">ID: #<%= userC.getCustomerID()%></span> 
                            </div>
                        </div>

                        <div class="col-lg-8">
                            <form action="${pageContext.request.contextPath}/customer" method="post" class="profile-form">
                                
                                <input type="hidden" name="action" value="updateProfile">
                                
                                <input type="hidden" name="redirect" value="${param.redirect}">
                                
                                <% if (request.getAttribute("message") != null) {%>
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle"></i>
                                    <%= request.getAttribute("message")%>
                                </div>
                                <% } else if (request.getAttribute("error") != null) {%>
                                <div class="alert alert-danger">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <%= request.getAttribute("error")%>
                                </div>
                                <% }%>

                                <div class="form-group">
                                    <label for="fullName" class="form-label">
                                        <i class="fas fa-user"></i> Full Name
                                    </label>
                                    <input type="text" class="form-control" id="fullName" name="fullName"
                                           value="<%= userC.getFullName()%>" required>
                                </div>
                                
                                <div class="form-group">
                                    <label for="cccd" class="form-label">
                                        <i class="fas fa-id-card"></i> CCCD
                                    </label>
                                    <input type="text" class="form-control" id="cccd" name="cccd"
                                           value="<%= userC.getCccd() != null ? userC.getCccd() : ""%>">
                                </div>

                                <div class="form-group">
                                    <label for="yob" class="form-label">
                                        <i class="fas fa-calendar"></i> Year of Birth
                                    </label>
                                    <input type="date" class="form-control" id="yob" name="yob"
                                           value="<%=(userC.getYob() != null) ? userC.getYob().toString() : ""%>">
                                </div>

                                <div class="form-group">
                                    <label for="email" class="form-label">
                                        <i class="fas fa-envelope"></i> Email Address
                                    </label>
                                    <input type="email" class="form-control" id="email" name="email"
                                           value="<%= userC.getEmail()%>" required>
                                </div>

                                <div class="form-group">
                                    <label for="phone" class="form-label">
                                        <i class="fas fa-phone"></i> Phone Number
                                    </label>
                                    <input type="text" class="form-control" id="phone" name="phone"
                                           value="<%= userC.getPhone() != null ? userC.getPhone() : ""%>">
                                </div>

                                <div class="form-group">
                                    <label for="address" class="form-label">
                                        <i class="fas fa-map-marker-alt"></i> Address
                                    </label>
                                    <input type="text" class="form-control" id="address" name="address"
                                           value="<%= userC.getAddress() != null ? userC.getAddress() : ""%>">
                                </div>

                                <div class="d-flex justify-content-end gap-3">
                                    <a href="${pageContext.request.contextPath}/user" class="btn btn-secondary">
                                        <i class="fas fa-times"></i> Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i> Save Changes
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/jquery-1.11.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>