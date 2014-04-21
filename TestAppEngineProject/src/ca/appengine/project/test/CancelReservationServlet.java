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

public class CancelReservationServlet extends HttpServlet {
    
	//@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {

        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
        String reservationId = req.getParameter("id");
        Key reservationParentKey = KeyFactory.createKey("Reservation", user.getEmail());
        Key reservationKey = KeyFactory.createKey(reservationParentKey, "Reservation", Long.parseLong(reservationId));
        Key spotKey = null;
        System.out.println("reservationKey=" + reservationKey);
     
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
       	Entity reservation = null;
        Entity spot = null;
		try {
			reservation = datastore.get(reservationKey);
			String spotId = (String) reservation.getProperty("spotID");
		    Key spotParentKey = KeyFactory.createKey("UBCEECE417parkspot", "parkspot");
		    spotKey = KeyFactory.createKey(spotParentKey, "UBCEECE417parkspot", Long.parseLong(spotId));
			spot = datastore.get(spotKey);
			spot.setProperty("isReserved", false);
			datastore.put(spot);
		} catch (EntityNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
       	System.out.println("reservation="+reservation);
        datastore.delete(reservationKey);
 
        String responseString = reservationId;

        resp.setContentType("text/html");
        resp.getWriter().println(responseString);     

    }
}