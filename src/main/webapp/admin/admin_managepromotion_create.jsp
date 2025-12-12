<%@page import="model.Staff"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Create Promotion</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_createpromotion.css">

        
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

                <% List<Products> listProducts = (List<Products>) request.getAttribute("listProducts"); %>

                <div class="container-fluid p-4">
                    <form action="promotion" id="promotionForm" method="post" class="form-card p-5 mx-auto" style="max-width: 800px;">
                        
                        <div class="form-header text-center">
                            <h2 class="fw-bold text-primary mb-1">Create Promotion</h2>
                            <p class="text-muted">Set up a new discount campaign</p>
                        </div>
                        
                        <input type="hidden" name="pmtID" value="">

                        <div class="row g-4">
                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-tag-fill me-2"></i>Product Details</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">Select Product</label>
                                    <select class="form-select" name="pID" id="pID">
                                        <option selected value="">Choose a product...</option>
                                        <% for (Products p : listProducts) { %>
                                        <option value="<%= p.getProductID()%>"><%= p.getName()%></option>
                                        <% } %>
                                    </select>
                                    <p id="productError" class="text-danger mt-2" style="display:none;">Please select a product!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Discount Percent (%)</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-percent"></i></span>
                                        <input type="number" class="form-control" name="discountPercent" id="discountPercent" placeholder="e.g. 20">
                                    </div>
                                    <p id="discountError" class="text-danger mt-2" style="display:none;">Enter discount value!</p>
                                    <p id="discountRangeError" class="text-danger mt-2" style="display:none;">Value must be 0 - 100!</p>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-calendar-range me-2"></i>Duration</h5>

                                <div class="mb-3">
                                    <label class="form-label">Start Date</label>
                                    <input type="text" class="form-control" name="startDate" id="startDate" placeholder="dd-MM-yyyy">
                                    <p id="startDateError" class="text-danger mt-2" style="display:none;">Enter start date!</p>
                                    <p id="formatStartDateError" class="text-danger mt-2" style="display:none;">Format: dd-MM-yyyy</p>
                                    <p id="conditionStartDate" class="text-danger mt-2" style="display:none;">Cannot be before today!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">End Date</label>
                                    <input type="text" class="form-control" name="endDate" id="endDate" placeholder="dd-MM-yyyy">
                                    <p id="endDateError" class="text-danger mt-2" style="display:none;">Enter end date!</p>
                                    <p id="formatEndDateError" class="text-danger mt-2" style="display:none;">Format: dd-MM-yyyy</p>
                                    <p id="conditionEndDate" class="text-danger mt-2" style="display:none;">Must be after start date!</p>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top text-center">
                            <button type="submit" name="action" value="createPromotion" class="btn btn-gradient-primary rounded-pill w-50">
                                <i class="bi bi-check-circle me-2"></i> Create Campaign
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

            // 2. Form Validation
            document.getElementById("promotionForm").addEventListener("submit", function (e) {
                const product = document.getElementById("pID");
                const startDate = document.getElementById("startDate");
                const endDate = document.getElementById("endDate");
                const discountPercent = document.getElementById("discountPercent");

                // Error Elements
                const productError = document.getElementById("productError");
                const startDateError = document.getElementById("startDateError");
                const formatStartDateError = document.getElementById("formatStartDateError");
                const conditionStartDate = document.getElementById("conditionStartDate");
                const endDateError = document.getElementById("endDateError");
                const formatEndDateError = document.getElementById("formatEndDateError");
                const conditionEndDate = document.getElementById("conditionEndDate");
                const discountError = document.getElementById("discountError");
                const discountRangeError = document.getElementById("discountRangeError");

                const today = new Date();
                today.setHours(0, 0, 0, 0);
                let isValid = true;
                const dateRegex = /^(0[1-9]|[12][0-9]|3[01])\-(0[1-9]|1[0-2])\-[0-9]{4}$/;

                // --- Helper Reset Error ---
                function resetError(field, errorElement) {
                    errorElement.style.display = "none";
                    field.classList.remove("is-invalid");
                    field.classList.add("is-valid");
                }
                function showError(field, errorElement) {
                    errorElement.style.display = "block";
                    field.classList.add("is-invalid");
                    field.classList.remove("is-valid");
                    isValid = false;
                }

                // 1. Check Product
                if (product.value === "") showError(product, productError);
                else resetError(product, productError);

                // 2. Check Discount
                if (discountPercent.value.trim() === "") {
                    showError(discountPercent, discountError);
                    discountRangeError.style.display = "none";
                } else {
                    const discount = Number(discountPercent.value.trim());
                    if (isNaN(discount)) {
                        showError(discountPercent, discountError);
                    } else if (discount < 0 || discount > 100) {
                        showError(discountPercent, discountRangeError);
                        discountError.style.display = "none";
                    } else {
                        resetError(discountPercent, discountError);
                        discountRangeError.style.display = "none";
                    }
                }

                // 3. Check Start Date
                let startDateValue = null;
                if (startDate.value.trim() === "") {
                    showError(startDate, startDateError);
                    formatStartDateError.style.display = "none";
                    conditionStartDate.style.display = "none";
                } else if (!dateRegex.test(startDate.value)) {
                    showError(startDate, formatStartDateError);
                    startDateError.style.display = "none";
                } else {
                    const [day, month, year] = startDate.value.split('-');
                    startDateValue = new Date(year, month - 1, day);
                    if (startDateValue < today) {
                        showError(startDate, conditionStartDate);
                    } else {
                        resetError(startDate, startDateError);
                        formatStartDateError.style.display = "none";
                        conditionStartDate.style.display = "none";
                    }
                }

                // 4. Check End Date
                if (endDate.value.trim() === "") {
                    showError(endDate, endDateError);
                    formatEndDateError.style.display = "none";
                    conditionEndDate.style.display = "none";
                } else if (!dateRegex.test(endDate.value)) {
                    showError(endDate, formatEndDateError);
                    endDateError.style.display = "none";
                } else {
                    const [day, month, year] = endDate.value.split('-');
                    const endDateValue = new Date(year, month - 1, day);
                    
                    if (startDateValue && endDateValue < startDateValue) {
                        showError(endDate, conditionEndDate);
                    } else {
                        resetError(endDate, endDateError);
                        formatEndDateError.style.display = "none";
                        conditionEndDate.style.display = "none";
                    }
                }

                if (!isValid) {
                    e.preventDefault();
                    const firstError = document.querySelector(".is-invalid");
                    if (firstError) {
                        firstError.scrollIntoView({ behavior: "smooth", block: "center" });
                        firstError.focus();
                    }
                }
            });
        </script>
    </body>
</html>