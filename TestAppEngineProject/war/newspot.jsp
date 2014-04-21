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
<link rel="stylesheet"
	href="/stylesheets/jquery-ui-1.10.4.custom/css/flick/jquery-ui-1.10.4.custom.css">
<script
	src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script type="text/javascript" src="/javascripts/main.js"></script>
<script
	src="/stylesheets/jquery-ui-1.10.4.custom/js/jquery-ui-1.10.4.custom.js"></script>
<script type="text/javascript"
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAQGlrb5YtgGtV96Hi5efMuc5z7osDvSeY&sensor=true">
    </script>
<script type="text/javascript"
	src="/stylesheets/bootstrap/js/bootstrap.js"></script>
<script type="text/javascript"> 
    	window.onload = lg;	
    	var daysToAdd = 1; //force the spot to be available for at least a day
    	
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
	        	{
		        	var dtMax = new Date();
		            dtMax.setDate(dtMax.getDate() + daysToAdd); 
		            var dd = dtMax.getDate();
		            var mm = ('0' + (dtMax.getMonth()+1)).slice(-2);
		            var y = dtMax.getFullYear();
	            	var dtFormatted = mm + '/'+ dd + '/'+ y;
	        		$("#enddate").datepicker("option", "minDate", dtFormatted);
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
	        		$("#startdate").datepicker("option", "maxDate", null);
	        }
	    });
	});
   
   
    function validate(evt) {
  		var theEvent = evt || window.event;
		var key = theEvent.keyCode || theEvent.which;
		key = String.fromCharCode( key );
		var regex = /[0-9]|\./;
		if( !regex.test(key) ) {
	 		theEvent.returnValue = false;
	    	if(theEvent.preventDefault) 
	    		theEvent.preventDefault();
		}
	}
    
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
	    /** ----------------- **/
	    
	function initialize() {

		var mapOptions = {
			center: new google.maps.LatLng(48, -100),	
			zoom: 12
		};

		map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);		
		setPosition(map, "map");

<<<<<<< HEAD
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
			
=======
>>>>>>> 6035c15d298ed0e51d3c81c9ce58747d0d96b615
		// Open info window everywhere we click on the map
	    var clickedSpotInfoWind = new google.maps.InfoWindow();
		geocoder = new google.maps.Geocoder();
	    google.maps.event.addListener(map, 'click', function(event) {
									  if (globalInfoWind != null) {
										  globalInfoWind.close();
									  }
									  var newSpotAddr;
									  newSpotLatLng = event.latLng;
										  geocoder.geocode({'latLng': newSpotLatLng}, function(results, status) {
											  if (status == google.maps.GeocoderStatus.OK) {
												  clickedSpotInfoWind.setContent(results[0].formatted_address);
												  clickedSpotInfoWind.setPosition(newSpotLatLng);
												  clickedSpotInfoWind.open(map);
					                              globalInfoWind = clickedSpotInfoWind;
											  }
										  });
		});
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
	<%@ include file="navbar" %>
	<!-- Don't insert code above this line (unless it's Javascript or imports etc)-->
	
	
	<div class="container">
		<h1 class="page-header">List a Spot</h1>
		<div class="row">
			<div class="col-lg-8">
				<div id="map-canvas"></div>
			</div>
			<div class="col-lg-4">
				<div class="search-container">
					<div class="well" align="center">
							<div class="input-group form-group">
							    <span class="input-group-addon">Address</span>
								<input type="text" class="form-control" name="location"
									id="location" placeholder="e.g.123 Broadway St., Vancouver" onblur="checkInputAddr()">
							</div>
							<div class="input-group form-group">
								<span class="input-group-addon"><span
									class="glyphicon glyphicon-calendar"></span></span> <input type="text"
									class="form-control" name="startdate" id="startdate"
									placeholder="From">
							</div>
							<div class="input-group form-group">
								<span class="input-group-addon"><span
									class="glyphicon glyphicon-calendar"></span></span> <input type="text"
									class="form-control" name="enddate" id="enddate"
									placeholder="To">
							</div>
							<div class="input-group form-group">
								<span class="input-group-addon">$</span> <input type="number"
									class="form-control" name="price" id="price"
									placeholder="Price" onkeypress='validate(event)'>
							</div>
							<input id="post-btn" class="btn btn-success text-center"
								type="submit" value="Submit" onclick="newSpotAjaxRequest()" />
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
