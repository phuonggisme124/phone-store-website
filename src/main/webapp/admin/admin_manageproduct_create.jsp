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
            <%                Users currentUser = (Users) session.getAttribute("user");
            %>
            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>
                        <div class="d-flex align-items-center ms-auto">
                            <a href="logout" class="btn btn-outline-danger btn-sm me-3">Logout</a>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= currentUser.getFullName()%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <!-- Search bar -->



                <%                    Variants variant = (Variants) request.getAttribute("variant");
                    Products product = (Products) request.getAttribute("product");
                    List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");
                    List<Category> listCategories = (List<Category>) request.getAttribute("listCategories");
                %>
                <!-- Table -->
                <form action="product" method="post" id="productForm" class="w-50 mx-auto bg-light p-4 rounded shadow m-3">


                    <div class="container-fluid p-4 ps-3">
                        <h1 class="fw-bold ps-3 mb-4 fw-bold text-primary">Create Product</h1>
                    </div>
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
                        <input type="text" class="form-control" name="pName" id="pName" value="">
                        <p id="productNameError" class="text-danger mt-2" style="display:none;">Please enter product name!</p>
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
                        <input type="text" class="form-control" name="brand" id="brand" value="">
                        <p id="brandError" class="text-danger mt-2" style="display:none;">Please enter product brand!</p>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Warranty Period</label>
                        <input type="text" class="form-control" name="warrantyPeriod" id="warrantyPeriod" value="">
                        <p id="warrantyPeriodError" class="text-danger mt-2" style="display:none;">Please enter warranty period!</p>
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
                        <input type="text" class="form-control" name="os" id="os" value="">
                        <p id="osError" class="text-danger mt-2" style="display:none;">Please enter operating system!</p>
                    </div>
                    <div class="mb-3" id="group-cpu">
                        <label class="form-label">CPU</label>
                        <input type="text" class="form-control" name="cpu" id="cpu" value="">
                        <p id="cpuError" class="text-danger mt-2" style="display:none;">Please enter CPU!</p>
                    </div>
                    <div class="mb-3" id="group-gpu">
                        <label class="form-label">GPU</label>
                        <input type="text" class="form-control" name="gpu" id="gpu" value="">
                        <p id="gpuError" class="text-danger mt-2" style="display:none;">Please enter GPU!</p>
                    </div>
                    <div class="mb-3" id="group-ram">
                        <label class="form-label">RAM</label>
                        <input type="text" class="form-control" name="ram" id="ram" value="">
                        <p id="ramError" class="text-danger mt-2" style="display:none;">Please enter RAM!</p>
                    </div>
                    <div class="mb-3" id="group-battery">
                        <label class="form-label">Battery Capacity</label>
                        <input type="number" class="form-control" name="batteryCapacity" id="batteryCapacity" value="">
                        <p id="batteryCapacityError" class="text-danger mt-2" style="display:none;">Please enter battery capacity!</p>
                    </div>
                    <div class="mb-3" id="group-touchscreen">
                        <label class="form-label">Touchscreen</label>
                        <input type="text" class="form-control" name="touchscreen" id="touchscreen" value=""> 
                        <p id="touchscreenError" class="text-danger mt-2" style="display:none;">Please enter touchscreen!</p>
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
                    const productName = document.getElementById("pName");
                    const brand = document.getElementById("brand");
                    const warrantyPeriod = document.getElementById("warrantyPeriod");
                    const os = document.getElementById("os");
                    const cpu = document.getElementById("cpu");
                    const gpu = document.getElementById("gpu");
                    const ram = document.getElementById("ram");
                    const batteryCapacity = document.getElementById("batteryCapacity");
                    const touchscreen = document.getElementById("touchscreen");

                    const categoryError = document.getElementById("categoryError");
                    const supplierError = document.getElementById("supplierError");
                    const productNameError = document.getElementById("productNameError");
                    const brandError = document.getElementById("brandError");
                    const warrantyPeriodError = document.getElementById("warrantyPeriodError");
                    const osError = document.getElementById("osError");
                    const cpuError = document.getElementById("cpuError");
                    const gpuError = document.getElementById("gpuError");
                    const ramError = document.getElementById("ramError");
                    const touchscreenError = document.getElementById("touchscreenError");

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

                    //check product name
                    if (productName.value === "") {
                        productNameError.style.display = "block";
                        productName.classList.add("is-invalid");
                        isValid = false;
                    } else {
                        productNameError.style.display = "none";
                        productName.classList.remove("is-invalid");
                    }

                    //check brand
                    if (brand.value === "") {
                        brandError.style.display = "block";
                        brand.classList.add("is-invalid");
                        isValid = false;
                    } else {
                        brandError.style.display = "none";
                        brand.classList.remove("is-invalid");
                    }

                    //check warranty Period
                    if (warrantyPeriod.value === "") {
                        warrantyPeriodError.style.display = "block";
                        warrantyPeriod.classList.add("is-invalid");
                        isValid = false;
                    } else {
                        warrantyPeriodError.style.display = "none";
                        warrantyPeriod.classList.remove("is-invalid");
                    }

                    if (category.value === "1" || category.value === "3") {
                        //check os
                        if (os.value === "") {
                            osError.style.display = "block";
                            os.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            osError.style.display = "none";
                            os.classList.remove("is-invalid");
                        }
                        //check cpu
                        if (cpu.value === "") {
                            cpuError.style.display = "block";
                            cpu.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            cpuError.style.display = "none";
                            cpu.classList.remove("is-invalid");
                        }

                        //check gpu
                        if (gpu.value === "") {
                            gpuError.style.display = "block";
                            gpu.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            gpuError.style.display = "none";
                            gpu.classList.remove("is-invalid");
                        }

                        //check ram
                        if (ram.value === "") {
                            ramError.style.display = "block";
                            ram.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            ramError.style.display = "none";
                            ram.classList.remove("is-invalid");
                        }
                        
                        //check battery Capacity
                        if (batteryCapacity.value === "") {
                            batteryCapacityError.style.display = "block";
                            batteryCapacity.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            batteryCapacityError.style.display = "none";
                            batteryCapacity.classList.remove("is-invalid");
                        }
                        
                        //check touchscreen
                        if (touchscreen.value === "") {
                            touchscreenError.style.display = "block";
                            touchscreen.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            touchscreenError.style.display = "none";
                            touchscreen.classList.remove("is-invalid");
                        }
                    }else if (category.value === "2"){
                        //check gpu
                        if (gpu.value === "") {
                            gpuError.style.display = "block";
                            gpu.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            gpuError.style.display = "none";
                            gpu.classList.remove("is-invalid");
                        }
                        //check battery Capacity
                        if (batteryCapacity.value === "") {
                            batteryCapacityError.style.display = "block";
                            batteryCapacity.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            batteryCapacityError.style.display = "none";
                            batteryCapacity.classList.remove("is-invalid");
                        }
                        //check touchscreen
                        if (touchscreen.value === "") {
                            touchscreenError.style.display = "block";
                            touchscreen.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            touchscreenError.style.display = "none";
                            touchscreen.classList.remove("is-invalid");
                        }
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
