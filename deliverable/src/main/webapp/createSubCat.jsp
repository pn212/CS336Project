<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat, java.text.DecimalFormat" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Auction Site | Create SubCategory</title>
<style>
	.attr-cont:not(:last-child) {
		margin-bottom: 10px;
	}
</style>
</head>
<body>
	
	<%!
	public static boolean validAttributes (ArrayList<String> attributes, ArrayList<String> domains){
		final int MAX_ATTR_LENGTH = 50;
		final int MAX_DOMAIN_LENGTH = 50;
		boolean existsDuplicates = false;
		for (int i = 0; i < attributes.size(); i++) {
			if(attributes.get(i).length() > MAX_ATTR_LENGTH || domains.get(i).length() > MAX_DOMAIN_LENGTH){
				return false;
			}
			for (int j = i+1; j < attributes.size(); j++) {
		    	if (attributes.get(i).toLowerCase().equals(attributes.get(j).toLowerCase())) {
		      		existsDuplicates = true;
		      		break;
				}
			}
		}
		return !existsDuplicates;
	}
	
	%>
	
	<%
	try {
		// if user is not an authorized admin, show 404 error
		if (session.getAttribute("userId") == null || session.getAttribute("userTable") == null) {
			response.sendError(404, request.getRequestURI());
			return;
		}
		else {
			String userTable = (String) session.getAttribute("userTable");
			
			if (!userTable.equals("administrator")) {
				response.sendError(404, request.getRequestURI());
				return;
			}
		}
	}
	catch(Exception e){
		out.print(e);
		return;
	}
	
	//Get the database connection
	if(request.getParameter("attr1") != null){
		ArrayList<String> attributes = new ArrayList<String>();
		ArrayList<String> domains = new ArrayList<String>();
		int i = 1;
		while(request.getParameter("attr" + i) != null){
			attributes.add(request.getParameter("attr" + i));
			domains.add(request.getParameter("domain" + i));
			i++;
		}
		
		if(!validAttributes(attributes, domains)){
			out.print("Invalid attributes");
		}
		else{
			final int MAX_CAT_LENGTH = 50;
			String catName = "";
			if(request.getParameter("name") != null){
				catName = request.getParameter("name").trim();
				if (catName.length() > MAX_CAT_LENGTH || catName.isEmpty()){
					out.print("Invalid SubCategory name length");
				}
				else{
					ApplicationDB db = new ApplicationDB();	
					Connection conn = db.getConnection();
					if (conn == null){
						out.print("Could not connect to the database");
					}
					else{
						boolean catExists = false;
						for (String existingCat : SoldItem.getItemTypes(conn)){
							if(existingCat.toLowerCase().equals(catName.toLowerCase())){
								out.print("SubCategory already exists");
								catExists = true;
								break;
							}
						}
						if (!catExists){
							String subCatStmt = "INSERT into SubCategoryType (name) VALUES (?)";
							PreparedStatement subCatPS = conn.prepareStatement(subCatStmt);
							subCatPS.setString(1, catName);
							int status = subCatPS.executeUpdate();
							i = 1;
							for(int index = 0; index < attributes.size(); index++){
								String attrNameStmt = "INSERT into AttributeName (name, catName, domain) VALUES (?, ?, ?)";
								PreparedStatement attrNamePS = conn.prepareStatement(attrNameStmt);
								attrNamePS.setString(1, attributes.get(index));
								attrNamePS.setString(2, catName);
								attrNamePS.setString(3, domains.get(index));
								int success = attrNamePS.executeUpdate();
							}
							out.print("Added SubCategory");
						}	
					}
					db.closeConnection(conn);	
				}
			}
		}
	}
	
	%>
	
	<form id="create-form" method="post" action = "createSubCat.jsp">
		<label for="name">SubCategory Name</label>
		<input type="text" name="name" required id="name" />
		<br>
		<input type="submit" value="Create" />
		
		<div class="attr-cont">
			<label for="attr1">Attribute 1</label>
			<input id="attr1" name="attr1" type="text" required />
			<br>
			<label for="domain1">Domain 1</label>
			<select required id="domain1" name="domain1">
				<option value="int">Integer</option>
				<option value="string">String</option>
				<option value="double">Double</option>
				<option value="boolean">Boolean</option>
			</select>
			<br>
		</div>
	</form>
	
	<button onclick="addAttribute()">Add Attribute</button>
	<button onclick="deleteAttribute()">Remove Attribute</button>
	
	<script>
		function addAttribute() {
			var form = document.getElementById("create-form");
			var curLen = form.getElementsByClassName("attr-cont").length;
			var i = curLen + 1;
			
			var cont = document.createElement("div");
			cont.setAttribute("class", "attr-cont");
			
			var attrLabel = document.createElement("label");
			attrLabel.setAttribute("for", "attr"+i);
			attrLabel.innerText = "Attribute "+i;
			
			var attrInput = document.createElement("input");
			attrInput.setAttribute("id", "attr"+i);
			attrInput.setAttribute("name", "attr"+i);
			attrInput.setAttribute("type", "text");
			attrInput.setAttribute("required", "");
			
			var domLabel = document.createElement("label");
			domLabel.setAttribute("for", "domain"+i);
			domLabel.innerText = "Domain "+i;
			
			var domains = new Array();
			domains["int"] = "Integer";
			domains["string"] = "String";
			domains["double"] = "Double";
			domains["boolean"] = "Boolean";
			
			var dropdown = document.createElement("select");
			dropdown.setAttribute("required", "");
			dropdown.setAttribute("id", "domain"+i);
			dropdown.setAttribute("name", "domain"+i);
			
			for (let v in domains) {
				var opt = document.createElement("option");
				opt.innerText = domains[v];
				opt.setAttribute("value", v);
				dropdown.appendChild(opt);
			}
			
			cont.appendChild(attrLabel);
			cont.appendChild(attrInput);
			cont.appendChild(document.createElement("br"));
			cont.appendChild(domLabel);
			cont.appendChild(dropdown);
			cont.appendChild(document.createElement("br"));
			
			form.appendChild(cont);
		}
		
		function deleteAttribute() {
			var form = document.getElementById("create-form");
			var curLen = form.getElementsByClassName("attr-cont").length;
			if (curLen === 1) {
				return;
			}
			
			var attrs = form.getElementsByClassName("attr-cont");
			form.removeChild(attrs[curLen-1]);
		}
	</script>

	
	
		
	
</body>
</html>