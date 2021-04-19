package com.cs336.pkg;

import java.util.ArrayList;
import java.util.Date;

import java.sql.*;

public class ForumPost {
	private int postId, userId;
	private String title, description;
	private Date createdAt;
	private ArrayList<ForumAnswer> answers;
	private ArrayList<ForumComment> comments;

	public ForumPost(int postId, String title, String description, int userId, Date createdAt) throws Exception {
		this.postId = postId;
		this.userId = userId;
		this.title = title;
		this.description = description;
		this.createdAt = createdAt;
	}
	
	public void loadAnswers() throws Exception {
		answers = new ArrayList<>();
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
	
			if (con == null) {
				throw new NullPointerException();
			}
	
			String str = "select * from ForumAnswer where postId = ?";
	
			PreparedStatement stmt = con.prepareStatement(str);
			stmt.setInt(1, postId);
			
			ResultSet results = stmt.executeQuery();
			
			while (results.next()) {
				int answerId = results.getInt("answerId");
				Date answerDate = results.getDate("created_at");
				String content = results.getString("content");
				int csId = results.getInt("csId");
				answers.add(new ForumAnswer(answerId, postId, csId, answerDate, content));
			}

			db.closeConnection(con);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	public void loadComments() throws Exception {
		comments = new ArrayList<>();
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
	
			if (con == null) {
				throw new NullPointerException();
			}
	
			String str = "select * from ForumComment where postId = ?";
	
			PreparedStatement stmt = con.prepareStatement(str);
			stmt.setInt(1, postId);
			
			ResultSet results = stmt.executeQuery();
			
			while (results.next()) {
				int commentId = results.getInt("commentId");
				Date commentDate = results.getDate("created_at");
				String content = results.getString("content");
				int userId = results.getInt("userId");
				comments.add(new ForumComment(commentId, postId, userId, commentDate, content));
			}

			db.closeConnection(con);
		} catch(Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	public ArrayList<ForumAnswer> getAnswers() {
		return answers;
	}
	
	public ArrayList<ForumComment> getComments() {
		return comments;
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
	
	public static ArrayList<ForumPost> getForumPosts(boolean loadFull) {
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
	
			if (con == null) {
				return null;
			}
	
			String str = "select * from ForumPost";
	
			PreparedStatement stmt = con.prepareStatement(str);
			
			ResultSet results = stmt.executeQuery();
			
			ArrayList<ForumPost> posts = new ArrayList<ForumPost>();
			
			while (results.next()) {
				int postId = results.getInt("postId");
				String title = results.getString("title");
				String description = results.getString("description");
				int userId = results.getInt("userId");
				Date createdAt = results.getDate("created_at");
				
				ForumPost post = new ForumPost(postId, title, description, userId, createdAt);
				if (loadFull) {
					post.loadAnswers();
					post.loadComments();
				}
				posts.add(post);
			}

			db.closeConnection(con);
			
			return posts;
		} catch(Exception e) {
			return null;
		}
	}
}
