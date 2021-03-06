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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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
    }</style>
<link rel="stylesheet" href="/stylesheets/jquery-ui-1.10.4.custom/css/flick/jquery-ui-1.10.4.custom.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script type="text/javascript" src="/javascripts/main.js"></script>
<script src="/stylesheets/jquery-ui-1.10.4.custom/js/jquery-ui-1.10.4.custom.js"></script>
<script type="text/javascript" src="/stylesheets/bootstrap/js/bootstrap.js"></script>
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAQGlrb5YtgGtV96Hi5efMuc5z7osDvSeY&sensor=true">
<script type="text/javascript" src="/stylesheets/bootstrap/js/bootstrap.js"></script>
<script type="text/javascript"> 
    window.onload = lg;	
    /** Global Variables **/
    var globalInfoWind = null;
    var newSpotLatLng;
    var geocoder;
	var myGeocodeStat;
    var addrMarkers = [];
    var addrInfoWindows = [];
    var newSpotMarker = null;
    var newSpotInfoWind;
    var newSpotResults = [];
    var newSpot = null;
    var showNewSpots = true;
    
    var daysToAdd = 0;
    
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

		if(checkOK())
		{
			if(istodaylater())
			{
				var today = new Date();
			    var tdd = today.getDate();
			    var tmm = ('0' + (today.getMonth()+1)).slice(-2);
			    var ty = today.getFullYear();
			    var tdformat = tmm + '/'+ tdd + '/'+ ty;
				$("#startdate").datepicker("option", "minDate", tdformat);
				$("#enddate").datepicker("option", "minDate", tdformat);
				document.getElementById("startdate").value = tdformat;
			}
			else
			{
				$("#startdate").datepicker("option", "minDate", "${fn:escapeXml(startdate)}");
				$("#enddate").datepicker("option", "minDate", "${fn:escapeXml(startdate)}");
				document.getElementById("startdate").value = "${fn:escapeXml(startdate)}";
			}
			$("#startdate").datepicker("option", "maxDate", "${fn:escapeXml(enddate)}");
			$("#enddate").datepicker("option", "maxDate", "${fn:escapeXml(enddate)}");
			}
		else
		{
			alert("The last reservable date has passed, this spot is unavailable");
			document.getElementById("reserve-btn").disabled = true;
			document.getElementById("startdate").disabled = true;
			document.getElementById("enddate").disabled = true;
		}
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
	        	{
		        	if(istodaylater())
						$("#enddate").datepicker("option", "minDate", tdformat);
	        		else
		        		$("#enddate").datepicker("option", "minDate", "${fn:escapeXml(startdate)}");
	        	}
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
	        		$("#startdate").datepicker("option", "maxDate", "${fn:escapeXml(enddate)}");
	        }
	    });
	});
	
	// function checks which date is later: today or available start date,
	// then uses the later date as a minimum threshold for reservations
	function istodaylater() {
		var today = new Date();		    
	    var start = new Date("${fn:escapeXml(startdate)}");
	    
	    if(start < today)
	    	return true;
	    else
	    	return false;
	}

	// checks whether today's date is before the available end date.
	// returns false if available end date has passed (can't reserve 
	// a spot whose last available date has ended)
	function checkOK(){
		var today = new Date();		    
	    var end = new Date("${fn:escapeXml(enddate)}");
	    
	    if(today <= end)
			return true;
		else
			return false;
	}
	
	function goback()
	{
		window.history.back();
	}
    
	function initialize() {
		
		var mapOptions = {
		  zoom: 12
		};

		map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);		

		// Open info window everywhere we click on the map
	    var clickedSpotInfoWind = new google.maps.InfoWindow();
		geocoder = new google.maps.Geocoder();
  
		displayInputAddr();

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
 	      console.log("can't detect");
 	      pos = handleNoGeolocation(true);
 	      obj.setCenter(pos);
 	      obj.setZoom(4);
 	    });
 	  } else {
 		console.log("no support");
 	    // Browser doesn't support Geolocation
 	    pos = handleNoGeolocation(false);
 	    obj.setCenter(pos);
 	    obj.setZoom(4);
 	  }
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
		<h1 class="page-header">Spot Details</h1>
		<div class="row">
			<div class="col-lg-8">
				<div id="map-canvas"></div>
			</div>
			<div class="col-lg-4">
				<div class="container">
					<div class="well" align="center">
						<div class="panel panel-default">
							<div class="panel-heading">
								<h3 class="panel-title" style="text-align: left">Host</h3>
							</div>
							<div class="panel-body" style="text-align: left">
								${fn:escapeXml(host)}</div>
						</div>
						<div class="panel panel-default">
							<div class="panel-heading">
								<h3 class="panel-title" style="text-align: left">Location</h3>
							</div>
							<div class="panel-body" style="text-align: left">
								${fn:escapeXml(location)}</div>
						</div>
						<div class="panel panel-default">
							<div class="panel-heading">
								<h3 class="panel-title" style="text-align: left">Availability</h3>
							</div>
							<div class="panel-body" style="text-align: left">
								${fn:escapeXml(startdate)}  to  ${fn:escapeXml(enddate)}</div>
						</div>
						<div class="input-group form-group">
							<span class="input-group-addon">From:</span> <input type="text"
								class="form-control" name="startdate" id="startdate"
								placeholder="From" value=""> <span
								class="input-group-addon"><span
								class="glyphicon glyphicon-calendar"></span></span>
						</div>
						<div class="input-group form-group">
							<span class="input-group-addon">To:&nbsp&nbsp&nbsp&nbsp</span> <input
								type="text" class="form-control" name="enddate" id="enddate"
								placeholder="To" value="" /> <span class="input-group-addon"><span
								class="glyphicon glyphicon-calendar"></span></span>
						</div>
						<div class="panel panel-default">
							<div class="panel-heading">
								<h3 class="panel-title" style="text-align: left">Price</h3>
							</div>
							<div class="panel-body" style="text-align: left">
								$ ${fn:escapeXml(price)} per day</div>
						</div>
						<button id="back-btn" class="btn btn-success text-center"
							type="submit"value="Back" onclick="goback()">Back</button>
						<input id="reserve-btn" class="btn btn-primary text-center"
							value="Reserve Spot" onclick="newReservationAjaxRequest()" type="submit"/> <input
							id="price" type="hidden" value="${fn:escapeXml(price)}" /> <input
							id="spotID" type="hidden" value="${fn:escapeXml(spotID)}" /> <input
							id="location" type="hidden" value="${fn:escapeXml(location)}" />

					</div>
				</div>
			</div>
		</div>
	</div>


	<!-- Don't insert code below this line -->
	<%
    }
	 %>
</body>
</html>
