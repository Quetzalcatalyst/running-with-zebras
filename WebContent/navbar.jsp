<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!--  Java code to get username from datastore -->
<%
	String username;
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	
	if (user != null) {	
		username = user.getNickname();
		pageContext.setAttribute("username", username);
	}
	
	else {
		username = "Guest";
		pageContext.setAttribute("username", username);
	}
%>

<!-- Nav bar components  -->
<nav class="top-bar" data-topbar role="navigation">
	<ul class="title-area">
		<li class="name">
			<h1><a href="#">Running with Zebras</a></h1>
			</li>
	</ul>
	<!-- Add different links to the nav bar -->
	<section class="top-bar-section">
	<ul class="left">
		<li><a href="#">About</a></li>
		<li><a href="#">Contact</a></li>
		
	</ul>
	<ul class="right">
		<li class="has-dropdown">
		
			<a href="account.jsp">${fn:escapeXml(username)}</a>
			<ul class="dropdown">
				<!-- NOTE: If the user is a guest, have a modal to log in to access the account page  -->	
				<% if (!userService.isUserLoggedIn()){
					%><li><a href="<%=userService.createLoginURL("/home.jsp")%>">Login</a></li>			
				<% } else{ %>
				     <li><a href="<%=userService.createLogoutURL("/home.jsp")%>">Logout</a></li>
				<% } %>
			
			</ul>
			</li>
	</ul>
</nav>