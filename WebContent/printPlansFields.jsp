<%@ page language="java" contentType="application/pdf"
    pageEncoding="ISO-8859-1" import="volleyObjects.Tournament, volleyObjects.Field, volleyObjects.Match, java.io.OutputStream, java.util.Iterator,
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
	for (Field f: turnier.getFields()) {
		Phrase phrase = new Phrase(f.getName(), FontFactory.getFont(FontFactory.HELVETICA_BOLD, (float) 20, Font.BOLD,
				new BaseColor(0, 0, 0)));
		document.add(phrase);
		PdfPCell cell;
		PdfPTable table = new PdfPTable(5);
		
		cell = new PdfPCell(new Paragraph("Zeit", tableHeadFont));
		table.addCell(cell);
		cell = new PdfPCell(new Paragraph("Team 1", tableHeadFont));
		table.addCell(cell);
		cell = new PdfPCell(new Paragraph("Punkte 1", tableHeadFont));
		table.addCell(cell);
		cell = new PdfPCell(new Paragraph("Punkte 2", tableHeadFont));
		table.addCell(cell);
		cell = new PdfPCell(new Paragraph("Team 2", tableHeadFont));
		table.addCell(cell);
		
		for (Match m: f.getActiveMatches(status)) {
			cell = new PdfPCell(new Paragraph(m.getTime().out(), boldFont));
			table.addCell(cell);
			table.addCell(m.getTeam1().getName());
			table.addCell(" ");
			table.addCell(" ");
			table.addCell(m.getTeam2().getName());			
		}
		document.add(table);
		document.add(new Phrase("Alle Spiele dauern " + String.valueOf(turnier.getGameTime()) + " Minuten."));
		document.newPage();
	}
} catch (DocumentException de) {
	System.err.println(de.getMessage());
}
document.close();
%>