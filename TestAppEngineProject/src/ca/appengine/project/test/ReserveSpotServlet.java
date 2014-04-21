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

        // We have one entity group per Guestbook with all Greetings residing
        // in the same entity group as the Guestbook to which they belong.
        // This lets us run a transactional ancestor query to retrieve all
        // Greetings for a given Guestbook.  However, the write rate to each
        // Guestbook should be limited to ~1/second.
        
        String price = req.getParameter("price");
        String spotID = req.getParameter("id");
        String location = req.getParameter("location");
        String availabilityStartDateStr = req.getParameter("startdate");
        String availabilityEndDateStr = req.getParameter("enddate");
        Date availabilityStartDate = new Date();
        Date availabilityEndDate = new Date();
        try {
        	availabilityStartDate = new SimpleDateFormat("MM/dd/yyyy").parse(availabilityStartDateStr);
        	availabilityEndDate = new SimpleDateFormat("MM/dd/yyyy").parse(availabilityEndDateStr);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        Key reservationKey = KeyFactory.createKey("Reservation", user.getEmail());
        Key spotParentKey = KeyFactory.createKey("UBCEECE417parkspot", "parkspot");
        Key spotKey = KeyFactory.createKey(spotParentKey, "UBCEECE417parkspot", Long.parseLong(spotID));
        Entity reservation = new Entity("Reservation", reservationKey);

        reservation.setProperty("guest", user);
        reservation.setProperty("price", price);
        reservation.setProperty("location", location);
        reservation.setProperty("startdate", availabilityStartDate);
        reservation.setProperty("enddate", availabilityEndDate);
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
        String htmlString = "<div>" + user + " " + price + " " + location + " " + availabilityStartDateStr + " " + availabilityEndDateStr + " " + "</div>";      
        System.out.println(htmlString); 
        String responseString = "Your reservation was successfully registered!";
        //resp.setContentType("text/html");
        //resp.getWriter().println(htmlString);
        // Test
        resp.setContentType("text/html");
        resp.getWriter().println(responseString);        

        //resp.sendRedirect("/queryprocessor/?markerID="+markerID+"&guestbookName="+guestbookName);
    }
}