package dao
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import classes.GlobalConstants;
	
	import events.ContestantEvent;
	
	import models.ContestantVO;
	 
	public class ContestantDAO extends EventDispatcher 
	{
		  
		/********************************************************
		 *			GET CONTESTANTS (LIST)						*
		 *														*
		 ********************************************************/
		
		public function restGetContestants(competitionid:String):void {
		 
			if(competitionid.length>0) {
				var urlLoader:URLLoader = new URLLoader();
				var urlRequest : URLRequest;
					urlLoader.addEventListener(Event.COMPLETE, restGetContestantsCompleteHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetContestantsFailedHandler);
					
				urlRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "competition/" + competitionid);
				var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
				urlRequest.requestHeaders.push(acceptHeader);
				urlRequest.method = URLRequestMethod.GET;
				
				urlLoader.load(urlRequest);
			}
			 
		}
		
		private function restGetContestantsFailedHandler(event:Event):void {
			trace("Couldn't get contestants from server.");	
			
			dispatchEvent(new ContestantEvent(ContestantEvent.CONTESTANT_GETCONTESTANTS_FAILED,null,true,true));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restGetContestantsFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restGetContestantsCompleteHandler);
		}
		
		private function restGetContestantsCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader2.data);
			
			dispatchEvent(new ContestantEvent(ContestantEvent.CONTESTANT_GETCONTESTANTS_READY,obj,true,true));	
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restGetContestantsFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restGetContestantsCompleteHandler);
		}
	
		
	 
	}
}