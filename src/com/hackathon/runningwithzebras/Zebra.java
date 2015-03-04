package com.hackathon.runningwithzebras;

import java.util.ArrayList;
import java.util.List;

/*
 * Class used to store elements of the XML file from find zebras 
 * Consists of various getters and setters 
 */

public class Zebra {
	
	String content;
	String displayTitle;
	String retrievedDate;
	List<String> genes;
	List<String> symptoms;
	String source;
	String sourceUrl;
	String score; 
	
	public Zebra(String displaytitle, String content, String source, String sourceUrl, String retrievedDate, List<String> genes){
		this.displayTitle = displaytitle;
		this.content = content;
		this.source = source;
		this.sourceUrl = sourceUrl;
		this.retrievedDate = retrievedDate;
		this.genes = genes; 
	}
	
	public String getContent(){
		return content;
	}
	public String getRetrievedDate(){
		return retrievedDate;
	}
	
	public String getDisplayTitle(){
		return displayTitle;
	}
	
	public List<String> getGenes()
	{
		return genes;
	}
	
	public List<String> getSymptoms()
	{
		return symptoms;
	}
	
	public String getSourceUrl()
	{
		return sourceUrl;
	}
	
	public String getScore()
	{
		return score; 
	}
	public String getSource()
	{
		return source; 
	}
	
	
}
