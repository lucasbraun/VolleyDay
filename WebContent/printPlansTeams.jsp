<%@ page language="java" contentType="application/pdf"
    pageEncoding="ISO-8859-1" import="volleyObjects.Tournament, volleyObjects.Group, volleyObjects.Team, volleyObjects.Match, java.io.OutputStream, java.util.Iterator,
    	com.itextpdf.text.Document, com.itextpdf.text.DocumentException, com.itextpdf.text.Paragraph,
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
	Font tableHeadFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
	Font boldFont = new Font(Font.FontFamily.HELVETICA, Font.DEFAULTSIZE, Font.BOLD);
	
	int status = turnier.getStatus();
	
	for (Group g: turnier.getActiveGroups(status)) {
		for (Team t: g.members) {
			Phrase phrase = new Phrase(g.getName() + "\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, (float) 20, Font.BOLD,
					new BaseColor(0, 0, 0)));
			document.add(phrase);
			phrase = new Phrase(t.getName() + "\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, (float) 20, Font.BOLD,
					new BaseColor(0, 0, 0)));
			document.add(phrase);
			PdfPCell cell;
			PdfPTable table = new PdfPTable(4);
			
			cell = new PdfPCell(new Paragraph("Zeit", tableHeadFont));
			table.addCell(cell);
			cell = new PdfPCell(new Paragraph("Ort", tableHeadFont));
			table.addCell(cell);
			cell = new PdfPCell(new Paragraph("Spiel", tableHeadFont));
			cell.setColspan(2);
			table.addCell(cell);

			cell = new PdfPCell(new Paragraph(t.getName(), boldFont));
			for (Match m: t.getActiveMatches(status)) {
				if (m.getTeam1() == t || m.getTeam2() == t) {
					table.addCell(m.getTime().out());
					table.addCell(m.getField().getName());
					if (m.getTeam1() == t) {
						table.addCell(cell);
						table.addCell(m.getTeam2().getName());
					} else {
						table.addCell(m.getTeam1().getName());
						table.addCell(cell);
					}			
				}
			}
			
			document.add(table);
			document.add(new Phrase("Alle Spiele dauern " + String.valueOf(turnier.getGameTime()) + " Minuten."));
			document.newPage();
		}
	}
} catch (DocumentException de) {
	System.err.println(de.getMessage());
}
document.close();
%>		