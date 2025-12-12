<%@page import="model.Customer"%> <%@page import="model.Staff"%>    <%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Edit User</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link href="css/dashboard_table.css" rel="stylesheet">
    </head>
    <body>
        <%
            // 1. Lấy thông tin Admin đăng nhập (Staff)
            Staff currentUser = (Staff) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            if (currentUser.getRole() != 4) {
                response.sendRedirect("login");
                return;
            }

            // 2. Lấy thông tin Customer cần sửa (từ Servlet gửi sang)
            // Lưu ý: Attribute key phải khớp với Servlet. 
            // Trong CustomerServlet bạn setAttribute("user", targetUser); => nên dùng "user"
            // Nếu Servlet bạn gửi là "currentUser" thì giữ nguyên.
            // Ở đây tôi dùng "user" theo code servlet bạn gửi trước đó.
            Customer targetUser = (Customer) request.getAttribute("user");

            // Fallback nếu attribute tên là currentUser
            if (targetUser == null) {
                targetUser = (Customer) request.getAttribute("currentUser");
            }

            // Nếu vẫn null thì báo lỗi hoặc redirect
            if (targetUser == null) {
        %>
        <script>alert("User not found!"); window.location.href = "customer?action=manageUser";</script>
        <%
                return;
            }
        %>

        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>

            <div class="page-content flex-grow-1">
                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle"><i class="bi bi-list"></i></button>
                        <div class="d-flex align-items-center ms-auto">
                            <a href="logout" class="btn btn-outline-danger btn-sm me-3">Logout</a>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= currentUser.getFullName()%></span>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid p-4">
                    <h2 class="text-center mb-4 text-primary fw-bold">Edit Customer Information</h2>

                    <form action="user" method="post" class="w-50 mx-auto bg-light p-4 rounded shadow">

                        <%
                            String error = (String) request.getAttribute("error");
                            String message = (String) request.getAttribute("message");
                            if (error != null) {
                        %>
                        <div class="alert alert-danger"><%= error%></div>
                        <% } else if (message != null) {%>
                        <div class="alert alert-success"><%= message%></div>
                        <% }%>

                        <div class="mb-3" >
                            <label class="form-label fw-bold">User ID</label>
                            <input type="text" class="form-control" name="userId" value="<%= targetUser.getCustomerID()%>" readonly>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Full Name</label>
                            <input type="text" class="form-control" name="name" value="<%= targetUser.getFullName()%>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Email</label>
                            <input type="email" class="form-control" name="email" value="<%= targetUser.getEmail()%>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Phone</label>
                            <input type="text" class="form-control" name="phone" value="<%= targetUser.getPhone()%>">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Address</label>
                            <input type="text" class="form-control" name="address" value="<%= targetUser.getAddress()%>">
                        </div>

<!--                        <div class="mb-3">
                            <label class="form-label fw-bold">Status</label>
                            <select class="form-select" name="status" id="status">
                                <%
                                    String currentStatus = targetUser.getStatus();
                                %>
                                <option value="Active" <%= "Active".equalsIgnoreCase(currentStatus) ? "selected" : ""%>>Active</option>

                                <option value="Block" <%= !"Active".equalsIgnoreCase(currentStatus) ? "selected" : ""%>>Locked/Block</option>
                            </select>
                        </div>-->

                        <div class="mb-3">
                            <label class="form-label fw-bold">Role</label>
                            <select class="form-select" name="role" disabled>
                                <option value="1" selected>Customer</option>
                            </select>
                            <input type="hidden" name="role" value="1">
                        </div>

                        <div class="d-flex gap-2 mt-4">
                            <button type="submit" name="action" value="updateUserAdmin" class="btn btn-primary flex-fill">Update</button>
                            <button type="button" class="btn btn-danger flex-fill" id="btnDelete">Delete</button>
                            <input type="hidden" name="action" id="actionInput" value="updateUserAdmin">
                        </div>

                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
                // Toggle Sidebar
                document.getElementById("menu-toggle").addEventListener("click", function () {
                    document.getElementById("wrapper").classList.toggle("toggled");
                });

                // SweetAlert cho nút Delete
                document.getElementById('btnDelete').addEventListener('click', function () {
                    Swal.fire({
                        title: 'Are you sure?',
                        text: "You won't be able to revert this!",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#dc3545',
                        cancelButtonColor: '#6c757d',
                        confirmButtonText: 'Yes, delete it!'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            // Đổi value của action thành deleteUserAdmin và submit form
                            const form = document.querySelector('form');
                            // Tạo input hidden cho action delete (vì button type=button không submit value)
                            const input = document.createElement('input');
                            input.type = 'hidden';
                            input.name = 'action';
                            input.value = 'deleteUserAdmin';
                            form.appendChild(input);

                            // Xóa input action cũ nếu có để tránh conflict
                            const oldInput = document.getElementById('actionInput');
                            if (oldInput)
                                oldInput.remove();

                            form.submit();
                        }
                    })
                });
        </script>
    </body>
</html>