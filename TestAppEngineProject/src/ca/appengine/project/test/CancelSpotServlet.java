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

public class CancelSpotServlet extends HttpServlet {
    
	//@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {

        
        String id = req.getParameter("id");
        System.out.println("id="+ id);

        
        Key parentKey = KeyFactory.createKey("UBCEECE417parkspot", "parkspot");
        Key key = KeyFactory.createKey(parentKey, "UBCEECE417parkspot", Long.parseLong(id));
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
       	Entity spot = null;
		try {
			spot = datastore.get(key);
		} catch (EntityNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

       
       	System.out.println("spot="+spot);
        datastore.delete(key);
 
        // Test
        String htmlString = "<div>" + id + " " + "</div>";      
        System.out.println(htmlString); 
        String responseString = id;

        // Test
        resp.setContentType("text/html");
        resp.getWriter().println(responseString);     

  //    resp.sendRedirect("/viewspots/?user=" + user+"&price="+price +"&location="+location+"&availabilityStartDateStr="+availabilityStartDateStr+"&availabilityEndDateStr="+availabilityEndDateStr);

        
        //resp.sendRedirect("/queryprocessor/?markerID="+markerID+"&guestbookName="+guestbookName);
    }
}