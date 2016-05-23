<%@ page language="java" contentType="application/pdf"
    pageEncoding="ISO-8859-1" import="volleyObjects.Tournament, volleyObjects.Match, volleyObjects.Team, volleyObjects.Group, java.io.OutputStream, java.util.List,
    	com.itextpdf.text.Document, com.itextpdf.text.DocumentException, com.itextpdf.text.Paragraph, com.itextpdf.text.PageSize,
    	com.itextpdf.text.Phrase, com.itextpdf.text.Font, com.itextpdf.text.FontFactory, com.itextpdf.text.BaseColor,
   	 	com.itextpdf.text.pdf.PdfPCell, com.itextpdf.text.pdf.PdfPTable, com.itextpdf.text.pdf.PdfWriter" %>


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

Document document = new Document();

try {
	PdfWriter.getInstance(document, response.getOutputStream());
	document.open();
	document.add(new Phrase("\n"));
	Font tableHeadFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);

	int status = turnier.getStatus();
	for (int i = 1; i <= status; i++) {
		List<Group> groups = turnier.getActiveGroups(i);
		for (Group g: groups) {
			Phrase phrase = new Phrase("Runde " + i + "\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, (float) 20, Font.BOLD,
					new BaseColor(0, 0, 0)));
			document.add(phrase);
			phrase = new Phrase(g.getName() +  "\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, (float) 20, Font.BOLD,
					new BaseColor(0, 0, 0)));
			document.add(phrase);
			
			// create table
			PdfPTable table = new PdfPTable(5);
			PdfPCell cell;
			cell = new PdfPCell(new Paragraph("Rang", tableHeadFont));
			table.addCell(cell);
			cell = new PdfPCell(new Paragraph("Team", tableHeadFont));
			table.addCell(cell);
			cell = new PdfPCell(new Paragraph("Punkte", tableHeadFont));
			cell.setHorizontalAlignment(1);
			table.addCell(cell);
			cell = new PdfPCell(new Paragraph("Verhältnis", tableHeadFont));
			cell.setHorizontalAlignment(1);
			table.addCell(cell);
			cell = new PdfPCell(new Paragraph("Erspieltes Geld", tableHeadFont));
			cell.setHorizontalAlignment(2);
			table.addCell(cell);
			List<Team> teams = g.getTable();
			int r = 1;
			for (Team t: teams) {
				table.addCell(r + ".");
				table.addCell(t.getName());
				cell = new PdfPCell(new Paragraph(t.getPunkte()+""));
				cell.setHorizontalAlignment(1);
				table.addCell(cell);
				cell = new PdfPCell(new Paragraph(t.getTore() + " : " + t.getKassierteTore()));
				cell.setHorizontalAlignment(1);
				table.addCell(cell);
				cell = new PdfPCell(new Paragraph(t.getBetrag()+""));
				cell.setHorizontalAlignment(2);
				table.addCell(cell);
				r++;
			}
			document.add(table);
			document.add(new Phrase("\n"));
			
			// create matches
			table = new PdfPTable(3);
			cell = new PdfPCell(new Paragraph("Team 1", tableHeadFont));
			table.addCell(cell);
			cell = new PdfPCell(new Paragraph("Resultat", tableHeadFont));
			cell.setHorizontalAlignment(1);
			table.addCell(cell);
			cell = new PdfPCell(new Paragraph("Team 2", tableHeadFont));
			cell.setHorizontalAlignment(2);
			table.addCell(cell);
			
			for (Match match : g.getMatches()) {
	 			if (match != null) {
	 				table.addCell(match.getTeam1().getName());
	 				cell = new PdfPCell(new Phrase(match.getGoals1() + " : " + match.getGoals2()));
	 				cell.setHorizontalAlignment(1);
	 				table.addCell(cell);
	 				cell = new PdfPCell(new Phrase(match.getTeam2().getName()));
	 				cell.setHorizontalAlignment(2);
	 				table.addCell(cell);
				}
			}
			document.add(table);
			document.newPage();
		}
	}
} catch (DocumentException de) {
	System.err.println(de.getMessage());
}
document.close();
%>