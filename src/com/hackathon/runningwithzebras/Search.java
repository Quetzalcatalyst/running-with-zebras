package com.hackathon.runningwithzebras;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.*;
import org.xml.sax.helpers.*;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.util.logging.Logger;

/*
 * Code to get an XML file from the Find Zebras site with the user input and parse it for the website
 * 
 */

@SuppressWarnings("serial")
public class Search extends HttpServlet {
		
	private Logger logger = Logger.getLogger(this.getClass().getName());
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
		      throws IOException {		    
		    
			// add code here to check if the searchUrl is already available, otherwise make it out of search query
			// 
			
		
			String urlString ="";
			
			try {
				if(req.getParameter("searchUrl") != null){
					logger.info("We got a searchUrl");
					logger.info(req.getParameter("searchUrl"));
					urlString = req.getParameter("searchUrl");
					
				}
				else{
					// make an array of symptoms from the text input     
				    String symptoms = req.getParameter("symptoms");
				  
				    req.setAttribute("symptomString",symptoms); // sets the symptoms to be displayed as placeholder in the textbox 
				    List<String> symptomArray = Arrays.asList(symptoms.split(","));
				    		    
				    
				    // Add the comma back to each element (for purposes of URL queries), this code isn't really needed 
				    for(int i = 0; i < symptomArray.size(); i++ ){
				    	String symptom = symptomArray.get(i)+",";
				    	symptomArray.set(i,symptom);
				    }
				    
				    String symptomURL = "";
					
				    
				 // Formats the string for the XML Request 
				    for (int i = 0; i < symptomArray.size(); i++ ){				
						String symptom = symptomArray.get(i);
						symptom = symptom.replaceAll(" ", "+");
						if (i != symptomArray.size() - 1){
							symptom = symptom.replace(",","%2C");
							symptomURL += symptom;
						}
						else {
							symptom = symptom.replace(",","&");
							symptomURL += symptom;
						}
				   
				    }
				    
				    
				    String numResultsUrl = req.getParameter("numResults"); // sets the number of results to be returned
				    
				    urlString = "http://findzebra.compute.dtu.dk/api/call/xml/query?q="+symptomURL+"score=score%20desc&fl=score,%20display_title,%20associated_gene,symptom,content,source_url,source,retrieved_date&rows="+numResultsUrl;
				  
				}
				
						
				
			}
			catch(NullPointerException e){
			logger.info("It's null");
			}	
				
			
			req.setAttribute("searchUrl",urlString);
		    
			
			
		   	
		    
		    // opens a connection to findzebra, and grabs the XML
		    // NOTE: change the number of results returned here (+ other filters)
		    
		    
		    
		    URL url = new URL(urlString);
			URLConnection connection = url.openConnection();
			InputStream in = connection.getInputStream();
			InputSource responseXML = new InputSource(in);
			
			
			final List<Zebra> zebralist = new LinkedList<Zebra>();
			
			// Defines the default handler to be used in the parser 
			DefaultHandler myHandler = new DefaultHandler() {
				
				// Initializes several boolean variables 
				boolean inDisplayTitle = false;
				boolean inGenes = false;
				boolean inSymptoms = false;
				boolean inScore = false; 
				boolean inContent = false;
				boolean inSource = false;
				boolean inSourceUrl = false;
				boolean inDate = false;
				
				// initializes vars to add to Zebra 				
				String displayTitle;
				String content;
				String source;
				String sourceUrl;
				String retrievedDate;
				List<String> genes = new ArrayList<String>();
				List<String> symptoms = new ArrayList<String>();
				String score;
				
			
				// This code could use a little tuning up. 
				
				public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
					
					try{
						// First set of if-statements checking if the handler is at the start of the element 
						if(qName.equals("str") && attributes.getValue("name").equals("display_title")){
							inDisplayTitle = true;					
						}
						
						if(qName.equals("arr") && attributes.getValue("name").equals("content"))
						{	
							/// logger.info("Into content");
							inContent = true;
						}
						else if(qName.equals("arr") && inContent) {
							// logger.info("Out of content");
							inContent = false;
						}
						
						if(qName.equals("str") && attributes.getValue("name").equals("retrieved_date")){
							inDate = true;
						}
						
						if(qName.equals("str") && attributes.getValue("name").equals("source")){
							inSource = true;
						}
						
						if(qName.equals("str") && attributes.getValue("name").equals("source_url")){
							inSourceUrl = true; 
						}
						
						if(qName.equals("arr") && attributes.getValue("name").equals("associated_gene")){							
							inGenes = true;
						}
						else if(qName.equals("arr") && inGenes){					
							inGenes = false; 						
						}
						
						if(qName.equals("arr") && attributes.getValue("name").equals("symptom")) {							
							inSymptoms = true;
						}
						else if(qName.equals("arr") && inSymptoms){
						//	logger.info("getting out of symptoms");
							inSymptoms = false;
							zebralist.add(new Zebra(displayTitle,content,source, sourceUrl,retrievedDate,genes));
							
						}					
					}
					catch(NullPointerException e){					
					}
					
				}
				public void characters(char [] buf, int offset, int len) {
					
					try {
					// appends the value to the response string 
					if (inDisplayTitle){
						// NOTE: This is working
						inDisplayTitle = false;
						String s = new String(buf, offset, len);
						displayTitle = s; 
						/* Example code using string buffer 
						response.append(s);
						response.append("\n");
						*/
					}
					if (inContent){
						
						String s = new String(buf, offset, len);
					//	logger.info("Content: "+s);
						content = s; 
					}
					
					if(inDate){
						inDate = false;
						String s = new String(buf, offset, len);
						retrievedDate = s;
					}
					
					if(inSource){
						inSource = false;
						String s = new String(buf, offset, len);
						source = s;
					}
					
					if(inSourceUrl){
						inSourceUrl = false; 
						String s = new String(buf, offset, len);
						source = s;
					}
					
					if (inGenes){		
						String s = new String(buf, offset, len);						
						genes.add(s);
					}
					if (inSymptoms){						
						String s = new String(buf, offset, len);
						symptoms.add(s);	
					}
					if (inScore) {					
						inScore = false;
					}
				}
					catch(NullPointerException e){
						
					}
				}
			};
			
		   // Uses SAXParser to go through the string 
			
			SAXParserFactory factory = SAXParserFactory.newInstance();
			SAXParser parser;
			try {
				parser = factory.newSAXParser();
				parser.parse(responseXML,  myHandler);
			} catch (ParserConfigurationException | SAXException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	
			req.setAttribute("zebraList",zebralist);
			
			
			try {
				//logger.info("In dispatcher!");
				req.getRequestDispatcher("/search.jsp").forward(req,resp);
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
	}
}	
	
