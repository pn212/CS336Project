<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Auction Site | Place a Bid</title>
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
public boolean validBid(double bidAmount, double startPrice, double highestBidAmount, double incPrice){
	// no bids placed yet
	if(highestBidAmount == 0.00 ){
		if(bidAmount < startPrice){
			return false;
		}
	}
	else{
		// need to increase by at least incPrice
		if(bidAmount < highestBidAmount + incPrice){
			return false;
		}
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
	Integer userId = (Integer)session.getAttribute("userId");
	// user selected an auction from the previous page
	String auctionID = request.getParameter("auctionId");
	if(auctionID == null || auctionID.isEmpty() ){
		response.sendRedirect("account.jsp");
	}
	Integer auctionId = Integer.parseInt(auctionID);
	
	//Get the database connection
	ApplicationDB db = new ApplicationDB();	
	Connection conn = db.getConnection();
	
	// query to get highest auction bid (may change after insert)
	String getCurrentMax = "SELECT amount FROM Bid WHERE auctionId = ? AND amount IN (SELECT max(amount) FROM Bid WHERE auctionId = ? GROUP BY auctionId)";
	PreparedStatement auctionGCM = conn.prepareStatement(getCurrentMax);
	auctionGCM.setInt(1, auctionId);
	auctionGCM.setInt(2, auctionId);
	ResultSet auctionRCM = auctionGCM.executeQuery();
	String highestBid = "";
	
	if (!auctionRCM.next()){ // no bids placed yet
		highestBid = "0.00";
	}
	else{
		highestBid = auctionRCM.getString("amount");
	}
	// query to get startPrice and incPrice
	
	String getRequired = "SELECT startPrice, incPrice from Auction where auctionid = ?";
	PreparedStatement auctionGR = conn.prepareStatement(getRequired);
	auctionGR.setInt(1, auctionId);
	ResultSet auctionRR = auctionGR.executeQuery();
	auctionRR.next();
	double startPrice = Double.parseDouble(auctionRR.getString("startPrice"));
	double incPrice = Double.parseDouble(auctionRR.getString("incPrice"));
	
	// check if bid is valid
	
	double highestBidAmount = Double.parseDouble(highestBid);
	String bid = request.getParameter("bidAmount");
	if(bid != null && !bid.isEmpty()){
		double bidAmount = Double.parseDouble(bid);
		
		if (validPrice(bid) && validBid(bidAmount, startPrice, highestBidAmount, incPrice)){
			// find string for current datetime
			SimpleDateFormat format = new SimpleDateFormat("YYYY-MM-dd hh:mm:ss");
			String bidDateTime = format.format(new java.util.Date());
			
			// query to insert into bids table
			String stmt = "INSERT into Bid(amount, bidDateTime, auctionId, userId) VALUES(?,?,?,?)";
			PreparedStatement ps = conn.prepareStatement(stmt);
			ps.setDouble(1, bidAmount);
			ps.setString(2, bidDateTime);
			ps.setInt(3, auctionId);
			ps.setInt(4, userId);
			int status = ps.executeUpdate();
		}
		else{
			out.print("<span>Please Enter a Valid Bid</span>");
			out.print("<br>");
		}
	}
	
	// query to get auction name
	String getName = "SELECT auctionName FROM Auction WHERE auctionId = ? ";
	PreparedStatement auctionGN = conn.prepareStatement(getName);
	auctionGN.setInt(1, auctionId);
	ResultSet auctionRN = auctionGN.executeQuery();
	auctionRN.next();
	String auctionName = auctionRN.getString("auctionName");
	out.print("Place A Bid for Auction: " + auctionName );
	out.print("<br>");
	
	// query to get highest auction bid (may change after insert)
	String getMax = "SELECT amount FROM Bid WHERE auctionId = ? AND amount IN (SELECT max(amount) FROM Bid WHERE auctionId = ? GROUP BY auctionId)";
	PreparedStatement auctionGM = conn.prepareStatement(getMax);
	auctionGM.setInt(1, auctionId);
	auctionGM.setInt(2, auctionId);
	ResultSet auctionRM = auctionGM.executeQuery();

	
	// no bids yet
	if(!auctionRM.next()){
		out.print("The Current Auction Has No Bids Placed, The Starting Price is: " + startPrice);
		out.print("<br>");
	}
	// current highest bid
	else{
		highestBid = auctionRM.getString("amount");
		//highestBid = Double.parseDouble(auctionMax);
		out.print("The Current Highest Bid is: " + highestBid);
		out.print("<br>");
	}
	
	
	%>
	<form method = "post" action = "placeBid.jsp">
		<input type = "hidden" name = "auctionId" value = "<%= auctionId %>">
		<br>
		<label for= "bidAmount">Bid Amount</label>
		<input type = "number" id = "bidAmount" name = "bidAmount" step = "0.01">
		<br>
		<input type = "submit" value = "Place Bid">
	</form>
	<br><br>
	<form method = "post" action = "account.jsp">
		<input type = "submit" value = "Back">
	</form>
	
	<%
	
} catch (Exception e){
	out.print(e);
}


%>
</body>
</html>