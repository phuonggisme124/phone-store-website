<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="model.Promotions"%>
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
                    <input type="text" class="form-control w-25" placeholder="🔍 Search">
                </div>


                <%                    Promotions promotion = (Promotions) request.getAttribute("promotion");
                    Products product = (Products) request.getAttribute("product");
                    DateTimeFormatter format = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                    List<Products> listProduct = (List<Products>) request.getAttribute("listProduct");
                    String formattedStartDate = promotion.getStartDate().toLocalDate().format(format);
                    String formattedEndDate = promotion.getEndDate().toLocalDate().format(format);

                %>
                <!-- Table -->
                <form action="promotion" method="post" id="promotionForm" class="w-50 mx-auto bg-light p-4 rounded shadow">
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="pmtID" value="<%= promotion.getPromotionID()%>" readonly>
                    </div>



                    <div class="mb-3">
                        <label class="form-label">Product Name</label>
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
                        <label class="form-label">Discount Percent</label>
                        <input type="number" class="form-control" name="discountPercent" id="discountPercent" value="<%= promotion.getDiscountPercent()%>" >
                        <p id="discountError" class="text-danger mt-2" style="display:none;">Please enter a number!</p>
                        <p id="discountRangeError" class="text-danger mt-2" style="display:none;">Please enter number 0 to 100!</p>
                    </div>

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



                    <div class="d-flex gap-2">
                        <button type="submit" name="action" value="updatePromotion" class="btn btn-primary flex-fill">Update</button>
                        <button type="submit" name="action" value="deletePromotion" class="btn btn-danger flex-fill">Delete</button>
                    </div>

                </form>
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
