<%@page import="model.Staff"%>
<%@page import="java.util.List"%>

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
            /* --- GIỮ NGUYÊN CSS CỦA ĐẠI CA --- */
            body { background-color: #f5f5f9; font-family: 'Segoe UI', sans-serif; }
            .text-primary { color: #696cff !important; }
            .form-card { background: #fff; border-radius: 16px; box-shadow: 0 8px 24px rgba(105, 108, 255, 0.1); border: none; }
            .form-header { border-bottom: 1px solid #eceef1; padding-bottom: 1.5rem; margin-bottom: 2rem; }
            .form-label { font-weight: 600; color: #566a7f; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; }
            .form-control, .form-select { border-radius: 8px; border: 1px solid #d9dee3; padding: 0.7rem 1rem; color: #697a8d; }
            .form-control:focus, .form-select:focus { border-color: #696cff; box-shadow: 0 0 0 0.25rem rgba(105, 108, 255, 0.25); }
            .btn-gradient-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; color: white; font-weight: 600; letter-spacing: 1px; box-shadow: 0 4px 12px rgba(105, 108, 255, 0.4); }
            .btn-gradient-primary:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(105, 108, 255, 0.6); color: white; }
            p.text-danger { font-size: 0.85rem; margin-top: 5px; display: flex; align-items: center; gap: 5px; }
            p.text-danger::before { content: "\F333"; font-family: "bootstrap-icons"; }
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
                            <span class="fw-bold text-dark"><%= (currentUser != null) ? currentUser.getFullName() : "Admin" %></span>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid p-4">
                    <form action="account?action=createAccountAdmin" id="userForm" method="post" class="form-card p-5 mx-auto" style="max-width: 800px;">
                        
                        <div class="form-header text-center">
                            <h2 class="fw-bold text-primary mb-1">Create New Account</h2>
                            <p class="text-muted">Register new user for the system</p>
                        </div>

                        <div class="mb-4 text-center">
                            <%
                                if (session.getAttribute("exist") != null) {
                                    String exist = (String) session.getAttribute("exist");
                                    out.println("<div class='alert alert-danger shadow-sm border-0 rounded-3'><i class='bi bi-exclamation-circle-fill me-2'></i>" + exist + "</div>");
                                    session.removeAttribute("exist");
                                }
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
                                
                                <div class="mb-3">
                                    <label class="form-label">Address</label>
                                    <input type="text" class="form-control" name="address" id="address" placeholder="123 Street, City">
                                    <p id="addressError" class="text-danger mt-2" style="display:none;">Enter address!</p>
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
        
        <script>
            // 1. Sidebar Toggle
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });

            // 2. Form Validation
            document.getElementById("userForm").addEventListener("submit", function (e) {
                // Lấy các element input
                const name = document.getElementById("name");
                const phone = document.getElementById("phone");
                const email = document.getElementById("email");
                const address = document.getElementById("address"); // Đã có trong HTML, không bị lỗi nữa
                const password = document.getElementById("password");
                const role = document.getElementById("role");

                // Lấy các element hiển thị lỗi
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
                // Regex
                const reVN = /^(?:\+84|84|0)(?:3|5|7|8|9)\d{8}$/;
                const reEmail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                const rePass = /^.{8,}$/; // Ít nhất 8 ký tự

                // Helper Reset Style
                function resetError(field, ...errors) {
                    errors.forEach(err => err.style.display = "none");
                    field.classList.remove("is-invalid");
                    field.classList.add("is-valid");
                }
                
                // Helper Show Error
                function showError(field, errorElem) {
                    errorElem.style.display = "block";
                    field.classList.add("is-invalid");
                    field.classList.remove("is-valid");
                    isValid = false;
                }

                // --- LOGIC CHECK TRỐNG ---

                // 1. Check Name
                if (name.value.trim() === "") showError(name, nameError);
                else resetError(name, nameError);

                // 2. Check Role
                if (role.value === "") showError(role, roleError);
                else resetError(role, roleError);

                // 3. Check Address (Giờ đã hoạt động vì HTML đã có ID="address")
                if (address.value.trim() === "") showError(address, addressError);
                else resetError(address, addressError);

                // 4. Check Email
                if (email.value.trim() === "") {
                    showError(email, emailError);
                    emailFormat.style.display = "none";
                } else if (!reEmail.test(email.value)) {
                    showError(email, emailFormat);
                    emailError.style.display = "none";
                } else {
                    resetError(email, emailError, emailFormat);
                }

                // 5. Check Phone
                if (phone.value.trim() === "") {
                    showError(phone, phoneError);
                    phoneFormat.style.display = "none";
                } else if (!reVN.test(phone.value)) {
                    showError(phone, phoneFormat);
                    phoneError.style.display = "none";
                } else {
                    resetError(phone, phoneError, phoneFormat);
                }

                // 6. Check Password
                if (password.value === "") {
                    showError(password, passwordError);
                    passwordFormat.style.display = "none";
                } else if (!rePass.test(password.value)) {
                    showError(password, passwordFormat);
                    passwordError.style.display = "none";
                } else {
                    resetError(password, passwordError, passwordFormat);
                }

                // CHẶN SUBMIT NẾU CÓ LỖI
                if (!isValid) {
                    e.preventDefault(); // Dòng này chặn không cho qua Servlet
                    // Scroll tới lỗi đầu tiên
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