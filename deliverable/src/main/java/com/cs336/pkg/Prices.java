package com.cs336.pkg;

import java.text.DecimalFormat;

public class Prices {
	public static final double MAX_AMOUNT = 999999999999999.99;

	public static double getPrice(String price) {
		double amount = Double.parseDouble(price);
		System.out.println(amount);
		DecimalFormat df = new DecimalFormat("#.##");
	    amount = Double.parseDouble(df.format(amount));
	    return amount;
	}

	public static boolean isValidPrice (String price){
		if(price == null){
			return false;
		}
		price = price.trim();
		if (price.isEmpty()) {
			return false;
		}
		
		try {
			double amount = getPrice(price);
			return amount >= 0 && amount <= MAX_AMOUNT;
		} catch (NumberFormatException e) {
			return false;	
		}
	}
	
	public static boolean isValidBid(double bidAmount, double startPrice, double highestBidAmount, double incPrice){
		if (bidAmount < startPrice) return false;
		if (bidAmount < highestBidAmount + incPrice) return false;
		return true;
	}
}
