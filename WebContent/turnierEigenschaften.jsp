<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="volleyObjects.Tournament"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="DC.Language" content="de-CH">
<link rel="stylesheet" type="text/css" href="css/volley.css">
<meta name="AUTHOR" content="Lucas Braun">
<meta name="ROBOTS" content="NOINDEX">
<meta name="Description" content="Spielplan-Manager Volleyday">
<title>Volleyday - Turnier Eigenschaften</title>
</head>
<body>

<%@include file="header.jsp" %>
<div id="fixiert">
<%@include file="menue.jsp" %>
</div>

<div id="main">

<%
   Tournament turnier = null;
String status = request.getParameter("status");
try {
	turnier = (Tournament) session.getAttribute("turnier");
} catch (Exception e) {}
%>

<h2>Turnier Eigenschaften festlegen</h2>

<form method="POST" action="turnierVerwalten.jsp?status=<%=status %>">

<table>

<tr>
<td>Turniername:</td>
<td><input type="text" value="<%=request.getParameter("tname")%>" name="tname"></td>
</tr>

<tr>
<td>Modus:</td>
<td><select name="mode"><option value="volleyday">volleyday</option></select></td>
</tr>

<% if (status.equals("neu")) {%>

<tr>
<td>Anzahl Mannschaften:</td>
<td><input type="text" value="24" name="teamzahl"></td>
</tr>

<tr>
<td>Anzahl Spielfelder:</td>
<td><input type="text" value="6" name="feldzahl"></td>
</tr>

<% } %>

<tr>
<td>Spieldauer:</td>
<td>zwischen <input type="text" value="<%=turnier==null?10:turnier.getMinTime() %>" name="minzeit"> und 
<input type="text" value="<%=turnier==null?20:turnier.getMaxTime() %>" name="maxzeit"> Minuten.</td>
</tr>

<tr>
<td>Dauer der Pausen (in min):</td>
<td><input type="text" value="<%=turnier==null?2:turnier.getBreakTime() %>" name="pausenzeit"></td>
</tr>

<tr>
<td colspan="2"><input type="submit" value="Speichern" class="redbutton"></td>
</tr>

</table>

</form>

</div>

</body>
</html>