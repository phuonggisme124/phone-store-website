<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.UsersDAO"%>
<%@page import="model.Order"%>
<%@page import="model.Suppliers"%>
<%@page import="model.Category"%>
<%@page import="model.Products"%>
<%@page import="java.util.List"%>
<%@page import="model.Users"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Instalment Orders</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

        <link rel="stylesheet" href="css/dashboard_admin.css">
        <link rel="stylesheet" href="css/search.css">

        <link href="css/dashboard_table.css" rel="stylesheet">
    </head>
    <body>
        <%
            Users user = (Users) session.getAttribute("user");
            String phone = (String) request.getAttribute("phone");
            if (phone == null || phone.isEmpty()) {
                phone = "";
            }
            String status = (String) request.getAttribute("status");
            if (status == null || status.isEmpty()) {
                status = "Filter";
            }
            List<String> listPhone = (List<String>) request.getAttribute("listPhone");

            if (listPhone == null) listPhone = new ArrayList<>();
        %>
        <div class="d-flex" id="wrapper">
            <%@ include file="sidebar.jsp" %>

            <div class="page-content flex-grow-1">

                <nav class="navbar navbar-light bg-white shadow-sm">
                    <div class="container-fluid">
                        <button class="btn btn-outline-primary" id="menu-toggle">
                            <i class="bi bi-list"></i>
                        </button>
                        <div class="d-flex align-items-center ms-auto">


                            <form action="order" method="get" class="d-flex position-relative me-3" id="searchForm" autocomplete="off">
                                <input type="hidden" name="action" value="searchInstalment"> <input type="hidden" name="status" value="<%= status%>">

                                <div class="position-relative" style="width: 300px;">
                                    <input class="form-control" type="text" id="searchPhone" name="phone"
                                           placeholder="Search Phone Number..."
                                           oninput="fetchSuggestions(this.value)"
                                           value="<%= phone%>">
                                    <div id="suggestionBox" class="list-group position-absolute w-100"
                                         style="top: 100%; z-index: 1000;"></div>
                                </div>

                                <button class="btn btn-outline-primary ms-2" type="submit">
                                    <i class="bi bi-search"></i>
                                </button>
                            </form>



                            <form action="order" method="get" class="dropdown me-3">
                                <input type="hidden" name="action" value="filterInstalment">

                                <input type="hidden" name="phone" value="<%= phone%>">

                                <button class="btn btn-outline-secondary fw-bold dropdown-toggle" 
                                        type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-funnel"></i>
                                    <span id="selectedStatus">
                                        <%= status%>
                                    </span>
                                </button>

                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="filterDropdown">
                                    <li><button type="submit" name="status" value="All" class="dropdown-item">All</button></li>
                                    <li><button type="submit" name="status" value="Pending" class="dropdown-item">Pending</button></li>
                                    <li><button type="submit" name="status" value="Completed" class="dropdown-item">Completed</button></li> 
                                </ul>
                            </form>

                            <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
                            <div class="d-flex align-items-center ms-3">
                                <img src="https://i.pravatar.cc/40" class="rounded-circle me-2" width="35">

                                <span><%= user != null ? user.getFullName() : "Admin"%></span>

                            </div>
                        </div>
                    </div>
                </nav>


                <%
                    UsersDAO udao = new UsersDAO();
                    // Lấy danh sách đơn hàng (Servlet đã lọc sẵn đây là đơn trả góp)
                    List<Order> listInstalment = (List<Order>) request.getAttribute("listOrder");
                    
                    // MỚI: Lấy list Staff/Shipper để hiển thị tên
                    List<Users> listStaff = (List<Users>) request.getAttribute("listStaff");
                    List<Users> listShippers = (List<Users>) request.getAttribute("listShippers");
                    
                    if(listStaff == null) listStaff = new ArrayList<>();
                    if(listShippers == null) listShippers = new ArrayList<>();

                %>

                <%
                    if (listInstalment != null && !listInstalment.isEmpty()) {
                %>

                <div class="card shadow-sm border-0 p-4 m-3">
                    <div class="card-body p-0">
                         <div class="container-fluid p-4 ps-3">
                            <h1 class="fw-bold ps-3 mb-4 fw-bold text-primary">Instalment Orders</h1>
                        </div>

                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>OrderID</th>
                                    <th>User Name</th>
                                    <th>Receiver Phone</th>
                                    <th>Receiver Name</th>
                                    <th>Address</th>
                                    <th>Method</th>
                                    <th>Order Date</th>
                                    <th>Total Amount</th>
                                    <th>Staff</th>
                                    <th>Shipper</th>
                                    <th>Status</th>

                                </tr>
                            </thead>

                            <tbody>
                            <%
                                for (Order o : listInstalment) {
                                    
                                    // --- LOGIC TÌM TÊN STAFF/SHIPPER ---
                                    String staffName = "Not Assigned";
                                    int sID = o.getStaffID(); 
                                    if (sID != 0) {
                                        for (Users u : listStaff) {
                                            if (u.getUserId() == sID) {
                                                staffName = u.getFullName();
                                                break;
                                            }
                                        }
                                    }

                                    String shipperName = "Not Assigned";
                                    int shipID = o.getShipperID();
                                    if (shipID != 0) {
                                        for (Users u : listShippers) {
                                            if (u.getUserId() == shipID) {
                                                shipperName = u.getFullName();
                                                break;
                                            }
                                        }
                                    }
                                    // ----------------------------------
                                    
                                    // Format Date
                                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                                    String dateFormated = "";
                                    LocalDateTime createAt = o.getOrderDate();
                                    if (createAt != null) {
                                        dateFormated = createAt.format(formatter);
                                    }
                            %>
                                <tr  onclick="window.location.href = 'order?action=orderDetail&id=<%= o.getOrderID()%>&isInstalment=true'">
                                    <td>#<%= o.getOrderID()%></td>

                                    <td><%= udao.getUserByID(o.getUserID()).getFullName()%></td>
                                    <td><%= o.getBuyerPhone()%></td>
                                    <td><%= o.getBuyerName()%></td>
                                    <td><%= o.getShippingAddress()%></td>
                                    <td><span class="badge bg-info text-dark"><%= o.getPaymentMethod()%></span></td>
                                    <td><%= dateFormated%></td>
                                    <td class="fw-bold"><%= String.format("%,.0f", o.getTotalAmount())%></td>
                                    
                                    <td><%= staffName%></td>   
                                    <td><%= shipperName%></td>   

                                    <td><%= o.getStatus()%></td>
                                </tr>                          
                            <%
                                }
                            %>
                            </tbody>

                        </table>
                    </div>
                </div>
                <%
                } else {
                %>
                <div class="container-fluid p-4 ps-3">
                    <p>The instalment list is currently empty.</p>
                </div>
                <%
                    }
                %>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
        <script>
            const phoneNumbers = <%= new Gson().toJson(listPhone)%>;
            const searchInput = document.getElementById("searchPhone");
            const suggestionBox = document.getElementById("suggestionBox");

            // Hàm hiển thị gợi ý
            function fetchSuggestions(query) {
                query = query.trim().toLowerCase();
                suggestionBox.innerHTML = "";

                if (!query) {
                    suggestionBox.style.display = "none";
                    return;
                }

                const matches = phoneNumbers.filter(num => num.includes(query));

                if (matches.length === 0) {
                    suggestionBox.style.display = "none";
                    return;
                }

                matches.forEach(num => {
                    const item = document.createElement("button");
                    item.type = "button";
                    item.className = "list-group-item list-group-item-action";
                    item.innerHTML = highlightMatch(num, query);

                    item.addEventListener("click", () => {
                        searchInput.value = num;
                        suggestionBox.style.display = "none";
                        document.getElementById("searchForm").submit();
                    });

                    suggestionBox.appendChild(item);
                });

                suggestionBox.style.display = "block";
            }

            // Tô đậm phần khớp
            function highlightMatch(text, keyword) {
                const regex = new RegExp(`(${keyword})`, "gi");
                return text.replace(regex, `<strong>$1</strong>`);
            }

            // Ẩn box khi click ra ngoài
            document.addEventListener("click", (e) => {
                if (!e.target.closest("#searchForm")) {
                    suggestionBox.style.display = "none";
                }
            });
            
            document.getElementById("menu-toggle").addEventListener("click", function () {
                document.getElementById("wrapper").classList.toggle("toggled");
            });
        </script>
    </body>
</html>

