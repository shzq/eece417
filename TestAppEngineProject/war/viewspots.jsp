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
<link type="text/css" rel="stylesheet" href="/stylesheets/bootstrap/css/bootstrap.css" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
<script	src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
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
		<UL><span STYLE="color: #5F5FFF; text-decoration:underline" >View Reservation spots&raquo;</span>
         	 <ul class="collapse" >
				
  				<li class="list-group-item">North Parkade</li>
  				<li class="list-group-item">Thunderbird Parkade</li>
  				<li class="list-group-item">West Parkade</li>
  				<li class="list-group-item">Fraser River Parkade</li>
  				<li class="list-group-item">Health Sciences Parkade</li>
 				<li class="list-group-item">Rose Garden Parkade</li>
			</ul>
		</UL>
	</UL>
	</div>
</div>
    


<script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
	<script type="text/javascript">
		$(function(){
				$('#Reservation').find('SPAN').click(function(e){
					$(this).parent().find('UL').toggle();
			});
		});
</script>

<div class="container">
   <div class="row">
	<UL id="Host">
		<UL><span STYLE="color: #5F5FFF; text-decoration:underline" >View Host spots&raquo;</span>
         	 <ul class="collapse" >
				
  				<li class="list-group-item">North Parkade</li>
  				<li class="list-group-item">Thunderbird Parkade</li>
  				<li class="list-group-item">West Parkade</li>
  				<li class="list-group-item">Fraser River Parkade</li>
  				<li class="list-group-item">Health Sciences Parkade</li>
 				<li class="list-group-item">Rose Garden Parkade</li>
			</ul>
		</UL>
	</UL>
	</div>
</div>

<script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
	<script type="text/javascript">
		$(function(){
				$('#Host').find('SPAN').click(function(e){
					$(this).parent().find('UL').toggle();
			});
		});
</script>



	<!-- Don't insert code below this line -->
	<% 
	}
	%>
</body>
</html>












<!--UNUSED 
	<div class="container"> -->
<!--      <div class="row"> -->
<!--         <div class="span4 collapse-group"> -->
<!--           <h2>View Your Spots</h2> -->
<!--             <p><a class="btn" href="#">	View Reservation spots&raquo;</a></p> -->
<!-- <!--            <p class="collapse">aaaaaaaaaaaaaaaaaaaaaaaaaaa</p> --> -->
          
<!--           <ul class="collapse" > -->

<!--   				<li class="list-group-item">North Parkade</li> -->
<!--   				<li class="list-group-item">Thunderbird Parkade</li> -->
<!--   				<li class="list-group-item">West Parkade</li> -->
<!--   				<li class="list-group-item">Fraser River Parkade</li> -->
<!--   				<li class="list-group-item">Health Sciences Parkade</li> -->
<!--  				<li class="list-group-item">Rose Garden Parkade</li> -->

<!-- 		</ul> -->
		
<!--         </div> -->
<!--       </div> -->
<!--       	</div> -->
      
<!-- 	<script type="text/javascript"> 
	
// 	$('.row .btn').on('click', function(e) {
// 	    e.preventDefault();
// 	    var $this = $(this);
// //	    var $collapse = $this.closest('.collapse-group').find('.collapse');
	    
// 	    var $collapse = $this.closest('.collapse-group').find('.collapse');
	    
// 	    $collapse.collapse('toggle');
	    
// 	});
	
<!--     </script> -->