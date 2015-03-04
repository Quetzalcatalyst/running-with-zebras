package com.hackathon.runningwithzebras;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sourceforge.tess4j.Tesseract;
import net.sourceforge.tess4j.TesseractException;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.images.Image;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;


@SuppressWarnings("serial")
public class ImageUploadTest extends HttpServlet {
	
	// NOTE: See about accessing the images from the account page. A good idea may be to 
	// save the blob key according to name + timestamp for future reference 
	// Code which allows the user to select relevant parts of the document: 
	
	/*
	File imageFile = new File("hello.txt");
	Tesseract instance = 
	
	*/
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	private ImagesService imagesService = ImagesServiceFactory.getImagesService();

    @Override
    
    public void doPost(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException {
    	
    	// gets the file that was uploaded via blobstoreService (NOTE: is there an easier way -- this may be better
    	// in the long run to save image files in the cloud) 
    	
    	Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(req);
    	BlobKey blobKey = blobs.get("myFile").get(0);
        Image image = ImagesServiceFactory.makeImageFromBlob(blobKey);
        // String url = image.getServingUrl();
        
        
        
        /*
        Tesseract instance = Tesseract.getInstance();
        
        try {
        	String result = instance.doOCR((File) image);
        	res.getWriter().println("result");
        	//System.out.println(result);
        } catch (TesseractException e) {
        	System.err.println(e.getMessage());
        }
        */
        
        
        // Add code here to modify the image via image service factory? 
        
        
        
    	/*
    	 * Example code 
    	 * 

        Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(req);
        List<BlobKey> blobKeys = blobs.get("myFile");

        if (blobKeys == null || blobKeys.isEmpty()) {
            res.sendRedirect("/");
        } else {
            res.sendRedirect("/serve?blob-key=" + blobKeys.get(0).getKeyString());
        }
        */
    }
}
	
