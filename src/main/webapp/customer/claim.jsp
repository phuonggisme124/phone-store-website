<%-- 
    Document   : claim
    Created on : Dec 16, 2025, 7:12:14 PM
    Author     : Nhung Hoa
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Warranty" %>
<%@ include file="/layout/header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Gửi Yêu Cầu Bảo Hành</title>

    <link rel="stylesheet" href="/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/profile.css">
</head>

<body>
<section class="bg-light-blue padding-large">
    <div class="container">
        <h2 class="mb-4">Gửi Yêu Cầu Bảo Hành</h2>

        <%
            Warranty w = (Warranty) request.getAttribute("warranty");
        %>

        <form action="<%= request.getContextPath() %>/warranty" method="post">
            <input type="hidden" name="action" value="claim">
            <input type="hidden" name="warrantyID" value="<%= w.getWarrantyID() %>">

            <div class="mb-3">
                <label class="form-label">Mã bảo hành</label>
                <input type="text" class="form-control"
                       value="<%= w.getWarrantyID() %>" disabled>
            </div>

            <div class="mb-3">
                <label class="form-label">Lý do bảo hành</label>
                <textarea name="reason" class="form-control" rows="4"
                          required placeholder="Mô tả lỗi sản phẩm."></textarea>
            </div>

            <div class="text-end">
                <a href="<%= request.getContextPath() %>/warranty"
                   class="btn btn-secondary">Hủy</a>
                <button type="submit" class="btn btn-primary">
                    Gửi yêu cầu
                </button>
            </div>
        </form>
    </div>
</section>
</body>
</html>
