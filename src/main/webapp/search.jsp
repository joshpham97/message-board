<%--
  Created by IntelliJ IDEA.
  User: thuan
  Date: 2020-11-04
  Time: 10:21 p.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <form action="index.jsp">
        <div>
            <input type="text" placeholder="Username" name="username" />
        </div>

        <button type="submit">Search by username</button>
    </form>

    <form action="index.jsp">
        <div>
            <input type="date" name="from" />
            <input type="date" name="to" />
        </div>

        <div>
            <button type="submit">Search by date</button>
        </div>
    </form>

    <form action="index.jsp">
        <div>
            <input type="text" placeholder="Hashtag1 Hashtag2 ..." name="hashtags" />
        </div>

        <div>
            <button type="submit">Search by hashtags</button>
        </div>
    </form>
</body>
</html>
