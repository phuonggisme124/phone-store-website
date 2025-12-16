<%@page import="model.Staff"%>
<%@page import="java.util.List"%>
<<<<<<< HEAD
=======

>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Create User</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_createuser.css">

        <style>
            /* --- 1. GENERAL TONE --- */
            body { background-color: #f5f5f9; font-family: 'Segoe UI', sans-serif; }
            .text-primary { color: #696cff !important; }
            
            /* --- 2. NAVBAR --- */
            .border-light-purple { border-color: rgba(102, 126, 234, 0.3) !important; }
            
            /* --- 3. FORM CARD STYLING --- */
            .form-card {
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 8px 24px rgba(105, 108, 255, 0.1);
                border: none;
                transition: transform 0.3s ease;
            }
            .form-header {
                border-bottom: 1px solid #eceef1;
                padding-bottom: 1.5rem;
                margin-bottom: 2rem;
            }

            /* --- 4. INPUTS --- */
            .form-label {
                font-weight: 600;
                color: #566a7f;
                font-size: 0.85rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            .form-control, .form-select {
                border-radius: 8px;
                border: 1px solid #d9dee3;
                padding: 0.7rem 1rem;
                color: #697a8d;
            }
            .form-control:focus, .form-select:focus {
                border-color: #696cff;
                box-shadow: 0 0 0 0.25rem rgba(105, 108, 255, 0.25);
            }

            /* --- 5. BUTTONS --- */
            .btn-gradient-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none; color: white; transition: all 0.3s ease;
                font-weight: 600; letter-spacing: 1px;
                box-shadow: 0 4px 12px rgba(105, 108, 255, 0.4);
            }
            .btn-gradient-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 15px rgba(105, 108, 255, 0.6);
                color: white;
            }

            /* --- 6. ERROR MESSAGES --- */
            p.text-danger { 
                font-size: 0.85rem; margin-top: 5px; display: flex; align-items: center; gap: 5px; 
            }
            p.text-danger::before { content: "\F333"; font-family: "bootstrap-icons"; }

            /* Navbar Profile */
            .hover-danger:hover { background-color: #ffe5e5 !important; color: #dc3545 !important; transform: rotate(90deg); transition: 0.3s; }
        </style>
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
                    <form action="user?action=createAccountAdmin" id="userForm" method="post" class="form-card p-5 mx-auto" style="max-width: 800px;">
                        
                        <div class="form-header text-center">
                            <h2 class="fw-bold text-primary mb-1">Create New Account</h2>
                            <p class="text-muted">Register new user for the system</p>
                        </div>

                        <div class="mb-4 text-center">
                            <%
                                if (session.getAttribute("exist") != null) {
                                    String exist = (String) session.getAttribute("exist");
                                    out.println("<div class='alert alert-danger shadow-sm border-0 rounded-3'><i class='bi bi-exclamation-circle-fill me-2'></i>" + exist + "</div>");
                                }
                                session.removeAttribute("exist");
                            %>
                        </div>

                        <div class="row g-4">
                            
                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-shield-lock me-2"></i>Account Details</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">Email Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-envelope"></i></span>
                                        <input type="text" class="form-control" name="email" id="email" placeholder="example@email.com">
                                    </div>
                                    <p id="emailError" class="text-danger mt-2" style="display:none;">Enter email!</p>
                                    <p id="emailFormat" class="text-danger mt-2" style="display:none;">Invalid email format!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-key"></i></span>
                                        <input type="password" class="form-control" name="password" id="password" placeholder="Min 8 characters">
                                    </div>
                                    <p id="passwordError" class="text-danger mt-2" style="display:none;">Enter password!</p>
                                    <p id="passwordFormat" class="text-danger mt-2" style="display:none;">Must be at least 8 chars!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Role</label>
                                    <select class="form-select" name="role" id="role">
                                        <option value="" selected>Select Role</option>
                                       
                                        <option value="2">Staff</option>
                                        <option value="3">Shipper</option>
                                    </select>
                                    <p id="roleError" class="text-danger mt-2" style="display:none;">Select a role!</p>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-person-vcard me-2"></i>Personal Info</h5>

                                <div class="mb-3">
                                    <label class="form-label">Full Name</label>
                                    <input type="text" class="form-control" name="name" id="name" placeholder="John Doe">
                                    <p id="nameError" class="text-danger mt-2" style="display:none;">Enter full name!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Phone Number</label>
                                    <input type="text" class="form-control" name="phone" id="phone" placeholder="e.g. 0912345678">
                                    <p id="phoneError" class="text-danger mt-2" style="display:none;">Enter phone number!</p>
                                    <p id="phoneFormat" class="text-danger mt-2" style="display:none;">Invalid phone format!</p>
                                </div>

                                
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top text-center">
                            <button type="submit" class="btn btn-gradient-primary rounded-pill w-50">
                                <i class="bi bi-person-plus-fill me-2"></i> Create Account
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
            document.getElementById("userForm").addEventListener("submit", function (e) {
                const name = document.getElementById("name");
                const phone = document.getElementById("phone");
                const email = document.getElementById("email");
                const address = document.getElementById("address");
                const password = document.getElementById("password");
                const role = document.getElementById("role");

                // Errors
                const nameError = document.getElementById("nameError");
                const phoneError = document.getElementById("phoneError");
                const phoneFormat = document.getElementById("phoneFormat");
                const emailError = document.getElementById("emailError");
                const emailFormat = document.getElementById("emailFormat");
                const addressError = document.getElementById("addressError");
                const passwordError = document.getElementById("passwordError");
                const passwordFormat = document.getElementById("passwordFormat");
                const roleError = document.getElementById("roleError");

                let isValid = true;
                const reVN = /^(?:\+84|84|0)(?:3|5|7|8|9)\d{8}$/;
                const reEmail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                const rePass = /^.{8,}$/; // Ít nhất 8 ký tự

                // Helper Reset
                function resetError(field, ...errors) {
                    errors.forEach(err => err.style.display = "none");
                    field.classList.remove("is-invalid");
                    field.classList.add("is-valid");
                }
                function showError(field, errorElem) {
                    errorElem.style.display = "block";
                    field.classList.add("is-invalid");
                    field.classList.remove("is-valid");
                    isValid = false;
                }

                // Check Name
                if (name.value.trim() === "") showError(name, nameError);
                else resetError(name, nameError);

                // Check Role
                if (role.value === "") showError(role, roleError);
                else resetError(role, roleError);

                // Check Address
                if (address.value.trim() === "") showError(address, addressError);
                else resetError(address, addressError);

                // Check Email
                if (email.value.trim() === "") {
                    showError(email, emailError);
                    emailFormat.style.display = "none";
                } else if (!reEmail.test(email.value)) {
                    showError(email, emailFormat);
                    emailError.style.display = "none";
                } else {
                    resetError(email, emailError, emailFormat);
                }

                // Check Phone
                if (phone.value.trim() === "") {
                    showError(phone, phoneError);
                    phoneFormat.style.display = "none";
                } else if (!reVN.test(phone.value)) {
                    showError(phone, phoneFormat);
                    phoneError.style.display = "none";
                } else {
                    resetError(phone, phoneError, phoneFormat);
                }

                // Check Password
                if (password.value === "") {
                    showError(password, passwordError);
                    passwordFormat.style.display = "none";
                } else if (!rePass.test(password.value)) {
                    showError(password, passwordFormat);
                    passwordError.style.display = "none";
                } else {
                    resetError(password, passwordError, passwordFormat);
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