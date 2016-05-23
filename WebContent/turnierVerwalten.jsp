<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="volleyObjects.Tournament, volleyObjects.TournamentLoader" %>
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

<%! Tournament turnier;%>
<%! String status; %>
<%! String tname; %>

<%
   tname = request.getParameter("tname");
status = request.getParameter("status");
if (status!=null) {
	String message = null;
	if (status.equals("neu")) {
		turnier = new Tournament();
		turnier.setFieldCount(Integer.valueOf(request.getParameter("feldzahl")));
		turnier.setTeamCount(Integer.valueOf(request.getParameter("teamzahl")));
		message = "Das Turnier wurde erfolgreich erstellt.\n";
		message += "Sie k&ouml;nnen nun die verschiedenen Men&uuml;funktionen nutzen.";
	} else if (status.equals("change")) {
		turnier = (Tournament) session.getAttribute("turnier");
		message = "Die &Auml;nderungen wurden gespeichert.";
	}
	
	// set all variables of the tournament
	turnier.setMinTime(Integer.valueOf(request.getParameter("minzeit")));
	turnier.setMaxTime(Integer.valueOf(request.getParameter("maxzeit")));
	turnier.setBreakTime(Integer.valueOf(request.getParameter("pausenzeit")));
	
	// save tournament
	TournamentLoader.saveTournament(turnier, tname + ".trf");
%>
	<p><%=message %></p>
<%
} else {	// status eq null means load a tournament!!
	turnier = TournamentLoader.loadTournament(tname + ".trf");
%>
	<p>Das Turnier <%=tname %> wurde erfolgreich geladen.<br>
		Sie k&ouml;nnen nun die verschiedenen Men&uuml;funktionen nutzen.</p>
<%
   }
session.setAttribute("turnier", turnier);
session.setAttribute("tname", tname);
%>

</div>

</body>
</html>