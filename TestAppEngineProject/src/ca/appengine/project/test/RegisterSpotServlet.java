package ca.appengine.project.test;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
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

public class RegisterSpotServlet extends HttpServlet {
    
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
        
        Key key = KeyFactory.createKey("UBCEECE417parkspot", "parkspot");
        Entity spot = new Entity("UBCEECE417parkspot", key);
        spot.setProperty("user", user);
        spot.setProperty("price", price);
        spot.setProperty("location", location);
        spot.setProperty("startdate", availabilityStartDate);
        spot.setProperty("enddate", availabilityEndDate);
        spot.setProperty("isReserved", false);
       
        DatastoreService spotdatastore = DatastoreServiceFactory.getDatastoreService();
        spotdatastore.put(spot);	
        
        // Test
        String htmlString = "<div>" + user + " " + price + " " + location + " " + availabilityStartDateStr + " " + availabilityEndDateStr + " " + "</div>";      
        System.out.println(htmlString); 
        String responseString = "Your spot was successfully registered!";
        //resp.setContentType("text/html");
        //resp.getWriter().println(htmlString);
        // Test
        resp.setContentType("text/html");
        resp.getWriter().println(responseString);     

  //    resp.sendRedirect("/viewspots/?user=" + user+"&price="+price +"&location="+location+"&availabilityStartDateStr="+availabilityStartDateStr+"&availabilityEndDateStr="+availabilityEndDateStr);

        
        //resp.sendRedirect("/queryprocessor/?markerID="+markerID+"&guestbookName="+guestbookName);
    }
}
