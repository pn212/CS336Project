package com.cs336.pkg;

import java.util.*;
import java.text.*;

public class DateCheck{
	public static int expiredAuction(String endTime) throws ParseException{ 
		java.util.Date endDate = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).parse(endTime);
		if (endDate.compareTo((new Date())) < 0 || endDate.compareTo((new Date())) == 0 ){
			return 0;
		}
		else {
			return 1;
		}
	}
	
	public static int validCreate(String endTime) throws ParseException{
		endTime += ":00";
		java.util.Date endDate = (new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")).parse(endTime);
		
		if (endDate.compareTo((new Date())) < 0 || endDate.compareTo((new Date())) == 0 ){
			return 0;
		}
		else {
			return 1;
		}
	}
}
