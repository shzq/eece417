package ca.appengine.project.test;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ReserveSpotServlet extends HttpServlet {
    
	//@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
        String price = req.getParameter("price");
        String spotID = req.getParameter("id");
        String location = req.getParameter("location");
        String startDateStr = req.getParameter("startdate");
        String endDateStr = req.getParameter("enddate");
        Date startDate = null;
        Date endDate = null;
        try {
        	startDate = new SimpleDateFormat("MM/dd/yyyy").parse(startDateStr);
        	endDate = new SimpleDateFormat("MM/dd/yyyy").parse(endDateStr);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        System.out.println("sdstr=" + startDateStr);
        System.out.println("edstr="+ endDateStr);
        if (startDate == null) {
        	System.out.println("startdate null");
        	String responseString = "Please enter a valid start date!";
        	resp.getWriter().println(responseString);    
        	return;
        }
        if (endDate == null) {
        	System.out.println("enddate null");
        	String responseString = "Please select a valid end date!";
        	resp.getWriter().println(responseString);        
        	return;
        }
        Key reservationKey = KeyFactory.createKey("Reservation", user.getEmail());
        Key spotParentKey = KeyFactory.createKey("UBCEECE417parkspot", "parkspot");
        Key spotKey = KeyFactory.createKey(spotParentKey, "UBCEECE417parkspot", Long.parseLong(spotID));
        Entity reservation = new Entity("Reservation", reservationKey);

        reservation.setProperty("guest", user);
        reservation.setProperty("price", price);
        reservation.setProperty("location", location);
        reservation.setProperty("startdate", startDate);
        reservation.setProperty("enddate", endDate);
        reservation.setProperty("spotID", spotID);
       
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(reservation);	
        
        try {
			Entity spot = datastore.get(spotKey);
			System.out.println("spot location="+ spot.getProperty("location"));
			spot.setProperty("isReserved", true);
			datastore.put(spot);
		} catch (EntityNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        // Test
        String htmlString = "<div>" + user + " " + price + " " + location + " " + startDateStr + " " + endDateStr + " " + "</div>";      
        System.out.println(htmlString); 
        String responseString = "Your reservation was successfully reserved!";
        //resp.setContentType("text/html");
        //resp.getWriter().println(htmlString);
        // Test
        resp.setContentType("text/html");
        resp.getWriter().println(responseString);        

        //resp.sendRedirect("/queryprocessor/?markerID="+markerID+"&guestbookName="+guestbookName);
    }
}