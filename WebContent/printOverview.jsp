<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="volleyObjects.Tournament" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="DC.Language" content="de-CH">
<link rel="stylesheet" type="text/css" href="css/volley.css">
<meta name="AUTHOR" content="Lucas Braun">
<meta name="ROBOTS" content="NOINDEX">
<meta name="Description" content="Spielplan-Manager Volleyday">
<title>Volleyday - Dokumente drucken</title>
</head>
<body>

<%@include file="header.jsp" %>
<div id="fixiert">
<%@include file="menue.jsp" %>
</div>

<div id="main">

<h2>Dokumente drucken</h2>

<%! Tournament turnier=null; %>
<%! String tname=null; %>

<%
   try {
	tname = (String) session.getAttribute("tname");
	turnier = (Tournament) session.getAttribute("turnier");
} catch (Exception e) {
	turnier = null;
	tname = null;
}

if (tname!=null) {
%>
	<ul>
		<li><a href="printPlansTeams.jsp" target="_blank">aktuelle Spielpl&auml;ne f&uuml;r Spieler drucken</a></li>
		<li><a href="printPlansFields.jsp" target="_blank">aktuelle Spielpl&auml;ne f&uuml;r Schiedsrichter drucken</a></li>
		<li><a href="printResults.jsp" target="_blank">Resultate drucken (&Uuml;bersicht)</a></li>
		<li><a href="printResults2.jsp" target="_blank">Resultate drucken (nach Gruppen)</a></li>
		<li><a href="printPoints.jsp" target="_blank">alle Teams mit allen Punkten</a></li>
<%
	if (turnier.getStatus() > 1) {
%>
		<li><a href="printTipp.jsp" target="_blank">Tipp-Spiel</a></li>
<%	} %>
	</ul>
	
<%
} else {
%>
	<p>Es muss zuerst ein Turnier geladen werden und eine Zeile ausgew&auml;hlt werden!</p>
<%
}
%>

</div>

</body>
</html>