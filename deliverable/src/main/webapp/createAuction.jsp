<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Auction Site | Create Auction</title>
</head>
<body>
Enter Auction Information:

<%
try{
	// should not happen
	if(session == null){
		response.sendRedirect("index.jsp");
	}
	if(session.getAttribute("userId") == null){
		response.sendRedirect("index.jsp");
	}
	
	String itemid = request.getParameter("items");
	if (itemid == null || itemid.isEmpty()){
		response.sendRedirect("userItems.jsp");
	}
	else{
		Integer itemId = Integer.valueOf(itemid);
		// create auction for item
		
		// ask user to fill out auction information
		
	   %>
	   <input type ="number" min = "0.00" step = "0.01">
	   <input type = "datetime-local" >
	   <%
	}
	
} catch(Exception e){
	out.print(e);
}



%>


</body>
</html>