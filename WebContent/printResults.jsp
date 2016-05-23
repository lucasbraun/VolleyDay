
<%@page import="com.itextpdf.text.Rectangle"%>
<%@page import="com.itextpdf.text.pdf.PdfDocument"%>
<%@page import="com.itextpdf.text.xml.xmp.PdfA1Schema"%><%@ page language="java" contentType="application/pdf"
    pageEncoding="ISO-8859-1" import="volleyObjects.Tournament, volleyObjects.Match, java.io.OutputStream, java.util.List,
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
document.setPageSize(PageSize.A4.rotate());

try {
	PdfWriter.getInstance(document, response.getOutputStream());
	document.open();
	Font tableHeadFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
	document.add(new Phrase("\n"));
	
	int status = turnier.getStatus();
	for (int i = 1; i <= status; i++) {
		
		Phrase phrase = new Phrase("Runde " + i + "\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, (float) 20, Font.BOLD,
				new BaseColor(0, 0, 0)));
		document.add(phrase);
		PdfPCell cell;
		PdfPTable table = new PdfPTable(4);
		
		// table heads
		cell = new PdfPCell(new Paragraph("Team 1", tableHeadFont));
		table.addCell(cell);
		cell = new PdfPCell(new Paragraph("Resultat", tableHeadFont));
		cell.setHorizontalAlignment(1);
		table.addCell(cell);
		cell = new PdfPCell(new Paragraph("Team 2", tableHeadFont));
		cell.setHorizontalAlignment(2);
		table.addCell(cell);
		cell = new PdfPCell(new Paragraph("Zeit & Ort", tableHeadFont));
		cell.setHorizontalAlignment(2);
		table.addCell(cell);

		String displayeResult;
		for (List<Match> row : turnier.getOverviewTable(i)) {
			for (Match match : row) {
	 			if (match != null) {
	 				table.addCell(match.getTeam1().getName());
	 				if (match.getGoals1() == 0 && match.getGoals2() == 0) {
	 					displayeResult = ":";
	 				} else {
	 					displayeResult = match.getGoals1() + " : " + match.getGoals2();
	 				}
	 				cell = new PdfPCell(new Phrase(displayeResult));
	 				cell.setHorizontalAlignment(1);
	 				table.addCell(cell);
	 				cell = new PdfPCell(new Phrase(match.getTeam2().getName()));
	 				cell.setHorizontalAlignment(2);
	 				table.addCell(cell);
	 				cell = new PdfPCell(new Phrase(match.getTime().out()+ ", " + match.getField().getName()));
	 				cell.setHorizontalAlignment(2);
	 				table.addCell(cell);
				}
			}
		}
		document.add(table);
		document.newPage();
	}
} catch (DocumentException de) {
	System.err.println(de.getMessage());
}
document.close();
%>