<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset = ISO-8859-1">
		<title>Auction Site | Item/Auction Information</title>
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
		%>
		
		<table>
			<tr>
				<td>
					<strong>Item ID Number: </strong>
				</td>
				<td>
					<%=result.getString("itemID")%><br>
				</td>
			</tr>
			<tr>
				<td>
					<strong>Item Name: </strong>
				</td>
				<td>
					<%=result.getString("itemName")%><br>
				</td>
			</tr>
			<tr>
				<td>
					<strong>Item Subcategory Type: </strong>
				</td>
				<td>
					<%=result.getString("catName")%><br>
				</td>
			</tr>
			<tr>
				<td>
					<strong>Item Status: </strong>
				</td>
				<td>
					<%=result.getString("itemStatus")%><br>
				</td>
			</tr>
			<tr>
				<td>
					<strong>Item Owner Name: </strong>
				</td>
				<td>
					<%=result.getString("fname") + " " + result.getString("lname")%><br>
				</td>
			</tr>
			<tr>
				<td>
					<strong>Item Owner Email Address: </strong>
				</td>
				<td>
					<%=result.getString("email")%><br>
				</td>
			</tr>
		</table> <br>
		
		<strong>Item Attributes: </strong>
		<blockquote><table>
			<tr>
				<td>
					<strong><%=result.getString("attributeName") + ": "%></strong>
				</td>
				<td>
					<%=result.getString("attributeValue")%>
				</td>
			</tr>
			<% 	//parse out the results
				while (result.next()) { 
			%>
			<tr>
				<td>
					<strong><%=result.getString("attributeName") + ": "%></strong>
				</td>
				<td>
					<%=result.getString("attributeValue")%>
				</td>
			</tr>
		
		<%		}
			//close the connection.
			db.closeConnection(con);
		%>
		
		</table></blockquote>
		
		A status of 0 represents that the item has not been sold yet. <br>
		A status of 1 represents that the item has been sold. <br>
		A status of 2 represents that the item had been on auction previously, but there was no winner. <br> <br>
		
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