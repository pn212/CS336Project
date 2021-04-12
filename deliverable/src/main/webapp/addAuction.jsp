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
	
	double amount = Double.parseDouble(price);
	if(amount < 0){
		return false;
	}
	return true;
}

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
	String itemID = request.getParameter("itemId");
	if(itemID == null || itemID.isEmpty()){
		response.sendRedirect("userItems.jsp");
	}
	Integer itemId = Integer.parseInt(itemID);
	
	// error check for empty auction name
	String auctionName = request.getParameter("auctionName");
	if(auctionName == null || auctionName.isEmpty()){
		%>
		<form id = "noName" method = "post" action = "createAuction.jsp?error=noName">
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
	String minPrice = request.getParameter("minReserve");
	String startPrice = request.getParameter("startPrice");
	String incPrice = request.getParameter("incPrice");
	String endTime = request.getParameter("endTime");
	
	if(!validPrice(minPrice) || !validPrice(startPrice) || !validPrice(incPrice) ){
		%>
		<form id = "invalidPrice" method = "post" action = "createAuction.jsp?error=invalidPrice">
			<input type = "hidden" name = "items" value = "<%=itemId %>">
 			<script>document.getElementById("invalidPrice").submit();</script>
		</form>
		<%
	}
	
	if(endTime == null){
		%>
		<form id = "invalidDate" method = "post" action = "createAuction.jsp?error=invalidDate">
			<input type = "hidden" name = "items" value = "<%=itemId %>">
			<script>document.getElementById("invalidDate").submit();</script>
		</form>
		<%
	}
	
	// make information provided compatible data types with SQL insert
	
	double minimumPrice = Double.parseDouble(minPrice);
	double startingPrice = Double.parseDouble(startPrice);
	double incrementPrice = Double.parseDouble(incPrice);
	
	String endingDate = endTime.replace('T', ' ');
	endingDate += ":00"; 
	
	//Get the database connection
	ApplicationDB db = new ApplicationDB();	
	Connection conn = db.getConnection();
		
	if (conn == null) {
		System.out.println("Could not connect to database");
		out.print("Could not connect to database");
		response.sendRedirect("index.jsp?error=failed");
	}
	
	// find string for current datetime
	SimpleDateFormat format = new SimpleDateFormat("YYYY-MM-dd hh:mm:ss");
	String startingDate = format.format(new java.util.Date());
	
			
	// insert into auction table
	String stmt = "INSERT into Auction (auctionName, description, minPrice," + 
			"startPrice, incPrice, startingDateTime, endingDateTime, itemId) VALUES (?,?,?,?,?,?,?,?)";
	PreparedStatement ps = conn.prepareStatement(stmt);
	ps.setString(1, auctionName);
	ps.setString(2, description);
	ps.setDouble(3, minimumPrice);
	ps.setDouble(4, startingPrice);
	ps.setDouble(5, incrementPrice);
	ps.setString(6, startingDate);
	ps.setString(7, endingDate);
	ps.setInt(8, itemId);
	ps.executeUpdate();
	
	String stmt2 = "UPDATE Item SET onAuction = ? WHERE itemId = ?";
	PreparedStatement ps2 = conn.prepareStatement(stmt2);
	ps2.setInt(1, 1); // true
	ps2.setInt(2, itemId);
	ps2.executeUpdate();
	
	
	db.closeConnection(conn);
	response.sendRedirect("account.jsp");
	
	
} catch(Exception e){
	out.print(e);
}

%>
</body>
</html>