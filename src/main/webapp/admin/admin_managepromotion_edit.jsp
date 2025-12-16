<%@page import="model.Staff"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="model.Promotions"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Products"%>
<%@page import="model.Variants"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Update Promotion</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_createpromotion.css">
    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <!-- Sidebar -->
            <%@ include file="sidebar.jsp" %>
            <% Staff currentUser = (Staff) session.getAttribute("user");%>
            <!-- Page Content -->
            <div class="page-content flex-grow-1">
                <!-- Navbar -->
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

                


                <%                    Promotions promotion = (Promotions) request.getAttribute("promotion");
                    Products product = (Products) request.getAttribute("product");
                    DateTimeFormatter format = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                    List<Products> listProduct = (List<Products>) request.getAttribute("listProduct");
                    String formattedStartDate = promotion.getStartDate().toLocalDate().format(format);
                    String formattedEndDate = promotion.getEndDate().toLocalDate().format(format);

                %>
                <!-- Table -->
                <div class="container-fluid p-4">
                    <form action="promotion" id="promotionForm" method="post" class="form-card p-5 mx-auto" style="max-width: 800px;">
                        <div class="form-header text-center">
                            <h2 class="fw-bold text-primary mb-1">Update Promotion</h2>
                            <p class="text-muted">Modify discount campaign details</p>
                        </div>
                        <div class="mb-3">
                            <input type="hidden" class="form-control" name="pmtID" value="<%= promotion.getPromotionID()%>" readonly>
                        </div>

                        <div class="row g-4">
                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-tag-fill me-2"></i>Product Details</h5>
                                <div class="mb-3">
                                    <label class="form-label">Select Product</label>
                                    <select class="form-select" name="pID" id="pID">
                                        <%
                                            for (Products p : listProduct) {
                                        %>                    
                                        <option value="<%= p.getProductID()%>" <%= (p.getProductID() == product.getProductID() ? "selected" : "")%> ><%= p.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                    <p id="productError" class="text-danger mt-2" style="display:none;">Please select a product!</p>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Discount Percent (%)</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-percent"></i></span>
                                        <input type="number" class="form-control" name="discountPercent" id="discountPercent" value="<%= promotion.getDiscountPercent()%>" >
                                    </div>

                                    <p id="discountError" class="text-danger mt-2" style="display:none;">Please enter a number!</p>
                                    <p id="discountRangeError" class="text-danger mt-2" style="display:none;">Please enter number 0 to 100!</p>
                                </div>
                            </div>





                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-calendar-range me-2"></i>Duration</h5>
                                <div class="mb-3">
                                    <label class="form-label">Start Date</label>
                                    <input type="text" class="form-control" name="startDate" id="startDate" placeholder="dd-MM-yyyy" value="<%= formattedStartDate%>" >
                                    <input type="hidden" class="form-control" name="currentStartDate" id="currentStartDate" value="<%= formattedStartDate%>" required>
                                    <p id="startDateError" class="text-danger mt-2" style="display:none;">Please enter a value in this field!</p>
                                    <p id="formatStartDateError" class="text-danger mt-2" style="display:none;">Please enter format dd-MM-yyyy!</p>
                                    <p id="conditionStartDate" class="text-danger mt-2" style="display:none;">Start date cannot be before today!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">End Date</label>
                                    <input type="text" class="form-control" name="endDate" id="endDate" placeholder="dd-MM-yyyy"  value="<%= formattedEndDate%>" >
                                    <input type="hidden" class="form-control" name="currentEndDate" id="currentEndDate" value="<%= formattedEndDate%>" required>
                                    <p id="endDateError" class="text-danger mt-2" style="display:none;">Please enter a value in this field!</p>
                                    <p id="formatEndDateError" class="text-danger mt-2" style="display:none;">Please enter format dd-MM-yyyy!</p>
                                    <p id="conditionEndDate" class="text-danger mt-2" style="display:none;">End date cannot be before start date!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Status</label>
                                    <select class="form-select" name="status" id="status">

                                        <option value="active" <%= (promotion.getStatus().equalsIgnoreCase("active") ? "selected" : "")%>>Active</option>
                                        <option value="expired" <%= (promotion.getStatus().equalsIgnoreCase("expired") ? "selected" : "")%> >Expired</option>
                                        <option value="pending" <%= (promotion.getStatus().equalsIgnoreCase("pending") ? "selected" : "")%> >Pending</option>

                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex gap-2">
                            <button type="submit" name="action" value="updatePromotion" class="btn btn-primary flex-fill">Update</button>
                            <button type="submit" name="action" value="deletePromotion" class="btn btn-danger flex-fill">Delete</button>
                        </div>

                    </form>
                </div>

            </div>


            <!-- JS Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

            <!-- Custom JS -->
            <script src="js/dashboard.js"></script>
            <script>
                document.getElementById("promotionForm").addEventListener("submit", function (e) {
                    const product = document.getElementById("pID");
                    const startDate = document.getElementById("startDate");
                    const currentStartDate = document.getElementById("currentStartDate");
                    const endDate = document.getElementById("endDate");
                    const currentEndDate = document.getElementById("currentEndDate");
                    const discountPercent = document.getElementById("discountPercent");

                    const productError = document.getElementById("productError");
                    const startDateError = document.getElementById("startDateError");
                    const endDateError = document.getElementById("endDateError");
                    const formatStartDateError = document.getElementById("formatStartDateError");
                    const formatEndDateError = document.getElementById("formatEndDateError");
                    const discountError = document.getElementById("discountError");
                    const discountRangeError = document.getElementById("discountRangeError");
                    const conditionStartDate = document.getElementById("conditionStartDate");
                    const conditionEndDate = document.getElementById("conditionEndDate");

                    const today = new Date();
                    today.setHours(0, 0, 0, 0);





                    let isValid = true;
                    // Regex check dd/MM/yyyy
                    const dateRegex = /^(0[1-9]|[12][0-9]|3[01])\-(0[1-9]|1[0-2])\-[0-9]{4}$/;

                    // Check product
                    if (product.value === "") {
                        productError.style.display = "block";
                        product.classList.add("is-invalid");
                        isValid = false;
                    } else {
                        productError.style.display = "none";
                        product.classList.remove("is-invalid");
                    }

                    //check start date
                    if (currentStartDate.value !== startDate.value) {
                        if (startDate.value === "") {
                            startDateError.style.display = "block";
                            startDate.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            startDateError.style.display = "none";
                            startDate.classList.remove("is-invalid");
                            if (!dateRegex.test(startDate.value)) {
                                formatStartDateError.style.display = "block";
                                startDate.classList.add("is-invalid");
                                isValid = false;
                            } else {
                                formatStartDateError.style.display = "none";
                                startDate.classList.remove("is-invalid");

                                const [day, month, year] = startDate.value.split('-');
                                const startDateValue = new Date(year, month - 1, day);
                                if (startDateValue < today) {
                                    conditionStartDate.style.display = "block";
                                    startDate.classList.add("is-invalid");
                                    isValid = false;
                                } else {
                                    conditionStartDate.style.display = "none";
                                    startDate.classList.remove("is-invalid");
                                }

                            }
                        }
                    }

                    //check end date
                    if (currentStartDate.value !== startDate.value || currentEndDate.value !== endDate.value) {
                        if (endDate.value === "") {
                            endDateError.style.display = "block";
                            endDate.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            endDateError.style.display = "none";
                            endDate.classList.remove("is-invalid");
                            if (!dateRegex.test(endDate.value)) {
                                formatEndDateError.style.display = "block";
                                endDate.classList.add("is-invalid");
                                isValid = false;
                            } else {
                                formatEndDateError.style.display = "none";
                                endDate.classList.remove("is-invalid");
                                const [sday, smonth, syear] = startDate.value.split('-');
                                const startDateValue = new Date(syear, smonth - 1, sday);
                                const [eday, emonth, eyear] = endDate.value.split('-');
                                const endDateValue = new Date(eyear, emonth - 1, eday);
                                if (endDateValue < startDateValue) {
                                    conditionEndDate.style.display = "block";
                                    endDate.classList.add("is-invalid");
                                    isValid = false;
                                } else {
                                    conditionEndDate.style.display = "none";
                                    endDate.classList.remove("is-invalid");
                                }

                            }
                        }
                    }

                    // check discount
                    if (discountPercent.value.trim() === "") {
                        discountError.style.display = "block";
                        discountRangeError.style.display = "none";
                        discountPercent.classList.add("is-invalid");
                        isValid = false;
                    } else {
                        const discount = Number(discountPercent.value.trim());
                        if (isNaN(discount)) {
                            discountError.style.display = "block";
                            discountRangeError.style.display = "none";
                            discountPercent.classList.add("is-invalid");
                            isValid = false;
                        } else if (discount < 0 || discount > 100) {
                            discountError.style.display = "none";
                            discountRangeError.style.display = "block";
                            discountPercent.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            discountError.style.display = "none";
                            discountRangeError.style.display = "none";
                            discountPercent.classList.remove("is-invalid");
                        }
                    }




                    if (!isValid) {
                        e.preventDefault();
                        document.querySelector(".is-invalid").scrollIntoView({
                            behavior: "smooth",
                            block: "center"
                        });
                    }
                });
            </script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const form = document.querySelector('form[action="promotion"]');
                    const deleteBtn = form?.querySelector('button[name="action"][value="deletePromotion"]');

                    if (!deleteBtn) {
                        console.error("Delete button not found!");
                        return;
                    }

                    deleteBtn.addEventListener('click', function (event) {
                        event.preventDefault(); // Prevent default submit

                        Swal.fire({
                            title: 'Are you sure you want to delete this promotion?',
                            text: 'This action cannot be undone.',
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonColor: '#dc3545',
                            cancelButtonColor: '#6c757d',
                            confirmButtonText: 'Delete',
                            cancelButtonText: 'Cancel',
                            reverseButtons: true,
                            background: '#fff',
                            color: '#333',
                            customClass: {
                                popup: 'shadow-lg rounded-4 p-3',
                                confirmButton: 'px-4 py-2 rounded-3',
                                cancelButton: 'px-4 py-2 rounded-3'
                            }
                        }).then((result) => {
                            if (result.isConfirmed) {
                                // Ensure correct action is sent
                                let actionInput = form.querySelector('input[name="action"]');
                                if (!actionInput) {
                                    actionInput = document.createElement('input');
                                    actionInput.type = 'hidden';
                                    actionInput.name = 'action';
                                    form.appendChild(actionInput);
                                }
                                actionInput.value = 'deletePromotion';
                                form.submit();
                            }
                        });
                    });
                });
            </script>
    </body>
</html>
