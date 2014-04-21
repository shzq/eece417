package ca.appengine.project.test;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;


import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;


import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SpotQueryForwardServlet extends HttpServlet {
	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException, ServletException {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Key dsKey = KeyFactory.createKey("UBCEECE417parkspot", "parkspot");
		String id = req.getParameter("id");
		Key key = KeyFactory.createKey(dsKey, "UBCEECE417parkspot", Long.parseLong(id));
        Entity spot = null;
        
		try {
			spot = datastore.get(key);
		} catch (EntityNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String stNumber = (String) spot.getProperty("stNumber");
        String stName = (String) spot.getProperty("stName");
        String nbhood = (String) spot.getProperty("neighborhood");
        String locality = (String) spot.getProperty("locality");
        String adminLevel3 = (String) spot.getProperty("admin_level_3");
        String adminLevel2 = (String) spot.getProperty("admin_level_2");
        String adminLevel1 = (String) spot.getProperty("admin_level_1");
		String locationString = "";
		if(!stNumber.equals("null")) 
			locationString += stNumber + ", ";
		if(!stName.equals("null")) 
			locationString += stName + ", ";
		if(!nbhood.equals("null") && !nbhood.equals(""))
			locationString += nbhood + ", "; 
		if(!locality.equals("null") && !locality.equals(" "))
			locationString += locality + ", ";
		if(!adminLevel3.equals("null") && !adminLevel3.equals(""))
			locationString += adminLevel3 + ", ";
		if(!adminLevel2.equals("null") && !adminLevel2.equals(""))
			locationString += adminLevel2 + ", ";
		if(!adminLevel1.equals("null") && !adminLevel1.equals(""))
			locationString += adminLevel1 + " ";
        DateFormat df = new SimpleDateFormat("MM/dd/yyyy");
		ServletContext sc = getServletContext();
		RequestDispatcher rd = sc.getRequestDispatcher("/spotdetails.jsp");
		req.setAttribute("location", locationString);
		req.setAttribute("startdate", df.format(spot.getProperty("startdate")));
		req.setAttribute("enddate", df.format(spot.getProperty("enddate")));
		req.setAttribute("price", spot.getProperty("price"));
		req.setAttribute("host", spot.getProperty("user"));
		req.setAttribute("spotID", id);
		rd.forward(req, resp);
	}    
}
