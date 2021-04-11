<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
try{
	// should not happen
	if(session == null){
		response.sendRedirect("index.jsp");
	}
	if(session.getAttribute("userId") == null){
		response.sendRedirect("index.jsp");
	}
		
	Integer userId = (Integer)session.getAttribute("userId");
	
	//Get the database connection
	ApplicationDB db = new ApplicationDB();	
	Connection conn = db.getConnection();
				
	if (conn == null) {
		System.out.println("Could not connect to database");
		out.print("Could not connect to database");
		response.sendRedirect("index.jsp?error=failed");
	}
	
	String stmt = "SELECT a.itemId itemId, a.name itemName, b.catName catName,"
			+ "b.attributeValue attributeValue from Item a, ItemAttribute b where "
			+ "a.itemId = b.itemId and a.userId = ?";
	PreparedStatement ps = conn.prepareStatement(stmt);
	ps.setInt(1, userId);
	ResultSet rs = ps.executeQuery();
	
	%>
	Items Owned by User:
	<br>
	<pre> ItemID	Name </pre>
	<br>
	<%
	while(rs.next()){
		out.print("<pre>");
		out.print(rs.getInt("itemId") + "&#9" + rs.getString("itemName"));
		out.print("</pre>");
		out.print("<br>");
	}
	
	
	%>

	
	<form method = "post" action = "account.jsp">
		<input type = "submit" value = "Back">
	</form>
	<a href = "itemSubCat.jsp">Create an Item</a>
	
	
	
<%	
}catch(Exception e){
	out.print(e);
}

%>
</body>
</html>