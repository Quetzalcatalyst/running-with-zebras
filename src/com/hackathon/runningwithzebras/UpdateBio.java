package com.hackathon.runningwithzebras;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Logger;

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

@SuppressWarnings("serial")
public class UpdateBio extends HttpServlet {
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp){
		
		Logger logger = Logger.getLogger(this.getClass().getName());
		// Initializes datastore/userservices
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    UserService userService = UserServiceFactory.getUserService();
	    User usersev = userService.getCurrentUser();
	    String userid = usersev.getUserId();
	    
	    
	    Key userKey = KeyFactory.createKey("User", userid);
	    try {
			Entity user = datastore.get(userKey);
			Entity bio = new Entity("Bio", userid, userKey);
			
			bio.setProperty("Name",req.getParameter("bioname"));
			bio.setProperty("Location",req.getParameter("location"));
			bio.setProperty("Profession",req.getParameter("profession"));
			bio.setProperty("Email",req.getParameter("bioemail"));
			bio.setProperty("Facebook",req.getParameter("facebook"));
			bio.setProperty("Twitter",req.getParameter("twitter"));
			
			datastore.put(bio);
			
	
						
		} catch (EntityNotFoundException e) {
			// TODO Auto-generated catch block	
			e.printStackTrace();
		}
	    
	  try {
		resp.sendRedirect("/account.jsp");
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	    
		
	    
	    
		
	}
	
	
}