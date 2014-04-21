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
		console.log("checking1");
		if ($("#location").val() != "") {
   			console.log("search from home page!!!!!");
   			querySpotsAjaxRequest();
   		}
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
	<div class="container" id="search-result-container"></div>

	<!-- Don't insert code below this line -->
	<%
    }
	 %>
</body>
</html>
