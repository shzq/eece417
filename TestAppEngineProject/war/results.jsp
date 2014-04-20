<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.Query.CompositeFilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.io.IOException"%>
<%@ page import="java.text.SimpleDateFormat" %> 
<%@ page import="java.text.ParseException" %> 
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DateFormat"%> 

<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<meta charset="utf-8">
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
<link type="text/css" rel="stylesheet"
	href="/stylesheets/bootstrap/css/bootstrap.min.css" />
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
<script
	src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script type="text/javascript" src="/javascripts/main.js"></script>
<script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
<script type="text/javascript" src="/stylesheets/bootstrap/js/bootstrap.js"></script>
<script type="text/javascript"
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAQGlrb5YtgGtV96Hi5efMuc5z7osDvSeY&sensor=true">
    </script>
<script type="text/javascript"> 
    window.onload = lg;	
    	function lg()
    	{
    		<%
    		UserService userService = UserServiceFactory.getUserService();
			User user = userService.getCurrentUser();
	
			if (user == null) {%>
				alert("Please log in before using ParkSpot");
				window.location.href = "login.jsp";
			<%
			}
			%>
	    }
	    
	    $(function() {
	    	$( "#startdate" ).datepicker();
	    });
	    $(function() {
	    	$( "#enddate" ).datepicker();
	    });
		function initialize() {
					
			var myLatlng = new google.maps.LatLng(37.33152141760375,-122.04732071026367);   
		   
			var mapOptions = {
			  center: myLatlng,
			  zoom: 12
			};
			
			map = new google.maps.Map(document.getElementById("map-canvas"),
			  mapOptions);		
						
			var mrkID = "0";
			var gstBkNm = guestbookNameString; //"default";
			var msgbox = "msgbox_" + mrkID;	
			var msglist = "msglist_" + mrkID;
									
			var contentString  = '#' + mrkID + '<div id="content">' +  	
			  '<div class="msglist" id="'+ msglist +'"></div>' + '</div>' +
			  '<textarea class="msgbox" id="'+ msgbox +'" rows="2" cols="20"></textarea>' +			  
			  '<input type="button" value="Post" onclick="postAjaxRequest('+ 
				"'" + msgbox + "', '" + mrkID + "', '" + gstBkNm + "', '" + msglist + "'" +')"/>';  
			
			var infowindow = new google.maps.InfoWindow({
			  content: contentString
			}); 
			
			var iconBase = 'https://maps.google.com/mapfiles/kml/shapes/';
			var icons = {
  				parking: {
    				icon: iconBase + 'parking_lot_maps.png'
  				},
  				library: {
    				icon: iconBase + 'library_maps.png'
  				},
  				info: {
    				icon: iconBase + 'info-i_maps.png'
  				}
			};
						   
			var marker = new google.maps.Marker({       
			  position: myLatlng,
			  map: map,
			  icon: icons['parking'].icon,			  
			  title: 'Custom Marker!'
			});    
			
			google.maps.event.addListener(marker, 'click', function() {
			  selectedMarkerID = mrkID;  	
			  infowindow.open(map, marker);
			  getAjaxRequest();   
			});        
					
			// Load the selected markers			
			loadMarkers();       
		}      
 	
		google.maps.event.addDomListener(window, 'load', initialize);
    </script>
</head>
<body>
	<%
    userService = UserServiceFactory.getUserService();
    user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
	%>
	<%@ include file="navbar" %>
	<!-- Don't insert code above this line (unless it's Javascript or imports etc)-->
	
	<div class="container">
	    <h1 class="page-header">Find a Spot</h1>
		<div class="row">
			<div class="col-lg-8">
				<div id="map-canvas"></div>
			</div>
			<div class="col-lg-4">
				<div class="search-container">
					<div class="well" align="center">
						<form action="/results" method="get" class="form">
							<div class="form-group">
								<input type="text" class="form-control" name="location"
									id="location" placeholder="Enter a city"
									value="${fn:escapeXml(location)}">
							</div>
							<div class="input-group form-group">
								<span class="input-group-addon"><span
									class="glyphicon glyphicon-calendar"></span></span> <input type="text"
									class="form-control" name="startdate" id="startdate"
									placeholder="From" value="${fn:escapeXml(startdate)}">
							</div>
							<div class="input-group form-group">
								<span class="input-group-addon"><span
									class="glyphicon glyphicon-calendar"></span></span> <input type="text"
									class="form-control" name="enddate" id="enddate"
									placeholder="To" value="${fn:escapeXml(enddate)}">
							</div>
							<input id="post-btn" class="btn btn-success text-center"
								type="submit" value="Search"/>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="container">
	<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key dsKey = KeyFactory.createKey("UBCEECE417parkspot", "parkspot");
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
    String location = (String) request.getParameter("location");
    String startDateStr = (String) request.getAttribute("startdate");
    String endDateStr = (String) request.getAttribute("enddate");
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
    
    Query startDateQuery = new Query("UBCEECE417parkspot", dsKey).setFilter(startDateFilter);
	List<Entity> startDateResults = datastore.prepare(startDateQuery).asList(FetchOptions.Builder.withDefaults());
	
	Query endDateQuery = new Query("UBCEECE417parkspot", dsKey).setFilter(endDateFilter);
	List<Entity> endDateResults = datastore.prepare(endDateQuery).asList(FetchOptions.Builder.withDefaults());
	
	List<Entity> spotsList = startDateResults;
	if(startDate == null) {
		spotsList = endDateResults;
	}
	else if(endDate != null){
		spotsList.retainAll(endDateResults);
	}
	
    if(location != null)
    {
    %>
      <h1 class="page-header">Search Results</h1>
    <%
    	if(spotsList.isEmpty())
    	{
    	%>
    	 <p>Sorry, no matching results were found.</p>
    	<%
    	}
    	else 
    	{
    		for(Entity spot:spotsList) 
    		{
    			System.out.print(spot.toString());
    			System.out.print(spot.getKey());
    			DateFormat df = new SimpleDateFormat("EEEE MM/dd/yyyy");
    			String sdStr = df.format(spot.getProperty("startdate"));
    			String edStr = df.format(spot.getProperty("enddate"));
    			pageContext.setAttribute("spotID", spot.getKey().getId());
    			pageContext.setAttribute("host", spot.getProperty("user"));
    			pageContext.setAttribute("resultsStartDate", sdStr);
    			pageContext.setAttribute("resultsEndDate", edStr);
    			pageContext.setAttribute("resultsPrice", spot.getProperty("price"));
    			pageContext.setAttribute("resultsLocation", spot.getProperty("location"));
   		%>
       	 <div class="panel panel-default">
		   <div class="panel-body">
		   	 <p class="lead">
		   	   <small>
		   	     Location: <strong>${fn:escapeXml(resultsLocation)}</strong>
		   	   </small>
		   	 </p>
		     <p class="lead">
		        <small class="pull-left">
		     	  Available from <strong>${fn:escapeXml(resultsStartDate)}</strong> to <strong>${fn:escapeXml(resultsEndDate)}</strong>
		     	</small>
		     	<small class="pull-right"> @ <strong>$ ${fn:escapeXml(resultsPrice)}</strong> per day</small>
		     </p>
		   </div>
		   <div class="panel-footer">
		     <p>
		       <em>Hosted by: ${fn:escapeXml(user.nickname)}</em>
		       <a class="btn btn-primary pull-right" href="/spotdetails?id=${fn:escapeXml(spotID)}" id="spot-${fn:escapeXml(spotID)}">Reserve This Spot!</a>
		     </p>
		     
		   </div>
		 </div>
       	<%	
    		}
    	}
    }
    	
	%>
	 
	  <hr/>
	</div>
	
	<!-- Don't insert code below this line -->
	<%
    }
	 %>
</body>
</html>