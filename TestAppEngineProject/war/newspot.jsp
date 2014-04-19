<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" /> 
    <meta charset="utf-8">       
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
    <link type="text/css" rel="stylesheet" href="/stylesheets/bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">    
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script type="text/javascript" src="/javascripts/main.js"></script>     
 	<script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>    
    <script type="text/javascript"
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAQGlrb5YtgGtV96Hi5efMuc5z7osDvSeY&sensor=true">
    </script>
    <script type="text/javascript"> 
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
    <nav class="navbar navbar-default" role="navigation">
	  <div class="container-fluid">
	    <!-- Brand and toggle get grouped for better mobile display -->
	    <div class="navbar-header">
	      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
	        <span class="sr-only">Toggle navigation</span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	        <span class="icon-bar"></span>
	      </button>
	      <a class="navbar-brand" href="/home.jsp">ParkSpot</a>
	    </div>
	
	    <!-- Collect the nav links, forms, and other content for toggling -->
	    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
	      <ul class="nav navbar-nav">
	        <li><a href="/newspot.jsp">List Your Spot</a></li>
	      </ul>
	      <form class="navbar-form navbar-left" role="search">
	        <div class="form-group">
	          <input type="text" class="form-control" placeholder="Search">
	        </div>
	        <button type="submit" class="btn btn-default">Submit</button>
	      </form>
	      <ul class="nav navbar-nav navbar-right">
	        <li><a href="#">Link</a></li>
	      </ul>
	    </div><!-- /.navbar-collapse -->
	  </div><!-- /.container-fluid -->
	</nav>
	<div class="container">
	<div class="row">
	  <div class="col-lg-8">
	    <div id="map-canvas"></div>
	  </div>
	  <div class="col-lg-4">
	    <div class="search-container">
	    <div class="well" align="center">
	      <form action="" method="post" class="form">
	         <div class="form-group">
               <input type="text" class="form-control" name="location" id="location" placeholder="Enter a city" >
             </div>
             <div class="input-group form-group">
               <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span> 
               <input type="text" class="form-control" name="startdate" id="startdate" placeholder="From" >
             </div>
             <div class="input-group form-group">
               <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span> 
               <input type="text" class="form-control" name="endate" id="enddate" placeholder="To" >
             </div>
             <div class="input-group form-group">
               <span class="input-group-addon">$</span> 
               <input type="text" class="form-control" name="price" id="price" placeholder="Price">
             </div>
       	     <input id="post-btn" class="btn btn-success text-center" type="submit" value="Submit" align="center" onclick="newSpotAjaxRequest()"/>
          </form>
        </div>
        </div>
	  </div>
	 </div> 
	 </div>
  </body>
</html>