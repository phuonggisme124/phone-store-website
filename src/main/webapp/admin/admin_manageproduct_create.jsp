<%@page import="model.Category"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Products"%>
<%@page import="model.Variants"%>
<%@page import="java.util.List"%>
<%@page import="model.Users"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <%@ include file="sidebar.jsp" %>

            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle"><i class="bi bi-list"></i></button>
                        <form class="d-none d-md-flex ms-3">
                            <input class="form-control" type="search" placeholder="Ctrl + K" readonly>
                        </form>
                        <div class="d-flex align-items-center ms-auto">
                            <div class="position-relative me-3">
                                <a href="logout">logout</a>
                            </div>
                            <i class="bi bi-bell me-3 fs-5"></i>
                            <div class="position-relative me-3">
                                <i class="bi bi-github fs-5"></i>
                            </div>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span>Admin</span>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Search bar -->
                <div class="container-fluid p-4">
                    <h1 class="w-50 mx-auto bg-light p-4 rounded shadow">Create Product</h1>
                </div>


                <%                    Variants variant = (Variants) request.getAttribute("variant");
                    Products product = (Products) request.getAttribute("product");
                    List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");
                    List<Category> listCategories = (List<Category>) request.getAttribute("listCategories");
                %>
                <!-- Table -->
                <form action="product" method="post" id="productForm" class="w-50 mx-auto bg-light p-4 rounded shadow">
                    <div class="mb-3" >
                        <%
                            if (session.getAttribute("existName") != null) {
                                String exist = (String) session.getAttribute("existName");
                                out.println("<p class='error-message'>" + exist + "</p>");
                            }
                            session.removeAttribute("existName");
                        %>
                    </div>
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="vID" value="" readonly>
                    </div>

                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="pID" value="" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="pName" value="" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <select class="form-select" name="category" id="category">
                            <option selected value="">Select Category</option>
                            <%
                                for (Category ct : listCategories) {
                            %>
                            <option value="<%= ct.getCategoryId()%>" ><%= ct.getCategoryName()%></option>
                            <%
                                }
                            %>             
                        </select>
                        <p id="categoryError" class="text-danger mt-2" style="display:none;">Please select a category!</p>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Brand</label>
                        <input type="text" class="form-control" name="brand" value="" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Warranty Period</label>
                        <input type="text" class="form-control" name="warrantyPeriod" value="" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Supplier</label>
                        <select class="form-select" name="supplierID" id="supplierID">
                            <option selected value="">Supplier</option>
                            <%
                                for (Suppliers sl : listSupplier) {
                            %>
                            <option value="<%= sl.getSupplierID()%>"><%= sl.getName()%></option>
                            <%
                                }
                            %>             
                        </select>
                        <p id="supplierError" class="text-danger mt-2" style="display:none;">Please select a supplier!</p>
                    </div>
                    <div class="mb-3" id="group-tech">
                        <label class="form-label">OS</label>
                        <input type="text" class="form-control" name="os">
                    </div>
                    <div class="mb-3" id="group-cpu">
                        <label class="form-label">CPU</label>
                        <input type="text" class="form-control" name="cpu">
                    </div>
                    <div class="mb-3" id="group-gpu">
                        <label class="form-label">GPU</label>
                        <input type="text" class="form-control" name="gpu">
                    </div>
                    <div class="mb-3" id="group-ram">
                        <label class="form-label">RAM</label>
                        <input type="text" class="form-control" name="ram">
                    </div>
                    <div class="mb-3" id="group-battery">
                        <label class="form-label">Battery Capacity</label>
                        <input type="number" class="form-control" name="batteryCapacity">
                    </div>
                    <div class="mb-3" id="group-touchscreen">
                        <label class="form-label">Touchscreen</label>
                        <input type="text" class="form-control" name="touchscreen">
                    </div>

                    <div class="mb-3">

                        <button type="submit" name="action" value="createProduct" class="btn btn-primary w-100">Create</button>
                    </div>


                </form>
            </div>


            <!-- JS Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

            <!-- Custom JS -->
            <script src="js/dashboard.js"></script>
            <script src="js/create_product.js"></script>
            <script>
                document.getElementById("productForm").addEventListener("submit", function (e) {
                    const category = document.getElementById("category");
                    const supplier = document.getElementById("supplierID");
                    const categoryError = document.getElementById("categoryError");
                    const supplierError = document.getElementById("supplierError");

                    let isValid = true;

                    // Check Category
                    if (category.value === "") {
                        categoryError.style.display = "block";
                        category.classList.add("is-invalid");
                        isValid = false;
                    } else {
                        categoryError.style.display = "none";
                        category.classList.remove("is-invalid");
                    }

                    // Check Supplier
                    if (supplier.value === "") {
                        supplierError.style.display = "block";
                        supplier.classList.add("is-invalid");
                        isValid = false;
                    } else {
                        supplierError.style.display = "none";
                        supplier.classList.remove("is-invalid");
                    }

                    // Nếu có lỗi thì chặn submit & cuộn tới ô lỗi đầu tiên
                    if (!isValid) {
                        e.preventDefault();
                        document.querySelector(".is-invalid").scrollIntoView({
                            behavior: "smooth",
                            block: "center"
                        });
                    }
                });
            </script>
            <script>
                const categorySelect = document.getElementById("category");

                // Gom nhóm input để dễ xử lý
                const techGroups = [
                    "group-tech", "group-cpu", "group-gpu", "group-ram",
                    "group-battery", "group-touchscreen"
                ];

                const filteredGroups = techGroups.filter(id => id !== "group-cpu" && id !== "group-tech" && id !== "group-ram");
                

                // Hàm ẩn tất cả nhóm
                function hideAllGroups() {
                    techGroups.forEach(id => document.getElementById(id).style.display = "none");
                }

                // Gọi ban đầu để ẩn hết
                hideAllGroups();

                // Khi chọn Category
                categorySelect.addEventListener("change", function () {
                    const selectedValue = this.value;

                    hideAllGroups(); // Ẩn hết trước

                    // Ví dụ: 1 = Điện thoại, 2 = tablet, 3 = Phụ kiện
                    if (selectedValue === "1" || selectedValue === "3") {
                        // Hiện toàn bộ nhóm kỹ thuật
                        techGroups.forEach(id => document.getElementById(id).style.display = "block");
                    } else if (selectedValue === "2") {

                        filteredGroups.forEach(id =>
                            document.getElementById(id).style.display = "block"
                        );
                    } else {
                        // Phụ kiện: không hiện gì
                    }
                });
            </script>

    </body>
</html>
