<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="com.hackathon.runningwithzebras.Zebra" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>

    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<style>
.searchBar{
	padding-top: 20px;

}



</style>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type ="text/css" href="foundation.min.css">  
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="foundation.min.js"></script>
<title>Search</title>
</head>

<body>

<!-- NOTE: Add code to save search  -->

<!--  Java code to get username/etc.  -->
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

<!-- Code for nav bar -->
<nav class="top-bar" data-topbar role="navigation">
	<ul class="title-area">
		<li class="name">
			<h1><a href="home.jsp">Running with Zebras</a></h1>
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
		<!-- Add name that dynamically changes based on user -->
			<a href="account.jsp">${fn:escapeXml(username)}</a>
			<ul class="dropdown">
				<!-- NOTE: Make Login/Logout servlet -->	
				<% if (!userService.isUserLoggedIn()){
					%><li><a href="<%=userService.createLoginURL("/home.jsp")%>">Login</a></li>			
				<% } else{ %>
				     <li><a href="<%=userService.createLogoutURL("/home.jsp")%>">Logout</a></li>
				<% } %>
				<!-- <li><a href="/user_test">Test</a> -->
			</ul>
			</li>
	</ul>
</nav>


<!--  NOTE: need to change text in placeholder to be editable -->
<!-- NOTE: Trouble getting search to work from here, check console -->
<div class ="searchBar">
<div class="row">
    <div class="large-12 columns">
      <div class="row collapse">
      <form action="/search" method="post">
        <div class="large-8 columns">       
          <input type="text" name="symptoms" placeholder="${symptomString}">
        </div>
        <div class="large-2 columns">
          <input type="submit" value="Search" class="button postfix">
        </div>
        <div class="large-2 columns">
        	<a href="#" data-reveal-id="saveModal" class="button postfix">Save Search</a>
        </div>
        </form>
      </div>
    </div>
  </div>
</div>


<div id="saveModal" class="reveal-modal" data-reveal>
<% 

DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd - HH:mm:ss");
Date date = new Date();
pageContext.setAttribute("templateSearch",dateFormat.format(date));

%>
<!-- Need to change text in placeholder to be editable -->
<h3>Name the Search</h3>
<form action="/saveSearch" method="post">
<div class="large-10 columns">
<input type="text" name="searchName" placeholder="${templateSearch} - ${symptomString}">
</div>
<input type="hidden" name="searchUrl" value="${searchUrl }">
<div class="large-2 columns">
<input type="submit" value="Submit" class="button">
</div>
</form>

</div>

<script>


</script>

<dl class="accordion" data-accordion>
<% int searchIndex = 0; %>
<c:forEach items="${zebraList}" var="zebra">
	<% searchIndex += 1;
		pageContext.setAttribute("searchIndex",searchIndex);
	%>
	<dd class="accordion-navigation">
	<a href="#panel${searchIndex}">${zebra.displayTitle }</a>
	<div id="panel${searchIndex}" class="content">
	<h3><a href="${zebra.source}">Source</a> <!-- <small><a href="${zebra.sourceUrl}">Link</a></small>--></h3>
	<h4 class="subheader">Retrieved On: ${zebra.retrievedDate}</h4>
	</div>
	</dd>
</c:forEach>

</dl>

<!-- NOTE: Add code to save a search -->


</body>

<!-- Add code for footer -->
<footer></footer>

<!--  Various javascript from CDNs, can be trimmed -->
<script src="foundation.min.js"></script>
<!-- jQuery CDN -->
  <script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
  <!-- jQuery local fallback -->
  <script>window.$ || document.write('<script src="/local/jquery.min.js"><\/script>')</script>
  <!-- Foundation JS CDN -->
  <script src="//cdn.jsdelivr.net/foundation/5.0.2/js/foundation.min.js"></script>
  <!-- Foundation JS local fallback -->
  <script>window.Foundation || document.write('<script src="/local/foundation.min.js"><\/script>')</script>
  <!-- Initialize Foundation -->
  <script>$(document).foundation();</script>
  <!-- Foundation CSS local fallback -->
  <script>
  $(document).ready(function() {
	    var bodyColor = $('body').css('color');
	    if(bodyColor != 'rgb(34, 34, 34)') {
	    $("head").prepend('<link rel="stylesheet" href="/local/foundation.min.css">');}});
 </script>


</html>