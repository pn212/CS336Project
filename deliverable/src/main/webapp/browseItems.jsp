<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset = ISO-8859-1">
		<title>Auction Site | Browse Items</title>
	</head>
	
	<body>
		A status of 0 represents that the item has not been sold yet. <br>
		A status of 1 represents that the item has been sold. <br>
		A status of 2 represents that the item had been on auction previously, but there was no winner. <br> <br> 
		You can select an Item ID and click the "View Additional Info" button to view additional information 
		about the selected item. <br>
		<!-- You can also select an Item ID and click the "Set Alert" button to set an alert for that item to notify
		you when it becomes available. --> <br>
		Here is a current list of all items: <br> <br>
		
		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			//String entity = request.getParameter("command");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "select distinct e.fname, e.lname, i.itemID, i.name, j.catName, i.itemStatus "
				+ "from item i, auction a, enduser e, itemattribute j where (j.itemId = i.itemId and "
				+ "e.userId = i.userId) order by i.itemID;";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
		
		<form method="post">
		<table border='1'>
			<tr>
				<th> Item ID </th>
				<th> Item Seller </th>
				<th> Item Name </th>
				<th> Item Subcategory </th>
				<th> Item Status </th>
			</tr>
			
			<%
				//parse out the results
				int count = 1;
				while (result.next()) { 
			%>
					<tr>
						<td>
							<input type="radio" id="<%=result.getString("itemID")%>" name="command" 
								value="<%=result.getString("itemID")%>" <% if (count == 1) out.print("checked"); %>>
							<label for="<%=result.getString("itemID")%>"><%=result.getString("itemID")%> </label>
						</td>
						<td> <%= result.getString("fname") + " " + result.getString("lname") %> </td>
						<td> <%= result.getString("name") %> </td>
						<td> <%= result.getString("catName") %> </td>
						<td> <%= result.getString("itemStatus") %> </td>
					</tr>
					
		<%			count++;
				} 
				
				//close the connection.
				db.closeConnection(con);
		%>
		
		</table>
		<br><br> Here is a list of all items currently on auction and the highest bid on those items: <br><br>

		<%	} catch (Exception e) {
				out.print(e);
			}
		
		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			//String entity = request.getParameter("command");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "select a.itemId, a.auctionId, max(b.amount) as bid from item i, auction a, "
				+ "bid b where (a.auctionId = b.auctionId and a.itemId = i.itemId and i.itemStatus = 0) "
				+ "group by itemId;";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
		
		<table border="1">
			<tr>
				<th> Item ID </th>
				<th> Current Highest Bid </th>
			</tr>
			
			<%
				//parse out the results
				int count = 1;
				while (result.next()) { 
			%>
			
				<tr>
					<td><%=result.getString("itemId") %></td>
					<td> <%=result.getString("bid")%></td>
				</tr>
					
			<%		count++;
				} 
				
				//close the connection.
				db.closeConnection(con);

			} catch (Exception e) {
				out.print(e);
			}
			%>
			
		</table>
		
			<br> <input type="submit" value="View Additional Info" formaction="itemInformation.jsp">
			<!-- <input type="submit" value="Set Alert" formaction="chooseAlerts.jsp"> -->
			<input type="submit" value="Back Home" formaction="account.jsp">
		</form>
	</body>
</html>