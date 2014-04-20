package ca.appengine.project.test;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SpotQueryForwardServlet extends HttpServlet {
	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException, ServletException {
		System.out.println(req.getParameter("location"));
		System.out.println(req.getParameter("startdate"));
		System.out.println(req.getParameter("endate"));
		String location = req.getParameter("location");
		String startDateStr = req.getParameter("startdate");
		String endDateStr = req.getParameter("endate");
	
		ServletContext sc = getServletContext();
		RequestDispatcher rd = sc.getRequestDispatcher("/spotdetails.jsp");
		req.setAttribute("location", location);
		req.setAttribute("startdate", startDateStr);
		req.setAttribute("enddate", endDateStr);
		rd.forward(req, resp);
	}    
}
