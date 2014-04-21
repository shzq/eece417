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
<link type="text/css" rel="stylesheet" href="/stylesheets/bootstrap/css/bootstrap.css" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
<script	src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
<script type="text/javascript" src="/javascripts/main.js"></script>
<script type="text/javascript" src="/stylesheets/bootstrap/js/bootstrap.js"></script>
<script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
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
    
<<<<<<< HEAD
//     $(".cancel-button").click(function(){
//     	console.log("here");
//     	alert("click");
//     	document.getElementByID("spotID").value = $(this).attr('id');
//     	cancelspotAjaxRequest();
//     });

	$(function(){
		$('#Reservation').find('SPAN').click(function(e){
			$(this).parent().find('UL').toggle();
	});
	$(function(){
		$('#Host').find('SPAN').click(function(e){
			$(this).parent().find('UL').toggle();
	});
	});
});
=======
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
	            $("#startdate").datepicker("option", "maxDate", dtFormatted)
	            console.log(dtFormatted);
	        }
	    });
	});
    
>>>>>>> refs/remotes/origin/master
    
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
   <div class="row">
	<UL id="Reservation">
		<UL><span STYLE="color: #5F5FFF; text-decoration:underline" >View Your Reservation spots&raquo;</span>
         	 <ul class="collapse" >
				
  				<li class="list-group-item">under construction</li>
  				<li class="list-group-item">under construction</li>
  				<li class="list-group-item">under construction</li>
  				<li class="list-group-item">under construction</li>
  				<li class="list-group-item">under construction</li>
 				<li class="list-group-item">under construction</li>
			</ul>
		</UL>
	</UL>
	</div>
</div>

<input type="hidden" id="spotID" value=""/>
<div class="container">
   <div class="row">
	<UL id="Host">
		<UL><span STYLE="color: #5F5FFF; text-decoration:underline" >View Your Host spots&raquo;</span>
         	 <ul class="collapse" >
				
 				<div class="container">
				<%
 					   DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
  					   Key dsKey = KeyFactory.createKey("UBCEECE417parkspot", "parkspot");
 					   // Run an ancestor query to ensure we see the most up-to-date
 					   // view of the Greetings belonging to the selected Guestbook.
					   //     String location = (String) request.getParameter("location");
					   //     String startDateStr = (String) request.getParameter("startdate");
					   //     String endDateStr = (String) request.getParameter("enddate");
    				   Date startDate = new Date();
    				   Date endDate = new Date();
   					   try {
    						startDate = new SimpleDateFormat("MM/dd/yyyy").parse((String) request.getParameter("startdate"));
       						endDate = new SimpleDateFormat("MM/dd/yyyy").parse((String) request.getParameter("enddate"));
   					   } catch(Exception e) {
    				   }
						//     System.out.println(location +","+startDateStr+","+endDateStr);
					
						Filter startDateFilter = new FilterPredicate("user", FilterOperator.EQUAL, user);
    
   						Query startDateQuery = new Query("UBCEECE417parkspot", dsKey).setFilter(startDateFilter).addSort("startdate", Query.SortDirection.DESCENDING);;
						List<Entity> startDateResults = datastore.prepare(startDateQuery).asList(FetchOptions.Builder.withDefaults());
						List<Entity> spotsList = startDateResults;
	
						//	 Query query = new Query("UBCEECE417parkspot", dsKey).addSort("location", Query.SortDirection.DESCENDING);
						//	 List<Entity> spotsList = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
		
						for(Entity spot:spotsList) 
						{
							System.out.print(spot.toString());
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
				 <li class="list-group-item" id='${fn:escapeXml(spotID)}'>
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
		      						 <em>Status:  rented / unrented</em>
<%--     		   <em>Hosted by: ${fn:escapeXml(user.nickname)}</em> --%>
		       <a class="btn btn-primary pull-right" href="#" onclick="cancelspotAjaxRequest('${fn:escapeXml(spotID)}')">Cancel this Spot.</a>
		     					</p>
		     
		   						</div>
		 				</div>
				 </li>
       			<%	
 						}
  				%>
	 
			</div>
 				
			</ul>
		</UL>
	</UL>
	</div>
</div>





	<!-- Don't insert code below this line -->
	<% 
	}
	%>
</body>
</html>







