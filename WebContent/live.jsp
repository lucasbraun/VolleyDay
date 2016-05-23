<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="volleyObjects.TournamentLoader, volleyObjects.Tournament, volleyObjects.Field, volleyObjects.Match, volleyObjects.Group, volleyObjects.Team, java.util.List, java.util.Iterator" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="refresh" content="15" >
<meta name="DC.Language" content="de-CH">
<meta name="AUTHOR" content="Lucas Braun">
<meta name="ROBOTS" content="NOINDEX">
<meta name="Description" content="Spielplan-Manager Volleyday">
<link rel="stylesheet" type="text/css" href="css/live.css">
<title>Volleyday - Live Mode</title>
</head>
<body>

<h1>Volley - Day 2013</h1>

<div id="main">

<%! Tournament turnier=null; %>
<%! String tname=null; %>
<%! int status; %>
<%! int round; %>

<%
   try {
	tname = (String) session.getAttribute("tname");
	turnier = TournamentLoader.loadTournament(tname + ".trf");
	status = turnier.getStatus();
} catch (Exception e) {
	turnier = null;
	tname = null;
}

try {
	round = ((Integer) session.getAttribute("round")) % (2 * turnier.getActiveGroups(status).size());
} catch (Exception e) {
	round = 0;
}

if (tname!=null && status != 0) {
	// set next round
	session.setAttribute("round", (round +1));
	
	// print out MONEY
%>
	<div style="width:500px; background-color:red">
		<center><font size="+2"><b>Gespendet: CHF <%=turnier.getBetrag() %></b></font></center>
	</div>
<%
	
	if ((round % 2) == 0) {
		if (status < 5) {
			// show overview table
			List<List<Match>> table = turnier.getOverviewTable(status);
			Iterator<List<Match>> rowIterator = table.iterator();
			Iterator<Match> columnIterator;
			Match tempMatch;
			String tempString;
			String clockString;
			int i = 0;
%>
			<h2>Resultate</h2>
			<table style="margin-top:0">
<%
			// Create header line
			out.println("<tr>");
			out.println("<td class='list'>&nbsp;</td>");
			for (Field f: turnier.getFields()) {
				out.println("<td class='list' align='center'><b>" + f.getName() + "</b></td>");
			}
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
						tempString += ("<td class='list'>" + tempMatch.getTeam1().getName() + " " + tempMatch.getGoals1() + ":" + 
								tempMatch.getGoals2() + " " + tempMatch.getTeam2().getName() + "</td>\n");
						clockString = tempMatch.getTime().out();
					} else {
						tempString += ("<td class='list'>&nbsp;</td>\n");
					}
				}
				out.println("<td class='list' align='right'><b>" + clockString + "</b></td>\n" + tempString);
				out.println("</tr>");
				i++;
			}
%>		
			</table>
<%
		} else {
%>
			<jsp:forward page="overview.jsp"/>
<%
		}
	} else {
		// show group table and group results
		Group g = turnier.getActiveGroups(status).get(round/2);
		int i = 1;
%>
	<div style="float:left; valign:top">
		<h2>Tabelle <%=g.getName() %></h2>
		<table style="margin-top:0">
		<tr>
			<td class="list"><b>Rang</b></td>
			<td class="list"><b>Team</b></td>
			<td class="list"><b>Punkte</b></td>
			<td class="list"><b>Verh&auml;ltnis</b></td>
			<td class="list"><b>Erspieltes Geld</b></td>
		</tr>
<%
		for (Team t: g.getTable()) {
%>
		<tr>
			<td class="list"><b><%=i %>.</b></td>
			<td class="list"><%=t.getName() %></td>
			<td class="list" align="center"><%=t.getPunkte() %></td>
			<td class="list" align="center"><%=t.getTore() %> : <%=t.getKassierteTore() %></td>
			<td class="list" align="right"><%=t.getBetrag() %> CHF</td>
		</tr>
<%
			i++;
		}
%>
		</table>
	</div>
	
	<div style="float:left; margin-left:50px; valign:top">	
		<h2>Resultate</h2>
		<table style="margin-top:0">
<%
		for (Match m: g.getMatches()) {
%>
		<tr>
				<td class="list"><%=m.getTeam1().getName() %></td>
				<td class="list"><%=m.getGoals1() %></td>
				<td class="list" align="center">:</td>
				<td class="list" align="right"><%=m.getGoals2() %></td>
				<td class="list" align="right"><%=m.getTeam2().getName() %></td>
		</tr>
<%
			i++;
		}
%>
		</table>
	</div>
<%
	}
%>
	
<%
} else {
%>
	<p>Es muss zuerst ein Turnier geladen und die erste Runde berechnet werden!</p>
<%
}
%>

</div>

</body>
</html>