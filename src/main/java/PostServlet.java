import com.google.gson.Gson;
import server.chat.Post;

import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;

@WebServlet(name = "PostServlet")
public class PostServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter responseWriter = response.getWriter();

        String username = request.getParameter("username");
        String strFrom = request.getParameter("from");
        String strTo = request.getParameter("to");
        String hashtags = request.getParameter("hashtags");

        try {
            ArrayList<Post> posts;

            if(username != null)
                posts = PostManager.searchPostsByUsername(username);
            else if(strFrom != null || strTo != null) {
                LocalDateTime from = (strFrom == null || strFrom.isEmpty()) ? null : LocalDate.parse(strFrom).atStartOfDay();
                LocalDateTime to = (strTo == null || strTo.isEmpty()) ? null : LocalDate.parse(strTo).plusDays(1).atStartOfDay();

                posts = PostManager.searchPostsByDateModified(from, to);
            }
            else if(hashtags != null)
                posts = PostManager.searchPostsByHashtags(Arrays.asList(hashtags.split(" ")));
            else
                posts = PostManager.getRecentPosts();

            Gson gson = new Gson();
            responseWriter.append(gson.toJson(posts));
        } catch(Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            responseWriter.append("Invalid request");
        }

        responseWriter.close();
    }
}
