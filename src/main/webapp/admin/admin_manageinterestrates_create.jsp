<%@page import="model.InterestRate"%>
<%@page import="model.Staff"%>
<%@page import="model.Suppliers"%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Create Interest Rate</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_editsupplier.css">

    </head>
    <body>
        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>
            <% Staff currentUser = (Staff) session.getAttribute("user");%>

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

                <div div class="container-fluid p-4">
                    <form action="interestrates" method="post">
                        <div class="form-header text-center">
                            <h2 class="fw-bold text-primary mb-1">Create Interest Rate</h2>
                            <p class="text-muted">Create information</p>
                        </div>
                        <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-person-vcard me-2"></i>Contact Info</h5>
                        <div class="mb-3">
                            <input type="hidden" name="action" value="createInterestRate">
                            <input type="hidden" id="id" name="id" class="form-control" 
                                   value="" readonly>
                        </div>

                        <div class="mb-3">
                            <label for="period">Period</label>
                            <input type="number" id="period" name="period" class="form-control" 
                                   value="" required placeholder="Ví dụ: 6">
                        </div>

                        <div class="mb-3">
                            <label for="rateValue">Interest Rate</label>
                            <input type="number" step="0.01" id="rateValue" name="rateValue" class="form-control" 
                                   value="" required placeholder="Ví dụ: 5.5">
                        </div>

                        <div class="mb-3">
                            <label for="rateValue">Penalty (Expired)</label>
                            <input type="number" step="0.01" id="rateExpired" name="rateExpired" class="form-control" 
                                   value="" required placeholder="Ví dụ: 5.5">
                        </div>

                        <div class="btn-group">
                            <a href="interestrate?action=viewInterestRate" class="btn btn-cancel">Cancel</a>

                            <button type="submit" class="btn btn-save">Create</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="js/dashboard.js"></script>

        <script>
            // 1. Sidebar Toggle
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });

            // 2. Form Validation
            document.getElementById("supplierForm").addEventListener("submit", function (e) {
                let isValid = true;
                const reVN = /^(?:\+84|84|0)(?:3|5|7|8|9|2)\d{8}$/;
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
                        error.innerText = msg;
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
                if (!validateField("name", "nameError"))
                    isValid = false;
                if (!validateField("phone", "phoneError", reVN, "Invalid Phone format! e.g. 09xxxx"))
                    isValid = false;
                if (!validateField("email", "emailError", reEmail, "Invalid Email format!"))
                    isValid = false;
                if (!validateField("address", "addressError"))
                    isValid = false;

                if (!isValid) {
                    e.preventDefault();
                    const firstError = document.querySelector(".is-invalid");
                    if (firstError) {
                        firstError.scrollIntoView({behavior: "smooth", block: "center"});
                        firstError.focus();
                    }
                }
            });

            // 3. Delete Confirmation
            const form = document.getElementById('supplierForm');
            const deleteBtn = form.querySelector('button[value="deleteSupplier"]');

            if (deleteBtn) {
                deleteBtn.addEventListener('click', function (event) {
                    event.preventDefault();
                    Swal.fire({
                        title: 'Are you sure?',
                        text: "You won't be able to revert this!",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#dc3545',
                        cancelButtonColor: '#6c757d',
                        confirmButtonText: 'Yes, delete it!',
                        background: '#fff',
                        customClass: {popup: 'rounded-4'}
                    }).then((result) => {
                        if (result.isConfirmed) {
                            // Create hidden input to submit delete action
                            const hiddenAction = document.createElement('input');
                            hiddenAction.type = 'hidden';
                            hiddenAction.name = 'action';
                            hiddenAction.value = 'deleteSupplier';
                            form.appendChild(hiddenAction);
                            form.submit();
                        }
                    });
                });
            }
        </script>
    </body>
</html>