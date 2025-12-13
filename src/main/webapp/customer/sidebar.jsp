<%@page import="model.Customer"%>
<aside class="profile-sidebar">
    <%  Customer c = (Customer) session.getAttribute("user");  %>
    <h3>Hello, <%= c.getFullName()%></h3> 

    <a href="product?action=viewWishlist" class="sidebar-link">
        <i class="fas fa-heart"></i> <span>My Wishlist</span>
    </a>

    <a href="customer?action=transaction" class="sidebar-link">
        <i class="fas fa-shopping-bag"></i> <span>My Orders</span>
    </a>

    <a href="customer?action=payInstallment" class="sidebar-link">
        <i class="fas fa-receipt"></i> <span>Installment Paying</span>
    </a>

    <a href="customer?action=view" class="sidebar-link active">
        <i class="fas fa-user"></i> <span>Profile & Address</span>
    </a>

    <a href="customer?action=changePassword" class="sidebar-link">
        <i class="fas fa-lock"></i> <span>Change Password</span>
    </a>

    <form action="logout" method="post">
        <button type="submit" class="logout-btn">
            <i class="fas fa-sign-out-alt"></i> Logout
        </button>
    </form>
</aside>
