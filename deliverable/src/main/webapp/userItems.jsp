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
<%!
public String createRow(Integer itemId, Connection conn) throws SQLException { 
	String result = "";
	// query Item to get the name of the item
	
	String stmt1 = "SELECT distinct name FROM Item WHERE itemId = ?";
	PreparedStatement ps1 = conn.prepareStatement(stmt1);
	ps1.setInt(1, itemId);
	ResultSet rs1 = ps1.executeQuery();
	String name = "";
	while(rs1.next()){
		name = rs1.getString("name");
	}
	result += itemId + "     " + name + "    ";
	
	// query Item to get a table with Attribute Name and Values as columns
	
	String stmt2 = "SELECT name, attributeValue FROM ItemAttribute where itemId = ?";
	PreparedStatement ps2 = conn.prepareStatement(stmt2);
	ps2.setInt(1, itemId);
	ResultSet rs2 = ps2.executeQuery();
	while (rs2.next()){
		String attrName = rs2.getString("name");
		String attrVal = rs2.getString("attributeValue");
		result += attrName + "     " + attrVal;
	}
	
	return result;
}


%>

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
	/*
	String stmt = "SELECT a.itemId itemId, a.name itemName, b.catName catName,"
			+ "b.attributeValue attributeValue from Item a, ItemAttribute b where "
			+ "a.itemId = b.itemId and a.userId = ? order by a.itemId asc";
	PreparedStatement ps = conn.prepareStatement(stmt);
	ps.setInt(1, userId);
	ResultSet rs = ps.executeQuery();
	*/
	// query Item to get all itemIds of items the user owns
	String stmt = "SELECT itemId FROM Item WHERE userId = ?";
	PreparedStatement ps = conn.prepareStatement(stmt);
	ps.setInt(1, userId);
	ResultSet rs = ps.executeQuery();
	
	// move ids into an ArrayList
	ArrayList<Integer> itemIdList = new ArrayList<Integer>();
	while(rs.next()){
		itemIdList.add(rs.getInt("itemId"));
	}
	
	// create an arraylist of strings where each string is a row in the displayed items list
	ArrayList<String> rows = new ArrayList<String>();
	for(int i = 0; i < itemIdList.size(); i++){
		String row = createRow(itemIdList.get(i), conn);
		rows.add(row);
	}
	/*
	for (String row: rows){
		out.print(row);
		out.print("<br>");
	}
	*/
	
	%>
	<!--
	
	Items Owned by User:
	<br>
	<pre> ItemID	Name </pre>
	<br>
	-->
	<%
	/*
	while(rs.next()){
		out.print("<pre>");
		out.print(rs.getInt("itemId") + "&#9" + rs.getString("itemName"));
		out.print("</pre>");
		out.print("<br>");
	}
	*/
	
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