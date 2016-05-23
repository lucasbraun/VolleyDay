<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.io.File, volleyObjects.Tournament, volleyObjects.TournamentLoader" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="DC.Language" content="de-CH">
<link rel="stylesheet" type="text/css" href="css/volley.css">
<meta name="AUTHOR" content="Lucas Braun">
<meta name="ROBOTS" content="NOINDEX">
<meta name="Description" content="Spielplan-Manager Volleyday">
<title>Volleyday - Turnier erstellen</title>
</head>
<body>

<%@include file="header.jsp" %>
<div id="fixiert">
<%@include file="menue.jsp" %>
</div>

<div id="main">

<h2>Neues Turnier / Turnier laden</h2>

<%
   try {
	tname = (String) session.getAttribute("tname");
	turnier = (Tournament) session.getAttribute("turnier");
} catch (Exception e) {
	turnier = null;
	tname = null;
}
%>

<p>Hier k&ouml;nnen Sie ein neues Turnier anlegen oder bestehende Turniere
laden.</p>

<h4>Neues Turnier erstellen</h4>

<form method="POST" action="turnierEigenschaften.jsp?status=neu">
Turniername:
<input type="text" name="tname" value="turnier1">
<input type="submit" value="Erstellen" class="bluebutton">
</form>

<h4>Bestehendes Turnier laden</h4>

<form method="POST" action="turnierVerwalten.jsp">
<select name="tname" size="1">
<%
File[] filelist;
filelist = TournamentLoader.getFileList();
for (File f: filelist) {
	String name = f.getName();
	name = name.substring(0, name.length()-4);
%> <option value="<%=name %>" ><%=name %></option><%
}
%>
</select>
<input type="submit" value="Laden" class="bluebutton">
</form>

<%! Tournament turnier=null; %>
<%! String tname=null; %>

<%
if (tname!=null) {
%>

	<h2><%=tname %> verwalten</h2>
	
	<%
	if (turnier.getStatus()==0) {
	%>
		<form method="POST" action="turnierEigenschaften.jsp?status=change">
		<input type="hidden" value="<%=tname %>" name="tname" />
		<p>Eigenschaften von <%=tname %></p>
		<input type="submit" value="&auml;ndern" />
		</form>
	
	<% } %>
	
	<form method="POST" action="turnierSicherungskopie.jsp">
	<p>Sicherungskopie von <%=tname %> unter dem Namen</p>
	<input type="text" value="Sicherung1" name="tname" />
	<input type="submit" value="erstellen" />
	</form>

<% } %>
</div>

</body>
</html>