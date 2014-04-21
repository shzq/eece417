var map;
var xmlHttpReq = null;
var selectedMarkerID;
var guestbookNameString = "";

function loadMarkers() {
	//alert("loadMarkers");
	try {
		xmlHttpReq = new XMLHttpRequest();
		xmlHttpReq.onreadystatechange = httpCallBackFunction_loadMarkers;
		var url = "/resources/markers.xml";
	
		xmlHttpReq.open('GET', url, true);
    	xmlHttpReq.send(null);
    	
    	//alert();
    	
	} catch (e) {
    	alert("Error: " + e);
	}	
}

function httpCallBackFunction_loadMarkers() {
	//alert("httpCallBackFunction_loadMarkers");
	
	if (xmlHttpReq.readyState == 1){
		//updateStatusMessage("<blink>Opening HTTP...</blink>");
	}else if (xmlHttpReq.readyState == 2){
		//updateStatusMessage("<blink>Sending query...</blink>");
	}else if (xmlHttpReq.readyState == 3){ 
		//updateStatusMessage("<blink>Receiving...</blink>");
	}else if (xmlHttpReq.readyState == 4){
		var xmlDoc = null;

		if(xmlHttpReq.responseXML){
			xmlDoc = xmlHttpReq.responseXML;
		}else if(xmlHttpReq.responseText){
			var parser = new DOMParser();
		 	xmlDoc = parser.parseFromString(xmlHttpReq.responseText,"text/xml");			 	
		}

		if(xmlDoc){				
			//alert(xmlHttpReq.responseText);	
						
			var markerElements = xmlDoc.getElementsByTagName('marker');
			//alert(markerElements[0].getAttribute("srl"));	
			//alert(markerElements.length);
			
			for(mE = 0; mE < markerElements.length; mE++) {
				var markerElement = markerElements[mE];
				
				//alert(markerElement.getAttribute("srl"));
				
				var lat = parseFloat(markerElement.getAttribute("lat"));
				var lng = parseFloat(markerElement.getAttribute("lng"));
				var srl = markerElement.getAttribute("srl");
							
				var myLatlng = new google.maps.LatLng(lat, lng);
								
				var mrkID = ""+srl;
				var msgbox = "msgbox_"+mrkID;				
				var msglist = "msglist_"+mrkID; 
				var gstBkNm = guestbookNameString; // "default"; 
				
				var contentString  = '#' + mrkID + '<div id="content">' +  	
				  '<div class="msglist" id="'+ msglist +'"></div>' + '</div>' +
				  '<textarea class="msgbox" id="'+ msgbox +'" rows="2" cols="20"></textarea>' +			  
				  '<input type="button" value="Post" onclick="postAjaxRequest('+ 
					"'" + msgbox + "', '" + mrkID + "', '" + gstBkNm + "', '" + msglist + "'" +')"/>';  
														
				var marker = new google.maps.Marker({       
					position: myLatlng,
					map: map,
					title: ''+mrkID
				});
								
				addInfowindow(marker, contentString);
			}			
		}else{
			alert("No data.");
		}	
	}		
}

function addInfowindow(marker, content) {
	var infowindow = new google.maps.InfoWindow({
			content: content
	});
	google.maps.event.addListener(marker, 'click', function() {
		selectedMarkerID = marker.getTitle();
		infowindow.setContent(""+content);
		infowindow.setPosition(marker.getPosition());
		infowindow.open(marker.get('map'), marker);		 
		getAjaxRequest(); 
	});
}

function getAjaxRequest() {
	//alert("getAjaxRequest");
	try {
		xmlHttpReq = new XMLHttpRequest();
		xmlHttpReq.onreadystatechange = httpCallBackFunction_getAjaxRequest;
		var url = "/queryprocessor/?markerID="+selectedMarkerID+"&guestbookName="+guestbookNameString;
		
		xmlHttpReq.open('GET', url, true);
    	xmlHttpReq.send(null);
    	
    	//alert();
    	
	} catch (e) {
    	alert("Error: " + e);
	} 	
}

function httpCallBackFunction_getAjaxRequest() {
	//alert("httpCallBackFunction_getAjaxRequest");
	
	if (xmlHttpReq.readyState == 1){
		//updateStatusMessage("<blink>Opening HTTP...</blink>");
	}else if (xmlHttpReq.readyState == 2){
		//updateStatusMessage("<blink>Sending query...</blink>");
	}else if (xmlHttpReq.readyState == 3){ 
		//updateStatusMessage("<blink>Receiving...</blink>");
	}else if (xmlHttpReq.readyState == 4){
		var xmlDoc = null;

		if(xmlHttpReq.responseXML){
			xmlDoc = xmlHttpReq.responseXML;
		}else if(xmlHttpReq.responseText){
			var parser = new DOMParser();
		 	xmlDoc = parser.parseFromString(xmlHttpReq.responseText,"text/xml");			 	
		}

		if(xmlDoc){
			//alert(xmlHttpReq.responseText);			
			document.getElementById("msglist_"+selectedMarkerID).innerHTML=xmlHttpReq.responseText;					
		}else{
			alert("No data.");
		}	
	}		
}

function postAjaxRequest(postMsg, markerID, guestbookName, rspMsgList) {
	//alert("postAjaxRequest");
	try {
		xmlHttpReq = new XMLHttpRequest();
		xmlHttpReq.onreadystatechange = httpCallBackFunction_postAjaxRequest;
		var url = "/sign";
	
		xmlHttpReq.open("POST", url, true);
		xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');		
		
		var postMsgValue = document.getElementById(postMsg).value;
		var markerIDValue = markerID; 
		var guestbookNameValue = guestbookName; 
    	
		xmlHttpReq.send("postMsg="+postMsgValue+"&markerID="+markerIDValue+"&guestbookName="+guestbookNameValue);
    	
    	//alert();
    	
	} catch (e) {
    	alert("Error: " + e);
	}	
}

function newSpotAjaxRequest() {
	if (myGeocodeStat == false) {
		alert("Sorry, we could not find your location. Please check that you input the right address.");
	} else if (newSpot == null){
		alert("Please confirm your new spot location before you proceed.");
	} 
	else {
		try {
			xmlHttpReq = new XMLHttpRequest();
			xmlHttpReq.onreadystatechange = httpCallBackFunction_newSpotAjaxRequest;
			var url = "/registerspot";
			var st_number = newSpot.street_number;
			var st_name = newSpot.street_name;
			var nbhood = newSpot.neighborhood;
			var locality = newSpot.locality;
			var aL3 = newSpot.admin_level_3;
			var aL2 = newSpot.admin_level_2;
			var aL1 = newSpot.admin_level_1;
			var country = newSpot.country;
			var lat = newSpot.lat;
			var lng = newSpot.lng;
			var price = document.getElementById("price").value;
			var startdate = document.getElementById("startdate").value;
			var enddate = document.getElementById("enddate").value
			xmlHttpReq.open("POST", url, true);
			xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');		
			
			xmlHttpReq.send("stNumber="+st_number+"&stName="+st_name+"&nbhood="+nbhood+"&locality="+locality+"&aL3="+aL3+"&aL2="+"&aL1="+aL1+"&country="+country+"&lat="+lat+"&lng="+lng+"&price="+price+"&startdate="+startdate+"&enddate="+enddate);
			
			newSpot = null;
		} catch (e) {
			alert("Error: " + e);
		}
	}
	showNewSpots = true;
}

function cancelspotAjaxRequest(spotID) {
	try {
		xmlHttpReq = new XMLHttpRequest();
		xmlHttpReq.onreadystatechange = httpCallBackFunction_cancelspotAjaxRequest;
		var url = "/cancelspot";
		
		var id = spotID;
		console.log(id);
//		var id = '${fn:escapeXml(spotID)}'; 
		
		xmlHttpReq.open("POST", url, true);
		xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');		
		
		xmlHttpReq.send("id="+id);
		
		//alert();
		
	} catch (e) {
		alert("Error: " + e);
	}
}

function querySpotsAjaxRequest() {
	try {
		xmlHttpReq = new XMLHttpRequest();
		xmlHttpReq.onreadystatechange = httpCallBackFunction_querySpotAjaxRequest;
		var url = "/queryspot";
		//var price = document.getElementById("price").value;
		var location = document.getElementById("location").value;
		var startdate = document.getElementById("startdate").value;
		var enddate = document.getElementById("enddate").value
		xmlHttpReq.open("POST", url, true);
		xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');		
		
		xmlHttpReq.send("location="+location+"&startdate="+startdate+"&enddate="+enddate);
		
		//alert();
		
	} catch (e) {
		alert("Error: " + e);
	}
}

function newReservationAjaxRequest() {
	try {
		xmlHttpReq = new XMLHttpRequest();
		xmlHttpReq.onreadystatechange = httpCallBackFunction_newReservationAjaxRequest;
		var url = "/reservespot";
		var price = document.getElementById("price").value;
		console.log(price);

		var location = document.getElementById("location").value;
		console.log(location)
		var startdate = document.getElementById("startdate").value;
		console.log(startdate);
		var enddate = document.getElementById("enddate").value
		var spotID = document.getElementById("spotID").value;
		console.log(spotID);
		xmlHttpReq.open("POST", url, true);
		xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');		
		
		xmlHttpReq.send("price="+price+"&location="+location+"&startdate="+startdate+"&enddate="+enddate+"&id="+spotID);
		
		//alert();
		
	} catch (e) {
		alert("Error: " + e);
	}
}

function httpCallBackFunction_newSpotAjaxRequest() {
	console.log("callback!");
	if (xmlHttpReq.readyState == 1){
		console.log("1");
		//updateStatusMessage("<blink>Opening HTTP...</blink>");
	}else if (xmlHttpReq.readyState == 2){
		console.log("2");
		//updateStatusMessage("<blink>Sending query...</blink>");
	}else if (xmlHttpReq.readyState == 3){ 
		console.log("3");
		//updateStatusMessage("<blink>Receiving...</blink>");
	}else if (xmlHttpReq.readyState == 4){
		console.log("4");
		var xmlDoc = null;

		if(xmlHttpReq.responseXML){
			xmlDoc = xmlHttpReq.responseXML;			
		}else if(xmlHttpReq.responseText){
			var parser = new DOMParser();
		 	xmlDoc = parser.parseFromString(xmlHttpReq.responseText,"text/html");		 		
		}
		
		if(xmlDoc){				
			alert(xmlHttpReq.responseText);			
			document.getElementById("price").value = "";
	    	document.getElementById("location").value = "";
	    	document.getElementById("startdate").value = "";
	    	document.getElementById("enddate").value = "";
	    	
		}else{
			alert("No data.");
		}	
	}		
}

function httpCallBackFunction_cancelspotAjaxRequest() {
	console.log("callback!");
	if (xmlHttpReq.readyState == 1){
		console.log("1");
		//updateStatusMessage("<blink>Opening HTTP...</blink>");
	}else if (xmlHttpReq.readyState == 2){
		console.log("2");
		//updateStatusMessage("<blink>Sending query...</blink>");
	}else if (xmlHttpReq.readyState == 3){ 
		console.log("3");
		//updateStatusMessage("<blink>Receiving...</blink>");
	}else if (xmlHttpReq.readyState == 4){
		console.log("4");
		var xmlDoc = null;

		if(xmlHttpReq.responseXML){
			xmlDoc = xmlHttpReq.responseXML;			
		}else if(xmlHttpReq.responseText){
			var parser = new DOMParser();
		 	xmlDoc = parser.parseFromString(xmlHttpReq.responseText,"text/html");		 		
		}
		
		if(xmlDoc){				
			alert("Your spot was successfully registered!");		
			$("#"+xmlHttpReq.responseText).remove();
//			${fn:escapeXml(spotID)} ="";
			

		}else{
			alert("No data.");
		}	
	}		
}

function httpCallBackFunction_newReservationAjaxRequest() {
	console.log("callback!");
	if (xmlHttpReq.readyState == 1){
		console.log("1");
		//updateStatusMessage("<blink>Opening HTTP...</blink>");
	}else if (xmlHttpReq.readyState == 2){
		console.log("2");
		//updateStatusMessage("<blink>Sending query...</blink>");
	}else if (xmlHttpReq.readyState == 3){ 
		console.log("3");
		//updateStatusMessage("<blink>Receiving...</blink>");
	}else if (xmlHttpReq.readyState == 4){
		console.log("4");
		var xmlDoc = null;

		if(xmlHttpReq.responseXML){
			xmlDoc = xmlHttpReq.responseXML;			
		}else if(xmlHttpReq.responseText){
			var parser = new DOMParser();
		 	xmlDoc = parser.parseFromString(xmlHttpReq.responseText,"text/xml");		 		
		}
		
		if(xmlDoc){				
			alert(xmlHttpReq.responseText);	
			window.location.replace("/home.jsp");
		}else{
			alert("No data.");
		}	
	}		
}

function httpCallBackFunction_querySpotAjaxRequest() {
	if (xmlHttpReq.readyState == 1){
		console.log("1");
		//updateStatusMessage("<blink>Opening HTTP...</blink>");
	}else if (xmlHttpReq.readyState == 2){
		console.log("2");
		//updateStatusMessage("<blink>Sending query...</blink>");
	}else if (xmlHttpReq.readyState == 3){ 
		console.log("3");
		//updateStatusMessage("<blink>Receiving...</blink>");
	}else if (xmlHttpReq.readyState == 4){
		console.log("4");
		var xmlDoc = null;

		if(xmlHttpReq.responseXML){
			xmlDoc = xmlHttpReq.responseXML;			
		}else if(xmlHttpReq.responseText){
			var parser = new DOMParser();
		 	xmlDoc = parser.parseFromString(xmlHttpReq.responseText,"text/xml");		 		
		}
		
		if(xmlDoc){				
			$("#search-result-container").empty();
			$("#search-result-container").html(xmlHttpReq.responseText);		
		}else{
			alert("No data.");
		}	
	}		
	
}

function httpCallBackFunction_postAjaxRequest() {
	//alert("httpCallBackFunction_postAjaxRequest");
	
	if (xmlHttpReq.readyState == 1){
		//updateStatusMessage("<blink>Opening HTTP...</blink>");
	}else if (xmlHttpReq.readyState == 2){
		//updateStatusMessage("<blink>Sending query...</blink>");
	}else if (xmlHttpReq.readyState == 3){ 
		//updateStatusMessage("<blink>Receiving...</blink>");
	}else if (xmlHttpReq.readyState == 4){
		var xmlDoc = null;

		if(xmlHttpReq.responseXML){
			xmlDoc = xmlHttpReq.responseXML;			
		}else if(xmlHttpReq.responseText){
			var parser = new DOMParser();
		 	xmlDoc = parser.parseFromString(xmlHttpReq.responseText,"text/xml");		 		
		}
		
		if(xmlDoc){				
			//alert(xmlHttpReq.responseText);			
			document.getElementById("msglist_"+selectedMarkerID).innerHTML=xmlHttpReq.responseText;
			document.getElementById("msgbox_"+selectedMarkerID).value = "";
		}else{
			alert("No data.");
		}	
	}		
}

// NewSpot class
function NewSpot() {
	this.street_number = null;
	this.street_name = null; // route
	this.neighborhood = null;
	this.locality = null;
	this.admin_level_3 = null;
	this.admin_level_2 = null;
	this.admin_level_1 = null;
	this.country = null;
	this.lat = null;
	this.lng = null;
}

function checkInputAddr() {
	if (showNewSpots == true) {
		
		for (var i = 0; i < addrMarkers.length; i++) {
			addrMarkers[i].setMap(null);
		}
		addrMarkers = [];
		var inputAddr = document.getElementById("location").value;
		var bounds = new google.maps.LatLngBounds();
		geocoder.geocode( { 'address': inputAddr}, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
					for (var i = 0; i < results.length; i++) {
						// set up marker for each result
						var marker = new google.maps.Marker({
							map: map,
							position: results[i].geometry.location,
							animation: google.maps.Animation.DROP,
							icon: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png'
						});
						bounds.extend(marker.position); // include marker in bounds
						// set up infoWindow for each marker
						var infoWindow = new google.maps.InfoWindow();
						var formAddr = results[i].formatted_address;
						var content = "<p>"+formAddr +"</p>"+ '<br/><input class="btn btn-info btn-sm" type="button" value="Confirm Location" onClick="confirmNewSpot('+ i + ')"/>';
						infoWindow.setContent(content);
						infoWindow.open(map, marker);
						
						newSpotResults = results;
						addrMarkers.push(marker);
						addrInfoWindows.push(infoWindow);
					}
				
				map.fitBounds(bounds);
				
			} else {
				myGeocodeStat = false;
			}
		});
	}
}

function displayInputAddr() {
		
	for (var i = 0; i < addrMarkers.length; i++) {
		addrMarkers[i].setMap(null);
	}
	addrMarkers = [];
	var inputAddr = document.getElementById("location").value;
	var bounds = new google.maps.LatLngBounds();
	geocoder.geocode( { 'address': inputAddr}, function(results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
				for (var i = 0; i < results.length; i++) {
					// set up marker for each result
					var marker = new google.maps.Marker({
						map: map,
						position: results[i].geometry.location,
						animation: google.maps.Animation.DROP,
						icon: 'http://maps.google.com/mapfiles/ms/icons/red-dot.png'
					});
					bounds.extend(marker.position); // include marker in bounds
					// set up infoWindow for each marker
					var formAddr = results[i].formatted_address;
					var contentString = "<p>"+formAddr+"&nbsp&nbsp&nbsp</p>";

					var infoWindow = new google.maps.InfoWindow({content:contentString});
					//infoWindow.setContent(content);
					infoWindow.open(map, marker);
					
					newSpotResults = results;
					addrMarkers.push(marker);
					addrInfoWindows.push(infoWindow);
				}
			
			map.fitBounds(bounds);
			
		} else {
			myGeocodeStat = false;
		}
	});
}

function confirmNewSpot(chosenMarkerId) {
	showNewSpots = false;
	newSpotMarker = addrMarkers[chosenMarkerId];
	newSpotInfoWind = addrInfoWindows[chosenMarkerId];
	addrMarkers.splice(chosenMarkerId, 1);
	var myResult = newSpotResults[chosenMarkerId];
	newSpotResults.splice(chosenMarkerId, 1);
	for (var i = 0; i < addrMarkers.length; i++) {
			addrMarkers[i].setMap(null);
	}
	addrMarkers = [];
	addrInfoWindows = [];
	newSpotResults = [];
	
	console.log(myResult);
	
	newSpot = new NewSpot();
	for (var i = 0; i < myResult.address_components.length; i++) {
		if ($.inArray("street_number", myResult.address_components[i].types) >= 0) {
			newSpot.street_number = myResult.address_components[i].short_name;
		} else if ($.inArray("route", myResult.address_components[i].types) >= 0) {
			newSpot.street_name = myResult.address_components[i].short_name;
		} else if ($.inArray("neighborhood", myResult.address_components[i].types) >= 0) {
			newSpot.neighborhood = myResult.address_components[i].short_name;
		} else if ($.inArray("locality", myResult.address_components[i].types) >= 0) {
			newSpot.locality = myResult.address_components[i].short_name;
		} else if ($.inArray("administrative_area_level_3", myResult.address_components[i].types) >= 0) {
			newSpot.admin_level_3 = myResult.address_components[i].short_name;
		} else if ($.inArray("administrative_area_level_2", myResult.address_components[i].types) >= 0) {
			newSpot.admin_level_2 = myResult.address_components[i].short_name;
		} else if ($.inArray("administrative_area_level_1", myResult.address_components[i].types) >= 0) {
			newSpot.admin_level_1 = myResult.address_components[i].short_name;
		} else if ($.inArray("country", myResult.address_components[i].types) >= 0) {
			newSpot.country = myResult.address_components[i].short_name;
		}
	}
	
	newSpot.lat = myResult.geometry.location.lat();
	newSpot.lng = myResult.geometry.location.lng();
	
	var content = newSpotInfoWind.getContent().split("<br>")[0];
	newSpotInfoWind.setContent(content  + '<br><input type="button" value="Cancel" onClick="cancelNewSpot()"/>');
}

function cancelNewSpot() {
	newSpotMarker.setMap(null);
	newSpotMarker = null;
	newSpot = null;
	showNewSpots = true;
}
