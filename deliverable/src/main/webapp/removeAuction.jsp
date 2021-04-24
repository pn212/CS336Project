<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Auction Site | Remove Auctions</title>
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
		if (request.getParameter("action") != null) {
			int selectedId = Integer.parseInt(request.getParameter("auctionId"));
			String action = request.getParameter("action");
			
			
			Auction selectedAuction = null;
			for (Auction auction : auctions) {
				if (auction.getId() == selectedId) {
					selectedAuction = auction;
					break;
				}
			}
			
			if (selectedAuction == null) {
				out.print("Auction "+selectedId+" not found");
				out.print("<br>");
			}
			else {
				if (action.equals("Delete")) {
					if (selectedAuction.delete()) {
						int index = auctions.indexOf(selectedAuction);
						auctions.remove(index);
						out.print("Deleted auction "+selectedId);
						out.print("<br>");
					}
					else {
						out.print("Could not delete auction "+selectedId);
						out.print("<br>");
					}
				}
				else if (action.equals("View Bids")) {
					%>
					<form id="redirect" method="post" action="removeBid.jsp">
						<input name="auctionId" hidden value=<%=selectedId%> />
					</form>
					<script>document.getElementById("redirect").submit();</script>
					<%
					return;
				}
			}
		}
		
		if (auctions.size() == 0) {
			out.print("No live auctions");
		}
		else {
			for (Auction auction : auctions) {
				%>
				<form method="post">
					<input name="auctionId" hidden value=<%=auction.getId()%> />
					<h3>Auction <%=auction.getId()%></h3>
					<p>Name: <%=auction.getName()%></p>
					<input type="submit" name="action" value="Delete" />
					<input type="submit" name="action" value="View Bids" />
				</form>
				<%
			}
		}
	}
	%>
</body>
</html>