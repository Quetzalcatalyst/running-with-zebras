package com.hackathon.runningwithzebras;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.runningwithzebras.Zebra;
import com.runningwithzebras.parsers.dom.ZebraListParser;
import com.runningwithzebras.rest.ZebraApiConsumer;

public class FindZebraApiExplorer extends HttpServlet {

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		ZebraApiConsumer consumer = new ZebraApiConsumer();

		int numResults = 20;

		consumer.setNumResults(numResults);
		consumer.addSymptom("Cough");
		consumer.addSymptom("Seizure");

		InputStream stream=null;
		try {
			stream = consumer.getInputStream();


		} catch (Exception ex) {
			System.out.println("Exception!! " + ex);
			return;
		}
		

		ZebraListParser listParser = new ZebraListParser();

		ArrayList<Zebra> zebraList = listParser.ObjectFromDOM(stream);
		
		ArrayList<String> list = new ArrayList<String>();

		System.out.println("zebra size: " + zebraList.size());

		for (Zebra zebra : zebraList) {
			list.add(zebra.getDisplayTitle());
		}
		
		req.setAttribute("zebraList", list);

		try {
			req.getRequestDispatcher("/apiexplorer.jsp").forward(req, resp);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}