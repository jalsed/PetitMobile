package dao
{
	import classes.GlobalConstants;
	
	import events.FeedEvent;
	import events.PetEvent;
	
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
	
	public class FeedDAO extends EventDispatcher 
	{
		
		/********************************************************
		*			CREATE FEED									*
		*														*
		*********************************************************/
			 
		public function restCreateFeed(in_petid:String,in_text:String,in_restrictiontype:String,imageFID:String,thumbFID:String,videoFID:String,audioFID:String):void {
			var feedObj:Object = {};
			feedObj.type = "blog";
			feedObj.title = "News";			//Remove later
			feedObj.field_pet = { "und": in_petid};
			feedObj.body = {
					"und": [
						{
							"value": in_text,
							"format": "filtered_html"
						}
					]
			};

            feedObj.field_blog_images = {'und': []};
            feedObj.field_audio = {'und': []};
            feedObj.field_blog_video = {'und': []};
			
			if (imageFID != "") {
                feedObj.field_blog_images.und.push({"fid": imageFID, "display": 1});
            }

			if (videoFID != "") {
				feedObj.field_blog_video.und.push({"fid": videoFID, "dimensions": "480x360", "thumbnail": {"fid": thumbFID}});
			}

			if (audioFID != "") {
				feedObj.field_audio.und.push({"fid": audioFID});
			}

			
            feedObj.field_blog_visibility = {
				"und": in_restrictiontype
			};
  
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restCreateFeedHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restCreateFeedFaultHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "node");
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.POST;
			
			urlRequest.data = JSON.stringify(feedObj);
			urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
		}
		
		private function restCreateFeedHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
		//	var obj:Object = JSON.parse(loader.data);
			
			dispatchEvent(new FeedEvent(FeedEvent.FEED_PUBLISHED,null,true,true));
		
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restCreateFeedFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restCreateFeedHandler);
		}
		
		private function restCreateFeedFaultHandler(event:IOErrorEvent):void {
			var loader:URLLoader = URLLoader(event.target);
				 
			dispatchEvent(new FeedEvent(FeedEvent.FEED_PUBLISH_FAILED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restCreateFeedFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restCreateFeedHandler);
		}
		
		
		/********************************************************
		 *			DELETE (OWN) FEED							*
		 *														*
		 *********************************************************/
		public function restDeleteFeed(in_feedid:String):void{
			 
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restDeleteFeedHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restDeleteFeedFaultHandler);
			var url:String = GlobalConstants.DRUPAL_PATH + "node/" + in_feedid;
			var urlRequest:URLRequest = new URLRequest(url);
			var delHeader:URLRequestHeader = new URLRequestHeader("X-HTTP-Method-Override", "DELETE");
			var acceptHeader:URLRequestHeader = new URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(delHeader);
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.DELETE;
			
			urlLoader.load(urlRequest);

		}
		
		private function restDeleteFeedHandler(event:Event):void {
		 
			dispatchEvent(new FeedEvent(FeedEvent.FEED_DELETED,null));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restDeleteFeedFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restDeleteFeedHandler);
		}
		
		private function restDeleteFeedFaultHandler(event:IOErrorEvent):void {
			dispatchEvent(new FeedEvent(FeedEvent.FEED_DELETE_FAILED,null));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restDeleteFeedFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restDeleteFeedHandler);
		}
		
		
		
		
		
		/********************************************************
		 *			GET FEEDS (LIST)							*
		 *														*
		 ********************************************************/
		
		public function restGetFeeds(petid:String):void {
			if(petid.length>0) {
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, restGetFeedsCompleteHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetFeedsFailedHandler);
				var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "pet/" + petid + "/feed.json");
				urlLoader.load(urlRequest);
			}
		}
		
		private function restGetFeedsFailedHandler(event:Event):void {
			trace("Couldn't get feeds from server.");	
			
			dispatchEvent(new FeedEvent(FeedEvent.FEED_GETFEEDLIST_FAILED,null,true,true));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restGetFeedsFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restGetFeedsCompleteHandler);
		}
		
		private function restGetFeedsCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader2.data);
				
			dispatchEvent(new FeedEvent(FeedEvent.FEED_GETFEEDLIST_READY,obj,true,true));	
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restGetFeedsFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restGetFeedsCompleteHandler);
		}
		 
		 
		/********************************************************
		 *			GET FEED DETAIL								*
		 *														*
		 ********************************************************/
		
		public function restGetFeedDetail(feedID:String):void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restGetFeedDetailCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetFeedDetailFailedHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "node/" + feedID + ".json");
			urlLoader.load(urlRequest);
		}
		
		
		private function restGetFeedDetailFailedHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new FeedEvent(FeedEvent.FEED_GETFEED_FAILED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restGetFeedDetailFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restGetFeedDetailCompleteHandler);
		}
		
		private function restGetFeedDetailCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader2.data);
		
			dispatchEvent(new FeedEvent(FeedEvent.FEED_GETFEED_READY,obj,true,true));	//A user was successfully retrieved
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restGetFeedDetailFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restGetFeedDetailCompleteHandler);
		}
		
		
		/********************************************************
		 * 		REPORT FEED										*
		 * 														*						
		 ********************************************************/
		
		public function restReportFeed(feedID:String):void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restReportFeedDCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restReportFeedDFailedHandler);
			var urlRequest:URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "node/" + feedID + "/report");
			var acceptHeader:URLRequestHeader = new URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.contentType = "application/json";
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = "data";
			urlLoader.load(urlRequest);
		}
		
		private function restReportFeedDFailedHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new FeedEvent(FeedEvent.FEED_REPORT_FAILED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restReportFeedDFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restReportFeedDCompleteHandler);
		}
		
		private function restReportFeedDCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new FeedEvent(FeedEvent.FEED_REPORTED,null,true,true));	//A user was successfully retrieved
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restReportFeedDFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restReportFeedDCompleteHandler);
		}
		
		
		
	}
}