package com.cs336.pkg;

import java.util.ArrayList;
import java.util.Date;

import java.sql.*;

public class ForumPost {
	private int postId, userId;
	private String title, description;
	private Date createdAt;

	public ForumPost(int postId, String title, String description, int userId, Date createdAt) {
		this.postId = postId;
		this.userId = userId;
		this.title = title;
		this.description = description;
		this.createdAt = createdAt;
	}
	
	public String getTitle() {
		return title;
	}

	public int getId() {
		return postId;
	}

	public int getUserId() {
		return userId;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public String getDescription() {
		return description;
	}
	
	public static ArrayList<ForumPost> getForumPosts() {
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
	
			if (con == null) {
				return null;
			}
	
			String str = "select * from ForumPosts";
	
			PreparedStatement stmt = con.prepareStatement(str);
			
			ResultSet results = stmt.executeQuery();
			
			ArrayList<ForumPost> posts = new ArrayList<ForumPost>();
			
			while (results.next()) {
				int postId = results.getInt("postId");
				String title = results.getString("title");
				String description = results.getString("description");
				int userId = results.getInt("userId");
				Date createdAt = results.getDate("created_at");
				
				posts.add(new ForumPost(postId, title, description, userId, createdAt));
			}

			db.closeConnection(con);
			
			return posts;
		} catch(Exception e) { return null; }
	}
}
