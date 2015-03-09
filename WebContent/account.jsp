<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.EntityNotFoundException" %>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>

.tab-title{
 padding-right: 50px;
}



</style>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type ="text/css" href="foundation.min.css">  
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="foundation.min.js"></script>
<title>Account</title>
</head>

<!-- NOTE: Add code to reformat URL to user name (+ sign in preferences) -->
<!-- Also add code to redirect if the user is not logged in.  -->


<body>

<!--  Java code to get username/etc.  -->
<%
	String username;
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	String userid = (String)user.getUserId();
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	Logger logger = Logger.getLogger(this.getClass().getName());

	
	if (user != null) {	
		username = user.getNickname();
		pageContext.setAttribute("username", username);
	}
	
	else {
		username = "Guest";
		pageContext.setAttribute("username", username);
	}
	// userKey for use later 
	Key userKey = KeyFactory.createKey("User", userid);
	
		

%>

<!-- Add code for nav bar -->
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




<!-- Divides the account page into different tabs -->
<dl class="tabs vertical" data-tab>
	<dd class="tab-title active"><a href="#Bio">Bio</a></dd>
	<dd class="tab-title"><a href="#Profiles">Profiles</a></dd>
	<dd class="tab-title"><a href="#Settings">Settings</a></dd>
	<dd class="tab-title"><a href="#Searches">Saved Searches</a>
</dl>

<!-- Bio tab, to display personal information -->
<div class="tabs-content">
	<div class="content active" id="Bio">
	
	<!-- Add room for profile photo -->
	<!-- Add code to check whether personal information has been filled out before  -->
	<div class="bio">
	
	<!--  Java code to get Bio information from Datastore -->
	<%
	
    	
		Key bioKey = KeyFactory.createKey(userKey,"Bio", userid);
			
		try{
		Entity bio = datastore.get(bioKey);
		String name = (String)bio.getProperty("Name");
		String location = (String)bio.getProperty("Location");
		String profession = (String)bio.getProperty("Profession");
		String email = (String)bio.getProperty("Email");
		String facebook = (String)bio.getProperty("Facebook");
		String twitter = (String)bio.getProperty("Twitter");
		
		
		pageContext.setAttribute("bioname",name);
		pageContext.setAttribute("location",location);
		pageContext.setAttribute("profession",profession);
		pageContext.setAttribute("email",email);
		pageContext.setAttribute("facebook",facebook);
		pageContext.setAttribute("twitter",twitter);
		%>
		<div class="row">
		<ul class="vcard">
		<% if (name != null){ %>
		<li class="fn">Name: ${fn:escapeXml(bioname) }</li>
		<% } if (location != null) {%>
		<li class="location">Location: ${fn:escapeXml(location) }</li>
		<% } if (profession != null) { %>
		<li class="profession">Profession: ${fn:escapeXml(profession) }</li>
		<% } if (email != null) { %>
		<li class="email">Email: ${fn:escapeXml(email) }</li>
		<% } if (facebook != null) { %>
		<li class="facebook">Facebook: ${fn:escapeXml(facebook) }</li>
		<% } if (twitter!= null) { %>
		<li class="twitter">Twitter: ${fn:escapeXml(twitter) }</li>
		<%} %>
		</ul>
		</div>
		
		<%
		}
		catch(EntityNotFoundException e){
		}
		%>
	<!--  NOTE: remove the extra button -->
	<a href="#" id="editbio" class="button">Edit Bio</a>
	<a href="#" id="editBioTest" data-reveal-id="bioModal" class="button">Edit Bio Test</a>
	
	</div>
	<script>
	$(document).ready(function(){
		$(".biocreator").hide();
		$("#editbio").click(function(){
			$(".bio").hide();
			$(".biocreator").show();
		})
		$("#editBioTest").click(function(){
			$(".biocreator").show();
			//alert("Buttons clicked")
		})
	})
	</script>
	
	<!-- NOTE: Add code to fill this in with information from bio -->
	<div id="bioModal" class="reveal-modal" data-reveal>
	<div class = "biocreator">
	<form action = "/updatebio" method="POST">
	<fieldset>
		<legend>Personal Information</legend>
			<label>Name</label>
				<input type="text" name="bioname">
		    <div class="row">
		    <div class="large-6 columns">
			<label>Location</label>
				<input type="text" name="location">
			</div>
			<div class="large-6 columns">
			<label>Profession</label>
				<input type="text" name="profession">
			</div>
			</div>
			<div class="row">
			<div class="large-4 columns">
			<label>Email</label>
				<input type="text" name="bioemail">
			</div>
			<div class="large-4 columns">
			<label>Facebook Profile</label>
				<input type="text" name="facebook">
			</div>
			<div class="large-4 columns">
			<label>Twitter Handle</label>
				<input type="text" name="twitter">
			</div>
			</div>
	
	
	</fieldset>
	
	<!--  Calls Servlet to update bio -->
	<input type="submit" value="Update" id="updatebio" class="button">
	<a href="#" id="cancelbio" class="button">Cancel</a>
	</form>
	
	</div>
	</div>
	<script>
	
	$(document).ready(function(){
		$("#updatebio").click(function(){
			$(".bio").show();
			$(".biocreator").hide();
		})
		$("#cancelbio").click(function(){
			$(".bio").show();
			$(".biocreator").hide();
		})
	
	})
	
	</script>
	
	
	</div>
	
	
<div class="content" id="Profiles">
	
	
	
	
	<!-- List profiles here  -->
	<div class="profiles"><%
	
    		
		Query qp = new Query("Profile").setAncestor(userKey);
		PreparedQuery profiles = datastore.prepare(qp);
		int profileIndex = 1;
		for (Entity profile : profiles.asIterable()) {
			String profname = (String)profile.getProperty("Profname");
			String actname = (String)profile.getProperty("Actname");
			String age = (String)profile.getProperty("Age");
			String race = (String)profile.getProperty("Race");
			String gender = (String)profile.getProperty("Gender");
			
			List ailment = (List)profile.getProperty("Ailment");
			List medications = (List)profile.getProperty("Medications");
			List alladv = (List)profile.getProperty("Alladv");
			List<String> symptoms = (List)profile.getProperty("Symptoms");
			
			// NOTE: the profiles have an extra property called index created accidentally, how to delete this? 
			
			String indexString = profileIndex +"";
			profile.setProperty("IndexStr",indexString); // assigns each profile a unique index to reference when editing/deleting 
			//logger.info((String)profile.getProperty("IndexStr"));
			datastore.put(profile);
			
			//logger.info("Profile name "+ profile.getProperty("Profname") +" Index "+ profile.getProperty("Index"));
			
			profileIndex += 1;
			
			// At the moment, only a few headings of each profile is displayed, but the Update Profile Servlet
			// has the capability to grab all of the user input 
			
			pageContext.setAttribute("profname",profname);
			pageContext.setAttribute("actname",actname);
			pageContext.setAttribute("age",age);
			pageContext.setAttribute("race",race);
			pageContext.setAttribute("gender",gender);
			pageContext.setAttribute("profileIndex", profileIndex);
			
			// add code here to make symptoms, then submit it back into search
			
			String profileSymptoms;
			String symptomUrl; 
			
			
			for(String symptom: symptoms){
				symptom = symptom.replaceAll(" ","+");
				
				
				
			}
			
		
		%>
		
		<!-- Profile Creator -->
		<% if (profname != null){ %>
		<div class="row">
		<a data-dropdown="drop${fn:escapeXml(profileIndex)}">Profile:${fn:escapeXml(profname) }</a>
		<div id="drop${fn:escapeXml(profileIndex)}" data-dropdown-content class="large f-dropdown content" tabindex="-1">		
		<ul class="vcard">
		<li class="fn">Profile Name: ${fn:escapeXml(profname) }</li>
		<% } if (actname != null) {%>
		<li class="location">Actual Name: ${fn:escapeXml(actname) }</li>
		<% } if (age != null) { %>
		<li class="profession">Age: ${fn:escapeXml(age) }</li>
		<% } if (race != null) { %>
		<li class="email">Race: ${fn:escapeXml(race) }</li>
		<% } if (gender != null) { %>
		<li class="facebook">Gender: ${fn:escapeXml(gender) }</li>
		<%} %>
		</ul>
		<div class="row">
		
		<form action="/deleteProfile" method="post">
		<input type="hidden" name="Index" value="${fn:escapeXml(profileIndex)}">
		<input type="submit" value="Delete Profile" class="button">	
		</form>
		<a href="#" class="button">Edit Profile</a>
		<a href="#" class="button">Run Search</a>
		</div>
		</div>		
		</div>
		<%
		}
		
		%>
	
	
	
	<a href="#" id="addprofile" class="button">Create New Profile</a>
	<a href="#" id="addProfileTest" data-reveal-id="profileModal" class="button">Create New Profile Test</a>
	</div>
	
	
	<!-- Remove script once the buttons are worked out  -->
	<!-- Script  -->
	<script>
	$(document).ready(function(){
		
		// initially hides the profile creator
		$(".profilecreator").hide();
		
		$("#addprofile").click(function(){
			$(".profiles").hide();
			$(".profilecreator").show();
			
		})
		
		$("#addProfileTest").click(function(){
			$(".profilecreator").show();
		})
	})
	
	</script>
	
	<!--  Profile Form -->
	<div id="profileModal" class="reveal-modal" data-reveal>
	<div class="profilecreator">
	<form action="/updateprofile" method="POST">
	  <fieldset>
	  	<legend>Profile Information</legend>
	    	<label>Profile Name
	    		<input type="text" name="profilename" placeholder="Profile name">
	    	</label>
	    	<label>Actual Name</label>
	    		<input type="text" name="actualname" placeholder="Patient's name">
	    
	    <!-- NOTE: Align this stuff properly -->
	    <div class="row">
	    <div class="large-4 columns">
	    <label>Age</label>
	    	<input type="text" name="age" placeholder="Patient's age">
	   	</div>
	   	<div class="large-4 columns">
	    <label>Race</label>
	    	<select name="race">
	    		<option>Select from the dropdown menu</option>
	    		<option value="White or Caucasian">White or Caucasian</option>
	    		<option value="Black or African American">Black or African American</option>
	    		<option value="American Indian or Alaska Native">American Indian or Alaska Native</option>
	    		<option value="Asian">Asian</option>
	    		<option value="Native Hawaiian or Other Pacific Islander">Native Hawaiian or Other Pacific Islander</option>
	    		<option value="Other/Undisclosed">Other/Undisclosed</option>
	    	</select>
	    </div>
	    <div class="large-4 columns">
	    <label>Gender</label>
	    	<select name="gender">
	    		<option>Select from the dropdown menu</option>
	    		<option value="Male">Male</option>
	    		<option value="Female">Female</option>
	    		<option value="Other/Undisclosed">Other/Undisclosed
	    	</select>
	    </div>
	    </div>
	 </fieldset>
	 
	 <fieldset>
	 	<legend>Medical Information</legend>
	 	<label>Ailments</label>	
	 		<textarea name="ailments" placeholder="List any current ailments of the patient as comma separated values (Type II Diabetes, Downs Syndrome, etc.)"></textarea> 	 		 	
	 	<label>Medications</label>
	 		<textarea name="medications" placeholder="List any medications the patient is taking as comma separated values (Prozac, Lorazapam, etc.)"></textarea>	 		
		<label>Allergies and Adverse Reactions</label>
	 		<textarea name="alladv" placeholder="List any allergies or adverse reactions as comma separated values (Peanuts, Shellfish, etc.)"></textarea>
	 	<!--  Add Medical History? -->	
	 </fieldset>
	 
	 <fieldset>
	 	<legend>Symptoms</legend>
	 	<textarea name="symptoms" placeholder="List all symptoms as comma separated values (heart palpitations, sweating, seizures, etc.)"></textarea> 
	 </fieldset>
	
	<!-- NOTE: Add servlet to update profiles -->
	<input type="submit" value="Submit" id="submitprofile" class="button">
	<a href="#" id="cancelprofile" class="button">Cancel</a>
	</div>
	<!-- NOTE: Add script here to switch back between -->
	<script>
	$(document).ready(function(){
		
		$("#submitprofile").click(function(){
			$(".profiles").show();
			$(".profilecreator").hide();		
		})
		// NOTE: Change script to hide modal (not profilecreator div)
		
		$("#cancelprofile").click(function(){
			$(".profiles").show();
			$(".profilecreator").hide();
		})
	})
	</script>
	
	</form>
	</div>
	</div>
	
	
	
	
	<div class="content" id="Settings">
	
	<!-- NOTE: Add site layout/other options here? -->
	
	<!-- Receive email from administrators/doctors/notifications from journals/other sources, receive user messages, information available (+ disclosure)-->
	<label>Receive Email from</label>
	<input id="admincheck" type="checkbox"><label for="doctorcheck">Administrators</label>
	<input id="networkcheck" type="checkbox"><label for="networkcheck">Your Network</label>
	<input id="userscheck" type="checkbox"><label for="userscheck">Site Users</label>
	
	<label>Receive Notifications:</label>
	<select name="notifications">
		<option value="never">Never</option>
		<option value="montly">Monthly</option>
		<option value="weekly">Weekly</option>
		<option value="daily">Daily</option>
	</select>
	
	<!--  NOTE: Need to add functionality to this button -->
	<a href="#" class="button">Update</a>
	
	</div>


	<div class="content" id="Searches">
	
	<!-- Add code here for Saved Searches -->
	<div class="searches">
	<%
	
	
	
	//Logger log = Logger.getLogger(this.getClass().getName());
	//log.info("test");

	
	Query qs = new Query("Search").setAncestor(userKey);
	PreparedQuery searches = datastore.prepare(qs);
	int searchIndex = 1;
	for (Entity search: searches.asIterable()) {
		String searchName = (String)search.getProperty("name");
		String searchUrl = (String)search.getProperty("searchUrl");
		
		//log.info(searchName + searchUrl);
		String indexStr = Integer.toString(searchIndex);
		search.setProperty("indexStr",indexStr);
		
		//logger.info("Search Index:"+ search.getProperty("indexStr"));
		datastore.put(search);		
		//logger.info("Name: "+search.getProperty("name")+ "Index: " +search.getProperty("indexStr"));
		searchIndex += 1; 
		
		pageContext.setAttribute("searchName",searchName);
		pageContext.setAttribute("searchUrl",searchUrl);
		pageContext.setAttribute("indexStr", indexStr);
	%>
	<!-- NOTE: Add code here to edit searches and delete searches  -->
	<div class="row">
		<form action="/search" method="post">
		<!-- click on link to edit -->
		<a href="/search">${searchName}</a>
		<input type="hidden" name="searchUrl" value="${searchUrl}">
		<input type="submit" value="Run Search" class="button tiny">		
		</form>
		
		
		
		<form action="/deleteSearch" method="post">
		<input type="hidden" name="Index" value="${indexStr}">
		<input type="submit" value="Delete Profile" class="button tiny">	
		</form>
		
		
		
	</div>
	<% } %>
	</div>
	


	</div>
</div>


</body>

<!--  Add footer elements -->
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