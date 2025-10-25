<%-- 
    Document   : sidebar
    Created on : Oct 25, 2025, 4:17:27?PM
    Author     : duy
--%>

<nav class="sidebar bg-white shadow-sm border-end">
    <%
        String action = request.getParameter("action");
        if(action == null || action.isEmpty()){
            action = "Dashboard";
        }
    %>
    <div class="sidebar-header p-3">
        <h4 class="fw-bold text-primary">MiniStore</h4>
    </div>
    <ul class="list-unstyled ps-3">
        <li><a href="admin" <%= (action.equals("Dashboard")) ? "class='active'" : ""%>
               ><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
        <li><a href="admin?action=manageProduct" <%= (action.equals("manageProduct")) ? "class='active'" : ""%>
               ><i class="bi bi-box me-2"></i>Products</a></li>
        <li><a href="admin?action=manageSupplier" <%= (action.equals("manageSupplier")) ? "class='active'" : ""%>
               ><i class="bi bi-truck me-2"></i>Suppliers</a></li>
        <li><a href="admin?action=managePromotion" <%= (action.equals("managePromotion")) ? "class='active'" : ""%>
               ><i class="bi bi-tag me-2"></i></i>Promotions</a></li>
        <li><a href="admin?action=manageOrder" <%= (action.equals("manageOrder")) ? "class='active'" : ""%>
               ><i class="bi bi-bag me-2"></i>Orders</a></li>
        <li><a href="admin?action=manageReview" <%= (action.equals("manageReview")) ? "class='active'" : ""%>
               ><i class="bi bi-chat me-2"></i>Reviews</a></li>
        <li><a href="admin?action=manageUser" <%= (action.equals("manageUser")) ? "class='active'" : ""%>
               ><i class="bi bi-people me-2"></i>Users</a></li>
        <li><a href="admin?action=manageCategory" <%= (action.equals("manageCategory")) ? "class='active'" : ""%>
               ><i class="bi bi-grid me-2"></i>Category</a></li>
        <li><a href="#"><i class="bi bi-gear me-2"></i>Settings</a></li>            
    </ul>
</nav>