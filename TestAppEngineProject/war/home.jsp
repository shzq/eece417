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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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
<script type="text/javascript"
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAQGlrb5YtgGtV96Hi5efMuc5z7osDvSeY&sensor=true">
    </script>
<script type="text/javascript">
    window.onload = lg;	
    	function lg()
    	{
    		<%UserService userService = UserServiceFactory.getUserService();
			User user = userService.getCurrentUser();

			if (user == null) {%>
				alert("Please log in before using ParkSpot");
				window.location.href = "login.jsp";
			<%}%>
	    }
    
    $(function() {
    	$( "#startdate" ).datepicker();
    });
    $(function() {
    	$( "#enddate" ).datepicker();
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
	<%@ include file="navbar" %>
	<!-- Don't insert code above this line (unless it's Javascript or imports etc)-->
	
	
	<div class="container">
		<h1>Welcome</h1>
		<div class="well" align="center">
			<form action="/results" method="get" class="form-horizontal">
				<div class="form-group">
					<div class="col-sm-4 no-padding">
						<input type="text" class="form-control" name="location"
							id="location" placeholder="Enter a city">
					</div>
					<div class="input-group col-sm-3 no-padding">
						<span class="input-group-addon"><span
							class="glyphicon glyphicon-calendar"></span></span> <input type="text"
							class="form-control" name="startdate" id="startdate"
							placeholder="From">
					</div>
					<div class="input-group col-sm-3 no-padding">
						<span class="input-group-addon"><span
							class="glyphicon glyphicon-calendar"></span></span> <input type="text"
							class="form-control" name="endate" id="enddate" placeholder="To">
					</div>
					<div class="col-sm-2 no-padding">
						<input id="post-btn" class="btn btn-success" type="submit"
							value="Search" />
					</div>
				</div>
			</form>
		</div>
	</div>
	<!-- container end -->


	<!-- Don't insert code below this line -->
	<% 
	}
	%>
</body>
</html>