<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Auction Site | Forum</title>
	<style>
	.replies {
	 	list-style-type: none;
	 	padding: 0;
		margin: 0;
	}
	.replies > li:not(:last-child) {
		margin: 0 0 10px 0;
	}
	</style>
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
	
	<h3>Welcome to the Forum!</h3>
	
	<%
	
	ArrayList<ForumPost> forumPosts;
	if (request.getParameter("postId") != null) {
		forumPosts = ForumPost.getForumPosts(true);
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
		else {
			// display post
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			%>
			<span style="font-weight: bold;">Made by:</span>
			<span>User <%= selectedPost.getUserId()%></span>
			<br>
			<span style="font-weight: bold;">Title:</span>
			<span><%=selectedPost.getTitle()%></span>
			<br>
			<span style="font-weight: bold;">Description:</span>
			<span><%=selectedPost.getDescription()%></span>
			<br>
			<p style="font-weight: bold;">Replies (<%=selectedPost.getReplies().size()%>):</p>
			<ul class="replies">
			<%
				for (ForumReply reply : selectedPost.getReplies()) {
					String creator = reply instanceof ForumAnswer ? "Customer Support" : "User";
					%>
					<li>
						<span><%= formatter.format(reply.getCreatedAt())%></span>
						<br>
						<span style="font-weight: bold;"><%=creator+" "+reply.getCreatorId()+":"%></span>
						<span><%=reply.getContent()%></span>
					</li>
					<%
				}
			%>
			</ul>
			<%
		}
	}
	else {
		forumPosts = ForumPost.getForumPosts(false);
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
	%>
	
	<script>
	function attachSearch() {
		// find search bar
		var searchBar = document.getElementById("search-bar");
		
		// attach listener for "keyup" event
		// event is triggered when key on keyboard is lifted
		searchBar.addEventListener('keyup', function (event) {
			// get current value of search bar
			var value = searchBar.value.trim().toLowerCase();
			
			// get all posts
			var posts = document.getElementsByClassName("post-link");
			
			// if there is a value
			if (value) {
				// show all posts that contain the value
				for (var i = 0; i < posts.length; i++) {
					var postText = posts[i].innerText.trim().toLowerCase();
					posts[i].style.display = postText.indexOf(value) >= 0 ? 'inline' : 'none';
				}
			}
			// if there is no value (empty search bar)
			else {
				// display all posts
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