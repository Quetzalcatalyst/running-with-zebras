<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- Formatting for image -->
<!-- NOTE: Fix the title! -->

<style>
img {
	display: block;
	width: 100%;
	padding-bottom: 1cm;
	position:relative;
	float: left;
	z-index: -1;
}
div.title{
	left: 0;
	position:absolute;
	text-align:center;
	top: 250px;
	width: 100%;
	
}
div.title.h1{
	font-size: 40px;
	font-weight: bold;
	color: #FFFFFF;
	border-style: solid;
	border-color:#000000;	
}

</style>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type ="text/css" href="foundation.min.css"> 
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
<script src="foundation.min.js"></script>
<script>
$(document).foundation();

</script>

<title>Running with Zebras</title>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<!-- NOTE: Add code/css for banner + title -->
<!-- <div class="title"><h1>Running with Zebras</h1></div> -->
<img src="zebras_wallpaper.jpg" alt="Zebra Banner">

<!-- NOTE: change formatting to add search icon -->

<div class="row">
    <div class="large-12 columns">
      <div class="row collapse">
      <form action="/search" method="post">
        <div class="small-10 columns">       
          <input type="text" name="symptoms" placeholder="Enter a list of symptoms in the box">
        </div>
        <div class="small-2 columns">
          <input type="submit" value="Search" class="button postfix">
          <input type="hidden" value="" name="numResults">
        </div>
        </form>
      </div>
    </div>
  </div>

 
 
<div class="row">
  <div class="small-10 medium-11 columns">
  	<h5>Number of results:</h5>
    <div class="range-slider" id="resultsSlider" data-slider="20" data-options="start: 10; end: 100; step: 5; display_selector: #sliderOutput3;">
      <span class="range-slider-handle" role="slider" tabindex="0"></span>
      <span class="range-slider-active-segment"></span>
    </div>
  </div>
  <div class="small-2 medium-1 columns">
    <span id="sliderOutput3"></span>
  </div>
</div>

<!--  Script to set # of returned results, NOTE: Not working at the moment -->
<script>


$(document).foundation({
  slider: {
    on_change: function(){      
     var numResults = $('#resultsSlider').attr('data-slider');
     $('input[name="numResults"]').val(numResults)
    // console.log($('input[name="numResults"]').attr('value'))
    }
  }
})
</script>

  
  <!--  NOTE: Add preference options which include:
  sort/rows/score/etc -->
 
<!-- Add popup for login/guest account  -->

<!-- Add footer components here (disclaimer) -->
<footer>
</footer>
<script src="http://cdn.foundation5.zurb.com/foundation.js"></script>


<!--  Various javascript from CDNs, can be trimmed -->
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

</body>
</html>