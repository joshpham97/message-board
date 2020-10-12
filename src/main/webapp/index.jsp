<%--
  Created by IntelliJ IDEA.
  User: Stefan JB
  Date: 2020-09-28
  Time: 9:06 a.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="server.chat.Message" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>A simple Chat Server</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
        <link rel="stylesheet" href="defaultTheme.css" />
        <link rel="stylesheet" href="darkTheme.css" />
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
        <script src="https://kit.fontawesome.com/15f69f89ed.js" crossorigin="anonymous"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="utils.js"></script>
    </head>
    <body>
        <jsp:useBean
                id= "theme"
                scope= "session"
                class= "Beans.ThemeManager">
        </jsp:useBean>
        <input id="refreshDate" type="text" hidden="true"/>
        <div id="navbar" class="bgPrimary textPrimary">
            <div id="appLogo">
                <i class="fas fa-comments"></i>
                <span>Chat Server</span>
            </div>
            <div id="navBarMenu">
                <div class="navBarMenuItem bgHighlight rounded" onclick="setUsername()" title="Click to change username">
                    <i class="fas fa-user mr-1"></i>
                    <span id="usernameNavBar">Anonymous</span>
                </div>
                <div class="navBarMenuItem bgHighlight rounded" onclick="switchTheme()" title="Click to change theme">
                    <i class="fas fa-cog mr-1"></i>
                    <span>Change theme</span>
                </div>
            </div>
        </div>

        <div id="mainUI">
            <div id="chatUI" class="bgSecondary rounded">
                <div id="messagesContainer" class="overflow-auto rounded">
                    <div id="noMessagePlaceholder" class="textSecondary">
                        <i class="far fa-comment-alt"></i>
                        <span>Send a message to start the chat!</span>
                    </div>
                </div>
                <div>
                    <div id="usernameChatUI">
                        <span>Sending messages as</span>
                        <span id="usernameDisplay" class="textSecondary">Anonymous</span>
                    </div>

                    <input id="usernameHidden" name="username" type="text" class="form-control" placeholder="Anonymous" hidden/>
                    <div>
                        <textarea id="message" name="message" class="form-control" rows="2" placeholder="Enter your message here..."></textarea>
                        <div id="btnPostMessageContainer">
                            <div class="btn btn-primary" onclick="sendMessage()">
                                <i class="fas fa-paper-plane mr-1"></i>
                                <span>Send</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="utilitiesUI">
                <div class="card mb-2">
                    <div class="card-header bgPrimary textPrimary bgHighlight">
                        <a class="btn" data-toggle="collapse" data-target="#downloadCardBody">
                            <i class="fas fa-download mr-1"></i>
                            <span>Archive Messages</span>
                        </a>
                    </div>
                    <div class="collapse" id="downloadCardBody">
                        <div class="card-body bgSecondary">
                            <div class="divInfo bgTertiary textInfo rounded mb-3 p-2">
                                To download the messages, specify a start date or end date. If no start or end date is
                                selected, all messages will be downloaded. If there is either a start date or end date,
                                messages that are from the start or to the end date will be downloaded. You can choose to
                                save the messages as plain text, or get them in XML format.
                            </div>
                            <form action="Servlet" class="customForm">
                                <div>
                                    <label for="archiveMessage_from">From: </label>
                                    <input id="archiveMessage_from" name="from" type="date" class="form-control"/>
                                </div>

                                <div>
                                    <label for="archiveMessage_to">To: </label>
                                    <input id="archiveMessage_to" name="to" type="date" class="form-control" />
                                </div>

                                <div>
                                    <label for="archiveMessage_to">Format: </label>
                                    <span class="radio">
                                                <input type="radio" name="fileFormat" value="TEXT" checked/> TEXT
                                            </span>
                                    <span class="radio">
                                                <input type="radio" name="fileFormat" value="XML"> XML
                                            </span>
                                </div>

                                <div class="utilitiesUIBtnContainer">
                                    <button type="Submit" class="btn btn-primary">
                                        <i class="fas fa-download mr-1"></i>Download
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header bgPrimary bgHighlight">
                        <a class="btn" data-toggle="collapse" data-target="#deleteCardBody">
                            <i class="fas fa-trash-alt mr-1 textPrimary"></i>
                            <span class="textPrimary">Clear Messages</span>
                        </a>
                    </div>
                    <div class="collapse" id="deleteCardBody">
                        <div class="card-body bgSecondary">
                            <div class="divInfo bgTertiary textInfo rounded mb-3 p-2">
                                To clear the messages, specify a start date or end date. If no start or end date is
                                selected, all messages will be cleared. If there is either a start date or end date,
                                messages that are from the start or to the end date will be deleted.
                            </div>
                            <form action="Servlet" method="post" class="customForm">
                                <div>
                                    <label for="deleteMessage_from">From: </label>
                                    <input id="deleteMessage_from" name="from" type="date" class="form-control" />
                                </div>

                                <div>
                                    <label for="deleteMessage_to">To: </label>
                                    <input id="deleteMessage_to" name="to" type="date" class="form-control" />
                                </div>

                                <div class="utilitiesUIBtnContainer">
                                    <button id="deleteMessagesBtn" type="Submit" name="clearChat" class="btn btn-primary">
                                        <i class="fas fa-trash-alt mr-1"></i>Delete
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
