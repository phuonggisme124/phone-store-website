<%@page import="java.util.List"%>
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



                <!-- Table -->
                <form action="user?action=createAccountAdmin" id="userForm" method="post" class="w-50 mx-auto bg-light p-4 rounded shadow">
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
                        <label class="form-label">Name</label>
                        <input type="text" class="form-control" name="name" id="name" value="" >
                        <p id="nameError" class="text-danger mt-2" style="display:none;">Please enter name!</p>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="text" class="form-control" name="email" id="email" value="" >
                        <p id="emailError" class="text-danger mt-2" style="display:none;">Please enter Email!</p>
                        <p id="emailFormat" class="text-danger mt-2" style="display:none;">Email is not in correct format!</p>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="text" class="form-control" name="password" id="password" value="" >
                        <p id="passwordError" class="text-danger mt-2" style="display:none;">Please enter password!</p>
                        <p id="passwordFormat" class="text-danger mt-2" style="display:none;">Password is not in correct format!</p>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone</label>
                        <input type="text" class="form-control" name="phone" id="phone" value="" >
                        <p id="phoneError" class="text-danger mt-2" style="display:none;">Please enter phone number!</p>
                        <p id="phoneFormat" class="text-danger mt-2" style="display:none;">Phone number is not in correct format!</p>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Address</label>
                        <input type="text"   class="form-control" name="address" id="address" value="" >
                        <p id="addressError" class="text-danger mt-2" style="display:none;">Please enter address!</p>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <select class="form-select" name="role" id="role">
                            <option value="" selected="">Select Role</option>
                            <option value="1" >Customer</option>
                            <option value="2" >Staff</option>
                            <option value="3" >Shipper</option>               
                        </select>
                        <p id="roleError" class="text-danger mt-2" style="display:none;">Please select role!</p>
                    </div>

                    <button type="submit" class="btn btn-primary w-100">Create</button>
                </form>
            </div>


            <!-- JS Libraries -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

            <!-- Custom JS -->
            <script src="js/dashboard.js"></script>
            <script>
                document.getElementById("userForm").addEventListener("submit", function (e) {
                    const name = document.getElementById("name");
                    const phone = document.getElementById("phone");
                    const email = document.getElementById("email");
                    const address = document.getElementById("address");
                    const password = document.getElementById("password");
                    const role = document.getElementById("role");


                    const nameError = document.getElementById("nameError");
                    const phoneError = document.getElementById("phoneError");
                    const phoneFormat = document.getElementById("phoneFormat");
                    const emailFormat = document.getElementById("emailFormat");
                    const emailError = document.getElementById("emailError");
                    const addressError = document.getElementById("addressError");
                    const passwordError = document.getElementById("passwordError");
                    const passwordFormat = document.getElementById("passwordFormat");
                    const roleError = document.getElementById("roleError");

                    let isValid = true;
                    const reVN = /^(?:\+84|84|0)(?:3|5|7|8|9)\d{8}$/;
                    const reEmail = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
                    const reExact8 = /^\S{8}$/;
                    // Check Name
                    if (name.value === "") {
                        nameError.style.display = "block";
                        name.classList.add("is-invalid");
                        isValid = false;
                    } else {
                        nameError.style.display = "none";
                        name.classList.remove("is-invalid");
                    }
                    // Check role
                    if (role.value === "") {
                        roleError.style.display = "block";
                        role.classList.add("is-invalid");
                        isValid = false;
                    } else {
                        roleError.style.display = "none";
                        role.classList.remove("is-invalid");
                    }
                    // Check address
                    if (address.value === "") {
                        addressError.style.display = "block";
                        address.classList.add("is-invalid");
                        isValid = false;
                    } else {
                        addressError.style.display = "none";
                        address.classList.remove("is-invalid");
                    }
                    // Check Email
                    if (email.value === "") {
                        emailError.style.display = "block";
                        email.classList.add("is-invalid");
                        isValid = false;

                    } else {
                        emailError.style.display = "none";

                        if (!reEmail.test(email.value)) {  
                            emailFormat.style.display = "block";
                            email.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            emailError.style.display = "none";
                            emailFormat.style.display = "none";
                            email.classList.remove("is-invalid");
                        }
                    }

                    // Check Phone
                    if (phone.value === "") {
                        phoneError.style.display = "block";

                        phone.classList.add("is-invalid");
                        isValid = false;
                    } else {
                        phoneError.style.display = "none";
                        if (!reVN.test(phone.value)) {

                            phoneFormat.style.display = "block";
                            phone.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            phoneError.style.display = "none";
                            phoneFormat.style.display = "none";
                            phone.classList.remove("is-invalid");
                        }
                    }
                    // Check password
                    if (password.value === "") {
                        passwordError.style.display = "block";

                        password.classList.add("is-invalid");
                        isValid = false;
                    } else {
                        passwordError.style.display = "none";
                        if (!reExact8.test(password.value)) {

                            passwordFormat.style.display = "block";
                            password.classList.add("is-invalid");
                            isValid = false;
                        } else {
                            passwordError.style.display = "none";
                            passwordFormat.style.display = "none";
                            password.classList.remove("is-invalid");
                        }
                    }
                    
                    

                    // Nếu có lỗi thì chặn submit & cuộn tới ô lỗi đầu tiên
                    if (!isValid) {
                        e.preventDefault();
                        document.querySelector(".is-invalid").scrollIntoView({
                            behavior: "smooth",
                            block: "center"
                        });
                    }
                });
            </script>
    </body>
</html>
