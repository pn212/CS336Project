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
	final int MAX_TITLE = 50;
	final int MAX_DESCRIPTION = 50;
	
	boolean isShort(String str) {
		return str.trim().isEmpty();
	}
	
	boolean parameterMatches(ServletRequest request, String paramName, String paramValue) {
		String param = request.getParameter(paramName);
		return param != null && param.equals(paramValue);
	}
	
	boolean createForumPost(int userId, String title, String description) {
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
	
			if (con == null) {
				return false;
			}
	
			String str = "INSERT INTO ForumPost (userId, title, description) VALUES (?, ?, ?)";
	
			PreparedStatement stmt = con.prepareStatement(str);
			stmt.setInt(1, userId);
			stmt.setString(2, title);
			stmt.setString(3, description);
			
			int addUserResult = stmt.executeUpdate();
			
			db.closeConnection(con);
			
			return true;
		} catch(Exception e) { return false; }
	}
	%>
	<%
	try {		
		if (session.getAttribute("userId") == null || session.getAttribute("userTable") == null) {
			response.sendRedirect("index.jsp");
			return;
		}

		String userTable = (String) session.getAttribute("userTable");
		if (!userTable.toLowerCase().equals("enduser")) {
			response.sendRedirect("createForumPost.jsp?error=access");
			return;
		}
		
		if (request.getParameter("title") != null && request.getParameter("description") != null) {
			// parse request
			String title = request.getParameter("title");
			String description = request.getParameter("description");
			
			if (title.length() > MAX_TITLE || description.length() > MAX_DESCRIPTION) {
				response.sendRedirect("createForumPost.jsp?error=toolong");
				return;
			}
			
			if (isShort(title) || isShort(description)) {
				response.sendRedirect("createForumPost.jsp?error=tooshort");
				return;
			}
			
			Integer userId = (Integer) session.getAttribute("userId");
			
			boolean success = createForumPost(userId, title, description);
			if (!success) {
				%><span>An unexpected error occurred</span><%
			}
			else {
				// TODO: redirect to post
			}
		}
	}
	catch(Exception e){
		out.print(e);
	}
	%>
		
	<h3>Create Forum Post</h3>

	<form action="createForumPost.jsp" method="post">
		<label for="title">Question</label>
		<input required maxlength=<%=MAX_TITLE%> id="title" name="title" type="text"/>
		<br>
		<label for="description">Description</label>
		<textarea required maxlength=<%=MAX_DESCRIPTION%> id="description" name="description"></textarea>
		<br>
		<input type="submit" value="Submit"/>
	</form>

	<%
		if (parameterMatches(request, "error", "toolong")) {
			%><span>Error: title or description too long</span><%
		}
		
		if (parameterMatches(request, "error", "tooshort")) {
			%><span>Error: title or description too short</span><%
		}

		if (parameterMatches(request, "error", "access")) {
			%><span>This resource is only available to EndUsers</span><%
		} 
	%>
</body>
</html>