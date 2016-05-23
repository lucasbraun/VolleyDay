<%@ page language="java" contentType="application/pdf"
    pageEncoding="ISO-8859-1" import="volleyObjects.Tournament, volleyObjects.Group, volleyObjects.Team, volleyObjects.Match, java.io.OutputStream, java.util.List, java.util.Iterator,
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

Document document = new Document(PageSize.A5.rotate());

try {
	PdfWriter.getInstance(document, response.getOutputStream());
	document.open();

	Phrase phrase = new Phrase("Tipp-Spiel\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, (float) 20, Font.BOLD,
			new BaseColor(0, 0, 0)));
	document.add(phrase);
	document.add(new Phrase("Name: ______________________________\n\n"));
	document.add(new Phrase("Wer wird Sieger der Liga A werden?\n"));
	int counter=0;
	PdfPTable table = new PdfPTable(6);
	List<Group> temp = turnier.getActiveGroups(2);
	for (int i = 0; i < (temp.size()+1)/2; i++) {
		for (Team t: temp.get(i).members) {
			table.addCell(t.getName());
			table.addCell("");
			counter += 2;
		}
	}
	for (int i = 0; i < ((6 - counter % 6) % 6); i++) {
		table.addCell("");
	}
	document.add(table);
	
	document.add(new Phrase("Wer wird Sieger der Liga B werden?\n"));
	counter = 0;
	table = new PdfPTable(6);
	for (int i = (temp.size()+1)/2; i < temp.size(); i++) {
		for (Team t: temp.get(i).members) {
			table.addCell(t.getName());
			table.addCell("");
			counter += 2;
		}
	}
	for (int i = 0; i < ((6 - counter % 6) % 6); i++) {
		table.addCell("");
	}
	document.add(table);
	document.add(new Phrase("Bitte jeweils ein Team ankreuzen!"));

} catch (DocumentException de) {
	System.err.println(de.getMessage());
}
document.close();
%>		