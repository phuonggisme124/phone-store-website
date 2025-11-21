<%@page import="dao.SupplierDAO"%>
<%@page import="dao.CategoryDAO"%>
<%@page import="model.Category"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="dao.ProductDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin - Import</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/dashboard_table.css">
  

        <style>
            .content-area {
                flex: 1;
                padding: 30px;
                background-color: #f8f9fa;
                min-height: 100vh;
            }
            .back-link {
                text-decoration: none;
                color: #6c757d;
                display: inline-block;
                margin-bottom: 20px;
                font-weight: 600;
            }
            .back-link:hover {
                color: #0d6efd;
            }
            form {
                max-width: 700px;
                margin: auto;
                background: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
            }
        </style>


    </head>

    <body>
        <div class="d-flex">
            <%@ include file="sidebar.jsp" %>

            <div class="content-area">


                <h2 class="text-center mb-4 text-primary">Import Products</h2>


                <form action="${pageContext.request.contextPath}/importproduct" method="post"  enctype="multipart/form-data" onsubmit= "return validateForm()" >
                    <%                    ProductDAO productDAO = new ProductDAO();
                        List<Products> products = productDAO.getAllProduct();
                    %>

                    <% if ("success".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-success text-center">Import successful!</div>
                    <% } else if ("error".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-danger text-center">An error occurred. Please try again..</div>
                    <% } %>

                    <label for="productSelect">Select Product:</label>
                    <select name="productID" id="productSelect" class="form-select" onchange="checkProductSelection();" required>

                        <option value="">-- Search Product --</option>
                        <option value="NEW" style="font-weight: bold; color: #d63384;"> Add New Product </option>
                        <% for (Products p : products) {%>
                        <option value="<%= p.getProductID()%>"><%= p.getName()%></option>
                        <% }%>
                    </select>


                    <label for="storage" class="mt-3">Storage</label>
                    <input type="text" name="storage" id="storage"  class="form-control"placeholder="Nhập dung lượng, ví dụ: 128GB"  required>
                    <span id="storageError" class="text-danger"></span>



                    <label for="color" id="color" class="mt-3">Color</label>
                    <input type="text" name="color" class="form-control" requered >


                    <label for="quantity" class="mt-3">Quatity </label>
                    <input type="number" name="quantity" class="form-control" min="0" value="1" required>

                    <div class="row mt-3">
                        <div class="col">
                            <label>Cost Price(VNĐ)</label>
                            <input type="number" name="costPrice" class="form-control" step="1000" min="0" required>
                        </div>
                        <div class="col">
                            <label> Selling Price (VNĐ)</label>
                            <input type="number" name="sellingPrice" class="form-control" step="1000" min="0" required>
                        </div>
                    </div>

                    <small class="text-muted d-block mt-2">
                        The selling price will update the current price of the product.
                    </small>

                    <label for="calculatedDate" class="mt-3">Import Date</label>
                    <input type="datetime-local" name="calculatedDate" id="calculatedDate" class="form-control" required>

                    <button type="submit" class="btn btn-primary w-100 mt-4">Confirm Import</button>

                </form>
            </div>
        </div>
    </body>
</html>


<script>
    document.addEventListener('DOMContentLoaded', function () {
    const dateInput = document.querySelector('input[name="calculatedDate"]');
    if (dateInput) {
    const now = new Date();
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
    dateInput.value = now.toISOString().slice(0, 16);
    }
    });
    function checkProductSelection() {
    var selectBox = document.getElementById("productSelect");
    var selectedValue = selectBox.value;
    if (selectedValue === "NEW") {
    window.location.href = "${pageContext.request.contextPath}/admin?action=showCreateProduct";
    }
    }

   
        document.getElementById("storage").addEventListener("input", function () {
            const storage = this.value.trim().toUpperCase();
    const regex = /^[0-9]+(GB|TB)$/;
    if (!regex.test(storage)) {
    document.getElementById("storageError").innerText =
            "Dung lượng không hợp lệ! Ví dụ: 64GB, 128GB, 1TB.";
    this.classList.add("is-invalid");
    } else {
    document.getElementById("storageError").innerText = "";
    this.classList.remove("is-invalid");
    this.classList.add("is-valid");
    }
                });

       
        function validateForm() {
            const storage = document.getElementById("storage").value.trim().toUpperCase();
    const regex = /^[0-9]+(GB|TB)$/;
    if (!regex.test(storage)) {
    alert("Dung lượng không hợp lệ! Hãy nhập dạng: 64GB, 128GB, 1TB...");
    return false; // chặn submit
    }

return true;
                }
</script>



