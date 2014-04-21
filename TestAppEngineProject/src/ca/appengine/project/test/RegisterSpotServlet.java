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
        
        String stNumber = req.getParameter("stNumber");
        String stName = req.getParameter("stName");
        String nbhood = req.getParameter("nbhood");
        String locality = req.getParameter("locality");
        String adminLevel3 = req.getParameter("aL3");
        String adminLevel2 = req.getParameter("aL2");
        String adminLevel1 = req.getParameter("aL1");
        String country = req.getParameter("country");
        String lat = req.getParameter("lat");
        String lng = req.getParameter("lng");
        String price = req.getParameter("price");
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
        if (availabilityStartDate == null) {
        	System.out.println("startdate null");
        	String responseString = "Please enter a valid start date!";
        	resp.getWriter().println(responseString);    
        	return;
        }
        if (availabilityEndDate == null) {
        	System.out.println("enddate null");
        	String responseString = "Please select a valid end date!";
        	resp.getWriter().println(responseString);        
        	return;
        }
        if (price.equals("")) {
        	System.out.println("enddate null");
        	String responseString = "Please select a valid price!";
        	resp.getWriter().println(responseString);        
        	return;
        }
        System.out.println("a3="+adminLevel3);
        System.out.println("a2="+adminLevel2);
        System.out.println("a1="+adminLevel1);
        
        Key key = KeyFactory.createKey("UBCEECE417parkspot", "parkspot");
        Entity spot = new Entity("UBCEECE417parkspot", key);
        spot.setProperty("user", user);
        spot.setProperty("stNumber", stNumber);
        spot.setProperty("stName", stName);
        spot.setProperty("neighborhood", nbhood);
        spot.setProperty("locality", locality);
        spot.setProperty("admin_level_3", adminLevel3);
        spot.setProperty("admin_level_2", adminLevel2);
        spot.setProperty("admin_level_1", adminLevel1);
        spot.setProperty("country", country);
        spot.setProperty("lat", lat);
        spot.setProperty("lng", lng);
        spot.setProperty("price", price);
        spot.setProperty("startdate", availabilityStartDate);
        spot.setProperty("enddate", availabilityEndDate);
        spot.setProperty("isReserved", false);
       
        DatastoreService spotdatastore = DatastoreServiceFactory.getDatastoreService();
        spotdatastore.put(spot);	
        
        // Test
        System.out.println("lat:");
        System.out.println(lat);
        System.out.println("lng:");
        System.out.println(lng);
        String htmlString = "<div>" + user + " " + stNumber + " " + stName + " " + nbhood + " " + locality + " " + adminLevel3 + " " + adminLevel2 + " " + adminLevel1 + " " + country + " " + price + " " + availabilityStartDateStr + " " + availabilityEndDateStr + " " + "</div>";
        System.out.println(htmlString); 
        String responseString = "Your spot was successfully registered!";
        // Test
        resp.setContentType("text/html");
        resp.getWriter().println(responseString);     
    }
}
