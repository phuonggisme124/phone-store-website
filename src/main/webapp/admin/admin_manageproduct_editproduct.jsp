<%@page import="model.Staff"%>
<%@page import="model.Specification"%>
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
        <title>Admin Dashboard - Update Product</title>

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
                    Products product = (Products) request.getAttribute("product");
                    Specification specification = (Specification) request.getAttribute("specification");
                    List<Suppliers> listSupplier = (List<Suppliers>) request.getAttribute("listSupplier");
                    List<Category> listCategories = (List<Category>) request.getAttribute("listCategories");
                %>

                <div class="container-fluid p-4">
                    <form action="product" method="post" id="productForm" class="form-card p-5 mx-auto" style="max-width: 900px;">
                        
                        <div class="form-header text-center">
                            <h2 class="fw-bold text-primary mb-1">Update Product</h2>
                            <p class="text-muted">Edit details for product #<%= product.getProductID() %></p>
                        </div>

                        <div class="mb-4 text-center">
                            <% if (session.getAttribute("existName") != null) {
                                String exist = (String) session.getAttribute("existName");
                                out.println("<div class='alert alert-danger shadow-sm border-0 rounded-3'><i class='bi bi-exclamation-circle-fill me-2'></i>" + exist + "</div>");
                            } session.removeAttribute("existName"); %>
                        </div>

                        <input type="hidden" name="pID" value="<%= product.getProductID()%>">
                        <input type="hidden" name="specID" value="<%= specification.getSpecificationID()%>">

                        <div class="row g-4">
                            
                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-info-circle me-2"></i>Basic Info</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">Product Name</label>
                                    <input type="text" class="form-control" name="pName" value="<%= product.getName()%>" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Category</label>
                                    <select class="form-select" name="category" id="category">
                                        <% for (Category ct : listCategories) { %>
                                        <option value="<%= ct.getCategoryId()%>" <%= (product.getCategoryID() == ct.getCategoryId()) ? "selected" : ""%> ><%= ct.getCategoryName()%></option>
                                        <% } %>              
                                    </select>
                                    <p id="categoryError" class="text-danger mt-2" style="display:none; font-size: 0.85rem;"><i class="bi bi-exclamation-circle-fill me-1"></i>Select category!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Supplier</label>
                                    <select class="form-select" name="supplierID" id="supplierID">
                                        <% for (Suppliers sl : listSupplier) { %>
                                        <option value="<%= sl.getSupplierID()%>" <%= product.getSupplierID() == sl.getSupplierID() ? "selected" : ""%>><%= sl.getName()%></option>
                                        <% } %>              
                                    </select>
                                    <p id="supplierError" class="text-danger mt-2" style="display:none; font-size: 0.85rem;"><i class="bi bi-exclamation-circle-fill me-1"></i>Select supplier!</p>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Brand</label>
                                        <input type="text" class="form-control" name="brand" value="<%= product.getBrand()%>" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Warranty</label>
                                        <input type="text" class="form-control" name="warrantyPeriod" value="<%= product.getWarrantyPeriod()%>" required>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-cpu me-2"></i>Tech Specs</h5>

                                <div class="mb-3" id="group-tech">
                                    <label class="form-label">Operating System (OS)</label>
                                    <input type="text" class="form-control" name="os" id="os" value="<%= specification.getOs()%>">
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3" id="group-cpu">
                                        <label class="form-label">CPU</label>
                                        <input type="text" class="form-control" name="cpu" id="cpu" value="<%= specification.getCpu()%>">
                                    </div>
                                    <div class="col-md-6 mb-3" id="group-gpu">
                                        <label class="form-label">GPU</label>
                                        <input type="text" class="form-control" name="gpu" id="gpu" value="<%= specification.getGpu()%>">
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3" id="group-ram">
                                        <label class="form-label">RAM</label>
                                        <input type="text" class="form-control" name="ram" id="ram" value="<%= specification.getRam()%>">
                                    </div>
                                    <div class="col-md-6 mb-3" id="group-battery">
                                        <label class="form-label">Battery (mAh)</label>
                                        <input type="number" class="form-control" name="batteryCapacity" id="batteryCapacity" value="<%= specification.getBatteryCapacity()%>">
                                    </div>
                                </div>

                                <div class="mb-3" id="group-touchscreen">
                                    <label class="form-label">Touchscreen</label>
                                    <input type="text" class="form-control" name="touchscreen" id="touchscreen" value="<%= specification.getTouchscreen()%>">
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top text-center">
                            <button type="submit" name="action" value="updateProduct" class="btn btn-gradient-primary rounded-pill w-50">
                                <i class="bi bi-check-circle me-2"></i> Update Product
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

            // 2. Logic ẩn hiện input theo Category & Validation (Tự động set required)
            const categorySelect = document.getElementById("category");
            const techGroups = ["group-tech", "group-cpu", "group-gpu", "group-ram", "group-battery", "group-touchscreen"];
            const tabletGroups = techGroups.filter(id => id !== "group-cpu" && id !== "group-tech" && id !== "group-ram");

            function hideAllGroups() {
                techGroups.forEach(id => {
                    const group = document.getElementById(id);
                    group.style.display = "none";
                    // Bỏ required khi ẩn
                    group.querySelectorAll("input").forEach(input => input.removeAttribute("required"));
                });
            }

            function updateFormFields() {
                const selectedValue = categorySelect.value;
                hideAllGroups();

                if (selectedValue === "1" || selectedValue === "3") { // Phone (1) or (3)
                    techGroups.forEach(id => {
                        const group = document.getElementById(id);
                        group.style.display = "block";
                        group.querySelectorAll("input").forEach(input => input.setAttribute("required", "true"));
                    });
                } else if (selectedValue === "2") { // Tablet
                    tabletGroups.forEach(id => {
                        const group = document.getElementById(id);
                        group.style.display = "block";
                        group.querySelectorAll("input").forEach(input => input.setAttribute("required", "true"));
                    });
                }
            }

            // Lắng nghe sự kiện change
            categorySelect.addEventListener("change", updateFormFields);

            // Gọi lần đầu khi trang load để hiển thị đúng theo data hiện có
            updateFormFields();
        </script>
    </body>
</html>