package com.cs336.pkg;

import java.sql.*;
import java.util.*;

public class SalesReport {
	public static ArrayList<String> getItemTypes(Connection con) throws SQLException {
		String sql = "SELECT name FROM SubCategoryType";
		
		Statement stmt = con.createStatement();
		ResultSet results = stmt.executeQuery(sql);
		
		ArrayList<String> itemTypes = new ArrayList<String>();
		
		while (results.next()) {
			itemTypes.add(results.getString("name"));
		}
		
		return itemTypes;
	}
	
	public static ArrayList<SoldItem> getSoldItems(Connection con) throws SQLException {
		String sql = 
				"select\n" +
				"	itemId,\n" +
				"	name,\n" +
				"    userId as sellerId,\n" +
				"    b.price,\n" +
				"    b.buyerId,\n" +
				"    (\n" +
				"		select ia.catName\n" +
				"        from ItemAttribute ia\n" +
				"        where ia.itemId = a.itemId\n" +
				"        limit 1\n" +
				"    ) as itemType\n" +
				"from\n" +
				"	(\n" +
				"		select\n" +
				"			max(amount) as price,\n" +
				"            auctionId,\n" +
				"            any_value(userId) as buyerId\n" +
				"		from bid\n" +
				"		group by auctionId\n" +
				"	) b,\n" +
				"    item join Auction a using(itemId)\n" +
				"where itemStatus = 1 and b.auctionId = a.auctionId";
		
		Statement stmt = con.createStatement();
		ResultSet results = stmt.executeQuery(sql);
		
		ArrayList<SoldItem> items = new ArrayList<SoldItem>();
		
		while (results.next()) {
			SoldItem item = new SoldItem(
				results.getInt("itemId"),
				results.getDouble("price"),
				results.getString("name"),
				results.getInt("buyerId"),
				results.getInt("sellerId"),
				results.getString("itemType")
			);
			items.add(item);
		}
		return items;
	}
}
