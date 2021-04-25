<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
	<meta http-equiv="Content-Type" content="text/html; charset = ISO-8859-1">
		<title>Auction Site | User's Auction History</title>
	</head>
	
	<body>
		The following are auctions that the selected user either participated in or hosted: <br><br>
		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			String entity = request.getParameter("command");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "select distinct a.auctionName, b.auctionId, b.userId from bid b, auction a "
				+ "where (a.auctionId = b.auctionId and userId = " + entity + ") union select a.auctionName, "
				+ "a.auctionId, e.userId from auction a, item i, enduser e where (a.itemId = i.itemId "
				+ "and i.userId = e.userId and e.userId = " + entity + ");";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
		
		<form method="post">
		<table border="1">
			<tr>
				<th>Auction ID</th>
				<th>Auction Name</th>
			</tr>
			<%
				//parse out the results
				while (result.next()) { 
			%>
					<tr>
						<td> <%= result.getString("auctionId") %> </td>
						<td> <%= result.getString("auctionName") %> </td>
					</tr>	
		<%		} 
				
				//close the connection.
				db.closeConnection(con);
		%>

		</table> <br>
		
			<input type="submit" value="Back" formaction="enduserList.jsp">
			<input type="submit" value="Back Home" formaction="account.jsp">
		</form>
		
		<%	} catch (Exception e) {
				out.print(e);
			}
		%>
		
	</body>
</html>