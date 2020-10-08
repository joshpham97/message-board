import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.TimeZone;
import java.util.stream.Stream;

import static java.time.format.DateTimeFormatter.RFC_1123_DATE_TIME;

@WebServlet(name = "Servlet")
public class Servlet extends HttpServlet {
    private enum Parameters {
        FROM("from"),
        TO("to"),
        FILE_FORMAT("fileFormat"),
        POST_MESSAGE("postMessage"),
        CLEAR_CHAT("clearChat");

        private final String value;

        private Parameters(String value){
            this.value = value;
        }

        public String toString(){
            return this.value;
        }
    }


    private ChatManager chatManager;
    //private final String TIME_ZONE_ID = TimeZone.getDefault().toString();
    //private final Locale LOCALE = Locale.ENGLISH;
    private final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm:ss");

    @Override
    public void init() throws ServletException {
        super.init();

        chatManager = new ChatManager();

        for(int i=1; i<=5; i++){
            String username = "User" + i;
            String content = "Content" + i;
            LocalDateTime date = LocalDateTime.of(2020, 10, i, 0, 0, 0);
            //Message message = new Message(username, content, date);
            chatManager.postMessage(username, content);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if(request.getHeader("referer") != null) {
            String postMessageParam = request.getParameter(Parameters.POST_MESSAGE.toString());
            String clearChatParam= request.getParameter(Parameters.CLEAR_CHAT.toString());

            // POST MESSAGE
            if(postMessageParam != null) {
                // TODO: post message
            }
            // CLEAR CHAT
            else if (clearChatParam != null) {
                String strFromParam = request.getParameter(Parameters.FROM.toString());
                String strToParam = request.getParameter(Parameters.TO.toString());

                if (strFromParam.isEmpty() && strToParam.isEmpty()) {
                    chatManager.ClearChat();
                }
                else {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
                    LocalDateTime fromParam = LocalDateTime.parse(strFromParam, formatter);
                    LocalDateTime toParam = LocalDateTime.parse(strToParam, formatter);
                    chatManager.ClearChat(fromParam, toParam);
                }
            }
        }
        else {
            PrintWriter responseWriter = response.getWriter();
            responseWriter.append("Invalid request. No Referrer found.");
            responseWriter.close();
            // TODO: error.jsp
//            request.setAttribute("error", "Invalid request. No Referrer found.");
        }

//        request.setAttribute("messages", chatManager.ListMessages());
//        request.getRequestDispatcher("/").forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter responseWriter = response.getWriter();

        if(request.getHeader("referer") != null){
            String strFrom = request.getParameter(Parameters.FROM.toString());
            String strTo = request.getParameter(Parameters.TO.toString());
            String strFileFormat = request.getParameter(Parameters.FILE_FORMAT.toString());

            LocalDateTime from = ((strFrom != null) ? LocalDateTime.parse(strFrom) : null);
            LocalDateTime to = ((strTo != null) ? LocalDateTime.parse(strTo) : null);
            FileFormat fileFormat = ((strFileFormat != null) ? FileFormat.valueOf(strFileFormat) : null);

            Stream<Message> filteredMessagesStream = chatManager.ListMessages(from, to).stream();

            StringBuilder fileContent = new StringBuilder();

            if(fileFormat == FileFormat.XML){
                fileContent.append("<Messages>\n");
                filteredMessagesStream.forEach((Message m) -> fileContent.append(m.toXML()));
                fileContent.append("</Messages>");
                response.setHeader("Content-Disposition", "attachment; filename=\"messages.xml\"");
            }else{
                filteredMessagesStream.forEach((Message m) -> fileContent.append(m.toString()).append("\n"));
                response.setHeader("Content-Disposition", "attachment; filename=\"messages.txt\"");
            }

            response.setContentType("text/plain");
            response.setHeader("expires", LocalDateTime.now().format(FORMATTER));
            responseWriter.append(fileContent.toString());

        }else{
            responseWriter.append("Invalid request. No Referrer found.");
        }

        responseWriter.close();
    }
}