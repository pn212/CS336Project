<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	
		
	%>
	
	<form id="create-form" method="post">
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