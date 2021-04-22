package com.cs336.pkg;

public class SoldItem {
	private double price;
	private String name;
	private int buyerId;
	private int sellerId;
	private String type;
	private int itemId;

	public SoldItem(int itemId, double price, String name, int buyerId, int sellerId, String type) {
		this.itemId = itemId;
		this.price = price;
		this.name = name;
		this.buyerId = buyerId;
		this.sellerId = sellerId;
		this.type = type;
	}
	public double getPrice() {
		return price;
	}
	public String getName() {
		return name;
	}
	public int getBuyerId() {
		return buyerId;
	}
	public int getSellerId() {
		return sellerId;
	}
	public String getType() {
		return type;
	}
	public int getId() {
		return itemId;
	}
}
