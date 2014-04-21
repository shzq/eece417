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
	//alert("postAjaxRequest");
	if (geocodeStatusCond = false) {
		alert("Your input address gives unsuccessful geocode because of: " + geocodeStatus);
	} else {
		try {
			xmlHttpReq = new XMLHttpRequest();
			xmlHttpReq.onreadystatechange = httpCallBackFunction_newSpotAjaxRequest;
			var url = "/registerspot";
			var price = document.getElementById("price").value;
			var location = document.getElementById("location").value;
			var startdate = document.getElementById("startdate").value;
			var enddate = document.getElementById("enddate").value
			xmlHttpReq.open("POST", url, true);
			xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');		
			
			xmlHttpReq.send("price="+price+"&location="+location+"&startdate="+startdate+"&enddate="+enddate);
			
			//alert();
			
		} catch (e) {
			alert("Error: " + e);
		}
	}
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

function AddSpotInfo(city) {	
	document.getElementById("location").value = city;
}

function checkInputAddr() {
	var inputAddr = document.getElementById("location").value;
	var bounds = new google.maps.LatLngBounds();
	geocoder.geocode( { 'address': inputAddr}, function(results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			if (results.length > 0) {
				for (var i  = 0; i < results.length; i++) {
					var marker = new google.maps.Marker({
						map: map,
						position: results[i].geometry.location,
						animation: google.maps.Animation.DROP,
						icon: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png'
					});
					bounds.extend(marker.position);
					var infoWindow = new google.maps.InfoWindow();
					var formAddr = results[i].formatted_address;
					var content = formAddr + '<br><input type="button" value="Confirm Location" onClick="removeAddrMarkers('+ i + ')"/>';
					infoWindow.setContent(content);
					infoWindow.open(map, marker);
					addrMarkers.push(marker);
					addrInfoWindows.push(infoWindow);
				}
			} else {
				var marker = new google.maps.Marker({
					map: map,
					position: results[0].geometry.location,
					animation: google.maps.Animaiton.DROP,
					icon: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png'
				});
				var infoWindow = new google.maps.InfoWindow();
				var content = results[0].formatted_address;
				infoWindow.setContent(content);
				infoWindow.open(map, marker);
				newSpotMarker = marker;
				newSpotInfoWind = infoWindow;
			}
			
			map.fitBounds(bounds);
			
		} else {
			
			geocodeStatusCond = false;
			geocodeStatus = status;
			alert("Your input address gives unsuccessful geocode because of: " + geocodeStatus);
		}
	});
}

function removeAddrMarkers(chosenMarkerId) {
	newSpotMarker = addrMarkers[chosenMarkerId];
	newSpotInfoWind = addrInfoWindows[chosenMarkerId];
	addrMarkers.splice(chosenMarkerId, 1);
	for (var i = 0; i < addrMarkers.length; i++) {
			addrMarkers[i].setMap(null);
	}
	addrMarkers = [];
	addrInfoWindows = []
	
	var content = newSpotInfoWind.getContent().split("<br>")[0];
	newSpotInfoWind.setContent(content);
}