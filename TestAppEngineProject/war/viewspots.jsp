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
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.Query.CompositeFilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery" %>

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
	<style>
	body { padding-top: 60px; padding-bottom: 100px; }
    html { min-height: 100%; margin-bottom: 1px; }
    </style>
<link rel="stylesheet"
	href="/stylesheets/jquery-ui-1.10.4.custom/css/flick/jquery-ui-1.10.4.custom.css">
<script
	src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script type="text/javascript" src="/javascripts/main.js"></script>
<script type="text/javascript"
	src="/stylesheets/bootstrap/js/bootstrap.js"></script>
<script
	src="/stylesheets/jquery-ui-1.10.4.custom/js/jquery-ui-1.10.4.custom.js"></script>
<script type="text/javascript"
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAQGlrb5YtgGtV96Hi5efMuc5z7osDvSeY&sensor=true">
    </script>
<script type="text/javascript">
    window.onload = lg;
    var daysToAdd = 0;	
   	
   	function lg()
   	{
   		<%UserService userService = UserServiceFactory.getUserService();
			User user = userService.getCurrentUser();

			if (user == null) {%>
			alert("Please log in before using ParkSpot");
			window.location.href = "login.jsp";
		<%}%>
    }
	
	$(document).ready(function(){
		$("#toggler1").click(function(){
			console.log("t1");
  			$(this).toggleClass('active, inactive');
		});
	});
	
	$(document).ready(function(){
		$("#toggler2").click(function(){
			console.log("t2");
  			$(this).toggleClass('active, inactive');
		});
	});

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

	<input type="hidden" id="spotID" value="" />

	<div class="container"> <!-- Container for View Your Host Spots starts here -->
		<div class="well">
			<% 
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		
			Key dsKey = KeyFactory.createKey("UBCEECE417parkspot",
									"parkspot");
	
			Date startDate = new Date();
			Date endDate = new Date();
			try{
				startDate = new SimpleDateFormat("MM/dd/yyyy")
						.parse((String) request.getParameter("startdate"));
				endDate = new SimpleDateFormat("MM/dd/yyyy")
						.parse((String) request.getParameter("enddate"));
			} catch (Exception e) {
			}
			//     System.out.println(location +","+startDateStr+","+endDateStr);
	
			Filter startDateFilter = new FilterPredicate("user",
					FilterOperator.EQUAL, user);
	
			Query startDateQuery = new Query("UBCEECE417parkspot", dsKey)
					.setFilter(startDateFilter).addSort("startdate",
							Query.SortDirection.DESCENDING);
			;
			List<Entity> startDateResults = datastore.prepare(
					startDateQuery).asList(
					FetchOptions.Builder.withDefaults());
			List<Entity> spotsList = startDateResults;

			if(spotsList.isEmpty())	{ 
				System.out.println("empty");
		%>
			<h4><span id="toggler1"><font color="#787880"><i
					class="glyphicon glyphicon-chevron-down"></i> Your Host Spots
				</font></span>
			</h4>
			<%
				} else {
					
					pageContext.setAttribute("hostspotsize", spotsList.size());
			%>
			<h4>
				<div class="container-fluid"><a id="toggler1" href="#" data-toggle="collapse" class="active"
					data-target="#demo1"> <i class="glyphicon glyphicon-chevron-down"></i> Your Host Spots <div class="pull-right"><span class="badge pull-right">${fn:escapeXml(hostspotsize)}</span></div>
				</a>
			</h4>
			<%
				}
			%>

			<div class="container"> <!-- container for list items begin here -->
				<div id="demo1" class="collapse">
					<ul class="nav nav-list">
					<%
							for (Entity spot : spotsList) {
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
							String country = (String) spot.getProperty("country");
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
						    	 locationString += adminLevel1 + ", ";
						    if(!country.equals("null") && !country.equals(""))
						    	 locationString += country + " ";
							pageContext.setAttribute("spotID", spot.getKey().getId());
							pageContext.setAttribute("host", spot.getProperty("user"));
							pageContext.setAttribute("resultsStartDate", sdStr);
							pageContext.setAttribute("resultsEndDate", edStr);
							pageContext.setAttribute("resultsPrice", spot.getProperty("price"));
							pageContext.setAttribute("resultsLocation", locationString);
					%>
						<li class="dropdown-header" id='host-${fn:escapeXml(spotID)}'>
						  <div class="panel panel-default">
							<!-- Default panel contents -->
							<div class="panel-body">
								<h3 class="list-group-item-heading">
									<font color="#428BCA">Location: ${fn:escapeXml(resultsLocation)}</font>
								</h3>
								<h4>
									<span style="float: left">Availability:
										${fn:escapeXml(resultsStartDate)} to ${fn:escapeXml(resultsEndDate)}
									</span>
									<span style="float: right">Price:
										<font color="#5CB65C">$${fn:escapeXml(resultsPrice)} per day</font>
									</span>
								</h4>
							</div>
							<div class="panel-footer">
							  	<h4>
							  	<div class="container-fluid">
							  	  Status: 
								<%	
		      						try{
		      							if((Boolean)(spot.getProperty("isReserved")) == false) {
		      					%>
										
											<font color="#F0AD4E">Available for reservation</font>
											<div class="pull-right"><button class="btn btn-primary pull-right"
												onclick="cancelspotAjaxRequest('${fn:escapeXml(spotID)}')">Cancel
												this Spot</button></div>
										<% 
		      							} else {
		      					%> 
		      						Currently reserved
		      						 
		      					<% 
		      							}
		      						}
		      					  	catch(Exception e){ System.out.println("exception");
		      					  		
		      					  	}
		      					 %> 
		      					 </div>
		      					</h4>
							</div>
						  </div>
						</li>
					<%
						}
					%>
					</ul>
				</div>
			</div> <!-- container for list items end here -->
		</div>
	</div> <!-- Container for View Your Host Spots starts here -->
	<!-- /container -->
	
	<div class="container"> <!-- Container for Reservation Spots starts here -->
		<div class="well">
		<%
			Date today = new Date();
			System.out.println("today=" + today);
			datastore = DatastoreServiceFactory.getDatastoreService();
			Key reservationKey = KeyFactory.createKey("Reservation",
					user.getEmail());

			Filter userFilter = new FilterPredicate("guest",
					FilterOperator.EQUAL, user);

			Query reservationQuery = new Query("Reservation",
					reservationKey).setFilter(userFilter).addSort(
					"startdate", Query.SortDirection.DESCENDING);

			List<Entity> spotsList1 = datastore.prepare(reservationQuery)
					.asList(FetchOptions.Builder.withDefaults());

			if (spotsList1.isEmpty()){
				System.out.println("empty");
		%>
			<h4><span id="toggler2"><font color="#787880"> 
			<i class="glyphicon glyphicon-chevron-down"></i>
				Your Current Reservations
			</font></span></h4>
			
			<%} else{
				pageContext.setAttribute("reservationsize", spotsList1.size());
			%>
			
			<h4>
				<div class="container-fluid"><a id="toggler2" href="#" data-toggle="collapse" class="active"
					data-target="#demo2"> <i
					class="glyphicon glyphicon-chevron-down"></i> Your Current Reservations<div class="pull-right"><span class="badge pull-right">${fn:escapeXml(reservationsize)}</span></div>
				</a></div>
			</h4>
			
			<% } %>
			
			<div class="container"> <!-- container for list items begin here -->
				<div id="demo2" class="collapse">
					<ul class="nav nav-list">
					<%

						for (Entity spot : spotsList1) {
							System.out.print(spot.toString());
							Date reservationStartDate = (Date) spot.getProperty("startdate");
							Date reservationEndDate = (Date) spot.getProperty("enddate");
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
						<li class="dropdown-header" id='guest-${fn:escapeXml(spotID)}'>
						  	<div class="panel panel-default">
							<!-- Default panel contents -->
							<div class="panel-body">
								<h3 class="list-group-item-heading">
									<font color="#428BCA">Location: ${fn:escapeXml(resultsLocation)}</font>
								</h3>
								<h4>
									<span style="float: left">Reserved:
										${fn:escapeXml(resultsStartDate)} to ${fn:escapeXml(resultsEndDate)}
									</span>

									<span style="float: right">Price:
										<font color="#5CB65C">$${fn:escapeXml(resultsPrice)} per day</font>
									</span>
								</h4>
							</div>
							<div class="panel-footer">
							  <h4>
							    Status:
							<%	
								if(today.after(reservationStartDate)) {
									if(today.after(reservationEndDate)) {
								%>
			      					 <font color="#F0AD4E">Past</font> 
			      				<%		
									}else{
	      					%>
	      					    <font color="#F0AD4E">Has started</font> 
	      					<% 
	      							}
								} else {
	      					%> 
	      						<font color="#F0AD4E">Yet to start</font>
	      					  	<button class="btn btn-primary pull-right" onclick="cancelReservationAjaxRequest('${fn:escapeXml(spotID)}')">Cancel Reservation</button>
	      					<% 
	      							}
	      					%> 
	      					  </h4>
							</div>
						  </div>
						</li>
					<%
						}
						System.out.println("total reservation count: " + spotsList1.size());
					%>
					</ul>
				</div>
			</div> <!-- container for list items end here -->
		</div>
	</div> <!-- Container for Reservation Spots starts here -->


	<!-- Don't insert code below this line -->
	<%
		}
	%>
</body>
</html>
