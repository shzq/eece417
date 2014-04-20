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


</head>
  <body>

	<div class="container">

			<h1 style="text-align: center;">&nbsp;</h1>
			<h1 style="text-align: center;">&nbsp;</h1>
			<h1 style="text-align: center;">ParkSpot</h1>
			<p>&nbsp;</p>
			<p style="text-align: center;">
				To begin, login with your Google Account: <p style="text-align: center;"><img id="loginimg1"
					src="https://developers.google.com/+/images/branding/sign-in-buttons/Red-signin_Long_base_44dp.png"
					onClick="lg();" height="35" width="150" style="cursor:pointer" />
			</p>
			<p>&nbsp;</p>
			<p>&nbsp;</p>
			<p>&nbsp;</p>
			<p style="text-align: center; font-style:italic">"Simply the best way for exchanging parking spots"</p>
			<p style="text-align: center; text-indent: 17em">- Matei Ripeanu</p>
			
			
			

	</div>
	<!-- container end -->
	
	<script type="text/javascript">
	
	function lg()
	{
		<% 
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		if (user != null) {%>
			window.location.href = "home.jsp";
		<%
		} else {
		%>
			window.location.href= "<%= userService.createLoginURL("/home.jsp") %>";
		<%}%>
	}
	
	
    </script>
	
	
	
</body>
</html>