<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Auction Site|Add Item</title>
</head>
<body>
<%!
public boolean emptyFields(ArrayList<String> Attributes, HttpServletRequest request){ // checks if user entered item name/attributes
	if(request.getParameter("itemName") == null || request.getParameter("itemName").trim().isEmpty()){
		return true;
	}
	for(String field: Attributes){
		if(request.getParameter(field) == null || request.getParameter(field).trim().isEmpty()){
			return true;
		}
	}
		
	return false;
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
	String itemName = request.getParameter("itemName");
	
	
	//Get the database connection
	ApplicationDB db = new ApplicationDB();	
	Connection conn = db.getConnection();
			
	if (conn == null) {
		System.out.println("Could not connect to database");
		out.print("Could not connect to database");
		response.sendRedirect("index.jsp?error=failed");
	}
	
	// give item all of its attributes
	
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
	
	// check if attributes have been filled out
	if(emptyFields(attributes, request)){
		%>
	
		<form id = "errorRedirect" method = "post" action = "enterItemInfo.jsp?error=emptyFields"  >
		<input type = "hidden" name = "subcat" value = "<%= subCatType %>" >
		</form>
		<script>document.getElementById("errorRedirect").submit();</script>
		<% 	
	}
	else{
		// add item to items table
		String insertItem = "INSERT into Item (userId, name) values (?,?)";
		PreparedStatement preparedstmt = conn.prepareStatement(insertItem);
		preparedstmt.setInt(1, userId);
		preparedstmt.setString(2, itemName);
		preparedstmt.executeUpdate();
		
		// fetch itemid of item just inserted into the table 
		// (will have max itemid of all items in the table)
		
		String str2 = "SELECT itemId from Item where itemId = (SELECT max(itemID) from Item)";
		Statement maxstmt = conn.createStatement();
		ResultSet rsMax = maxstmt.executeQuery(str2);
		Integer itemId = 0;
		// fix error check later
		if(!rsMax.next()){ // should not happen because item was just inserted
			out.print("<span>No items in Item</span>" );
		}
		else{
			itemId = rsMax.getInt("itemId");
		}
		
		
		for(String attribute: attributes){
			String attrVal = request.getParameter(attribute);
			String insertAttr = 
				"INSERT into ItemAttribute (attributeValue, itemId, name, catName) Values (?,?,?,?)";
			PreparedStatement attrPS = conn.prepareStatement(insertAttr);
			attrPS.setString(1, attrVal);
			attrPS.setInt(2, itemId);
			attrPS.setString(3, attribute);
			attrPS.setString(4, subCatType);
			attrPS.executeUpdate();
		}
			
		response.sendRedirect("userItems.jsp");
		
		
	}
	
	
} catch(Exception e){
	out.print(e);
}




%>


</body>
</html>