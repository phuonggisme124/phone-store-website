<%@page import="model.Staff"%>
<%@page import="model.Users"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Create Supplier</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_createsupplier.css">
        
        
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

                <div class="container-fluid p-4">
                    <form action="supplier?action=createSupplier" id="supplierForm" method="post" class="form-card p-5 mx-auto" style="max-width: 800px;">
                        
                        <div class="form-header text-center">
                            <h2 class="fw-bold text-primary mb-1">Add New Supplier</h2>
                            <p class="text-muted">Enter partner details to add to database</p>
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

                        <div class="row g-4">
                            
                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-person-vcard me-2"></i>Contact Info</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">Supplier Name</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-shop"></i></span>
                                        <input type="text" class="form-control" name="name" id="name" placeholder="e.g. Samsung Vina">
                                    </div>
                                    <p id="nameError" class="text-danger mt-2" style="display:none;">Please enter supplier name!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Phone Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-telephone"></i></span>
                                        <input type="text" class="form-control" name="phone" id="phone" placeholder="e.g. 0912345678">
                                    </div>
                                    <p id="phoneError" class="text-danger mt-2" style="display:none;">Please enter phone number!</p>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-geo-alt me-2"></i>Address & Email</h5>

                                <div class="mb-3">
                                    <label class="form-label">Email Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-envelope"></i></span>
                                        <input type="text" class="form-control" name="email" id="email" placeholder="e.g. contact@samsung.com">
                                    </div>
                                    <p id="emailError" class="text-danger mt-2" style="display:none;">Please enter email!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-map"></i></span>
                                        <input type="text" class="form-control" name="address" id="address" placeholder="e.g. 123 Le Loi St, HCMC">
                                    </div>
                                    <p id="addressError" class="text-danger mt-2" style="display:none;">Please enter address!</p>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top text-center">
                            <button type="submit" class="btn btn-gradient-primary rounded-pill w-50">
                                <i class="bi bi-plus-circle me-2"></i> Create Supplier
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
            document.getElementById("supplierForm").addEventListener("submit", function (e) {
                let isValid = true;
                const reVN = /^(?:\+84|84|0)(?:3|5|7|8|9)\d{8}$/;
                const reEmail = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

                // Helper Validate
                function validateField(id, errorId, regex = null, errorMsgRegex = "") {
                    const field = document.getElementById(id);
                    const error = document.getElementById(errorId);
                    const val = field.value.trim();
                    let isError = false;
                    let msg = "This field is required!";

                    if (val === "") {
                        isError = true;
                    } else if (regex && !regex.test(val)) {
                        isError = true;
                        msg = errorMsgRegex;
                    }

                    if (isError) {
                        error.innerText = msg; // Update message text
                        error.style.display = "block";
                        field.classList.add("is-invalid");
                        return false;
                    } else {
                        error.style.display = "none";
                        field.classList.remove("is-invalid");
                        field.classList.add("is-valid");
                        return true;
                    }
                }

                // Check Fields
                if (!validateField("name", "nameError")) isValid = false;
                if (!validateField("phone", "phoneError", reVN, "Invalid Phone format! e.g. 09xxxx")) isValid = false;
                if (!validateField("email", "emailError", reEmail, "Invalid Email format!")) isValid = false;
                if (!validateField("address", "addressError")) isValid = false;

                if (!isValid) {
                    e.preventDefault();
                    // Scroll to first error
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