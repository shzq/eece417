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
    <script type="text/javascript" src="/javascripts/main.js"></script>        
    <script type="text/javascript"
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAQGlrb5YtgGtV96Hi5efMuc5z7osDvSeY&sensor=true">
    </script>    
    <script type="text/javascript"> 
    	
    /** Global Variables **/
    var newSpotCount = 0;
    var newSpotLatLng;
    var map;
    var globalInfoWind = null;
    // for now assume the spots prices are stored in an array according to their spot number
    var prices = [];
    var dynAddedMarker = [];
    
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
			
			
			// Set info window anywhere the mouse click
		    var addSpotInfoWind = new google.maps.InfoWindow();
			var geocoder = new google.maps.Geocoder();
		    google.maps.event.addListener(map, 'click', function(event) {
										  if (globalInfoWind != null) {
											  globalInfoWind.close();
										  }
										  var newSpotAddr;
										  newSpotLatLng = event.latLng;
										  geocoder.geocode({'latLng': newSpotLatLng}, function(results, status){
											  if (status == google.maps.GeocoderStatus.OK) {
												  if (results[1]) {
													  newSpotAddr = results[1].formatted_address;
													  var chooseNewSpotContent = newSpotAddr + '<br><input type="button" value="Add a Spot Here!" onclick="ShowAddSpot()""/>';
					                                  addSpotInfoWind.setContent(chooseNewSpotContent);
					                                  addSpotInfoWind.setPosition(newSpotLatLng);
					                                  addSpotInfoWind.open(map);
					                                  globalInfoWind = addSpotInfoWind;
												  }
											  }
											  
		                                  }); 
		    });
		    
			// Load the selected markers			
			loadMarkers();       
		}      
 	
		google.maps.event.addDomListener(window, 'load', initialize);
    </script>
    
  </head>
  <body>
    
<%
    String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "default";
    }
    pageContext.setAttribute("guestbookName", guestbookName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
    } else {
%>
<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to include your name with greetings you post.</p>
<%
    }
%>
<p>Guestbook: ${fn:escapeXml(guestbookName)}</p>

<script type="text/javascript">guestbookNameString = "${fn:escapeXml(guestbookName)}";</script>
<!--<script type="text/javascript">alert(guestbookNameString);</script>-->

<!-- Original -->
<div id=oldMsgList>
<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
    
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
    
    Query query = new Query("Greeting", guestbookKey).addSort("date", Query.SortDirection.DESCENDING);
    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(10));
    
    if (greetings.isEmpty()) {
        %>
        <p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p>
        <%
    } else {
        %>
        <p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p>
        <%
        for (Entity greeting : greetings) {
            pageContext.setAttribute("greeting_content",
                                     greeting.getProperty("content"));
            if (greeting.getProperty("user") == null) {
                %>
                <p><b>An anonymous person wrote:</b></p>
                <%
            } else {
                pageContext.setAttribute("greeting_user",
                                         greeting.getProperty("user"));
                %>
                <p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>
                <%
            }
            %>
            <blockquote>${fn:escapeXml(greeting_content)}</blockquote>
            <%
        }
    }
%>

    <form action="/sign" method="post">
      <div><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Post Greeting" /></div>
      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
    </form>
    
</div> 
<!-- Original -->

	<div class="side-panel">
		<div class="panel" id="panel1">
	    	 <div class="heading">Add a new spot</div>
	     	<input type="text" placeholder="price" class="panel-textb" id="price">
	     	<br><button class="panel-button" id="addSpot" onclick="AddSpot(map)">Add</button>
		</div>
	</div>
    <div id="map-canvas"></div>
    
	<br/>
	<div>Please click on a marker to view and/or post greetings.</div>
		
  </body>
</html>