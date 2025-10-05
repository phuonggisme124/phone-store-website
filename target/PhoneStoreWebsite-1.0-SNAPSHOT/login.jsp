<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ministore - Login/Register</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">
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
    </style>
</head>

<body>
    <header>
        <h3>MINISTORE</h3>
    </header>

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
                    <input type="password" class="form-control" name="password" id="u_pwd" required placeholder="Enter Password">
                </div>

                <% String error = (String) request.getAttribute("error"); %>
                <% if (error != null) { %>
                    <p style="color:red; margin-top: 10px;"><%= error %></p>
                <% } %>

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
                    <label for="reg_pwd" class="form-label">Password</label>
                    <input type="password" class="form-control" name="password" id="reg_pwd" required placeholder="Enter Password">
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

            // Ẩn tất cả form
            loginForm.classList.remove('active');
            registerForm.classList.remove('active');

            // Reset nút về mặc định (outline-dark)
            btnLogin.classList.remove('btn-dark');
            btnLogin.classList.add('btn-outline-dark');
            btnRegister.classList.remove('btn-dark');
            btnRegister.classList.add('btn-outline-dark');

            // Hiển thị form + tô nút tương ứng (dark)
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
        // Gọi hàm showForm('login') khi trang được tải xong để thiết lập trạng thái ban đầu.
        document.addEventListener('DOMContentLoaded', (event) => {
            // Kiểm tra nếu có lỗi (chỉ có thể xảy ra khi Đăng nhập thất bại), 
            // thì giữ nguyên form Đăng nhập đang hiển thị.
            // Nếu không có lỗi, mặc định hiển thị form 'login'.
            
            // Do logic JSP kiểm tra lỗi chỉ nằm trong form login, nên ta mặc định 
            // hiển thị login form khi trang tải. Nếu có lỗi, nó sẽ tự hiển thị.
            // Ta chỉ cần đảm bảo hàm này chạy để thiết lập nút chính xác.
            showForm('login'); 
        });
        
    </script>
</body>
</html>