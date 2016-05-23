<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<div class="floatLeft">
	<img src='css/ball.gif' width='100px'>
</div>
<h1>
	Volley - Day
	<% out.println(Calendar.getInstance().get(Calendar.YEAR));  %>
</h1>