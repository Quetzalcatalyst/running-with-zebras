package com.hackathon.runningwithzebras;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class SaveSearch extends HttpServlet {

	public void doPost(HttpServletRequest req, HttpServletResponse resp){
		
		Logger logger = Logger.getLogger(this.getClass().getName());

		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    UserService userService = UserServiceFactory.getUserService();
	    User usersev = userService.getCurrentUser();
	    String userid = usersev.getUserId();
	    Key userKey = KeyFactory.createKey("User", userid);
	    
	    Entity search = new Entity("Search",userKey);
	    
	    String searchName = req.getParameter("searchName");
	    String searchUrl = req.getParameter("searchUrl");
	    
	    search.setProperty("name",searchName);
	    search.setProperty("searchUrl",searchUrl);
		
	    datastore.put(search);
	    // Need to make it so that results page does not disappear 
	    
	    try {
			resp.sendRedirect("/search.jsp");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	
}
