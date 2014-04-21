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
        DateFormat df = new SimpleDateFormat("MM/dd/yyyy");
		ServletContext sc = getServletContext();
		RequestDispatcher rd = sc.getRequestDispatcher("/spotdetails.jsp");
		req.setAttribute("location", spot.getProperty("location"));
		req.setAttribute("startdate", df.format(spot.getProperty("startdate")));
		req.setAttribute("enddate", df.format(spot.getProperty("enddate")));
		req.setAttribute("price", spot.getProperty("price"));
		req.setAttribute("host", spot.getProperty("user"));
		rd.forward(req, resp);
	}    
}
