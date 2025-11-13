package controller;

import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.List;
import model.Notification;
import model.Users;
import utils.DBContext;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notification"})
public class NotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users user = (Users) (session != null ? session.getAttribute("user") : null);

        response.setContentType("text/html;charset=UTF-8");

        if (user == null) {
            response.getWriter().write("<div style='padding:10px;color:gray;'>Vui lòng đăng nhập</div>");
            return;
        }

        try (Connection conn = new DBContext().conn) {
            NotificationDAO dao = new NotificationDAO(conn);
            List<Notification> notifications = dao.getNotificationsByUser(user.getUserId());

            if (notifications.isEmpty()) {
                response.getWriter().write("<div style='padding:10px;text-align:center;color:gray;'>Không có thông báo</div>");
            } else {
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                for (Notification n : notifications) {
                    String html = "<div class='notification-item' "
                            + "style='border:1px solid #ccc; border-radius:8px; padding:8px; margin-bottom:8px;'>"
                            + "<p style='margin:0;font-size:14px;'>" + n.getContent() + "</p>"
                            + "<small style='color:gray;'>" + sdf.format(n.getCreatedAt()) + "</small>"
                            + "</div>";
                    response.getWriter().write(html);
                    System.out.println("NotificationServlet chạy rồi");

                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("<div style='padding:10px;color:red;'>Lỗi load thông báo</div>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users user = (Users) (session != null ? session.getAttribute("user") : null);

        if (user == null) {
            response.getWriter().write("error");
            return;
        }

        try (Connection conn = new DBContext().conn) {
            NotificationDAO dao = new NotificationDAO(conn);
            dao.markAllAsRead(user.getUserId()); // đánh dấu tất cả chưa đọc thành đã đọc
            response.getWriter().write("success");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}

