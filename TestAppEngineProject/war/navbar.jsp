<nav class="navbar navbar-default" role="navigation">
	<div class="container-fluid">
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target="#bs-example-navbar-collapse-1">
				<span class="sr-only">Toggle navigation</span> <span
					class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="/home.jsp">ParkSpot</a>
		</div>

		<!-- Collect the nav links, forms, and other content for toggling -->
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="/newspot.jsp">List A Spot</a></li>
			</ul>
			<ul class="nav navbar-nav">
				<li><a href="/results.jsp">Find A Spot</a></li>
			</ul>
			<ul class="nav navbar-nav">
				<li><a href="#">View Your Spots</a></li>
			</ul>
			
<%
    userService = UserServiceFactory.getUserService();
    user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
			<ul class="nav navbar-nav navbar-right">
				<li><p class="navbar-text text-right">Signed in as ${fn:escapeXml(user.nickname)}</p></li>
				<li><a href="<%= userService.createLogoutURL("/login.jsp") %>">Sign out</a></li>
			</ul>
				   <%
    } else {
			%> 		
			<ul class="nav navbar-nav navbar-right">
				<li><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></li>
			</ul>
<% 
	}
%>
			
		</div>
		<!-- /.navbar-collapse -->
	</div>
	<!-- /.container-fluid -->
</nav>