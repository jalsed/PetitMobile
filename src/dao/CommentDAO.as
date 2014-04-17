package dao
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	import mx.collections.ArrayCollection;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	
	import classes.GlobalConstants;
	
	import events.CommentEvent;
	import events.FeedEvent;
	
	public class CommentDAO extends EventDispatcher 
	{
		
		[Bindable]
		private var comments:ArrayCollection = new ArrayCollection();		
		 
		
		public function getComments():ArrayCollection {
			return comments;
		}
		
		public function getNumOfComments():int {
			return comments.length;
		}
		
		/********************************************************
		 *			SERVER FUNCTIONALITY						*
		 *														*
		 *********************************************************/
		
		public function restGetComments(pid:String):void {
			if(pid!="0") {
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, restGetCommentsHandler);
				var loginUrl:String = GlobalConstants.DRUPAL_PATH + "node/" + pid + "/petcomments.json";
				var urlRequest:URLRequest = new URLRequest(loginUrl);
				
				function restGetCommentsHandler(event:Event):void {
					var loader:URLLoader = URLLoader(event.target);
					var objcomments:Object = JSON.parse(loader.data);
					
					comments.removeAll();
					for each(var obj:Object in objcomments) {
						comments.addItem(obj);
					}
					 
					dispatchEvent( new CommentEvent(CommentEvent.COMMENTS_READY,objcomments));
					
					//Clean
				 	loader.removeEventListener(Event.COMPLETE,restGetCommentsHandler);
				}
				 
				urlLoader.load(urlRequest);
			}
		}
		
		//pid=petID, nid=nodeID (newsID)
		public function restAddComment(in_pid:String, comment:String,in_nid:String):void {
			var rpcParams:Object = {};
			rpcParams.comment_body = {'und': [{'value': comment}]};
            rpcParams.field_comment_pet = { "und": in_pid}; // TODO. set proper petID
			rpcParams.nid = in_nid;	//behövs denna då?
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restAddCommentHandler);
			var loginUrl:String = GlobalConstants.DRUPAL_PATH + "comment";
			var urlRequest:URLRequest = new URLRequest(loginUrl);
			var acceptHeader:URLRequestHeader = new URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.POST;
			
			urlRequest.data = JSON.stringify(rpcParams);
			urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
		}
		
		private function restAddCommentHandler(event:Event):void {
			 this.dispatchEvent(new CommentEvent(CommentEvent.COMMENT_ADDED));
			 
			 //Clean
			 var loader:URLLoader = URLLoader(event.target);
			 loader.removeEventListener(Event.COMPLETE,restAddCommentHandler);
		}
	}
}