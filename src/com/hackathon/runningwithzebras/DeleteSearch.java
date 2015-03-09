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
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;


public class DeleteSearch extends HttpServlet {

	public void doPost(HttpServletRequest req, HttpServletResponse resp){
		
		Logger logger = Logger.getLogger(this.getClass().getName());
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String userid = (String)user.getUserId();
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Key userKey = KeyFactory.createKey("User", userid);
		
		logger.info("Index from HTML File" + req.getParameter("Index"));
		/*
		Filter indexFilter2 = 
				new FilterPredicate("")
		*/
		 
		Filter indexFilter = 
				new FilterPredicate("indexStr",FilterOperator.EQUAL,req.getParameter("Index"));
		
		
		
		Query qs = new Query("Search").setAncestor(userKey).setFilter(indexFilter);
				//.setKeysOnly();
		
		//logger.info("We're trying to delete the search");
		
		PreparedQuery pq = datastore.prepare(qs);
		for (Entity search : pq.asIterable())
		{
			//logger.info("Search Name: "+search.getProperty("name")+" Index:"+ search.getProperty("indexStr"));
			Key searchKey = search.getKey();
			datastore.delete(searchKey);
		}
		//Entity profile = pq.asSingleEntity();
		//logger.info((String)profile.getProperty("Profname") + (String)profile.getProperty("Index"));
		
		//Key profileKey = profile.getKey();
		
		//datastore.delete(profileKey);
		
		try {
			resp.sendRedirect("/account.jsp");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
}
