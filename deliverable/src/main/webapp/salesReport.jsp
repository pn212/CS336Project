<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Auction Site | Sales Report</title>
</head>
<body>
	<%
		try {
			// if user is not an authorized admin, show 404 error
			if (session.getAttribute("userId") == null || session.getAttribute("userTable") == null) {
				response.sendError(404, request.getRequestURI());
			}
			else {
				String userTable = (String) session.getAttribute("userTable");
				
				if (!userTable.equals("administrator")) {
					response.sendError(404, request.getRequestURI());
				}
			}
		}
		catch(Exception e){
			out.print(e);
		}
	%>
	
	<%
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
	
		if (con != null) {
			try {
				ArrayList<String> itemTypes = SalesReport.getItemTypes(con);
				ArrayList<SoldItem> items = SalesReport.getSoldItems(con);
				out.print(items.size());
			} catch (SQLException e) {
				db.closeConnection(con);
				e.printStackTrace();
			}
		}
	%>
</body>
</html>