<%-- 
    Document   : orderDetail
    Created on : Oct 27, 2025, 1:11:54 AM
    Author     : Nhung Hoa
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
    <head>
        <title>Chi tiết đơn hàng</title>
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" type="text/css" href="css/home.css">
    </head>
    <body>
        <h2>Chi tiết đơn hàng #${order.orderID}</h2>
        <p><strong>Người mua:</strong> ${order.buyer.fullName}</p>
        <p><strong>Ngày đặt:</strong> ${order.orderDate}</p>
        <p><strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress}</p>
        <p><strong>Trạng thái:</strong> ${order.status}</p>
        <p><strong>Tổng tiền:</strong> ${order.totalAmount}</p>

        <hr>

        <h3>Danh sách sản phẩm</h3>
        <table border="1" cellspacing="0" cellpadding="6">
            <tr>
                <th>Tên sản phẩm</th>
                <th>Số lượng</th>
                <th>Đơn giá</th>
                <th>Tổng</th>
            </tr>
            <c:forEach var="d" items="${details}">
                <tr>
                    <td>${d.productName}</td>
                    <td>${d.quantity}</td>
                    <td>${d.price}</td>
                    <td>${d.subTotal}</td>
                </tr>
            </c:forEach>
        </table>

        <br>

    </body>
</html>

