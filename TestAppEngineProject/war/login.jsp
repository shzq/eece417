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
<script type="text/javascript">
      (function() {
       var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
       po.src = 'https://apis.google.com/js/client:plusone.js';
       var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
     })();
    </script>
<script type="text/javascript">
    	function signinCallback(authResult) {
  			if (authResult['status']['signed_in']) {
  			//if (authResult['g-oauth-window']){
			    // Update the app to reflect a signed in user
			    // Hide the sign-in button now that the user is authorized, for example:
			    gapi.client.load('plus','v1', loadProfile);
			    //alert("Successfully signed in!");
			    //window.location.href = "pickdate.jsp";
			    //document.getElementById('signinButton').setAttribute('style', 'display: none');
			} else if (authResult['status']['user_signed_out'])	{
				alert("You've been signed out, please sign in again");
			} else if (authResult['status']['access_denied']) {
				alert("Access has been denied");
			} else {
			    //   "immediate_failed" - Could not automatically log in the user
			    //alert("Immediate failure: unknown");
			    console.log('Sign-in state: ' + authResult['error']);
			}
		}
		
		function loadProfile(){
    		var request = gapi.client.plus.people.get( {'userId' : 'me'} );
    		request.execute(loadProfileCallback);
  		}
  		
  		function loadProfileCallback(obj) {
    		profile = obj;

    		// Filter the emails object to find the user's primary account, which might
    		// not always be the first in the array. The filter() method supports IE9+.
    		email = obj['emails'].filter(function(v) {
        	return v.type === 'account'; // Filter out the primary email
    		})[0].value; // get the email from the filtered results, should always be defined.
    		displayProfile(profile);
  		}
  		
  		function displayProfile(profile){
    		//document.getElementById('name').innerHTML = profile['displayName'];
    		//document.getElementById('pic').innerHTML = '<img src="' + profile['image']['url'] + '" />';
    		//document.getElementById('email').innerHTML = email;
    		//toggleElement('profile');
    		alert("Successfully logged in as " + email);
    		window.location.href = "home.jsp";
			document.getElementById('signinButton').setAttribute('style', 'display: none');
  		}
    </script>
</head>
  <body>

	<div class="container">
		<body>
		
			<h1 style="text-align: center;">&nbsp;</h1>
			<h1 style="text-align: center;">&nbsp;</h1>
			<h1 style="text-align: center;">
				ParkSpot
			</h1>
			<p>&nbsp;</p>
			<p style="text-align: center;">
				<span
					style="font-family: lucida sans unicode, lucida grande, sans-serif;">To
					begin, login with your Google Account: <span id="signinButton">
						<span class="g-signin" data-callback="signinCallback"
						data-clientid="869942779396.apps.googleusercontent.com" data-cookiepolicy="single_host_origin"
						data-scope="https://www.googleapis.com/auth/plus.profile.emails.read"> </span>
				</span>
				</span>
			</p>
		</body>
	</div>
	<!-- container end -->
	
</body>
</html>