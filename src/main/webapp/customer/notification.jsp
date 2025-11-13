<%@page import="java.util.List"%>
<%@page import="model.Notification"%>
<%
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    Integer unreadCount = (Integer) request.getAttribute("unreadCount");
%>

<div class="notification-wrapper" style="position: relative; display: inline-block;">
    <i id="notificationBell" class="fa fa-bell" style="font-size: 24px; cursor: pointer;"></i>

    <% if (unreadCount > 0) { %>
    <span class="badge" style="
          position: absolute; top: -5px; right: -5px;
          background-color: red; color: white;
          border-radius: 50%; padding: 2px 6px; font-size: 12px;">
        <%= unreadCount %>
    </span>
    <% } %>

    <div id="notificationPopup" class="notification-popup" style="
         display: none; position: absolute; right: 0; top: 35px;
         width: 350px; max-height: 400px; overflow-y: auto;
         background-color: white; box-shadow: 0px 4px 10px rgba(0,0,0,0.2);
         border-radius: 10px; z-index: 1000;">
        <div style="padding: 10px; border-bottom: 1px solid #ddd; font-weight: bold;">
            Thông báo
        </div>
        <div style="max-height: 350px; overflow-y: auto;">
            <% if (notifications == null || notifications.isEmpty()) { %>
            <div style="padding: 10px; text-align: center;">Không có thông báo nào</div>
            <% } else { %>
            <% for (Notification n : notifications) { %>
            <div class="notification-item" style="
                 padding: 10px; border-bottom: 1px solid #eee;
                 background-color: <%= n.isView() ? "white" : "#f0f8ff" %>;
                 cursor: pointer;"
                 onclick="markAsRead(<%= n.getNotificationID() %>)">
                <strong><%= n.getTitle() != null ? n.getTitle() : "Thông báo" %></strong><br>
                <small><%= n.getContent() %></small><br>
                <small style="color: gray;"><%= n.getCreatedAt() %></small>
            </div>
            <% } %>
            <% } %>
        </div>
    </div>
</div>

<script>
    const bell = document.getElementById("notificationBell");
    const popup = document.getElementById("notificationPopup");

    bell.addEventListener("click", function (event) {
        popup.style.display = popup.style.display === "block" ? "none" : "block";
        event.stopPropagation();
    });

    document.addEventListener("click", function (event) {
        if (!popup.contains(event.target) && event.target !== bell) {
            popup.style.display = "none";
        }
    });

    function markAsRead(id) {
        fetch('<%=request.getContextPath()%>/notification', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'id=' + id
        })
                .then(res => res.text())
                .then(data => {
                    if (data === "success")
                        location.reload();
                });
    }
</script>
