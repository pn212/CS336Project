<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Auction Site | Add Auction</title>
</head>
<body>

<%!
/*
public boolean validPrice (String price){
	if(price == null || price.isEmpty()){
		return false;
	}
	int decimalCount = 0;
	int i = 0;
	while (i < price.length()){
		if(!Character.isDigit(price.charAt(i))){
			if(price.charAt(i) == '.'){
				decimalCount++;
				break;
			}
			return false;
		}
		i++;
	}
	if (decimalCount != 1){
		return false;
	}
	
	i++;
	int centCount = 0;
	while(i < price.length()){
		if(!Character.isDigit(price.charAt(i))){
			return false;
		}
		i++;
		centCount++;
	}
	
	if (centCount != 2){
		return false;
	}
	
	return true;
}
*/
%>
<%
try{
	// should not happen
	if(session == null){
		response.sendRedirect("index.jsp");
	}
	if(session.getAttribute("userId") == null){
		response.sendRedirect("index.jsp");
	}
	
	// only endUsers can make auctions to be added to the Auction table
	String userTable = (String) session.getAttribute("userTable");
	if (userTable == null || !userTable.equals("endUser")){
		response.sendRedirect("account.jsp");
	}
	
	// should not be null
	String itemId = request.getParameter("itemId");
	if(itemId == null || itemId.isEmpty()){
		response.sendRedirect("userItems.jsp");
	}
	
	// error check for empty auction name
	String auctionName = request.getParameter("auctionName");
	if(auctionName == null || auctionName.isEmpty()){
		%>
		<form id = "noName"method = "post" action = "createAuction.jsp?error=noName">
			<input type = "hidden" name = "items" value = "<%=itemId %>">
			<script>document.getElementById("noName").submit();</script>
		</form>
		<%
	}
	// description is optional
	String description = request.getParameter("description");
	if(description == null){
		description = "";
	}
	
	// check if prices are valid
	String minPrice = request.getParameter("minPrice");
	String startPrice = request.getParameter("startPrice");
	String incPrice = request.getParameter("incPrice");
	String endTime = request.getParameter("endTime");
	
	// use information provided to add to the auction table
	
	
	
	
	
} catch(Exception e){
	out.print(e);
}

%>
</body>
</html>