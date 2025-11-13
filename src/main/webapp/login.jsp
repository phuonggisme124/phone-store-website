<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Ministore - Login/Register</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <style>
            body {
                background: #f8f9fa;
            }

            /* Thanh trên */
            header {
                background: #ffffff;
                box-shadow: 0px 2px 6px rgba(0,0,0,0.1);
                padding: 15px 0;
                position: fixed;
                top: 0;
                width: 100%;
                z-index: 10;
                text-align: center;
            }

            header h3 {
                margin: 0;
                font-weight: bold;
                letter-spacing: 2px;
                pointer-events: none;
            }

            /* Container */
            .auth-wrapper {
                max-width: 450px;
                margin: 120px auto;
                padding: 20px;
            }

            /* Nút chọn */
            .auth-buttons {
                display: flex;
                justify-content: center;
                gap: 20px;
                margin-bottom: 30px;
            }

            .auth-buttons button {
                width: 45%;
            }

            /* Form */
            .auth-form {
                display: none;
                background: #fff;
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0px 3px 8px rgba(0,0,0,0.1);
            }

            .auth-form.active {
                display: block;
            }

            /* 2. CSS cho nút hiển thị mật khẩu */
            .password-wrapper {
                position: relative;
            }

            .password-icon {
                position: absolute;
                top: 50%;
                right: 12px;
                transform: translateY(-50%);
                cursor: pointer;
                color: #6c757d;
            }
        </style>
    </head>

    <body>
        <header>
            <a href="homepage" style="color: black"><h1>MINISTORE</h1></a>

            <div class="auth-wrapper">
                <div class="auth-buttons">
                    <button id="btn-login" class="btn btn-dark" onclick="showForm('login')">Login</button>
                    <button id="btn-register" class="btn btn-outline-dark" onclick="showForm('register')">Register</button>
                </div>

                <div id="login-form" class="auth-form"> 
                    <h2 class="text-center mb-4">Login</h2>
                    <form action="login" method="post">
                        <div class="mb-3">
                            <label for="u_email" class="form-label">Email</label>
                            <input type="email" class="form-control" name="username" id="u_email" required placeholder="Enter Email">
                        </div>
                        <div class="mb-3">
                            <label for="u_pwd" class="form-label">Password</label>
                            <div class="password-wrapper">
                                <input type="password" class="form-control" name="password" id="u_pwd" required placeholder="Enter Password">
                                <i class="bi bi-eye-slash password-icon" id="toggleLoginPassword"></i>
                            </div>
                        </div>

                        <% String error = (String) request.getAttribute("error"); %>
                        <% if (error != null) {%>
                        <p style="color:red; margin-top: 10px;"><%= error%></p>
                        <% }%>

                        <div class="text-end mt-1">
                            <a href="forgotPassword" style="font-size: 0.9rem; text-decoration: none;">Forgot Password?</a>
                        </div>


                        <div class="text-center mt-4">
                            <button type="submit" class="btn btn-dark w-100">Login</button>
                        </div>
                    </form>
                </div>

                <div id="register-form" class="auth-form">
                    <h2 class="text-center mb-4">Register</h2>
                    <form action="register" method="post"> 
                        <div class="mb-3">
                            <label for="reg_fullname" class="form-label">Full Name</label>
                            <input type="text" class="form-control" name="fullname" id="reg_fullname" required placeholder="Enter Full Name">
                        </div>
                        <div class="mb-3">
                            <label for="reg_email" class="form-label">Email</label>
                            <input type="email" class="form-control" name="email" id="reg_email" required placeholder="Enter Email">
                        </div>
                        <div class="mb-3">
                            <label for="reg_num" class="form-label">Number Phone</label>
                            <input type="tel" class="form-control" name="numberphone" id="reg_num" required placeholder="Enter Number Phone">
                        </div>
                        <div class="mb-3">
                            <label for="reg_address" class="form-label">Address</label>
                            <input type="text" class="form-control" name="address" id="reg_address" required placeholder="Enter Address">
                        </div>
                        <div class="mb-3">
                            <label for="reg_pwd" class="form-label">Password</label>
                            <div class="password-wrapper">
                                <input type="password" class="form-control" name="password" id="reg_pwd" required placeholder="Enter Password">
                                <i class="bi bi-eye-slash password-icon" id="toggleRegisterPassword"></i>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="reg_repwd" class="form-label">Repeat Password</label>
                            <div class="password-wrapper">
                                <input type="password" class="form-control" name="rePassword" id="reg_repwd" required placeholder="Enter Repeat Password">
                                <i class="bi bi-eye-slash password-icon" id="toggleRegisterRePassword"></i>
                            </div>
                        </div>
                        <div class="text-center mt-4">
                            <button type="submit" class="btn btn-dark w-100">Register</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                // Hàm chuyển đổi form
                function showForm(formType) {
                    const loginForm = document.getElementById('login-form');
                    const registerForm = document.getElementById('register-form');
                    const btnLogin = document.getElementById('btn-login');
                    const btnRegister = document.getElementById('btn-register');

                    loginForm.classList.remove('active');
                    registerForm.classList.remove('active');

                    btnLogin.classList.remove('btn-dark');
                    btnLogin.classList.add('btn-outline-dark');
                    btnRegister.classList.remove('btn-dark');
                    btnRegister.classList.add('btn-outline-dark');

                    if (formType === 'login') {
                        loginForm.classList.add('active');
                        btnLogin.classList.remove('btn-outline-dark');
                        btnLogin.classList.add('btn-dark');
                    } else {
                        registerForm.classList.add('active');
                        btnRegister.classList.remove('btn-outline-dark');
                        btnRegister.classList.add('btn-dark');
                    }
                }

                // --- Cập nhật logic để đảm bảo form login luôn hiển thị đầu tiên ---
                document.addEventListener('DOMContentLoaded', (event) => {
                    showForm('login');

                    // 4. Thêm JavaScript để xử lý nút hiển thị mật khẩu
                    const setupPasswordToggle = (inputId, toggleId) => {
                        const passwordInput = document.getElementById(inputId);
                        const toggleIcon = document.getElementById(toggleId);

                        toggleIcon.addEventListener('click', function () {
                            // Lấy trạng thái hiện tại của ô input
                            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                            passwordInput.setAttribute('type', type);

                            // Đổi biểu tượng con mắt
                            this.classList.toggle('bi-eye');
                            this.classList.toggle('bi-eye-slash');
                        });
                    };

                    // Gọi hàm cho tất cả các trường mật khẩu
                    setupPasswordToggle('u_pwd', 'toggleLoginPassword');
                    setupPasswordToggle('reg_pwd', 'toggleRegisterPassword');
                    setupPasswordToggle('reg_repwd', 'toggleRegisterRePassword');
                });
            </script>
    </body>
</html>