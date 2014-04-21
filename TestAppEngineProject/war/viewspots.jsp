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
	<style>body { padding-top: 60px; padding-bottom: 100px; }
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
	            console.log(dtFormatted);
	        },
	        onClose: function (selected) {
	        	if(selected=="")
	        		$("#startdate").datepicker("option", "maxDate", null);
	        }
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


	<!-- <div class="container"> -->
	<!--    <div class="row"> -->
	<!-- 	<UL id="Reservation"> -->
	<!-- 		<UL><span STYLE="color: #5F5FFF; text-decoration:underline" >View Your Reservation spots&raquo;</span> -->
	<!--          	 <ul class="collapse" > -->

	<!--   				<li class="list-group-item">under construction</li> -->
	<!--   				<li class="list-group-item">under construction</li> -->
	<!--   				<li class="list-group-item">under construction</li> -->
	<!--   				<li class="list-group-item">under construction</li> -->
	<!--   				<li class="list-group-item">under construction</li> -->
	<!--  				<li class="list-group-item">under construction</li> -->
	<!-- 			</ul> -->
	<!-- 		</UL> -->
	<!-- 	</UL> -->
	<!-- 	</div> -->
	<!-- </div> -->

	<input type="hidden" id="spotID" value="" />





	<div class="container"> <!-- Container for View Your Host Spots starts here -->
		<div class="well">
			<h4><a id="toggler1" href="#" data-toggle="collapse" class="active"
				data-target="#demo1"> <i class="glyphicon glyphicon-chevron-down"></i>
				Your Host Spots
			</a></h4>
			<div class="container"> <!-- container for list items begin here -->
			
				<div id="demo1" class="collapse">
					<ul class="nav nav-list">
					<%
					DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
					
					Key dsKey = KeyFactory.createKey("UBCEECE417parkspot",
											"parkspot");
									// Run an ancestor query to ensure we see the most up-to-date
									// view of the Greetings belonging to the selected Guestbook.
									//     String location = (String) request.getParameter("location");
									//     String startDateStr = (String) request.getParameter("startdate");
									//     String endDateStr = (String) request.getParameter("enddate");
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

									//	 Query query = new Query("UBCEECE417parkspot", dsKey).addSort("location", Query.SortDirection.DESCENDING);
									//	 List<Entity> spotsList = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));

									for (Entity spot : spotsList) {
										DateFormat df = new SimpleDateFormat("EEEE MM/dd/yyyy");
										String sdStr = df.format(spot.getProperty("startdate"));
										String edStr = df.format(spot.getProperty("enddate"));
										pageContext.setAttribute("spotID", spot.getKey().getId());
										pageContext.setAttribute("host", spot.getProperty("user"));
										pageContext.setAttribute("resultsStartDate", sdStr);
										pageContext.setAttribute("resultsEndDate", edStr);
										pageContext.setAttribute("resultsPrice",
												spot.getProperty("price"));
										pageContext.setAttribute("resultsLocation",
												spot.getProperty("location"));
							%>
						<li class="dropdown-header" id='${fn:escapeXml(spotID)}'><div class="panel panel-default">
								<!-- Default panel contents -->
								<div class="panel-body">
									<h3 class="list-group-item-heading">
										<font color="#428BCA">Location: ${fn:escapeXml(resultsLocation)}</font>
									</h3>
									<h4>
										<div style="float: left">Availability:
											${fn:escapeXml(resultsStartDate)}</div>

										<div style="float: right">Price:
											<font color="#5CB65C">$${fn:escapeXml(resultsPrice)} per day</font></div>
									</h4>
								</div>
								<div class="panel-footer"><h4>Status: 
								<%	
		      						try{
		      							if((Boolean)(spot.getProperty("isReserved")) == false) {
		      						%> <font color="#F0AD4E">Available for reservation</font><button class="btn btn-primary pull-right" onclick="cancelspotAjaxRequest('${fn:escapeXml(spotID)}')">Cancel this Spot</button> 
		      						<% 
		      						} else {
		      						%> Currently reserved <% 
		      							}
		      						}
		      					  	catch(Exception e){%> <font color="#F0AD4E">Available for reservation</font> <%}
		      						%></h4>
							</div></li>
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
			<h4><a id="toggler2" href="#" data-toggle="collapse" class="active"
				data-target="#demo2"> 
				<i class="glyphicon glyphicon-chevron-down"></i>
				Your Current Reservations
			</a></h4>
			<div class="container"> <!-- container for list items begin here -->
			
				<div id="demo2" class="collapse">
					<ul class="nav nav-list">
					<%
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

							if (spotsList1.isEmpty())
								System.out.println("empty");

							for (Entity spot : spotsList1) {
								System.out.print(spot.toString());
								DateFormat df = new SimpleDateFormat("EEEE MM/dd/yyyy");
								String sdStr = df.format(spot.getProperty("startdate"));
								String edStr = df.format(spot.getProperty("enddate"));
								pageContext.setAttribute("spotID", spot.getKey().getId());
								pageContext.setAttribute("host", spot.getProperty("user"));
								pageContext.setAttribute("resultsStartDate", sdStr);
								pageContext.setAttribute("resultsEndDate", edStr);
								pageContext.setAttribute("resultsPrice",
										spot.getProperty("price"));
								pageContext.setAttribute("resultsLocation",
										spot.getProperty("location"));
					%>
						<li class="dropdown-header"><div class="panel panel-default">
								<!-- Default panel contents -->
								<div class="panel-body">
									<h3 class="list-group-item-heading">
										<font color="#428BCA">Location: ${fn:escapeXml(resultsLocation)}</font>
									</h3>
									<h4>
										<div style="float: left">Reserved:
											${fn:escapeXml(resultsStartDate)} to ${fn:escapeXml(resultsEndDate)}</div>

										<div style="float: right">Price:
											<font color="#5CB65C">$${fn:escapeXml(resultsPrice)} per day</font></div>
									</h4>
								</div>
								<div class="panel-footer"><h4>Status:
								<%	
		      						try{
		      							if((Boolean)(spot.getProperty("isReserved")) == false) {
		      						%> <font color="#F0AD4E">Available for reservation</font> 
		      						<% 
		      						} else {
		      						%> Currently reserved <% 
		      							}
		      						}
		      					  	catch(Exception e){%> <font color="#F0AD4E">Reserved</font><button class="btn btn-primary pull-right">Cancel Reservation</button> <%}
		      						%></h4>
							</div></li>

							<%
								}
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
