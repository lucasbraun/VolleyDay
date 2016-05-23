package volleyObjects;

import java.io.Serializable;

public class Time implements Serializable, Comparable<Time>{

	private static final long serialVersionUID = 1L;
	private int minute;
	private int hour;
	
	public Time (Time time) {
		this.minute = time.getMinute();
		this.hour = time.getHour();
	}
	
	public Time (int hour, int minute) {
		this.minute = minute;
		this.hour = hour;
	}
	
	public void setMinute(int minute) {
		this.minute = minute;
	}
	
	public int getMinute() {
		return minute;
	}
	
	public void setHour(int hour) {
		this.hour = hour;
	}
	
	public int getHour() {
		return hour;
	}
	
	public void addMinutes (int minute) {
		this.hour += (this.minute + minute) / 60;
		this.minute = (this.minute + minute) % 60;
	}
	
	public int subtractTime (Time other) {
		// returns difference in minutes
		return (hour - other.hour)*60 + minute - other.minute;
	}

	public String out () {
		String result = String.valueOf(hour) + ":";
		if (minute < 10) {
			result += "0";
		}
		result += String.valueOf(minute);
		return result;
	}
	
	public static Time parseTime (String string) {
		String[] args = string.split(":");
		int hour = Integer.parseInt(args[0]);
		int minute = Integer.parseInt(args[1]);
		return new Time(hour, minute);
	}

	@Override
	public int compareTo(Time arg0) {
		if (arg0.hour == hour) {
			return new Integer(minute).compareTo(new Integer(arg0.minute));
		} else {
			return new Integer(hour).compareTo(new Integer(arg0.hour));
		}
	}
	
	public boolean equals(Time arg0) {
		return (this.compareTo(arg0)==0);
	}
}
