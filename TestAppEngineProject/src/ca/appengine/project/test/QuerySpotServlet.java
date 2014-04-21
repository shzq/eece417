package ca.appengine.project.test;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class QuerySpotServlet extends HttpServlet {
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException, ServletException {
		 DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		    Key dsKey = KeyFactory.createKey("UBCEECE417parkspot", "parkspot");

		    String location = (String) req.getParameter("location");
		    String startDateStr = (String) req.getParameter("startdate");
		    String endDateStr = (String) req.getParameter("enddate");
		    Date startDate = null;
		    Date endDate = null;
		    try {
		    	startDate = new SimpleDateFormat("MM/dd/yyyy").parse(startDateStr);        
		    } catch(Exception e) {
		    	e.printStackTrace();
		    }
		    try{
		    	endDate = new SimpleDateFormat("MM/dd/yyyy").parse(endDateStr);
		    } catch(Exception e) {
		    	e.printStackTrace();
		    }
		    System.out.println("startDate="+startDate);
		 	System.out.println("enddate="+endDate);
		   	System.out.println(location +","+startDateStr+","+endDateStr);
		 
		    Filter startDateFilter = new FilterPredicate("startdate",
		    											 FilterOperator.LESS_THAN_OR_EQUAL,
		    											 startDate);

		    Filter endDateFilter = new FilterPredicate("enddate",
		    											 FilterOperator.GREATER_THAN_OR_EQUAL,
		    											 endDate);
		    Filter isReservedFilter = new FilterPredicate("isReserved",
		    											  FilterOperator.EQUAL,
		    											  false);
		    
		    Query startDateQuery = new Query("UBCEECE417parkspot", dsKey).setFilter(startDateFilter);
			List<Entity> startDateResults = datastore.prepare(startDateQuery).asList(FetchOptions.Builder.withDefaults());
			
			Query endDateQuery = new Query("UBCEECE417parkspot", dsKey).setFilter(endDateFilter);
			List<Entity> endDateResults = datastore.prepare(endDateQuery).asList(FetchOptions.Builder.withDefaults());
			
			Query isReservedQuery = new Query("UBCEECE417parkspot", dsKey).setFilter(isReservedFilter);
			List<Entity> isReservedResults = datastore.prepare(isReservedQuery).asList(FetchOptions.Builder.withDefaults());
			
			List<Entity> spotsList = isReservedResults;
			if(startDate != null) {
				spotsList.retainAll(startDateResults);
			}
			if(endDate != null){
				spotsList.retainAll(endDateResults);
			}
			
			String responseHTMLString = "<h1 class=\"page-header\">Search Results</h1>";
			DateFormat df = new SimpleDateFormat("EEEE MM/dd/yyyy");
			
		    if(location != null){
		    	if(spotsList.isEmpty()) {
		    		responseHTMLString += "<p>Sorry, no matching results were found.</p>";
		    	} else {
		    		for(Entity spot : spotsList) {
		    			String sdStr = df.format(spot.getProperty("startdate"));
		    			String edStr = df.format(spot.getProperty("enddate"));
		    			String stNumber = (String) spot.getProperty("stNumber");
		    			System.out.println("stnum="+stNumber.toString());
		    			System.out.println(stNumber.toString()=="null");
	    		        String stName = (String) spot.getProperty("stName");
	    		        System.out.println("stname="+stName);
	    		        String nbhood = (String) spot.getProperty("neighborhood");
	    		        System.out.println("nbh="+nbhood);
	    		        String locality = (String) spot.getProperty("locality");
	    		        String adminLevel3 = (String) spot.getProperty("admin_level_3");
	    		        String adminLevel2 = (String) spot.getProperty("admin_level_2");
	    		        String adminLevel1 = (String) spot.getProperty("admin_level_1");
	    		        String country = (String) spot.getProperty("country");
		    			responseHTMLString += "<div class=\"panel panel-default\">";
		    			responseHTMLString += "<div class=\"panel-body\">";
		    			responseHTMLString += "<p class=\"lead\"><small> Location: <strong>";
		    			if(!stNumber.equals("null")) 
		    				responseHTMLString += stNumber + ", ";
		    			if(!stName.equals("null")) 
		    				responseHTMLString += stName + ", ";
		    			if(!nbhood.equals("null") && !nbhood.equals(""))
		    				responseHTMLString += nbhood + ", "; 
		    			if(!locality.equals("null") && !locality.equals(" "))
		    				responseHTMLString += locality + ", ";
		    			if(!adminLevel3.equals("null") && !adminLevel3.equals(""))
		    				responseHTMLString += adminLevel3 + ", ";
		    			if(!adminLevel2.equals("null") && !adminLevel2.equals(""))
		    				responseHTMLString += adminLevel2 + ", ";
		    			if(!adminLevel1.equals("null") && !adminLevel1.equals(""))
		    				responseHTMLString += adminLevel1 + " ";

		    			
		    			responseHTMLString += "</strong></small></p>";
		    			responseHTMLString += "<p class=\"lead\"><small class=\"pull-left\"> Available from <strong>"+sdStr+"</strong>"
		    								+ " to <strong>"+edStr+"</strong>"
		    								+ "</small> <small class=\"pull-right\"> @ <strong>$"+spot.getProperty("price")+"</strong> dollars per day</small></p></div>";
		    			responseHTMLString += "<div class=\"panel-footer\"><p><em>Hosted by: "+spot.getProperty("user")+"</em>"
		    								+ "<a class=\"btn btn-primary pull-right\" href=\"/spotdetails?id="+spot.getKey().getId()+"\" id=\"spot-"+spot.getKey().getId()+"\">"
		    								+ "Reserve This Spot!</a></p></div></div><hr />";
		    			
		    		}
		    	}
		    }
	        resp.setContentType("text/html");
	        //resp.setCharacterEncoding("UTF-8");
	        System.out.println(responseHTMLString);
	        resp.getWriter().println(responseHTMLString); 
	}    
}
