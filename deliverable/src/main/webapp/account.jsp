<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Auction Site | Account</title>
</head>
<body>
	<%!
		public int userid = 0;
		public String fname = "";
		public String lname= "";
	%>
	<%
	try {		
		if (session.getAttribute("userId") == null || session.getAttribute("userTable") == null) {
			response.sendRedirect("index.jsp");
		}
		else {
			Integer userId = (Integer)session.getAttribute("userId");
			String userTable = (String)session.getAttribute("userTable");
			
			// Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
	
			if (con == null) {
				System.out.println("Could not connect to database");
				out.print("Could not connect to database");
				response.sendRedirect("index.jsp?error=failed");
			}
			
			String str = "SELECT userId, fName, lName from " + userTable + " WHERE userId = ? ";
			
			PreparedStatement stmt = con.prepareStatement(str);
			stmt.setInt(1, userId);
			
			ResultSet result = stmt.executeQuery();
			
			// check if any tuples where returned from the table, this should not happen if the user
			// exists
			if (!result.next()) {
				db.closeConnection(con);
				response.sendRedirect("index.jsp?error=failed");
			}
			userid = result.getInt("userId");
			fname = result.getString("fName");
			lname = result.getString("lName");
			
			db.closeConnection(con);
		
			if (userTable.equals("endUser")){
				out.print("Welcome to the Auction Site User!");
			}
			else if (userTable.equals("customerSupport")){
				out.print("Welcome to the Auction Site Customer Representative!");
			}
			else if(userTable.equals("administrator")){
				out.print("Welcome to the Auction Site Administrator!");
			}
		}	
	}
	catch(Exception e){
		out.print(e);
	}
	%>
		
	<br>
	User Information
	<table>
		<tr>
			<td> User ID </td>
			<td> First Name </td>
			<td> Last Name </td>
		</tr>
		<tr>
			<td>	<%= userid %>	</td>
			<td>	<%=  fname %>	</td>
			<td>	<%= lname %>	</td>
		</tr>
	</table>


	<a href = "logout.jsp">Logout</a>
</body>
</html>