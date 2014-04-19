package ca.appengine.project.model;

import java.util.Date;

import com.google.appengine.api.users.User;

public class Reservation {
	private Spot spot;
	private User spotGuest;
	private Date reservationStartDate;
	private Date reservationEndDate;
	
	public Reservation (Spot spot, User guest, Date start, Date end)
	{
		this.spot = spot;
		this.spotGuest = guest;
		this.reservationStartDate = start;
		this.reservationEndDate = end;
	}
	
	public Spot getSpot()
	{
		return this.spot;
	}
	
	public User getSpotGuest()
	{
		return this.spotGuest;
	}
	
	public Date getStartDate()
	{
		return this.reservationStartDate;
	}
	
	public Date getEndDate()
	{
		return this.reservationEndDate;
	}
	
}
