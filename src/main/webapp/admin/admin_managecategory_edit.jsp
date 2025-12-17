<%@page import="model.Staff"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.Staff"%> <%@page import="com.google.gson.Gson"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Update Category</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<<<<<<< HEAD

=======
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">

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
            .form-control {
                border-radius: 8px;
                border: 1px solid #d9dee3;
                padding: 0.7rem 1rem;
                color: #697a8d;
            }
            .form-control:focus {
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
            .btn-danger-soft {
                background-color: #ffe5e5; color: #ff3e1d; border: none; font-weight: 600;
            }
            .btn-danger-soft:hover {
                background-color: #ff3e1d; color: white; box-shadow: 0 4px 12px rgba(255, 62, 29, 0.4);
            }

            /* --- 6. ERROR MESSAGES --- */
            p.text-danger { 
                font-size: 0.85rem; 
                margin-top: 5px; 
                display: flex; 
                align-items: center; 
                gap: 5px; 
            }
            p.text-danger::before { content: "\F333"; font-family: "bootstrap-icons"; }

            /* Navbar Profile */
            .hover-danger:hover { background-color: #ffe5e5 !important; color: #dc3545 !important; transform: rotate(90deg); transition: 0.3s; }
        </style>
    </head>
    <body>
<<<<<<< HEAD
        <%
            // SỬA: Lấy Staff từ Session
            Staff currentUser = (Staff) session.getAttribute("user");
            
            if (currentUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            // Check Admin role
            if (currentUser.getRole() != 4) {
                response.sendRedirect("login"); 
                return;
            }

            Category catergory = (Category) request.getAttribute("catergory");
        %>

=======
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>
            <% Staff currentUser = (Staff) session.getAttribute("user"); %>

            <div class="page-content flex-grow-1">
<<<<<<< HEAD
                <nav class="navbar navbar-light bg-white shadow-sm">
=======
                
                <nav class="navbar navbar-light bg-white shadow-sm px-3 py-2 sticky-top">
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                    <div class="container-fluid">
                        <button class="btn btn-light text-primary border-0 shadow-sm rounded-circle" id="menu-toggle" style="width: 40px; height: 40px;">
                            <i class="bi bi-list fs-5"></i>
                        </button>
<<<<<<< HEAD
                        <div class="d-flex align-items-center ms-auto">
                            <a href="logout" class="btn btn-outline-danger btn-sm me-3">Logout</a>
                            <div class="d-flex align-items-center">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">
                                <span><%= currentUser.getFullName()%></span>
=======

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
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                            </div>
                        </div>
                    </div>
                </nav>

<<<<<<< HEAD
                <div class="card shadow-sm border-0 p-4 m-3">
                    <div class="card-body p-0">
                        <h4 class="fw-bold ps-3 mb-4">Edit Category</h4>
                        
                        <% if (catergory != null) {%>
                        <form action="category" method="post" class="w-50 mx-auto bg-light p-4 rounded shadow">

                            <div class="mb-3">
                                <input type="hidden" class="form-control" name="cateID" value="<%= catergory.getCategoryId()%>" readonly>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Category Name</label>
                                <input type="text" class="form-control" name="name" value="<%= catergory.getCategoryName()%>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <input type="text" class="form-control" name="description" value="<%= catergory.getDescription()%>" required>
                            </div>
                            <div class="d-flex gap-2">
                                <button type="submit" name="action" value="updateCategory" class="btn btn-primary flex-fill">Update</button>
                                <button type="submit" name="action" value="deleteCategory" class="btn btn-danger flex-fill" onclick="return confirm('Are you sure to delete this category?');">Delete</button>
                            </div>
                        </form>
                        <% } else { %>
                        <div class="alert alert-info m-4" role="alert">
                            <i class="bi bi-info-circle me-2"></i>Category not found.
=======
                <% 
                    Category category = (Category) request.getAttribute("catergory"); // Chú ý: biến trong Servlet đại ca đặt là 'catergory' (thừa chữ r)
                    
                    if (category == null) {
                %>
                    <div class="container p-5 text-center">
                        <div class="alert alert-danger shadow-sm">
                            <h4 class="alert-heading"><i class="bi bi-exclamation-triangle-fill"></i> Category Not Found</h4>
                            <p>The category you are trying to edit does not exist or has been deleted.</p>
                            <a href="category?action=manageCategory" class="btn btn-outline-danger">Back to List</a>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
                        </div>
                    </div>
                <% 
                        return; 
                    } 
                %>

                <div class="container-fluid p-4">
                    <form action="category" method="post" id="categoryForm" class="form-card p-5 mx-auto" style="max-width: 600px;">
                        
                        <div class="form-header text-center">
                            <h2 class="fw-bold text-primary mb-1">Update Category</h2>
                            <p class="text-muted">Modify category details</p>
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

                        <input type="hidden" name="cateID" value="<%= category.getCategoryId()%>">

                        <div class="mb-4">
                            <label class="form-label">Category Name</label>
                            <input type="text" class="form-control" name="name" id="name" value="<%= category.getCategoryName()%>" required>
                            <p id="nameError" class="text-danger mt-2" style="display:none;">Please enter category name!</p>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" rows="4"><%= category.getDescription()%></textarea>
                        </div>

                        <div class="mt-4 pt-3 border-top d-flex gap-3 justify-content-end">
                            <button type="submit" name="action" value="deleteCategory" class="btn btn-danger-soft px-4 rounded-pill">
                                <i class="bi bi-trash3 me-2"></i> Delete
                            </button>
                            <button type="submit" name="action" value="updateCategory" class="btn btn-gradient-primary px-5 rounded-pill">
                                <i class="bi bi-check-circle me-2"></i> Update Info
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<<<<<<< HEAD

=======
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
>>>>>>> 1b29b8814bac2c7c9547140c5454d64b3d75b806
        <script src="js/dashboard.js"></script>

        <script>
            // 1. Sidebar Toggle
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });

            // 2. Form Validation
            document.getElementById("categoryForm").addEventListener("submit", function (e) {
                const name = document.getElementById("name");
                const nameError = document.getElementById("nameError");
                let isValid = true;

                if (name.value.trim() === "") {
                    nameError.style.display = "block";
                    name.classList.add("is-invalid");
                    isValid = false;
                } else {
                    nameError.style.display = "none";
                    name.classList.remove("is-invalid");
                    name.classList.add("is-valid");
                }

                if (!isValid) {
                    e.preventDefault();
                    name.focus();
                }
            });

            // 3. Delete Confirmation
            const form = document.getElementById('categoryForm');
            const deleteBtn = form.querySelector('button[value="deleteCategory"]');

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
                            hiddenAction.value = 'deleteCategory';
                            form.appendChild(hiddenAction);
                            form.submit();
                        }
                    });
                });
            }
        </script>
    </body>
</html>