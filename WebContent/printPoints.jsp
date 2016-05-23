<%@ page language="java" contentType="application/pdf"
    pageEncoding="ISO-8859-1" import="volleyObjects.Tournament, volleyObjects.Team, java.io.OutputStream,
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
	Font tableHeadFont = new Font(Font.FontFamily.HELVETICA, Font.DEFAULTSIZE, Font.BOLD);

	Phrase phrase = new Phrase("Mannschaften mit erspielten Punkten\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, (float) 20, Font.BOLD,
					new BaseColor(0, 0, 0)));
	document.add(phrase);
	tableHeadFont.setColor(new BaseColor(255, 0, 0));
	tableHeadFont.setSize(14);
	phrase = new Phrase("Total: CHF " + String.valueOf(turnier.getBetrag()), tableHeadFont);
	document.add(phrase);
	tableHeadFont.setColor(new BaseColor(0, 0, 0));
	tableHeadFont.setSize(Font.DEFAULTSIZE);
	PdfPCell cell;
	PdfPTable table = new PdfPTable(3);
	cell = new PdfPCell(new Paragraph("Name", tableHeadFont));
	table.addCell(cell);
	cell = new PdfPCell(new Paragraph("Punkte", tableHeadFont));
	cell.setHorizontalAlignment(1);
	table.addCell(cell);
	cell = new PdfPCell(new Paragraph("Erspieltes Geld", tableHeadFont));
	cell.setHorizontalAlignment(2);
	table.addCell(cell);
	turnier.updateAllScores(1);
	String suffix;
	for (Team t: turnier.getTeams()) {
		suffix = t.getActiveMatches(turnier.getStatus()).size()>0?"*":"";
		table.addCell(t.getName() + suffix);
		cell = new PdfPCell(new Paragraph(String.valueOf(t.getTotalTore())));
		cell.setHorizontalAlignment(1);
		table.addCell(cell);
		cell = new PdfPCell(new Paragraph("CHF " + t.getBetrag()));
		cell.setHorizontalAlignment(2);
		table.addCell(cell);
	}
	cell = new PdfPCell (new Paragraph("Achtung!! Diese Teams sind noch am Spielen."));
	cell.setColspan(3);
	document.add(table);
	phrase = new Phrase("* Diese Mannschaften sind noch am Spielen.");
	document.add(phrase);
} catch (DocumentException de) {
	System.err.println(de.getMessage());
}
document.close();
%>