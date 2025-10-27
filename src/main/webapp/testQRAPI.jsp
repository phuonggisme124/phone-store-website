<%-- 
    Document   : test
    Created on : Oct 23, 2025, 3:47:09 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kiểm tra API VietQR</title>
    <style>
        body {
            font-family: sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f2f5;
        }
        #qrContainer {
            border: 1px solid #ccc;
            padding: 20px;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
        }
        img {
            width: 250px;
            height: 250px;
            border: 1px solid #eee;
            margin-bottom: 15px;
        }
        button {
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border: none;
            background-color: #007bff;
            color: white;
            border-radius: 5px;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

    <div id="qrContainer">
        <h3>Test QR Code Generation</h3>
        <img id="qrImage" src="" alt="QR Code sẽ hiện ở đây">
        <button id="generateBtn">Tạo mã QR</button>
    </div>

    <script>
        // Lắng nghe sự kiện click vào nút
        document.getElementById('generateBtn').addEventListener('click', () => {
            console.log("Nút đã được nhấn!");

            // 1. Lấy thẻ <img>
            const qrImageElement = document.getElementById('qrImage');

            // 2. Định nghĩa các thông số (giống hệt code của bạn)
            const bankId = "970422"; // MB Bank
            const accountNumber = "343339799999";
            const accountName = "PHAM HOANG PHUONG";
            const amount = 50000; // Số tiền ví dụ
            const addInfo = encodeURIComponent("Test QR DH12345");
            const encodedAccountName = encodeURIComponent(accountName);

            // 3. Tạo URL đầy đủ (có cache buster để chống lỗi cache)
   
            const vietQrApiUrl = `https://img.vietqr.io/image/${bankId}-${accountNumber}-compact.png?amount=${amount}&addInfo=${addInfo}&accountName=${encodedAccountName}`;

            // In URL ra console để kiểm tra
            console.log("URL được tạo ra:", vietQrApiUrl);

            // 4. Gán URL vào thuộc tính src của thẻ <img>
            qrImageElement.src = vietQrApiUrl;
        });
    </script>

</body>
</html>