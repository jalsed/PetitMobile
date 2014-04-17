package utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.GeolocationEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import flash.sensors.Geolocation;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import classes.GlobalConstants;
	
	[Event(name="locationUpdate", type="flash.events.Event")]
	public class GeolocationUtil extends EventDispatcher
	{
		protected var geo:Geolocation;
		public var updateCount:int;
		protected var service:HTTPService = new HTTPService();
		
		public var location:String;
		public var longitude:Number=0;
		public var latitude:Number=0;
		public var city:String="";
		public var zip:String="";
		
		public function GeolocationUtil()
		{
			service.url = "https://maps.googleapis.com/maps/api/geocode/xml";
		}
		
		public function geoCodeAddress(address: String):AsyncToken
		{
			return service.send({address: address, sensor: Geolocation.isSupported});
		}
		
		public function getLocation():void
		{
			if (Geolocation.isSupported)
			{
				geo = new Geolocation();
				geo.setRequestedUpdateInterval(700);   
				updateCount = 0;
				geo.addEventListener(GeolocationEvent.UPDATE, locationUpdateHandler);
			} 
		}
		
		
		public function getZipcodeLocation(in_zipcode:String):void {
			
			if(in_zipcode.length==0) {	//If nothing is input then set a default
				longitude = 13.2;
				latitude = 56.0;	
				
			}
			else {
				//get position via zipcode
				var token:AsyncToken =  service.send({address: in_zipcode+" ,Sweden", sensor:Geolocation.isSupported});		//Hardcoded to Sweden for the moment
				token.addResponder(new AsyncResponder(
					function(event:ResultEvent, token:AsyncToken):void
					{
						
						longitude = event.result.GeocodeResponse.result.geometry.location.lng;
						latitude =  event.result.GeocodeResponse.result.geometry.location.lat;
						if(event.result.GeocodeResponse.result.address_component.hasOwnProperty("2"))
							city = event.result.GeocodeResponse.result.address_component[2].long_name as String;
						else
							city="";
						
						location="";
						dispatchEvent(new Event("locationUpdate"));
					},
					function (event:FaultEvent, token:AsyncToken):void
					{
						// fail silently
						trace("Reverse geocoding error: " + event.fault.faultString);
					}));
			}
			
		}
		
		protected function locationUpdateHandler(event:GeolocationEvent):void
		{
			// Throw away the first location event because it's almost always the last known location, not current location
			updateCount++;
			if (updateCount == 1) return; 
			
			if (event.horizontalAccuracy <= 150)
			{
				trace("lat:" + event.latitude + " long:" + event.longitude + " horizontalAccuracy:" + event.horizontalAccuracy);
				geo.removeEventListener(GeolocationEvent.UPDATE, locationUpdateHandler);
				geo = null;
			}
			
			longitude = event.longitude;
			latitude = event.latitude;
			
			var token:AsyncToken = service.send({latlng: latitude+","+longitude, sensor: Geolocation.isSupported});
			token.addResponder(new AsyncResponder(
				function(event:ResultEvent, token:AsyncToken):void
				{
					// Map the location to city and state from the response address component
					//	location = event.result.GeocodeResponse.result[0].address_component[3].long_name + ', '+ event.result.GeocodeResponse.result[0].address_component[5].long_name;	//event.result.GeocodeResponse.result[0].address_component[6].long_name är postnummer
					//eller använd  event.result.GeocodeResponse.result[0].formatted_address
					
					location = event.result.GeocodeResponse.result[0].address_component[5].long_name + " "+ event.result.GeocodeResponse.result[0].address_component[2].long_name;
					//location = event.result.GeocodeResponse.result[0].formatted_address;
					dispatchEvent(new Event("locationUpdate"));
				},
				function (event:FaultEvent, token:AsyncToken):void
				{
					// fail silently
					trace("Reverse geocoding error: " + event.fault.faultString);
				}));
		}
		
		
		public function getAddressByLocation(in_lat:Number,in_lon:Number):void {	//MAPQUEST GEOCODING
			
			
			// Using Yahoo geocoding 
			
			var urlReq:URLRequest;
			var urlLdr:URLLoader;
			var urlVar:URLVariables;
			
			//			urlReq = new URLRequest("http://www.mapquestapi.com/geocoding/v1/reverse?key="+GlobalConstants.MAP_KEY+"&outFormat=xml&country=SE&location="+in_lat.toString()+","+in_lang.toString());	//+"&callback=renderReverse");
			
			//			var timestamp:String =  (new Date().time - 7 * 24 * 60 * 60 * 1000).toString();
			//			var val:String="&oauth_version=1.0&oauth_nonce=a1e88d60b3c07d416fb43f21024c40b3&oauth_timestamp="+timestamp+"&oauth_consumer_key=dj0yJmk9YVczRWthRDByZEpjJmQ9WVdrOWRVMVBhMnhzTlRBbWNHbzlNVGN4TlRZMk1URTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD1mOQ--&oauth_signature_method=HMAC-SHA1&oauth_signature=kEBJXyRAFC4RYnm9Fegwt3nIO%2Fo%3C";
			//			urlReq = new URLRequest("http://yboss.yahooapis.com/geo/placefinder?location="+in_lat.toString()+"+"+in_lon.toString()+"&appid=uMOkll50&gflags=R"+val);			
			
			
			/*http://www.geonames.org är en fri geoservice som har reversegeocoding. Kräver att man betalar för snabbare access, support mm */
			
			urlReq = new URLRequest("http://api.geonames.org/findNearbyPostalCodesJSON?lat="+in_lat.toString()+"&lng="+in_lon.toString()+"&username=jalsed");
			
			/* Initialize the URLRequest object with the URL to the file of name/value pairs. */
			//			gFlags: L=only in locale (sweden) 
			
			
			/* Initialize the URLLoader object, assign the various event listeners, and load the specified URLRequest object. */
			urlLdr = new URLLoader();
			
			urlLdr.addEventListener(Event.COMPLETE, doGeoCode);
			//	urlLdr.addEventListener(Event.OPEN, doEvent);
			//	urlLdr.addEventListener(HTTPStatusEvent.HTTP_STATUS, doEvent);
			urlLdr.addEventListener(IOErrorEvent.IO_ERROR, errorGeoCode);
			//	urlLdr.addEventListener(ProgressEvent.PROGRESS, doEvent);
			//	urlLdr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, doEvent);
			urlLdr.load(urlReq);	 
			
		}
		
		
		
		private function doGeoCode(evt:Event):void {		//Yahoo geocoding
			
			//var resStr:String = evt.currentTarget.data;
			//var resXML:XML = new XML(resStr);
			//city=resXML.code.name;;
			//zip=resXML.code[0].postalcode;
			
			var jsonresult:Object = JSON.parse(evt.target.data);
			
			city=jsonresult.postalCodes[0].placeName;
			zip=jsonresult.postalCodes[0].postalCode;
			
			dispatchEvent(new Event("locationUpdate"));
		}	
		private function errorGeoCode(event:IOErrorEvent):void {
			trace("error");
		}
	}
}