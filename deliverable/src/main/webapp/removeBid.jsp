<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.math.BigDecimal"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Auction Site | Remove Bids</title>
</head>
<body>
	<%
	try {
		// if user is not an authorized admin, show 404 error
		if (session.getAttribute("userId") == null || session.getAttribute("userTable") == null) {
			response.sendError(404, request.getRequestURI());
			return;
		}
		else {
			String userTable = (String) session.getAttribute("userTable");
			
			if (userTable.equals("administrator")) {
				out.print("<span>This service is for customer support</span>");
				return;
			}
			else if (userTable.equals("endUser")) {
				response.sendError(404, request.getRequestURI());
				return;
			}
		}
	}
	catch(Exception e){
		out.print(e);
		return;
	}
	
	ArrayList<Auction> auctions = Auction.getAuctions();
	
	if (auctions == null) {
		out.print("An error occurred. Please try again");
	}
	else {
		if (request.getParameter("auctionId") == null) {
			response.sendRedirect("removeAuction.jsp");
			return;
		}
		int selectedId = Integer.parseInt(request.getParameter("auctionId"));

		Auction selectedAuction = null;
		for (Auction auction : auctions) {
			if (auction.getId() == selectedId) {
				selectedAuction = auction;
				break;
			}
		}

		if (selectedAuction == null) {
			response.sendRedirect("removeAuction.jsp");
			return;
		}
		
		// pull bids
		
		ArrayList<Bid> bids = Bid.getBids(selectedId);
		if (bids == null) {
			out.print("An error occurred. Try again");
			return;
		}
		
		if (request.getParameter("amount") != null) {
			String amountStr = request.getParameter("amount");
			BigDecimal amount = new BigDecimal(amountStr);
			boolean deleted = Bid.deleteBid(selectedId, amount);
			if (deleted) {
				out.print("Deleted bid");
				out.print("<br/>");
				for (int i = 0; i < bids.size(); i++) {
					if (bids.get(i).getAmount().equals(amount)) {
						bids.remove(i);
						break;
					}
				}
			}
			else {
				out.print("Could not delete bid");
				out.print("<br/>");
			}
		}
		
		out.print("<h3>Auction "+selectedId+"</h3> <br>");
		
		if (bids.size() == 0) {
			out.print("No bids exist for this auction");
		}
		else {
			for (Bid bid : bids) {
				%>
				<form method="post">
					<input name="auctionId" hidden value=<%=selectedId%> />
					<input name="amount" hidden value=<%=bid.getAmount().toString()%> />
					<p>User ID: <%=bid.getUserId()%></p>
					<p>Amount: <%=Prices.formatPrice(bid.getAmount().floatValue())%></p>
					<input type="submit" name="action" value="Delete" />
				</form>
				<%
			}
		}
	}
	%>
</body>
</html>