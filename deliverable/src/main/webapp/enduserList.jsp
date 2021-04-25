<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
	<meta http-equiv="Content-Type" content="text/html; charset = ISO-8859-1">
		<title>Auction Site | List of Users</title>
	</head>
	
	<body>
		You can select a User ID and click the "View User's Auction History" button to view the list
			of auctions they participated in (including ones that they hosted themselves). <br><br>
		Here is a list of all users on this website and their corresponding information: <br><br>
		
		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			//String entity = request.getParameter("command");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "select userId, fName, lName, email from enduser;";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
		
		<form method="post">
		<table border='1'>
			<tr>
				<th> User ID </th>
				<th> User First Name </th>
				<th> User Last Name </th>
				<th> User E-mail Address </th>
			</tr>
			
			<%
				//parse out the results
				int count = 1;
				while (result.next()) { 
			%>
					<tr>
						<td>
							<input type="radio" id="<%=result.getString("userId")%>" name="command" 
								value="<%=result.getString("userId")%>" <% if (count == 1) out.print("checked"); %>>
							<label for="<%=result.getString("userId")%>"><%=result.getString("userId")%> </label>
						</td>
						<td> <%= result.getString("fName")%> </td>
						<td> <%= result.getString("lName")%> </td>
						<td> <%= result.getString("email") %> </td>
					</tr>
					
		<%			count++;
				} 
				
				//close the connection.
				db.closeConnection(con);
									
			} catch (Exception e) {
				out.print(e);
			}
		%>
		
		</table>
		
		<br> <input type="submit" value="View User's Auction History" formaction="userAuctionHistory.jsp">
			<!-- <input type="submit" value="Set Alert" formaction="chooseAlerts.jsp"> -->
			<input type="submit" value="Back Home" formaction="account.jsp">
		</form>
		
	</body>
</html>