/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.util.Date;
/**
 *
 * @author Stefan JB
 */
public class Message {
    private String username;
    private String message;
    private Date date;
    public Message()
    {
        username = "";
        message = "";
        date = new Date();
    }
    public Message(String username, String message, Date date) {
        this.username = username;
        this.message = message;
        this.date = date;
    }

    public Message(String message, Date date) {
        this("Anonymous", message, date);
    }

    public String getUsername() {
        return username;
    }

    public String getMessage() {
        return message;
    }

    public Date getDate() {
        return date;
    }

    public void setUser(String username) {
        this.username = username;
    }

    public void setContent(String message) {
        this.message = message;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    @Override
    public String toString() {
        return this.username + ": " + this.message;
    }
}