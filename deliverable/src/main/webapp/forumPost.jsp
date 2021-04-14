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
	int parseSelectedId(ServletRequest request) {
		if (request.getParameter("postId") == null) return -1;
		try {
			int postId = Integer.parseInt(request.getParameter("postId"));
			return postId;
		} catch (NumberFormatException e) { return -1; }
	}
	%>
	
	<%
	ArrayList<ForumPost> forumPosts = ForumPost.getForumPosts();

	if (forumPosts == null) {
		%><span>An error occurred</span><%
	}
	else {
		%><h3>Welcome to the Forum!</h3><%
		
		if (request.getParameter("postId") != null) {
			int selectedPostId = parseSelectedId(request);
			ForumPost selectedPost = null;
			for (ForumPost post : forumPosts) {
				if (post.getId() == selectedPostId) {
					selectedPost = post;
					break;
				}
			}
			
			if (selectedPost == null) {
				%>
				<span>This post does not exist</span>
				<br>
				<a href="forumPost.jsp">View all posts</a>
				<%
			}
		}
		else {
			%>
			<span>Total Posts: <%=forumPosts.size()%></span>
			<br>
			<br>
			
			<label for="search-bar">Search:</label>
			<input id="search-bar" type="text"/>
			
			<br>
			<br>
			<%
			for (ForumPost forumPost : forumPosts) {
				%>
				<div class="post-link">
					<a href="forumPost.jsp?postId=<%=forumPost.getId()%>">
						<%=forumPost.getTitle()%>
					</a>
					<br>
				</div>
				<%
			}
		}
	}
	%>
	
	<script>
	function attachSearch() {
		var searchBar = document.getElementById("search-bar");
		searchBar.addEventListener('keyup', function (event) {
			var value = searchBar.value.trim();
			var posts = document.getElementsByClassName("post-link");
			if (value) {
				for (var i = 0; i < posts.length; i++) {
					var postText = posts[i].innerText.trim().toLowerCase();
					posts[i].style.display = postText.indexOf(value) >= 0 ? 'inline' : 'none';
				}
			}
			else {
				for (var i = 0; i < posts.length; i++) {
					posts[i].style.display = 'inline';
				}
			}
		});
	}
	attachSearch();
	</script>
</body>
</html>