<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="volleyObjects.TournamentLoader, volleyObjects.Tournament" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="volleyObjects.TournamentLoader"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="DC.Language" content="de-CH">
<link rel="stylesheet" type="text/css" href="css/volley.css">
<meta name="AUTHOR" content="Lucas Braun">
<meta name="ROBOTS" content="NOINDEX">
<meta name="Description" content="Spielplan-Manager Volleyday">
<title>Volleyday - Sicherungskopie erstellen</title>
</head>
<body>

<%@include file="header.jsp" %>
<div id="fixiert">
<%@include file="menue.jsp" %>
</div>

<div id="main">

<h2>Sicherungskopie erstellen</h2>

<%
   TournamentLoader.saveTournament((Tournament) session.getAttribute("turnier"), request.getParameter("tname") + ".trf");
%>

<p>Die Sicherung wurde erfolgreich erstellt.</p>

</div>

</body>
</html>