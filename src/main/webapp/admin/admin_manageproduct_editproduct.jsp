<%@page import="model.Specification"%>
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


                <div class="container-fluid p-4">
                    <h1 class="w-50 mx-auto bg-light p-4 rounded shadow">Update Product</h1>
                </div>


                <%                    Products product = (Products) request.getAttribute("product");
                    Specification specification = (Specification) request.getAttribute("specification");
                    List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");
                    List<Category> listCategories = (List<Category>) request.getAttribute("listCategories");
                %>
                <!-- Table -->
                <form action="product" method="post" id="variantForm" class="w-50 mx-auto bg-light p-4 rounded shadow">
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
                        <input type="hidden" class="form-control" name="pID" value="<%= product.getProductID()%>" readonly>
                    </div>
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="specID" value="<%= specification.getSpecificationID()%>" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="pName" value="<%= product.getName()%>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <select class="form-select" name="category" id="category">

                            <%
                                for (Category ct : listCategories) {
                            %>
                            <option value="<%= ct.getCategoryId()%>" <%= (product.getCategoryID() == ct.getCategoryId()) ? "selected" : ""%> ><%= ct.getCategoryName()%></option>
                            <%
                                }
                            %>             
                        </select>
                        <p id="categoryError" class="text-danger mt-2" style="display:none;">Please select a category!</p>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Brand</label>
                        <input type="text" class="form-control" name="brand" value="<%= product.getBrand()%>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Warranty Period</label>
                        <input type="text" class="form-control" name="warrantyPeriod" value="<%= product.getWarrantyPeriod()%>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Supplier</label>
                        <select class="form-select" name="supplierID" id="supplierID">

                            <%
                                for (Suppliers sl : listSupplier) {
                            %>
                            <option value="<%= sl.getSupplierID()%>" <%= product.getSupplierID() == sl.getSupplierID() ? "selected" : ""%>><%= sl.getName()%></option>
                            <%
                                }
                            %>             
                        </select>
                        <p id="supplierError" class="text-danger mt-2" style="display:none;">Please select a supplier!</p>
                    </div>
                    <div class="mb-3" id="group-tech">
                        <label class="form-label">OS</label>
                        <input type="text" class="form-control" name="os" value="<%= specification.getOs()%>" required>
                    </div>
                    <div class="mb-3" id="group-cpu">
                        <label class="form-label">CPU</label>
                        <input type="text" class="form-control" name="cpu" value="<%= specification.getCpu()%>" required>
                    </div>
                    <div class="mb-3" id="group-gpu">
                        <label class="form-label">GPU</label>
                        <input type="text" class="form-control" name="gpu" value="<%= specification.getGpu()%>" required>
                    </div>
                    <div class="mb-3" id="group-ram">
                        <label class="form-label">RAM</label>
                        <input type="text" class="form-control" name="ram" value="<%= specification.getRam()%>" required>
                    </div>
                    <div class="mb-3" id="group-battery">
                        <label class="form-label">Battery Capacity</label>
                        <input type="number" class="form-control" name="batteryCapacity" value="<%= specification.getBatteryCapacity()%>" required>
                    </div>
                    <div class="mb-3" id="group-touchscreen">
                        <label class="form-label">Touchscreen</label>
                        <input type="text" class="form-control" name="touchscreen" value="<%= specification.getTouchscreen()%>" required>
                    </div>
                    <div class="mb-3">

                        <button type="submit" name="action" value="updateProduct" class="btn btn-primary w-100">Update</button>
                    </div>


                </form>
            </div>


            <!-- JS Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

            <!-- Custom JS -->
            <script src="js/dashboard.js"></script>

            <script>
                const categorySelect = document.getElementById("category");

                // Gom nhóm input để dễ xử lý
                const techGroups = [
                    "group-tech", "group-cpu", "group-gpu", "group-ram",
                    "group-battery", "group-touchscreen"
                ];

                const filteredGroups = techGroups.filter(id => id !== "group-cpu" && id !== "group-tech" && id !== "group-ram");

// Ẩn hết nhóm và bỏ required
                function hideAllGroups() {
                    techGroups.forEach(id => {
                        const group = document.getElementById(id);
                        group.style.display = "none";
                        group.querySelectorAll("input").forEach(input => input.removeAttribute("required"));
                    });
                }

// Khi chọn Category
                categorySelect.addEventListener("change", function () {
                    const selectedValue = this.value;

                    hideAllGroups(); // Ẩn hết trước

                    if (selectedValue === "1" || selectedValue === "3") {
                        techGroups.forEach(id => {
                            const group = document.getElementById(id);
                            group.style.display = "block";
                            group.querySelectorAll("input").forEach(input => input.setAttribute("required", "true"));
                        });
                    } else if (selectedValue === "2") {
                        filteredGroups.forEach(id => {
                            const group = document.getElementById(id);
                            group.style.display = "block";
                            group.querySelectorAll("input").forEach(input => input.setAttribute("required", "true"));
                        });
                    } else {
                        // Phụ kiện: không hiện gì
                    }
                });

// Gọi lần đầu khi trang load (hiển thị theo category hiện tại)
                categorySelect.dispatchEvent(new Event("change"));
            </script>
    </body>
</html>
