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


                <%                    
                    Users user = (Users) request.getAttribute("currentUser");
                %>
                <!-- Table -->
                <form action="user" method="post" class="w-50 mx-auto bg-light p-4 rounded shadow">
                    <div class="mb-3" >
                        <%
                            if (session.getAttribute("exist") != null) {
                                String exist = (String) session.getAttribute("exist");
                                out.println("<p class='error-message'>" + exist + "</p>");
                            }
                            session.removeAttribute("exist");
                        %>
                    </div>
                    <div class="mb-3">
                        <input type="hidden" class="form-control" name="userId" value="<%= user.getUserId()%>" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="name" value="<%= user.getFullName()%>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" value="<%= user.getEmail()%>" required>

                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone</label>
                        <input type="text" class="form-control" name="phone" value="<%= user.getPhone()%>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Address</label>
                        <input type="text" class="form-control" name="address" value="<%= user.getAddress()%>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">CreateAt</label>
                        <input type="text" class="form-control" name="createAt" value="<%= user.getCreatedAt()%>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <input type="hidden" name="oldRole" value="<%= user.getRole() %>">
                        <select class="form-select" name="role" id="role">
                            <option value="1" <%= (user.getRole().equals(1) ? "selected" : "")%>>Customer</option>
                            <option value="2" <%= (user.getRole().equals(2) ? "selected" : "")%>>Staff</option>
                            <option value="3" <%= (user.getRole().equals(3) ? "selected" : "")%>>Shipper</option>               
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <select class="form-select" name="status" id="status">
                            <option value="active" <%= (user.getStatus().equalsIgnoreCase("active") ? "selected" : "")%>>Active</option>
                            <option value="locked" <%= (user.getStatus().equalsIgnoreCase("locked") ? "selected" : "")%>>Locked</option>

                        </select>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" name="action" value="updateUserAdmin" class="btn btn-primary flex-fill">Update</button>
                        <button type="submit" name="action" value="deleteUserAdmin" class="btn btn-danger flex-fill">Delete</button>
                    </div>

                </form>
            </div>


            <!-- JS Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

            <!-- Custom JS -->
            <script src="js/dashboard.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const form = document.querySelector('form[action="user"]');
                    const deleteBtn = form?.querySelector('button[name="action"][value="deleteUserAdmin"]');

                    if (!deleteBtn) {
                        console.error("Delete button not found!");
                        return;
                    }

                    deleteBtn.addEventListener('click', function (event) {
                        event.preventDefault(); // Prevent default submit

                        Swal.fire({
                            title: 'Are you sure you want to delete this user?',
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
                                actionInput.value = 'deleteUserAdmin';
                                form.submit();
                            }
                        });
                    });
                });
            </script>

    </body>
</html>
