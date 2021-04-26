<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset = ISO-8859-1">
		<title>Auction Site | Alert Set Message</title>
	</head>
	
	<body>
		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			String entity = request.getParameter("command");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "select i.itemId as itemID, i.name as itemName, i.itemStatus, i.userId as " 
				+ "userID, j.catName, j.name as attributeName, j.attributeValue, e.fname, e.lname, "
				+ "e.email from item i, itemattribute j, enduser e where (i.itemID = " + entity
				+ " and j.itemID = " + entity + " and e.userId = i.userId);";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
			result.next();
			
			SimpleDateFormat format = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss");
			String currDateTime = format.format(new java.util.Date());
			String sql = "insert into alert (userId, alertMessage, alertDateTime) values(?, ?, ?)";
			PreparedStatement newAlert = con.prepareStatement(sql);
			newAlert.setInt(1, Integer.parseInt(result.getString("userID")));
			newAlert.setString(2, "Alert for item " + result.getString("itemID") + ": " + result.getString("itemName") + "has been set");
			newAlert.setString(3, currDateTime);
			int messageStatus = newAlert.executeUpdate();
		%>
		
		Alert for item <% out.print(result.getString("itemId") + ": " + result.getString("itemName")); %> 
		has been successfully created. <br><br>
		
		<% //close the connection.
			db.closeConnection(con);
		%>
		
		<form method="post">
			<input type="submit" value="Back" formaction="browseItems.jsp">
			<input type="submit" value="Back Home" formaction="account.jsp">
		</form>
		
		<%	} catch (Exception e) {
				out.print(e);
			}
		%>
		
	</body>
</html>