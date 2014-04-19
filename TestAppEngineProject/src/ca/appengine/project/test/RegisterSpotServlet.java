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
        String availablilityStartDate = req.getParameter("availablilityStartDate");
        String availabilityEndDate = req.getParameter("availabilityEndDate");
        String spotHost = req.getParameter("spotHost");
       
        Key locationKey = KeyFactory.createKey("UBCEECE417spotDB", location);
        //Date date = new Date();
        Entity greeting = new Entity("UBCEECE417spotLocations", locationKey);
        
        greeting.setProperty("user", user);
        //greeting.setProperty("date", date);
        greeting.setProperty("price", price);
        greeting.setProperty("location", location);
        greeting.setProperty("availablilityStartDate", availablilityStartDate);
        greeting.setProperty("availabilityEndDate", availabilityEndDate);
        greeting.setProperty("spotHost", spotHost);
       
        DatastoreService spotdatastore = DatastoreServiceFactory.getDatastoreService();
        spotdatastore.put(greeting);	
        
        // Test
        String htmlString = "<div>" + user + " " + price + " " + location + " " + availablilityStartDate + " " + availabilityEndDate + " " + spotHost + "</div>";      
        System.out.println(htmlString);  
        //resp.setContentType("text/html");
        //resp.getWriter().println(htmlString);
        // Test
        
        //resp.sendRedirect("/queryprocessor/?markerID="+markerID+"&guestbookName="+guestbookName);
    }
}