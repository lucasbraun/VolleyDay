<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.File, volleyObjects.Tournament, volleyObjects.TournamentLoader, volleyObjects.Field, volleyObjects.Group, volleyObjects.Match, volleyObjects.Team, java.util.List, java.util.Iterator" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="DC.Language" content="de-CH">
<link rel="stylesheet" type="text/css" href="css/volley.css">
<script type="text/javascript">
function sicher(status) {
	msg = "Wollen Sie wirklich zur nächsten Runde übergehen?\nSie können danach keine Resultate aus dieser Runde mehr ändern!";
	if (status == 0)
		msg = "Wollen Sie wirklich die erste Runde berechnen?\nSie können danach keine Mannschaften oder Felder mehr hinzufügen oder löschen!";
	if (status == 4)
		msg = "Sind Sie sicher, dass Sie das Turnier abschliessen wollen?\nSie können danach keine Resultate mehr ändern!";
	return confirm(msg);
}
</script>

<meta name="AUTHOR" content="Lucas Braun">
<meta name="ROBOTS" content="NOINDEX">
<meta name="Description" content="Spielplan-Manager Volleyday">
<title>Volleyday - &Uuml;bersicht</title>
</head>
<body>

<%@include file="header.jsp" %>
<div id="fixiert">
<%@include file="menue.jsp" %>
</div>

<div id="main">

<h2>&Uuml;bersicht</h2>

<%
   String tname;
Tournament turnier;
try {
	tname = (String) session.getAttribute("tname");
	turnier = (Tournament) session.getAttribute("turnier");
} catch (Exception e) {
	tname = null;
	turnier = null;
}
if (tname!=null) {
	
	int status;		// either status of actual round or of an old round
	try {
		status = Integer.valueOf(request.getParameter("status"));
		if (status > turnier.getStatus())
			throw new Exception("Status too high");
	} catch (Exception e) {
		status = turnier.getStatus();
	}
			
	if (status>0 && status <5) {
		
		// create overview
		List<List<Match>> table = turnier.getOverviewTable(status);
		Iterator<List<Match>> rowIterator = table.iterator();
		Iterator<Match> columnIterator;
		Match tempMatch;
		String tempString;
		String clockString;
		int i = 0;
%>
		<h2>Runde <%=status %></h2>
		<table style="margin-top:0">
<%
		// Create header line
		out.println("<tr>");
		out.println("<td class='list' style='background:#171760; color:white;'>&nbsp;</td>");
		for (Field f: turnier.getFields()) {
			out.println("<td class='list' align='center'  style='background:#171760; color:white;'><b>" + f.getName() + "</b></td>");
		}
		if (status == turnier.getStatus())
			out.println("<td class='list'>&nbsp;</td>");
		out.println("</tr>");
		
		// Create table rows
		while (rowIterator.hasNext()) {
			out.println("<tr>");
			columnIterator = rowIterator.next().iterator();
			tempString = "";
			clockString = null;
			while (columnIterator.hasNext()) {
				tempMatch = columnIterator.next();
				if (tempMatch!=null) {
					tempString += ("<td class='list' align='center'>" + tempMatch.getTeam1().getName() + " <b><font size='+1'>" + tempMatch.getGoals1() + ":" + 
							tempMatch.getGoals2() + "</font></b> " + tempMatch.getTeam2().getName() + "</td>\n");
					clockString = tempMatch.getTime().out();
				} else {
					tempString += ("<td class='list'>&nbsp;</td>\n");
				}
			}
			if (status == turnier.getStatus())
				tempString += ("<td class='list'><form method='POST' action='changeResult.jsp?row=" + String.valueOf(i) + "'><input type='submit' class='bluebutton' value='Resultate eintragen'/></form></td>");
			out.println("<td class='list' align='right'  style='background:#171760; color:white;'><b>" + clockString + "</b></td>\n" + tempString);
			out.println("</tr>");
			i++;
		}
%>		
		</table>
<%
		if (status == turnier.getStatus()) {
			// print game time
%>
		<p>Alle Spiele dauern <%=turnier.getGameTime() %> Minuten.</p>
<%
		}
	} else if (status == 5) {
		List<Group> finalGroups = turnier.getActiveGroups(4);
%>
		<h3 align="center">Sieger Liga A</h3>
		<center><b><%=finalGroups.get(0).getTable().get(0).getName() %></b></center>
		<h3 align="center">Sieger Liga B</h3>
		<center><b><%=finalGroups.get(1).getTable().get(0).getName() %></b></center>
		<h3 align="center">Sponsoren-Sieger</h3>
		<center>
<%		for (Team t: turnier.getBestSponsors()) {%>
		<b><%= t.getName()%>: <font color="red">CHF <%=t.getBetrag() %></font></b><br/>
<%		} %>
		</center>
		<h3 align="center">Gesamtsumme</h3>
		<center><b><font color="red">CHF <%=turnier.getBetrag() %></font></b></center>
<%
	}
	if (turnier.getStatus() > 1) {
		// print options to navigate to other rounds
%>
		<form action="overview.jsp" method="POST">
		<p>Wechseln Sie zu den Resultaten von einer anderen Runde:</p>
		<select size="1" name="status">
<%
	String caption;
	for (int j = 1; j <= turnier.getStatus(); j++) {
		if (j != status) {
			caption = "Runde " + j;
			if (j == 5) {
				caption = "Sieger";
			}
			out.println("<option value='" + j + "'>" + caption + "</option>");
		}
	}
%>		
		</select>
		<input type="submit" class="bluebutton" value="anzeigen" />
		</form>
<%			
	}
	if (status == turnier.getStatus() && status < 5) {
		// print option to next round
		String s = "Turnier starten / n&auml;chste Runde";
		if (status == 4)
			s = "Turnier abschliessen";
%>
		<br/>
		<form action="checkParameters.jsp" method="POST">
		<input type="submit" class="redbutton" value="<%=s %>" onclick="return sicher(<%=turnier.getStatus() %>)"/>
		</form>
<%
	}
%>

<%
} else {
%>
	<p>Es muss zuerst ein Turnier geladen werden!</p>
<% } %>
</div>

</body>
</html>