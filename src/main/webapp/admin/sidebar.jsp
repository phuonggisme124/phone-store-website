<%-- 
    Document   : sidebar
    Created on : Oct 25, 2025, 4:17:27?PM
    Author     : duy
--%>
<link rel="icon" type="image/x-icon" href="images/favicon.jpg">
<nav class="sidebar bg-white shadow-sm border-end">
    <%
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {

            action = "Dashboard";
        }
    %>
    <div class="sidebar-header p-3">
        <a style="font-size: 40px" class="logo-store">MiniStore</a>

    </div>
    <ul class="list-unstyled ps-3">
        <li><a href="admin" <%= (action.equals("Dashboard")) ? "class='active'" : ""%>
               ><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/product?action=manageProduct" <%= (action.equals("manageProduct")) ? "class='active'" : ""%>
               ><i class="bi bi-box me-2"></i>Products</a></li>
        <li><a href="${pageContext.request.contextPath}/admin?action=importproduct" <%= (action.equals("importproduct")) ? "class='active'" : ""%>
               ><i class="bi bi-box me-2"></i>Import Products</a></li>
        <li><a href="${pageContext.request.contextPath}/supplier?action=manageSupplier" <%= (action.equals("manageSupplier")) ? "class='active'" : ""%>
               ><i class="bi bi-truck me-2"></i>Suppliers</a></li>
        <li><a href="${pageContext.request.contextPath}/promotion?action=managePromotion" <%= (action.equals("managePromotion")) ? "class='active'" : ""%>
               ><i class="bi bi-tag me-2"></i></i>Promotions</a></li>
        <li><a href="${pageContext.request.contextPath}/order?action=manageOrder" <%= (action.equals("manageOrderAdmin")) ? "class='active'" : ""%>
               ><i class="bi bi-bag me-2"></i>Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/review?action=manageReview" <%= (action.equals("manageReview")) ? "class='active'" : ""%>
               ><i class="bi bi-chat me-2"></i>Reviews</a></li>
        <li><a href="${pageContext.request.contextPath}/customer?action=manageUser" <%= (action.equals("manageUser")) ? "class='active'" : ""%>
               ><i class="bi bi-people me-2"></i>Account</a></li>
        <li><a href="${pageContext.request.contextPath}/category?action=manageCategory" <%= (action.equals("manageCategory")) ? "class='active'" : ""%>

               ><i class="bi bi-grid me-2"></i>Category</a></li>          
    </ul>
</nav>