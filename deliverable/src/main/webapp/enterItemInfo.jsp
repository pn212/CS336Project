<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Auction Site | Enter Item Information</title>
</head>
<body>

<% 
try{
	
	//Get the database connection
	ApplicationDB db = new ApplicationDB();	
	Connection conn = db.getConnection();
		
	if (conn == null) {
		System.out.println("Could not connect to database");
		out.print("Could not connect to database");
		response.sendRedirect("index.jsp?error=failed");
	}
	
	String subCatType = request.getParameter("subcat"); 
	String str1 = "SELECT name from AttributeName where catname = ? ";
	PreparedStatement ps = conn.prepareStatement(str1);
	ps.setString(1, subCatType);
	
	
	ResultSet rs = ps.executeQuery();
	
	// move attribute names to arraylist
	
	ArrayList<String> attributes = new ArrayList<String>();
	while(rs.next()){
		attributes.add(rs.getString("name"));
	}
	db.closeConnection(conn);
	%>
	
	
	<form method= "post" action = "addItem.jsp" >
	<label for="itemName" >Item Name</label>
	<input type="text" id= "itemName" name= "itemName" >
	<br>
	<% 
	for(String attribute: attributes){ %>
		<label for= <%=attribute %> > <%=attribute %> </label>
		<input type= "text" id= <%=attribute%> name= <%=attribute%> > 
		<input type="hidden" id="subcat" name="subcat" value= <%=subCatType %>>
		<br>
		<%	
					
	}
	%>
	<input type="submit" value="Add Item">
	</form>	
	
	<% 
} catch(Exception e){
	out.print(e);
}
%>
</body>
</html>