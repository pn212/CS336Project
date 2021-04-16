<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Auction Site | Declare Auction Winner</title>
</head>
<body>
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
	
	// Get what page called auctionWinner
	String source = request.getParameter("source");
	if(source == null || source.trim().isEmpty()){
		response.sendRedirect("account.jsp");
	}
	//Get the database connection
	ApplicationDB db = new ApplicationDB();	
	Connection conn = db.getConnection();
	
	if (conn == null) {
		System.out.println("Could not connect to database");
		out.print("Could not connect to database");
		response.sendRedirect("index.jsp?error=failed");
	}
	
	// get auction info
	String auctionInfo = "SELECT auctionName, minPrice, itemId FROM Auction WHERE auctionId = ?";
	PreparedStatement auctionInfoStmt = conn.prepareStatement(auctionInfo);
	auctionInfoStmt.setInt(1, auctionId);
	ResultSet auctionInfoResult = auctionInfoStmt.executeQuery();
	// default value
	String auctionName = "";
	String minPrice = "";
	int itemId = 0; 
	while(auctionInfoResult.next()){
		auctionName = auctionInfoResult.getString("auctionName");
		minPrice = auctionInfoResult.getString("minPrice");
		itemId = auctionInfoResult.getInt("itemId");
	}
	
	// get item info
	String itemInfo = "SELECT name FROM item WHERE itemId = ?";
	PreparedStatement itemInfoStmt = conn.prepareStatement(itemInfo);
	itemInfoStmt.setInt(1, itemId);
	ResultSet itemInfoRS = itemInfoStmt.executeQuery();
	itemInfoRS.next();
	String itemName = itemInfoRS.getString("name");
	
	
	// once an auction is over the item can not be resold on the site even if there was no winner
	String isSoldCmd = "UPDATE Item SET itemStatus = ? WHERE itemId = ?";
	PreparedStatement isSoldStmt = conn.prepareStatement(isSoldCmd);
	isSoldStmt.setInt(2, itemId);
	
	double minReserve = Prices.getPrice(minPrice);
	// get highest bid amount from auction/bid tables
	// query to get highest auction bid (may change after insert)
	String getHighestBid = "SELECT amount, userId FROM Bid WHERE auctionId = ? AND amount IN (SELECT max(amount) FROM Bid WHERE auctionId = ? GROUP BY auctionId)";
	PreparedStatement auctionGHB = conn.prepareStatement(getHighestBid);
	auctionGHB.setInt(1, auctionId);
	auctionGHB.setInt(2, auctionId);
	ResultSet auctionRHB = auctionGHB.executeQuery();
	String highestBid = "";
	String alert = "";
	int winnerId = 0;
	double highestBidAmount = 0;
	if (!auctionRHB.next()){ // no bids were placed
		alert = "No users won the auction: " + auctionName + " for item: " + itemName;
		isSoldStmt.setInt(1, 2);
	}else{
		highestBid = auctionRHB.getString("amount");
		highestBidAmount = Prices.getPrice(highestBid);
		if (highestBidAmount < minReserve){ // no winners
			alert = "No users won the auction: " + auctionName + " for item: " + itemName;
			isSoldStmt.setInt(1,2);
		}
		else{
			winnerId = auctionRHB.getInt("userId");
			String getWinnerInfo = "SELECT fname, lname FROM endUser e WHERE userId = ?";
			PreparedStatement winnerStmt = conn.prepareStatement(getWinnerInfo);
			winnerStmt.setInt(1, winnerId);
			ResultSet winnerRS = winnerStmt.executeQuery();
			winnerRS.next();
			String fname = winnerRS.getString("fname");
			String lname = winnerRS.getString("lname");
			alert = fname + " " + lname + " won the auction: " + auctionName + " for item: " + itemName + " with a bid of: " + highestBidAmount;
			isSoldStmt.setInt(1,1);
		}
	}
	// depending on if there was a winner or not execute update
	int soldStatus = isSoldStmt.executeUpdate();
	
	// send alert about auction ending to all buyers
	// get all other buyers involved in auction
	String getBuyers = "SELECT distinct userId FROM Bid WHERE auctionId = ?";
	PreparedStatement auctionGB = conn.prepareStatement(getBuyers);
	auctionGB.setInt(1, auctionId);
	ResultSet auctionRB = auctionGB.executeQuery();
	ArrayList<String> buyerIds = new ArrayList<String>();
	while (auctionRB.next()){
		buyerIds.add(auctionRB.getString("userId"));
	}
	// find string for current datetime
	SimpleDateFormat format = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss");
	String currDateTime = format.format(new java.util.Date());
	for(int i = 0; i < buyerIds.size(); i++){
		String buyerID = buyerIds.get(i);
		Integer buyerId = Integer.parseInt(buyerID);
		String insertAlert = "INSERT into Alert (userId, alertMessage, alertDateTime) VALUES (?, ?, ?)";
		PreparedStatement auctionIA = conn.prepareStatement(insertAlert);
		auctionIA.setInt(1, buyerId);
		if(buyerId == winnerId){
			auctionIA.setString(2, "You won the auction: " + auctionName + " for item: " + itemName + " with a bid of: " + highestBidAmount);
		}
		else{
			auctionIA.setString(2, alert);
		}
		auctionIA.setString(3, currDateTime);
		int messageStatus = auctionIA.executeUpdate();
	}
	db.closeConnection(conn);
	
	// redirect back to page that called auctionWinner
	if (source.equals("placeBid")){
		%>
		<form id = redirectAuction method = "post" action = "fullAuctionListing.jsp">
			<input type = "hidden" id = "source" name = "source" value = "<%= source %>">
			<input type = "hidden" id = "expiredAuction" name = "expiredAuction" value = "<%= auctionName %>">
			<script>document.getElementById("redirectAuction").submit();</script>
		</form>
		<%
	}
	else if (source.equals("fullAuctionListing")){
		response.sendRedirect("fullAuctionListing.jsp");
	}
	else if(source.equals("userItems")){
		response.sendRedirect("userItems.jsp");
	}
	
} catch(Exception e){
	out.print(e);
}



%>
</body>
</html>