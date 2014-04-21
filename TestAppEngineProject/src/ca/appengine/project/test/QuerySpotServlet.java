package ca.appengine.project.test;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.CompositeFilter;
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
		    String neighborhood = (String) req.getParameter("neighborhood");
		    String locality = (String) req.getParameter("locality");
		    String aL2 = (String) req.getParameter("aL2");
		    String aL1 = (String) req.getParameter("aL1");
		    String aL3 = (String) req.getParameter("aL3");
		    String nationality = (String) req.getParameter("country");
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
		 
		    Filter startDateFilter = new FilterPredicate("startdate",
		    											 FilterOperator.LESS_THAN_OR_EQUAL,
		    											 startDate);

		    Filter endDateFilter = new FilterPredicate("enddate",
		    											 FilterOperator.GREATER_THAN_OR_EQUAL,
		    											 endDate);
		    Filter isReservedFilter = new FilterPredicate("isReserved",
		    											  FilterOperator.EQUAL,
		    											  false);
		    Filter neighborhoodFilter = new FilterPredicate("neighborhood", FilterOperator.EQUAL, neighborhood);
		    Filter localityFilter = new FilterPredicate("locality", FilterOperator.EQUAL, locality);
		    Filter aL2Filter = new FilterPredicate("admin_level_2", FilterOperator.EQUAL, aL2);
		    Filter aL3Filter = new FilterPredicate("admin_level_3", FilterOperator.EQUAL, aL3);
		    Filter aL1Filter = new FilterPredicate("admin_level_1", FilterOperator.EQUAL, aL1);
		    Filter nationalityFilter = new FilterPredicate("country", FilterOperator.EQUAL, nationality);
		    
		    
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
			
			Query nationalityQuery = new Query("UBCEECE417parkspot", dsKey).setFilter(nationalityFilter);
	    	List<Entity> nationalityResults = datastore.prepare(nationalityQuery).asList(FetchOptions.Builder.withDefaults());
			
			Query neighborhoodQuery = new Query("UBCEECE417parkspot", dsKey).setFilter(neighborhoodFilter);
		    List<Entity> neighborhoodResults = datastore.prepare(neighborhoodQuery).asList(FetchOptions.Builder.withDefaults());
		    
	    	Query localityQuery = new Query("UBCEECE417parkspot", dsKey).setFilter(localityFilter);
		    List<Entity> localityResults = datastore.prepare(localityQuery).asList(FetchOptions.Builder.withDefaults());

	    	Query aL2Query = new Query("UBCEECE417parkspot", dsKey).setFilter(aL2Filter);
	    	List<Entity> aL2Results= datastore.prepare(aL2Query).asList(FetchOptions.Builder.withDefaults());

	    	Query aL1Query = new Query("UBCEECE417parkspot", dsKey).setFilter(aL1Filter);
	    	List<Entity> aL1Results= datastore.prepare(aL1Query).asList(FetchOptions.Builder.withDefaults());

	    	Query aL3Query = new Query("UBCEECE417parkspot", dsKey).setFilter(aL3Filter);
	    	List<Entity> aL3Results= datastore.prepare(aL3Query).asList(FetchOptions.Builder.withDefaults());
		    
			List<Entity> locationList = null;
			if(!neighborhood.equals("null")) {
				System.out.println("nbd");
				locationList = neighborhoodResults;
			}
			else if(!locality.equals("null")) {
				System.out.println("loc");
				locationList = localityResults;
			}
			else if(!aL3.equals("null")) {
				System.out.println("al3");
				locationList = aL3Results;
			}
			else if(!aL2.equals("null")) {
				System.out.println("al2");
				locationList = aL2Results;
			}
			else if(!aL1.equals("null")) {
				System.out.println("al1");
				locationList = aL1Results;
			}
			else if(!nationality.equals("null")) {
				System.out.println("country");
				locationList = nationalityResults;
			}
			// combine lists
			spotsList.retainAll(locationList);    
			
			String responseHTMLString = "<h1 class=\"page-header\">Search Results</h1>";
			DateFormat df = new SimpleDateFormat("EEEE MM/dd/yyyy");
			
		  
	    	if(spotsList.isEmpty()) {
	    		responseHTMLString += "<p>Sorry, no matching results were found.</p><hr>";
	    	} else {
	    		for(Entity spot : spotsList) {
	    			System.out.println(spot);
	    			String sdStr = df.format(spot.getProperty("startdate"));
	    			String edStr = df.format(spot.getProperty("enddate"));
	    			String stNumber = (String) spot.getProperty("stNumber");
    		        String stName = (String) spot.getProperty("stName");
    		        String nbhood = (String) spot.getProperty("neighborhood");
    		        String loc = (String) spot.getProperty("locality");
    		        String adminLevel3 = (String) spot.getProperty("admin_level_3");
    		        String adminLevel2 = (String) spot.getProperty("admin_level_2");
    		        String adminLevel1 = (String) spot.getProperty("admin_level_1");
    		        String country = (String) spot.getProperty("country");
	    			responseHTMLString += "<div class=\"panel panel-default\">";
	    			responseHTMLString += "<div class=\"panel-body\">";
	    			responseHTMLString += "<p class=\"lead\"><font color=\"#428BCA\">Location: <strong>";
	    			String addrString = "";
	    			if(!stNumber.equals("null")) {
	    				responseHTMLString += stNumber + ", ";
	    				addrString += stNumber + ", ";
	    			}
	    			if(!stName.equals("null"))  {
	    				responseHTMLString += stName + ", ";
	    				addrString += stName + ", ";
	    			}
	    			if(!nbhood.equals("null") && !nbhood.equals("")) {
	    				responseHTMLString += nbhood + ", "; 
    					addrString += nbhood + ", ";
	    			}
	    			if(!loc.equals("null") && !loc.equals("")) {
	    				responseHTMLString += loc + ", ";
    					addrString += loc + ", ";
	    			}
	    			if(!adminLevel3.equals("null") && !adminLevel3.equals("")) {
	    				responseHTMLString += adminLevel3 + ", ";
	    				addrString += adminLevel3 + ", ";
	    			}
	    			if(!adminLevel2.equals("null") && !adminLevel2.equals("")) {
	    				responseHTMLString += adminLevel2 + ", ";
	    				addrString += adminLevel2 + ", ";
	    			}
	    			if(!adminLevel1.equals("null") && !adminLevel1.equals("")) {
	    				responseHTMLString += adminLevel1 + ", ";
	    				addrString += adminLevel1 + ", ";
	    			}
	    			if(!country.equals("null") && !country.equals("")) {
	    				responseHTMLString += country + " ";
	    				addrString += country + " ";
	    			}

	    			responseHTMLString += "</strong></font></p>";
	    			responseHTMLString += "<p class=\"lead\"><small class=\"pull-left\"> Available from <strong>"+sdStr+"</strong>"
	    								+ " to <strong>"+edStr+"</strong>"
	    								+ "</small> <small class=\"pull-right\"> @ <font color=\"#5CB65C\"><strong>$"+spot.getProperty("price")+"</strong> per day</font></small></p></div>";
	    			responseHTMLString += "<div class=\"panel-footer\"><p><em>Hosted by: "+spot.getProperty("user")+"</em>"
	    								+ "<a class=\"btn btn-primary pull-right\" href=\"/spotdetails?id="+spot.getKey().getId()+"\" id=\"spot-"+spot.getKey().getId()+"\">"
	    								+ "Reserve This Spot!</a></p></div></div>";
	    			
	    			responseHTMLString += "<input type=\"hidden\" class=\"result-address\" value=\""+addrString+"\">";

	    		}
	    		responseHTMLString += "<hr/>";
	    	}
		    
	        resp.setContentType("text/html");
	        //resp.setCharacterEncoding("UTF-8");
	        System.out.println(responseHTMLString);
	        resp.getWriter().println(responseHTMLString); 
	}    
}
