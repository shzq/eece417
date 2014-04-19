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
        String availablilityStartDate = req.getParameter("startdate");
        String availabilityEndDate = req.getParameter("enddate");
       
        Key locationKey = KeyFactory.createKey("UBCEECE417parkspot", location);
        //Date date = new Date();
        Entity spot = new Entity("UBCEECE417parkspot", locationKey);
        
        spot.setProperty("user", user);
        spot.setProperty("price", price);
        spot.setProperty("location", location);
        spot.setProperty("startdate", availablilityStartDate);
        spot.setProperty("startdate", availabilityEndDate);
       
        DatastoreService spotdatastore = DatastoreServiceFactory.getDatastoreService();
        spotdatastore.put(spot);	
        
        // Test
        String htmlString = "<div>" + user + " " + price + " " + location + " " + availablilityStartDate + " " + availabilityEndDate + " " + "</div>";      
        System.out.println(htmlString);  
        //resp.setContentType("text/html");
        //resp.getWriter().println(htmlString);
        // Test
        
        //resp.sendRedirect("/queryprocessor/?markerID="+markerID+"&guestbookName="+guestbookName);
    }
}