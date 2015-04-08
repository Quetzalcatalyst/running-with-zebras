package com.hackathon.runningwithzebras;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.runningwithzebras.Symptom;
import com.runningwithzebras.parsers.json.OpenFDASymptomListParser;
import com.runningwithzebras.rest.OpenFDAApiConsumer;

public class OpenFdaApiExplorer extends HttpServlet {

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		OpenFDAApiConsumer consumer = new OpenFDAApiConsumer();

		InputStream stream = null;

		try {
			stream = consumer.getInputStream();
		} catch (Exception ex) {

			System.out.println(ex);
			return;
		}

		ArrayList<Symptom> symptoms = new OpenFDASymptomListParser()
				.ObjectFromJSON(stream);

		ArrayList<String> list = new ArrayList<String>();

		for (Symptom symptom : symptoms)
			list.add(symptom.getTerm());

		req.setAttribute("zebraList", list);

		try {
			req.getRequestDispatcher("/apiexplorer.jsp").forward(req, resp);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}