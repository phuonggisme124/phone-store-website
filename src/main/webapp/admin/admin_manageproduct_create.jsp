<%@page import="model.Staff"%>
<%@page import="model.Category"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Products"%>
<%@page import="model.Variants"%>
<%@page import="java.util.List"%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Create Product</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_createproduct.css">

        
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>

            <% Staff currentUser = (Staff) session.getAttribute("user"); %>

            <div class="page-content flex-grow-1">
                
                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2 sticky-top">
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>

                        <div class="d-flex align-items-center ms-auto gap-3">
                            <div class="vr text-secondary opacity-25 mx-1" style="height: 25px;"></div>
                            <div class="d-flex align-items-center gap-3">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="position-relative">
                                        <img src="https://i.pravatar.cc/150?u=<%= currentUser.getStaffID()%>" 
                                             class="rounded-circle border border-2 border-white shadow-sm" 
                                             width="40" height="40" alt="Avatar">
                                        <span class="position-absolute bottom-0 start-100 translate-middle p-1 bg-success border border-light rounded-circle">
                                            <span class="visually-hidden">Online</span>
                                        </span>
                                    </div>
                                    <div class="d-none d-md-block lh-1">
                                        <span class="d-block fw-bold text-dark" style="font-size: 0.9rem;"><%= currentUser.getFullName()%></span>
                                        <span class="d-block text-muted" style="font-size: 0.75rem;">Administrator</span>
                                    </div>
                                </div>
                                
                                <a href="logout" class="btn btn-light text-danger rounded-circle shadow-sm d-flex align-items-center justify-content-center hover-danger" 
                                   style="width: 38px; height: 38px;" title="Logout">
                                    <i class="bi bi-box-arrow-right fs-6"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </nav>

                <% 
                    Variants variant = (Variants) request.getAttribute("variant");
                    Products product = (Products) request.getAttribute("product");
                    List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");
                    List<Category> listCategories = (List<Category>) request.getAttribute("listCategories");
                %>
                
                <div class="container-fluid p-4">
                    <form action="product" method="post" id="productForm" class="form-card p-5 mx-auto" style="max-width: 900px;">
                        
                        <div class="form-header text-center">
                            <h2 class="fw-bold text-primary mb-1">Create New Product</h2>
                            <p class="text-muted">Enter product details and technical specifications</p>
                        </div>

                        <div class="mb-4 text-center">
                            <%
                                if (session.getAttribute("existName") != null) {
                                    String exist = (String) session.getAttribute("existName");
                                    out.println("<div class='alert alert-danger shadow-sm border-0 rounded-3'><i class='bi bi-exclamation-circle-fill me-2'></i>" + exist + "</div>");
                                }
                                session.removeAttribute("existName");
                            %>
                        </div>

                        <input type="hidden" name="vID" value="">
                        <input type="hidden" name="pID" value="">

                        <div class="row g-4">
                            
                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-info-circle me-2"></i>Basic Info</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">Product Name</label>
                                    <input type="text" class="form-control" name="pName" id="pName" placeholder="e.g. iPhone 15 Pro Max">
                                    <p id="productNameError" class="text-danger mt-2" style="display:none;">Please enter product name!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Category</label>
                                    <select class="form-select" name="category" id="category">
                                        <option selected value="">Select Category</option>
                                        <% for (Category ct : listCategories) { %>
                                        <option value="<%= ct.getCategoryId()%>" ><%= ct.getCategoryName()%></option>
                                        <% } %>              
                                    </select>
                                    <p id="categoryError" class="text-danger mt-2" style="display:none;">Please select a category!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Supplier</label>
                                    <select class="form-select" name="supplierID" id="supplierID">
                                        <option selected value="">Select Supplier</option>
                                        <% for (Suppliers sl : listSupplier) { %>
                                        <option value="<%= sl.getSupplierID()%>"><%= sl.getName()%></option>
                                        <% } %>              
                                    </select>
                                    <p id="supplierError" class="text-danger mt-2" style="display:none;">Please select a supplier!</p>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Brand</label>
                                        <input type="text" class="form-control" name="brand" id="brand" placeholder="e.g. Apple">
                                        <p id="brandError" class="text-danger mt-2" style="display:none;">Enter brand!</p>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Warranty</label>
                                        <input type="text" class="form-control" name="warrantyPeriod" id="warrantyPeriod" placeholder="e.g. 12 Months">
                                        <p id="warrantyPeriodError" class="text-danger mt-2" style="display:none;">Enter warranty!</p>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-cpu me-2"></i>Tech Specs</h5>

                                <div class="mb-3" id="group-tech">
                                    <label class="form-label">Operating System (OS)</label>
                                    <input type="text" class="form-control" name="os" id="os" placeholder="e.g. iOS 17">
                                    <p id="osError" class="text-danger mt-2" style="display:none;">Enter OS!</p>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3" id="group-cpu">
                                        <label class="form-label">CPU</label>
                                        <input type="text" class="form-control" name="cpu" id="cpu" placeholder="e.g. A17 Pro">
                                        <p id="cpuError" class="text-danger mt-2" style="display:none;">Enter CPU!</p>
                                    </div>
                                    <div class="col-md-6 mb-3" id="group-gpu">
                                        <label class="form-label">GPU</label>
                                        <input type="text" class="form-control" name="gpu" id="gpu" placeholder="e.g. 6-core GPU">
                                        <p id="gpuError" class="text-danger mt-2" style="display:none;">Enter GPU!</p>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3" id="group-ram">
                                        <label class="form-label">RAM</label>
                                        <input type="text" class="form-control" name="ram" id="ram" placeholder="e.g. 8GB">
                                        <p id="ramError" class="text-danger mt-2" style="display:none;">Enter RAM!</p>
                                    </div>
                                    <div class="col-md-6 mb-3" id="group-battery">
                                        <label class="form-label">Battery (mAh)</label>
                                        <input type="number" class="form-control" name="batteryCapacity" id="batteryCapacity" placeholder="e.g. 4422">
                                        <p id="batteryCapacityError" class="text-danger mt-2" style="display:none;">Enter capacity!</p>
                                    </div>
                                </div>

                                <div class="mb-3" id="group-touchscreen">
                                    <label class="form-label">Touchscreen Technology</label>
                                    <input type="text" class="form-control" name="touchscreen" id="touchscreen" placeholder="e.g. OLED, 120Hz">
                                    <p id="touchscreenError" class="text-danger mt-2" style="display:none;">Enter touchscreen!</p>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top text-center">
                            <button type="submit" name="action" value="createProduct" class="btn btn-gradient-primary rounded-pill w-50">
                                <i class="bi bi-plus-circle me-2"></i> Create Product
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        
        <script src="js/dashboard.js"></script>
        <script>
            // 1. Sidebar Toggle
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });

            // 2. Logic ẩn hiện input theo Category
            const categorySelect = document.getElementById("category");
            const techGroups = ["group-tech", "group-cpu", "group-gpu", "group-ram", "group-battery", "group-touchscreen"];
            
            const tabletGroups = techGroups.filter(id => id !== "group-cpu" && id !== "group-tech" && id !== "group-ram");

            function hideAllGroups() {
                techGroups.forEach(id => document.getElementById(id).style.display = "none");
            }

            hideAllGroups();

            categorySelect.addEventListener("change", function () {
                const selectedValue = this.value;
                hideAllGroups();

                if (selectedValue === "1" || selectedValue === "3") {
                    techGroups.forEach(id => document.getElementById(id).style.display = "block");
                } else if (selectedValue === "2") {
                    tabletGroups.forEach(id => document.getElementById(id).style.display = "block");
                }
            });

            // 3. Validation Logic
            document.getElementById("productForm").addEventListener("submit", function (e) {
                let isValid = true;
                
                function validateField(id, errorId) {
                    const field = document.getElementById(id);
                    const error = document.getElementById(errorId);
                    
                    if(field.offsetParent === null) return true; 

                    if (!field.value.trim()) {
                        error.style.display = "block";
                        field.classList.add("is-invalid");
                        return false;
                    } else {
                        error.style.display = "none";
                        field.classList.remove("is-invalid");
                        return true;
                    }
                }

                const fields = [
                    {id: "category", err: "categoryError"},
                    {id: "supplierID", err: "supplierError"},
                    {id: "pName", err: "productNameError"},
                    {id: "brand", err: "brandError"},
                    {id: "warrantyPeriod", err: "warrantyPeriodError"},
                    {id: "os", err: "osError"},
                    {id: "cpu", err: "cpuError"},
                    {id: "gpu", err: "gpuError"},
                    {id: "ram", err: "ramError"},
                    {id: "batteryCapacity", err: "batteryCapacityError"},
                    {id: "touchscreen", err: "touchscreenError"}
                ];

                fields.forEach(f => {
                    if (!validateField(f.id, f.err)) isValid = false;
                });

                if (!isValid) {
                    e.preventDefault();
                    const firstError = document.querySelector(".is-invalid");
                    if(firstError) firstError.scrollIntoView({ behavior: "smooth", block: "center" });
                }
            });
        </script>
    </body>
</html>