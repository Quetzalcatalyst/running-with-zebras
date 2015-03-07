package com.hackathon.runningwithzebras;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

/*
 * Servlet to create a profile on button press 
 * 
 * 
 */


@SuppressWarnings("serial")
public class UpdateProfile extends HttpServlet {
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp){
		
		// NOTE: needs code to setup url for search here as well 
		
		// Initializes datastore/userservices
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    UserService userService = UserServiceFactory.getUserService();
	    User usersev = userService.getCurrentUser();
	    String userid = usersev.getUserId();
	    
	    
	    Key userKey = KeyFactory.createKey("User", userid);
	    
	    // Doesn't necessarily need the try/catch statement 
	    
			Entity profile = new Entity("Profile", userKey);
			
			profile.setProperty("Profname",req.getParameter("profilename"));
			profile.setProperty("Actname",req.getParameter("actualname"));
			profile.setProperty("Age",req.getParameter("age"));
			profile.setProperty("Race",req.getParameter("race"));
			profile.setProperty("Gender",req.getParameter("gender"));
			
			List<String> ailmentArray = Arrays.asList(req.getParameter("ailments").split(","));
			List<String> medicationArray = Arrays.asList(req.getParameter("medications").split(","));
			List<String> alladvArray = Arrays.asList(req.getParameter("alladv").split(","));
			List<String> symptomArray = Arrays.asList(req.getParameter("symptoms").split(","));
			
			profile.setProperty("Ailments",ailmentArray);
			profile.setProperty("Medications",medicationArray);
			profile.setProperty("Alladv",alladvArray);
			profile.setProperty("Symptoms",symptomArray);
			
			datastore.put(profile);
				    
	   try {
		resp.sendRedirect("/account.jsp");
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	    
		
	    
	    
		
	}
	
	
}
