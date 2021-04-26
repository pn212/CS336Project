<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset = ISO-8859-1">
		<title>Auction Site | Browse Items</title>
	</head>
	
	<body>
		A status of 0 represents that the item has not been sold yet. <br>
		A status of 1 represents that the item has been sold. <br>
		A status of 2 represents that the item had been on auction previously, but there was no winner. <br> <br> 
		You can select an Item ID and click the "View Additional Info" button to view additional information 
		about the selected item. <br>
		You can also select an Item ID and click the "Set Alert" button to set an alert for that item to notify
		you when it becomes available. <br><br>
		Click on the column names to sort by that particular column name. Click again to reverse the order of sorting (default sorted by Item ID).<br><br>
		Here is a current list of all items: <br><br>
		
		<!-- Sort By (Default is Item ID): 
			<input type="radio" id="itemID" name="sortBy" value="itemID" checked>
				<label for="itemID">Item ID</label>
			<input type="radio" id="itemSeller" name="sortBy" value="itemSeller" >
				<label for="itemSeller">Item Seller</label>
			<input type="radio" id="itemName" name="sortBy" value="itemName" >
				<label for="itemName">Item Name</label>
			<input type="radio" id="catName" name="sortBy" value="catName">
				<label for="catName">Item Subcategory</label>
			<input type="radio" id="itemStatus" name="sortBy" value="itemStatus">
				<label for="itemStatus">Item Status</label>
			<input type="submit" value="Submit" formaction="browseItems.jsp"> -->
			
		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			//String entity = request.getParameter("sortBy");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "select distinct e.fname, e.lname, i.itemID, i.name, j.catName, i.itemStatus "
				+ "from item i, auction a, enduser e, itemattribute j where (j.itemId = i.itemId and "
				+ "e.userId = i.userId) order by i.itemID;";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
		
		<script>
		function sortTable(n) {
		  var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
		  table = document.getElementById("items");
		  switching = true;
		  // Set the sorting direction to ascending:
		  dir = "asc";
		  /* Make a loop that will continue until
		  no switching has been done: */
		  while (switching) {
		    // Start by saying: no switching is done:
		    switching = false;
		    rows = table.rows;
		    /* Loop through all table rows (except the
		    first, which contains table headers): */
		    for (i = 1; i < (rows.length - 1); i++) {
		      // Start by saying there should be no switching:
		      shouldSwitch = false;
		      /* Get the two elements you want to compare,
		      one from current row and one from the next: */
		      x = rows[i].getElementsByTagName("TD")[n];
		      y = rows[i + 1].getElementsByTagName("TD")[n];
		      /* Check if the two rows should switch place,
		      based on the direction, asc or desc: */
		      if (dir == "asc") {
		        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
		          // If so, mark as a switch and break the loop:
		          shouldSwitch = true;
		          break;
		        }
		      } else if (dir == "desc") {
		        if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
		          // If so, mark as a switch and break the loop:
		          shouldSwitch = true;
		          break;
		        }
		      }
		    }
		    if (shouldSwitch) {
		      /* If a switch has been marked, make the switch
		      and mark that a switch has been done: */
		      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
		      switching = true;
		      // Each time a switch is done, increase this count by 1:
		      switchcount ++;
		    } else {
		      /* If no switching has been done AND the direction is "asc",
		      set the direction to "desc" and run the while loop again. */
		      if (switchcount == 0 && dir == "asc") {
		        dir = "desc";
		        switching = true;
		      }
		    }
		  }
		}
		</script>
		
		<form method="post">
		<table border='1' id="items">
			<tr>
				<th onclick="sortTable(0)">Item ID</th>
				<th onclick="sortTable(1)">Item Seller</th>
				<th onclick="sortTable(2)">Item Name</th>
				<th onclick="sortTable(3)">Item Subcategory</th>
				<th onclick="sortTable(4)">Item Status</th>
			</tr>
			
			<%
				//parse out the results
				int count = 1;
				while (result.next()) { 
			%>
					<tr>
						<td>
							<input type="radio" id="<%=result.getString("itemID")%>" name="command" 
								value="<%=result.getString("itemID")%>" <% if (count == 1) out.print("checked"); %>>
							<label for="<%=result.getString("itemID")%>"><%=result.getString("itemID")%> </label>
						</td>
						<td> <%= result.getString("fname") + " " + result.getString("lname") %> </td>
						<td> <%= result.getString("name") %> </td>
						<td> <%= result.getString("catName") %> </td>
						<td> <%= result.getString("itemStatus") %> </td>
					</tr>
					
		<%			count++;
				} 
				
				//close the connection.
				db.closeConnection(con);
		%>
		
		</table>

		<br><br>Here is a list of all items currently on auction and the highest bid on those items: <br><br>

		<%	} catch (Exception e) {
				out.print(e);
			}
		
		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			//String entity = request.getParameter("command");
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "select a.itemId, a.auctionId, max(b.amount) as bid from item i, auction a, "
				+ "bid b where (a.auctionId = b.auctionId and a.itemId = i.itemId and i.itemStatus = 0) "
				+ "group by itemId;";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
		
		<table border="1" id="items">
			<tr>
				<th> Item ID </th>
				<th> Current Highest Bid </th>
			</tr>
			
			<%
				//parse out the results
				int count = 1;
				while (result.next()) { 
			%>
			
				<tr>
					<td><%=result.getString("itemId") %></td>
					<td> <%=result.getString("bid")%></td>
				</tr>
					
			<%		count++;
				} 
				
				//close the connection.
				db.closeConnection(con);

			} catch (Exception e) {
				out.print(e);
			}
			%>
			
		</table> <br>
		
			<input type="submit" value="View Additional Info" formaction="itemInformation.jsp">
			<input type="submit" value="Set Alert" formaction="alertSetMessage.jsp">
			<input type="submit" value="Back Home" formaction="account.jsp">
		</form>
	</body>
</html>