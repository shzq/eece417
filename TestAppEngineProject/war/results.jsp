<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ page
	import="com.google.appengine.api.datastore.Query.FilterPredicate"%>
<%@ page import="com.google.appengine.api.datastore.Query.Filter"%>
<%@ page
	import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page
	import="com.google.appengine.api.datastore.Query.CompositeFilterOperator"%>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.ParseException"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DateFormat"%>

<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<meta charset="utf-8">
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
<link type="text/css" rel="stylesheet"
	href="/stylesheets/bootstrap/css/bootstrap.css" />
	<style>body {
        padding-top: 60px;
        padding-bottom: 60px;
    }</style>
<link rel="stylesheet"
	href="/stylesheets/jquery-ui-1.10.4.custom/css/flick/jquery-ui-1.10.4.custom.css">
<script
	src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script type="text/javascript" src="/javascripts/main.js"></script>
<script
	src="/stylesheets/jquery-ui-1.10.4.custom/js/jquery-ui-1.10.4.custom.js"></script>
<script type="text/javascript"
	src="/stylesheets/bootstrap/js/bootstrap.js"></script>
<script type="text/javascript"
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAQGlrb5YtgGtV96Hi5efMuc5z7osDvSeY&sensor=true">
    </script>
<script type="text/javascript">

	/** Global Variables for results.jsp **/
    window.onload = lg;
    var daysToAdd = 0;
    var querySpotGeocoder;
    /** -------------------------------- **/
    	
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
		
		var today = new Date();
		var tdd = today.getDate();
		var tmm = ('0' + (today.getMonth()+1)).slice(-2);
		var ty = today.getFullYear();
		var tdformat = tmm + '/'+ tdd + '/'+ ty;
		console.log(tmm);
		console.log(tdformat);
		$("#startdate").datepicker("option", "minDate", tdformat);
		//leave line below commented until search can function with a set begin date and all other fields blank
		document.getElementById("startdate").value = tdformat;
		
		//change date to date+1 for minimum date of the end date
		today.setDate(today.getDate() + daysToAdd);
		tdd = today.getDate();
		tmm = ('0' + (today.getMonth()+1)).slice(-2);
		ty = today.getFullYear();
		tdformat = tmm + '/'+ tdd + '/'+ ty;
		$("#enddate").datepicker("option", "minDate", tdformat);		
    }    
   
   	$(document).ready(function () {
	    
	    var today = new Date();
	    var tdd = today.getDate();
	    var tmm = today.getMonth()+1;
	    var ty = today.getFullYear();
	    var tdformat = tmm + '/'+ tdd + '/'+ ty;
	    $("#startdate").datepicker({
	        onSelect: function (selected) {
	            var dtMax = new Date(selected);
	            dtMax.setDate(dtMax.getDate() + daysToAdd); 
	            var dd = dtMax.getDate();
	           	var mm = ('0' + (dtMax.getMonth()+1)).slice(-2);
	            var y = dtMax.getFullYear();
	            var dtFormatted = mm + '/'+ dd + '/'+ y;
	            if(dtMax < today)
	            {
	            	$("#startdate").datepicker("option", "minDate", tdformat);
	            }
            	$("#enddate").datepicker("option", "minDate", dtFormatted);
	        },
			onClose: function (selected) {
	        	if(selected=="")
					$("#enddate").datepicker("option", "minDate", tdformat);
	        }
	    });
	    
	    $("#enddate").datepicker({
	        onSelect: function (selected) {
	            var dtMax = new Date(selected);
	            dtMax.setDate(dtMax.getDate() - daysToAdd); 
	            var dd = dtMax.getDate();
	            var mm = ('0' + (dtMax.getMonth()+1)).slice(-2);
	            var y = dtMax.getFullYear();
	            var dtFormatted = mm + '/'+ dd + '/'+ y;
	            $("#startdate").datepicker("option", "maxDate", dtFormatted);
	        },
	        onClose: function (selected) {
	        	if(selected=="")
	        		$("#startdate").datepicker("option", "maxDate", null);
	        }
	    });
	});
    
	function initialize() {
	   
		querySpotGeocoder = new google.maps.Geocoder();
		
		var mapOptions = {
			center: new google.maps.LatLng(48, -100),
	  		zoom: 12
		};
		
		map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
		setPosition(map, "map");

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
	}
	
	function setPosition(obj, type) {
		console.log("getting location");
		var pos;

		// Try HTML5 geolocation
		if(navigator.geolocation) {

			navigator.geolocation.getCurrentPosition(function(position) {
 	       	pos = new google.maps.LatLng(position.coords.latitude,
 	                                   position.coords.longitude);
 	       if(type == "map") {
 	    	obj.setCenter(pos);
 	       } 
 
 	       $("#latitude").val((position.coords.latitude));
 	       $("#longitude").val((position.coords.longitude));
 	    }, function() {
 	      pos = handleNoGeolocation(true);
 	      obj.setCenter(pos);
 	      obj.setZoom(3);
 	    });
 	  } else {
 	    // Browser doesn't support Geolocation
 	    pos = handleNoGeolocation(false);
 	    obj.setCenter(pos);
 	    obj.setZoom(3);
 	  }
	}
	
	function handleNoGeolocation(errorFlag) {
	   	  if (errorFlag) {
	   	    var content = 'Error: The Geolocation service failed.';
	   	  } else {
	   	    var content = 'Error: Your browser doesn\'t support geolocation.';
	   	  }
		  var pos = new google.maps.LatLng(48, -100);
	   	  return pos;
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
	<%@ include file="navbar"%>
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
							type="submit" value="Search" onclick="querySpotsAjaxRequest()"/>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="container" id="search-result-container">
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
    			DateFormat df = new SimpleDateFormat("EEEE MM/dd/yyyy");
    			String sdStr = df.format(spot.getProperty("startdate"));
    			String edStr = df.format(spot.getProperty("enddate"));
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
    			pageContext.setAttribute("spotID", spot.getKey().getId());
    			pageContext.setAttribute("host", spot.getProperty("user"));
    			pageContext.setAttribute("resultsStartDate", sdStr);
    			pageContext.setAttribute("resultsEndDate", edStr);
    			pageContext.setAttribute("resultsPrice", spot.getProperty("price"));
    			pageContext.setAttribute("resultsLocation", locationString);
   		%>
		<div class="panel panel-default">
			<div class="panel-body">
				<p class="lead">
					<small> Location: <strong>${fn:escapeXml(resultsLocation)}</strong>
					</small>
				</p>
				<p class="lead">
					<small class="pull-left"> Available from <strong>${fn:escapeXml(resultsStartDate)}</strong>
						to <strong>${fn:escapeXml(resultsEndDate)}</strong>
					</small> <small class="pull-right"> @ <strong>$
							${fn:escapeXml(resultsPrice)}</strong> per day
					</small>
				</p>
			</div>
			<div class="panel-footer">
				<p>
					<em>Hosted by: ${fn:escapeXml(user.nickname)}</em> <a
						class="btn btn-primary pull-right"
						href="/spotdetails?id=${fn:escapeXml(spotID)}"
						id="spot-${fn:escapeXml(spotID)}" >Reserve This Spot!</a>
				</p>

			</div>
		</div>
		<%	
    		}
    	}
		%>
		<hr/>
		<%
    }
    	
	%>

	</div>

	<!-- Don't insert code below this line -->
	<%
    }
	 %>
</body>
</html>
