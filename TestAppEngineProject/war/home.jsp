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
<script type="text/javascript" src="/stylesheets/bootstrap/js/bootstrap.js"></script>
<script src="/stylesheets/jquery-ui-1.10.4.custom/js/jquery-ui-1.10.4.custom.js"></script>
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAQGlrb5YtgGtV96Hi5efMuc5z7osDvSeY&sensor=true"></script>
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
	    
	    $('#myCarousel').carousel();
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

      
	<div id="myCarousel" class="carousel slide">
        <ol class="carousel-indicators">
            <li class="" data-slide-to="0" data-target="#myCarousel"></li>
            <li class="active" data-slide-to="1" data-target="#myCarousel"></li>
            <li class="" data-slide-to="2" data-target="#myCarousel"></li>
        </ol>
    
        <div class="carousel-inner">
          	<div class="item active">
                <img alt="" src="http://www.whatcanipaint.com/wp-content/uploads/2010/09/IMG_0184.jpg"></img>
            </div>
            <div class="item">
                <img alt="" src="http://media.merchantcircle.com/21687765/Asphalt%20Parking%20Lot_full.jpeg"></img>
            </div>
             <div class="item">
                <img alt="" src="http://3.bp.blogspot.com/-1ky8-w4v1RY/T5WhcKj9qDI/AAAAAAAABEE/eQPVCofDaPg/s1600/DSCF6406.JPG"></img>
            </div>
        </div>
	  <a class="left carousel-control arrow" href="#myCarousel" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span></a>
      <a class="right carousel-control arrow" href="#myCarousel" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span></a>
    </div>
	<!-- container end -->
    <div class="container home-search-area">
		<h1><font color="white"><strong>Welcome to ParkSpot.</strong></font></h1>
		<h4 class="lead"><font color="white">&nbsp&nbsp&nbspFind a place for you to park today!</font></h4>
			<div class="well" align="center">
				<form action="/results" method="get"
					class="form-horizontal home-search-form">
					<div class="form-group">
						<div class="col-sm-4">
							<input type="text" class="form-control" name="location"
								id="location" placeholder="Enter a city">
						</div>
						<div class="input-group col-sm-3">
							<span class="input-group-addon"><span
								class="glyphicon glyphicon-calendar"></span></span> <input type="text"
								class="form-control" name="startdate" id="startdate"
								placeholder="From">
						</div>
						<div class="input-group col-sm-3">
							<span class="input-group-addon"><span
								class="glyphicon glyphicon-calendar"></span></span> <input type="text"
								class="form-control" name="enddate" id="enddate" placeholder="To">
						</div>
						<div class="col-sm-2">
							<input id="post-btn" class="btn btn-success" type="submit"
								value="Search" />
						</div>
					</div>
				</form>
			</div>
		</div>

	<!-- Don't insert code below this line -->
	<%
		}
	%>
</body>
</html>