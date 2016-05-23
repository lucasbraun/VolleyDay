<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="volleyObjects.Tournament, volleyObjects.TournamentLoader, volleyObjects.Field, java.util.Iterator" %>
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

<h2>Spielfelder verwalten</h2>

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
	String[] namen = request.getParameterValues("name");
	String[] regionIndices = request.getParameterValues("region");
	// update names if necessary
	int regionIndex;
	if (namen != null) {
		Iterator<Field> fit = turnier.getFields().iterator();
		for (int i = 0; i < namen.length; i++) {
			Field field = fit.next();
			field.setName(namen[i]);
			try {
				regionIndex = Integer.valueOf(regionIndices[i]);
			} catch (NumberFormatException ex) {
			   regionIndex = 0;
			}
			field.setRegionIndex(regionIndex);
		}
		TournamentLoader.saveTournament(turnier, (String) session.getAttribute("tname") + ".trf");
	}
	
	// add/remove if necessary
	String delete = request.getParameter("delete");
	if (delete!=null) {
		if (delete.equals("-1"))
			turnier.addField("neues Feld");
		else {
			turnier.removeField(Integer.valueOf(delete));
		}
		TournamentLoader.saveTournament(turnier, (String) session.getAttribute("tname") + ".trf");
	}
%>
	<form action="felder.jsp" method="POST">
	<input type="submit" value="Speichern" class="redbutton">
	<table style="margin-top:0">
	<tr align="center">
  		<td width="150px"><b>Name</b></td>
  		<td width="150px"><b>Geb&auml;ude-Nummer <sup>1)</sup></b></td>
	</tr>
<%
	int i = 0;
	Iterator<Field> it = turnier.getFields().iterator();
	while (it.hasNext()) {
		Field field = it.next();
		String name = field.getName();
		int region = field.getRegionIndex();
%>
	<tr>
		<td><input name="name" type="text" value="<%=name %>" /></td>
		<td><input name="region" type="text" value="<%=region %>" /></td>
<%
		if (turnier.getStatus()==0) {
%>
		<td><a href="felder.jsp?delete=<%=i %>">Feld l&ouml;schen</a></td>
<% 		} %>
	</tr>
<%
		i++;
	} // end while
%>
	</table>
	<input type="submit" value="Speichern" class="redbutton">
<%		
	if (turnier.getStatus()==0) {
%>
	<a href="felder.jsp?delete=-1">neues Feld hinzuf&uuml;gen</a><br/>
<%	} %>
	</form>
	<p>1) Felder die im selben Geb&auml;de sind (zu denen man also schnell
	genug gelangt, ohne dass man ein Spiel Pause braucht) haben die gleiche Nummer.</p>
<%
} else {
%>
	<p>Es muss zuerst ein Turnier geladen werden!</p>
<%
}
%>

</div>

</body>
</html>