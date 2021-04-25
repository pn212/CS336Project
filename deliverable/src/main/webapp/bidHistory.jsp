<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset = ISO-8859-1">
		<title>Auction Site | Bid History</title>
	</head>
	
	<body>
		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			String entity = request.getParameter("auctionId");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "select b.amount, b.bidDateTime, e.fname, e.lname from bid b, enduser e where "
				+ "(auctionID = " + entity + " and b.userId = e.userId);";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
		
		<strong>Bid History for Auction <% out.println(entity); %>:</strong><br><br>
		
		<table border="1">
			<tr>
				<td></td>
				<td>
					<strong>User</strong>
				</td>
				<td>
					<strong>Bid Amount</strong>
				</td>
				<td>
					<strong>Bid Date and Time</strong>
				</td>
			</tr>
			<%	//parse out the results
				int count = 1;
				while (result.next()) {
			%>
			<tr>
				<td><% out.println(count); %></td>
				<td>
					<%=result.getString("fname") + " " + result.getString("lname")%>
				</td>
				<td>
					<%=result.getString("amount")%>
				</td>
				<td>
					<%=result.getString("bidDateTime")%>
				</td>
			</tr>
		
		<%			count++;
				}
			//close the connection.
			db.closeConnection(con);
		%>
		
		</table><br>
		
		<form method="post">
			<input type="submit" value="Back" formaction="fullAuctionListing.jsp">
			<input type="submit" value="Back Home" formaction="account.jsp">
		</form>
		
		<%	} catch (Exception e) {
				out.print(e);
			}
		%>
		
	</body>
</html>