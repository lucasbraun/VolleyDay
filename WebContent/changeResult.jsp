<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="volleyObjects.Tournament, volleyObjects.TournamentLoader, volleyObjects.Match, java.util.List" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="DC.Language" content="de-CH">
<link rel="stylesheet" type="text/css" href="css/volley.css">
<meta name="AUTHOR" content="Lucas Braun">
<meta name="ROBOTS" content="NOINDEX">
<meta name="Description" content="Spielplan-Manager Volleyday">
<title>Volleyday - Resultate speichern</title>
</head>
<body>

<%@include file="header.jsp" %>
<div id="fixiert">
<%@include file="menue.jsp" %>
</div>

<div id="main">

<h2>Resultate speichern</h2>

<%! Tournament turnier=null; %>
<%! String tname=null; %>
<%! Integer row=null; %>

<%
   try {
	tname = (String) session.getAttribute("tname");
	turnier = (Tournament) session.getAttribute("turnier");
	row = Integer.valueOf(request.getParameter("row"));
} catch (Exception e) {
	turnier = null;
	tname = null;
	row = null;
}

if (tname!=null && row!=null) {
	// get updating values if there are any
	String[] werte1 = request.getParameterValues("wert1");
	String[] werte2 = request.getParameterValues("wert2");
%>
	<form action="changeResult.jsp?row=<%=row %>" method="POST">
	<table style="margin-top:0">
<%
	// start creating the table
	List<Match> matches = turnier.getOverviewTable(turnier.getStatus()).get(row);
	int i = 0;
	for (Match match: matches) {
		// update values if necessary
		if (match != null) {
			if (werte1 != null) {
				match.setResult(Integer.valueOf(werte1[i]), Integer.valueOf(werte2[i]));
			}
%>
			<tr>
				<td><%=match.getTeam1().getName() %><td>
				<td><input type="text" size="3px" name="wert1" value="<%=match.getGoals1() %>" /></td>
				<td>:</td>
				<td><input type="text" width="3px" name="wert2" value="<%=match.getGoals2() %>" /></td>
				<td align="right"><%=match.getTeam2().getName() %></td>
			</tr>
<%
			i++;
		}
	}
	// save changes in tournament
	if (werte1 != null)
		TournamentLoader.saveTournament(turnier, tname + ".trf");
%>	
	</table>
	<input type="submit" value="Speichern" class="redbutton" />
	</form>
	
	<form action="overview.jsp" method="POST">
		<input type="submit" value="Zur&uuml;ck zur &Uuml;bersicht" class="bluebutton" />
	</form>
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