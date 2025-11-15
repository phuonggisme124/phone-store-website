<%@page import="dao.ProductDAO"%>
<%@page import="model.Variants"%>
<%@page import="dao.VariantsDAO"%>
<%@page import="java.util.List"%>
<%@page import="model.Profit"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<Profit> listImports = (List<Profit>) request.getAttribute("listImports");
    VariantsDAO vdao = new VariantsDAO();
    ProductDAO pdao = new ProductDAO();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin - Lịch sử nhập kho</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard_admin.css">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', sans-serif;
            }
            .container-content {
                margin-left: 250px; /* để chừa chỗ cho sidebar */
                padding: 30px;
            }
            .table th {
                background-color: #0d6efd;
                color: white;
            }
            .btn-add {
                background-color: #0d6efd;
                color: white;
            }
            .btn-add:hover {
                background-color: #0b5ed7;
            }
        </style>
    </head>
    <body>
        <%-- Sidebar admin --%>
        <jsp:include page="sidebar.jsp"/>

        <div class="container-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="text-primary mb-0">
                    <i class="bi bi-box-seam"></i> Import History
                </h2>
                <a href="${pageContext.request.contextPath}/admin?action=showImportForm" class="btn btn-add">
                    <i class="bi bi-plus-circle"></i> Import
                </a>
            </div>

            <div class="table-responsive shadow-sm bg-white p-3 rounded">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>ProfitID</th>
                            <th>ProductName</th>
                            <th>Storage</th>
                            <th>Color</th>
                            <th>Quality</th>
                            <th>Selling Price(VNĐ)</th>
                            <th>Cost Price(VNĐ)</th>
                            <th>CalculatedDate</th>
                        </tr>
                    </thead>
                    <tbody>
                     <% if (listImports != null && !listImports.isEmpty()) {

                                for (Profit p : listImports) {%>

                        <tr>

                            <td><%= p.getProfitID()%></td>

                            <%
                                Variants v = vdao.getVariantByID(p.getVariantID());
                            %>
                    <td><%= p.getProfitID()%></td>
                    
                    <td><%= pdao.getNameByID(v.getProductID())%></td>
                    <td><%= v.getStorage()%></td>
                    <td><%= v.getColor()%></td>
                    <td><%= p.getQuantity()%></td>
                    <td><%= String.format("%,.0f", p.getCostPrice())%></td>
                    <td><%= String.format("%,.0f", p.getSellingPrice())%></td>
                    <td><%= p.getCalculatedDate()%></td>
                    </tr>
                    <% }
                    } else { %>
                    <tr>
                        <td colspan="6" class="text-center text-muted py-4">
                            <i class="bi bi-inbox"></i> No stock entry history yet.
                        </td>
                    </tr>
                    <% }%>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
