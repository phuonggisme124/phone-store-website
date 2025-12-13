<%@page import="model.Customer"%>
<%@page import="model.Staff"%>
<%@page import="java.util.List"%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Update User</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_createuser.css">

        
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

                <% Customer user = (Customer) request.getAttribute("currentUser"); %>

                <div class="container-fluid p-4">
                    <form action="user" id="userForm" method="post" class="form-card p-5 mx-auto" style="max-width: 800px;">
                        
                        <div class="form-header text-center">
                            <h2 class="fw-bold text-primary mb-1">Update User Profile</h2>
                            <p class="text-muted">Modify account information and permissions</p>
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

                        <input type="hidden" name="userId" value="<%= user.getCustomerID()%>">
                        <input type="hidden" name="oldRole" value="<%= user.getRole() %>">

                        <div class="row g-4">
                            
                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-shield-lock me-2"></i>Account Info</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">Email Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-envelope"></i></span>
                                        <input type="email" class="form-control" name="email" id="email" value="<%= user.getEmail()%>" readonly>
                                    </div>
                                    <small class="text-muted fst-italic">*Email cannot be changed</small>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Role</label>
                                    <select class="form-select" name="role" id="role">
                                        <option value="2" <%= (user.getRole()== 2 ? "selected" : "")%>>Staff</option>
                                        <option value="3" <%= (user.getRole()== 3 ? "selected" : "")%>>Shipper</option>
                                    </select>
                                    <p id="roleError" class="text-danger mt-2" style="display:none;">Select role!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Status</label>
                                    <select class="form-select" name="status" id="status">
                                        <option value="active" <%= (user.getStatus().equalsIgnoreCase("active") ? "selected" : "")%>>Active</option>
                                        <option value="locked" <%= (user.getStatus().equalsIgnoreCase("locked") ? "selected" : "")%>>Locked</option>
                                        <option value="block" <%= (user.getStatus().equalsIgnoreCase("block") ? "selected" : "")%>>Block</option>
                                    </select>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <h5 class="text-secondary border-bottom pb-2 mb-3"><i class="bi bi-person-vcard me-2"></i>Personal Info</h5>

                                <div class="mb-3">
                                    <label class="form-label">Full Name</label>
                                    <input type="text" class="form-control" name="name" id="name" value="<%= user.getFullName()%>" required>
                                    <p id="nameError" class="text-danger mt-2" style="display:none;">Enter name!</p>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Phone Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-telephone"></i></span>
                                        <input type="text" class="form-control" name="phone" id="phone" value="<%= user.getPhone()%>">
                                    </div>
                                    <p id="phoneError" class="text-danger mt-2" style="display:none;">Enter phone!</p>
                                    <p id="phoneFormat" class="text-danger mt-2" style="display:none;">Invalid format!</p>
                                </div>

                                
                                
                                <div class="mb-3">
                                    <label class="form-label">Created At</label>
                                    <input type="text" class="form-control" value="<%= user.getCreatedAt()%>" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 pt-3 border-top d-flex gap-3 justify-content-end">
                            <button type="submit" name="action" value="deleteUserAdmin" class="btn btn-danger-soft px-4 rounded-pill">
                                <i class="bi bi-trash3 me-2"></i> Delete
                            </button>
                            <button type="submit" name="action" value="updateUserAdmin" class="btn btn-gradient-primary px-5 rounded-pill">
                                <i class="bi bi-check-circle me-2"></i> Update Info
                            </button>
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
            document.getElementById("userForm").addEventListener("submit", function (e) {
                let isValid = true;
                const reVN = /^(?:\+84|84|0)(?:3|5|7|8|9)\d{8}$/;
                
                // Helper Validate
                function validateField(id, errorId, regex = null, errorMsgRegex = "") {
                    const field = document.getElementById(id);
                    const error = document.getElementById(errorId);
                    if (!field) return true; // Bỏ qua nếu field không tồn tại (ví dụ address optional)

                    const val = field.value.trim();
                    let isError = false;
                    let msg = "This field is required!";

                    // Một số trường có thể optional (như Address), tùy logic đại ca
                    if (id === "name" && val === "") isError = true;
                    if (id === "phone" && val !== "" && !reVN.test(val)) {
                        isError = true; msg = errorMsgRegex;
                    }

                    if (isError) {
                        if(error) {
                            error.innerText = msg;
                            error.style.display = "block";
                        }
                        field.classList.add("is-invalid");
                        return false;
                    } else {
                        if(error) error.style.display = "none";
                        field.classList.remove("is-invalid");
                        field.classList.add("is-valid");
                        return true;
                    }
                }

                // Check Fields
                if (!validateField("name", "nameError")) isValid = false;
                
                // Check Phone (Nếu nhập thì phải đúng format)
                const phoneField = document.getElementById("phone");
                const phoneError = document.getElementById("phoneError");
                const phoneFormat = document.getElementById("phoneFormat");
                if(phoneField.value.trim() !== "") {
                     if(!reVN.test(phoneField.value.trim())) {
                         phoneFormat.style.display = "block";
                         phoneField.classList.add("is-invalid");
                         isValid = false;
                     } else {
                         phoneFormat.style.display = "none";
                         phoneField.classList.remove("is-invalid");
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

            // 3. Delete Confirmation
            const form = document.getElementById('userForm');
            const deleteBtn = form.querySelector('button[value="deleteUserAdmin"]');

            if (deleteBtn) {
                deleteBtn.addEventListener('click', function (event) {
                    event.preventDefault();
                    Swal.fire({
                        title: 'Are you sure?',
                        text: "This action cannot be undone!",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#dc3545',
                        cancelButtonColor: '#6c757d',
                        confirmButtonText: 'Yes, delete it!',
                        background: '#fff',
                        customClass: { popup: 'rounded-4' }
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const hiddenAction = document.createElement('input');
                            hiddenAction.type = 'hidden';
                            hiddenAction.name = 'action';
                            hiddenAction.value = 'deleteUserAdmin';
                            form.appendChild(hiddenAction);
                            form.submit();
                        }
                    });
                });
            }
        </script>
    </body>
</html>