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


public class DeleteProfile extends HttpServlet {

	public void doPost(HttpServletRequest req, HttpServletResponse resp){
		
		Logger logger = Logger.getLogger(this.getClass().getName());
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String userid = (String)user.getUserId();
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Key userKey = KeyFactory.createKey("User", userid);
		
				
		Filter indexFilter = 
				new FilterPredicate("IndexStr",FilterOperator.EQUAL,req.getParameter("Index"));
		
		Query qp = new Query("Profile").setAncestor(userKey).setFilter(indexFilter);
				//.setKeysOnly();
		
		
		PreparedQuery pq = datastore.prepare(qp);
		for (Entity profile : pq.asIterable())
		{
			logger.info((String) profile.getProperty("IndexStr"));
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
