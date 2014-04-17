package dao
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	import mx.collections.ArrayCollection;
	
	import classes.GlobalConstants;
	
	import events.BadgeEvent;
	
	public class BadgeDAO extends EventDispatcher 
	{
		 
		/********************************************************
		 *			GET MY BADGES								*
		 *														*
		 *********************************************************/
		
		public function restGetMyBadges(in_userid:Number):void {
			if(in_userid!=0) {
				var urlLoader:URLLoader = new URLLoader();
				var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
				
				urlLoader.addEventListener(Event.COMPLETE, restGetBadgesHandler);
				//urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetMBadgesFailedHandler);
				var loginUrl:String = GlobalConstants.DRUPAL_PATH + "user/" + in_userid.toString() + "/badges";
				var urlRequest:URLRequest = new URLRequest(loginUrl);
				urlRequest.requestHeaders.push(acceptHeader);
				urlRequest.method= URLRequestMethod.GET;
				
				
				function restGetBadgesHandler(event:Event):void {
					var loader:URLLoader = URLLoader(event.target);
					var userbadges:Object = JSON.parse(loader.data);
					
					if(userbadges!=null) {
						dispatchEvent( new BadgeEvent(BadgeEvent.MYBADGES_READY,userbadges));
					}
					  
					//Clean
				 	loader.removeEventListener(Event.COMPLETE,restGetBadgesHandler);
				}
				 
				urlLoader.load(urlRequest);
			}
		}

	
		/********************************************************
		 *			GET BADGE DETAILS							*
		 *														*
		 *********************************************************/
		
		public function restGetBadgeDetails(in_badgeid:String,in_pos:String,in_date:Number):void {
			if(in_badgeid!="0" && in_badgeid!=null) {
				var urlLoader:URLLoader = new URLLoader();
				var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
				
				urlLoader.addEventListener(Event.COMPLETE, restGetBadgeDetailsHandler);
				//urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetBadgeDetailsFailedHandler);
				var loginUrl:String = GlobalConstants.DRUPAL_PATH + "node/" + in_badgeid;
				var urlRequest:URLRequest = new URLRequest(loginUrl);
				
				urlRequest.requestHeaders.push(acceptHeader);
				urlRequest.method= URLRequestMethod.GET;
				
				
				function restGetBadgeDetailsHandler(event:Event):void {
					var loader:URLLoader = URLLoader(event.target);
					var objBadgeDetails:Object = JSON.parse(loader.data);
					objBadgeDetails.position = in_pos;
					objBadgeDetails.recieved = in_date;
					
					dispatchEvent( new BadgeEvent(BadgeEvent.BADGEDETAILS_READY,objBadgeDetails));
					
					//Clean
					loader.removeEventListener(Event.COMPLETE,restGetBadgeDetailsHandler);
				}
				
				urlLoader.load(urlRequest);
			}
		}

	}
}