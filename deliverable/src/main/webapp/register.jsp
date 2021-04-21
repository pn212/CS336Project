<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Auction Site | Register</title>
	</head>
	
	<body>
		<%!
			public boolean tableHasEmail(Connection con, String userTable, String email) throws SQLException {
				String userCheck = "SELECT userId FROM "+userTable+" WHERE email=?";
				PreparedStatement stmt = con.prepareStatement(userCheck);
				stmt.setString(1, email);
				ResultSet result = stmt.executeQuery();
				return result.next();
			}

			final int MAX_NAME_LEN = 50;
		
			public boolean isValidName(String name) {
				if (!name.equals(name.trim())) return false;
				if (name.isEmpty()) return false;
				if (name.length() > MAX_NAME_LEN) return false;
				return true;
			}
		%>

		<%
			final int MIN_PASS_LEN = 8;
			final int MAX_PASS_LEN = 100;
			final int MAX_EMAIL_LEN = 100;
		
			try {
				String email = request.getParameter("email");
				String password = request.getParameter("password");
				String firstName = request.getParameter("firstName");
				String lastName = request.getParameter("lastName");
				
				if (email != null && password != null && firstName != null && lastName != null) {
					email = email.trim();
					
					if (email.isEmpty()) {
						response.sendRedirect("register.jsp?error=invalid");
					}

					if (password.isEmpty()) {
						response.sendRedirect("register.jsp?error=invalid");
					}

					// validate password
					int passLen = password.length();
					if (passLen < MIN_PASS_LEN) {
						response.sendRedirect("register.jsp?error=passShort");
					}
		
					// TODO: validate email is actually an email

					// validate names
					if (!isValidName(firstName) || !isValidName(lastName)) {
						response.sendRedirect("register.jsp?error=name");
					}
					
					// Get the database connection
					ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();
		
					if (con == null) {
						System.out.println("Could not connect to database");
						out.print("Could not connect to database");
						response.sendRedirect("register.jsp?error=failed");
					}
					
					// check to make sure email is not taken
					String[] tables = new String[] { "endUser", "administrator", "customerSupport" };
					for (String table : tables) {
						if (tableHasEmail(con, table, email)) {
							db.closeConnection(con);
							response.sendRedirect("register.jsp?error=taken");
						}
					}

					// email is valid and not taken, so create account
					String str = "INSERT INTO endUser (fName, lName, email, pw) VALUES (?, ?, ?, ?)";
					PreparedStatement stmt = con.prepareStatement(str);
					stmt.setString(1, firstName);
					stmt.setString(2, lastName);
					stmt.setString(3, email);
					stmt.setString(4, password);
					
					int addUserResult = stmt.executeUpdate();
					
					db.closeConnection(con);
		%>
					<form id="loginForm" method="post" action="login.jsp">
					<input hidden id="email" type="email" name="email" value="<%=email%>"/>
					<input hidden id="password" type="password" name="password" value="<%=password%>"/>
					<input hidden type="radio" id="endUser" name="userType" value="endUser" checked>
					</form>
					<script>document.getElementById("loginForm").submit();</script>
		<% 
				}
			} catch (Exception e) {
				out.print(e);
			}
		%>

		<% 
			String error = request.getParameter("error");
			if (error != null) {
				if (error.equals("invalid"))
				{
					out.print("<span>Invalid parameters</span>");	
				}
				else if (error.equals("passShort"))
				{
					out.print("<span>Password must be at least "+MIN_PASS_LEN+" characters</span>");
				}
				else if (error.equals("taken"))
				{
					out.print("<span>Email is taken</span>");
				}
				else if (error.equals("name"))
				{
					out.print("<span>Invalid name</span>");
				}
				else if (error.equals("failed"))
				{
					out.print("<span>Registration failed</span>");	
				}
				out.print("<br>");
			}
		%>
	
		<form method="post" action="register.jsp">
			<label for="email">E-Mail</label>
			<input required id="email" type="email" name="email"/>
			<br>
			<label for="password">Password</label>
			<input required id="password" type="password" name="password"/>
			<br>
			<label for="firstName">First Name</label>
			<input required id="firstName" type="text" name="firstName"/>
			<br>
			<label for="lastName">Last Name</label>
			<input required id="lastName" type="text" name="lastName"/>
			<br>
			<input type="submit" value="Register" />
		</form>
		
		<br>
		<a href="index.jsp">Already have an account? Login here</a>
</body>
</html>