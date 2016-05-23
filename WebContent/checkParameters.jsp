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
<title>Volleyday - Turnier erstellen</title>
</head>
<body>

<%@include file="header.jsp" %>
<div id="fixiert">
<%@include file="menue.jsp" %>
</div>

<div id="main">

<%! Tournament turnier=null;%>
<%! String tname=null; %>
<%! int status; %>
<%! int gpt; %>
<%! int totalTime; %>
<%! String nextStartTime; %>
<%! int[] bounds; %>

<%
   turnier = (Tournament) session.getAttribute("turnier");
tname = (String) session.getAttribute("tname");
status = turnier.getStatus();

//

try {
	gpt = Integer.valueOf(request.getParameter("gpt"));
	totalTime = Integer.valueOf(request.getParameter("totalTime"));
	nextStartTime = request.getParameter("nextStartTime");
}
catch (NumberFormatException e){gpt = 0;}

// update tournament if necessary
if (gpt > 0) {
	turnier.setTotalTime(totalTime);
	turnier.setNextStartTime(nextStartTime);
}

bounds = turnier.setGamesPerTeam(gpt);
if (gpt > 0 && (bounds.length == 0 || status > 1)) {
	TournamentLoader.saveTournament(turnier, tname + "_Sicherung_" + status + ".trf");
	turnier.calculateNext();
	TournamentLoader.saveTournament(turnier, tname + ".trf");
%>
	<form action="overview.jsp">
	<p>Runde <%=status+1 %> wurde erfolgreich berechnet. Hier geht es zurück zur &Uuml;bersicht.</p>
	<input type="submit" value="&Uuml;bersicht" />
	</form>
<%
} else if (status == 4){
	TournamentLoader.saveTournament(turnier, tname + "_Sicherung_" + status + ".trf");
	turnier.calculateNext();
	TournamentLoader.saveTournament(turnier, tname + ".trf");
%>
	<form action="overview.jsp">
	<p>Das Turnier wurde erfolgreich abgeschlossen. Hier geht es zurück zur &Uuml;bersicht.</p>
	<input type="submit" value="&Uuml;bersicht" />
	</form>
<%
} else {
%>
	<form action="checkParameters.jsp" method="POST">
	<p>
<% 	if (status < 2) { %>
		Mit der Totalzeit <%=turnier.getTotalTime() %> Minuten wird die Anzahl der Spiele pro Team zwischen
		<%=bounds[0] %> und <%=bounds[1] %> betragen. Bitte tragen Sie ein, wie lange die zur Verf&uuml;gung stehende Zeit ist,
		wann die n&auml;chste Runde beginnen soll und wie viele Spiele jede Mannschaft spielen soll.
<% 	} else { %>
		Wie lange sollen die Spiele dauern und wann sollen sie beginnen?
<% 	} %>
	</p>
	<table>
		<tr>
			<td>Zeit [min]:</td>
			<td><input type="text" name="totalTime" value="<%=turnier.getTotalTime() %>" /></td>
		</tr>
		<tr>
			<td>Startzeit:</td>
			<td> <input type="text" name="nextStartTime" value="<%=turnier.getNextStartTime().out() %>" /></td>
		</tr>
<%	if (status < 2 ) {%>
		<tr>
			<td>Spiele pro Mannschaft:</td>
			<td><input type="text" name="gpt" value="<%=gpt %>" />	</td>
		</tr>
<%	} %>
	</table>
<%	if (status > 1) { %>
		<input type="hidden" name="gpt" value="1" />
<%	} %>
	<input type="submit" value="Berechnen..." class="bluebutton" />
	</form>
<% } %>

</div>

</body>
</html>