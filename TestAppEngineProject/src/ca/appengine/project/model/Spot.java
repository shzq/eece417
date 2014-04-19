package ca.appengine.project.model;

import java.util.ArrayList;
import java.util.Date;

import com.google.appengine.api.users.User;

public class Spot {
	private int price;
	private String location;
	private Date availabilityStartDate;
	private Date availabilityEndDate;
	private ArrayList<Reservation> reservationList;
	private User spotHost;
	
	public Spot(int price, String location, User host, Date start, Date end)
	{
		this.price = price;
		this.location = location;
		this.spotHost = host;
		this.availabilityEndDate = end;
		this.availabilityStartDate = start;
		this.reservationList = new ArrayList<Reservation>();
	}
	
	public Boolean addReservation(Reservation reservation)
	{
		reservationList.add(reservation);		
		return true;
	}
	
	public int getPrice()
	{
		return this.price;
	}
	
	public String getLocation()
	{
		return this.location;
	}
	
	public User getSpotHost()
	{
		return this.spotHost;
	}
	
	public ArrayList<Reservation> getReservationList()
	{
		return this.reservationList;
	}
	
	public Date getStartDate()
	{
		return this.availabilityStartDate;
	}
	
	public Date getEndDate()
	{
		return this.availabilityEndDate;
	}
	
	
	
}
