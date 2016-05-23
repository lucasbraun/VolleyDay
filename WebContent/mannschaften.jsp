<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="volleyObjects.Tournament, volleyObjects.TournamentLoader, volleyObjects.Team, java.util.Iterator, java.util.Enumeration" %>
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

<h2>Teams verwalten</h2>

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
	String[] varbetrags = request.getParameterValues("varbetrag");
	String[] fixbetrags = request.getParameterValues("fixbetrag");
	// update names if necessary
	if (namen != null) {
		Iterator<Team> mit = turnier.getTeams().iterator();
		for (int i = 0; i < namen.length; i++) {
			Team team = mit.next();
			team.setName(namen[i]);
			team.setVarbetrag(Double.valueOf(varbetrags[i]));
			team.setFixbetrag(Double.valueOf(fixbetrags[i]));
		}
		TournamentLoader.saveTournament(turnier, (String) session.getAttribute("tname") + ".trf");
	}
	
	// add/remove if necessary
	String delete = request.getParameter("delete");
	if (delete!=null) {
		if (delete.equals("-1"))
			turnier.addTeam("neues Team");
		else {
			turnier.removeTeam(Integer.valueOf(delete));
		}
		TournamentLoader.saveTournament(turnier, (String) session.getAttribute("tname") + ".trf");
	}
%>
	<form action="mannschaften.jsp" method="POST">
	<input type="submit" value="Speichern" class="redbutton">
	<table style="margin-top:0">
	<tr align="center">
  		<td width="150px"><b>Name</b></td>
  		<td width="80px"><b>Fixbetrag</b></td>
  		<td width="80px"><b>Total-Betrag<br>pro Punkt</b></td>
	</tr>	
<%
	Iterator<Team> it = turnier.getTeams().iterator();
	int i = 0;
	while (it.hasNext()) {
		Team team = it.next();
		String name = team.getName();
		String fixbetrag = String.valueOf(team.getFixbetrag());
		String varbetrag = String.valueOf(team.getVarbetrag());
%>
	<tr>
		<td><input name="name" type="text" value="<%=name %>" /></td>
		<td align="center"><input name="fixbetrag" type="text" value="<%=fixbetrag %>" /></td>
		<td align="center"><input name="varbetrag" type="text" value="<%=varbetrag %>" /></td>
<%
		if (turnier.getStatus()==0) {
%>
		<td><a href="mannschaften.jsp?delete=<%=i %>">Mannschaft l&ouml;schen</a></td>
<%		} %>
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
	<a href="mannschaften.jsp?delete=-1">neue Mannschaft hinzuf&uuml;gen</a><br/>
<%	} %>
	</form>
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