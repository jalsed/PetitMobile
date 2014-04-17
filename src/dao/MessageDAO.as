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
	
	import events.FeedEvent;
	import events.MessageEvent;
	
	import models.MessageVO;
	
	public class MessageDAO extends EventDispatcher 
	{
		[Bindable]
		private var messages:ArrayCollection = new ArrayCollection();
		 
	
		public function getMessages():ArrayCollection {
			return messages;
		}
		
		/********************************************************
		*	GET MY MESSAGES										*
		*														*
		*********************************************************/
		
		public function restGetMessages(in_user:int,in_page:int,in_pageSize:int):void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restMessagesHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,getMessagesFaultHandler);
			
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			var urlRequest:URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "user/" + in_user.toString()+"/news?page="+in_page.toString()+"&pagesize="+in_pageSize.toString());
			
			urlRequest.requestHeaders.push(acceptHeader);
			
			urlLoader.load(urlRequest);
		}
		
		private function restMessagesHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			var objmessages:Object=null;
			
			if(loader.bytesLoaded>100)
				objmessages = JSON.parse(loader.data);
			
			this.dispatchEvent(new MessageEvent(MessageEvent.Message_GETLIST_READY,objmessages));
		
			//Clean
		 	loader.removeEventListener(Event.COMPLETE,restMessagesHandler);
		}
		
		private function getMessagesFaultHandler(event:Event):void {
			this.dispatchEvent(new MessageEvent(MessageEvent.Message_GETLIST_FAILED));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(Event.COMPLETE,restMessagesHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,getMessagesFaultHandler);
		}
		 
		/********************************************************
		 *	GET MY CREATED MESSAGES								*
		 *														*
		 *********************************************************/
		
		public function restGetOwnMessages(in_user:int,in_page:int,in_pageSize:int):void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restMessagesHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,getMessagesFaultHandler);
			
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			var urlRequest:URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "user/" + in_user.toString()+"/news?own=1&page="+in_page.toString()+"&pagesize="+in_pageSize.toString());
			
			urlRequest.requestHeaders.push(acceptHeader);
			
			urlLoader.load(urlRequest);
		}
		
		 
		
		
		/********************************************************
		 *	GET PUBLIC MESSAGES									*
		 *														*
		 *********************************************************/
		
		public function restGetPublicMessages(in_page:int,in_pageSize:int):void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restPublicMessagesHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,getPublicMessagesFaultHandler);
			
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			var urlRequest:URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "feed/"); //+ in_user.toString()+"/news?page="+in_page.toString()+"&pagesize="+in_pageSize.toString());
			
			urlRequest.requestHeaders.push(acceptHeader);
			
			urlLoader.load(urlRequest);
		}
		
		private function restPublicMessagesHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			var objmessages:Object=null;
			
			if(loader.bytesLoaded>100)
				objmessages = JSON.parse(loader.data);
			
			this.dispatchEvent(new MessageEvent(MessageEvent.Message_GETLIST_READY,objmessages));
			
			//Clean
			loader.removeEventListener(Event.COMPLETE,restPublicMessagesHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,getPublicMessagesFaultHandler);
		}
		
		private function getPublicMessagesFaultHandler(event:Event):void {
			this.dispatchEvent(new MessageEvent(MessageEvent.Message_GETLIST_FAILED));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(Event.COMPLETE,restPublicMessagesHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,getPublicMessagesFaultHandler);
		}
		
		
		
		/********************************************************
		 *	CREATE PRIVATE MESSAGE								*
		 *														*
		 *********************************************************/
		public function restCreatePrivateMessage(from_petid:int,to_petid:int,in_messagetext:String):void {
			
			var privateMessObj:Object = {};
			privateMessObj.petid_from = from_petid.toString();
			privateMessObj.petid_to = to_petid.toString();
			privateMessObj.body = in_messagetext;
			privateMessObj.type = "7";
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restCreatePrivateMessageHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,restCreatePrivateMessageFaultHandler);
			
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "message");
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.POST;
			
			urlRequest.data = JSON.stringify(privateMessObj);
			urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
		}
		
		private function restCreatePrivateMessageHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			
			this.dispatchEvent(new MessageEvent(MessageEvent.Message_PRIVATE_MESSAGE_SENT));
			
			//Clean
			loader.removeEventListener(Event.COMPLETE,restCreatePrivateMessageHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restCreatePrivateMessageFaultHandler);
		}
		
		private function restCreatePrivateMessageFaultHandler(event:Event):void {
			this.dispatchEvent(new MessageEvent(MessageEvent.MEssage_PRIVATE_MESSAGE_FAILED));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(Event.COMPLETE,restCreatePrivateMessageHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restCreatePrivateMessageFaultHandler);
		}
		
		/********************************************************
		 *	CREATE GIFT MESSAGE									*
		 *														*
		 *********************************************************/
		public function restCreateGiftMessage(from_petid:int,to_petid:int,in_messagetext:String,in_giftid:String):void {
			
			var privateMessObj:Object = {};
			privateMessObj.petid_from = from_petid.toString();
			privateMessObj.petid_to = to_petid.toString();
			privateMessObj.body = in_messagetext;
			privateMessObj.type = in_giftid;//7
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restCreateGiftMessageHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,restCreateGiftMessageFaultHandler);
			
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "message");
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.POST;
			
			urlRequest.data = JSON.stringify(privateMessObj);
			urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
		}
		
		private function restCreateGiftMessageHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			
			this.dispatchEvent(new MessageEvent(MessageEvent.Message_PRIVATE_MESSAGE_SENT));
			
			//Clean
			loader.removeEventListener(Event.COMPLETE,restCreateGiftMessageHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restCreateGiftMessageFaultHandler);
		}
		
		private function restCreateGiftMessageFaultHandler(event:Event):void {
			this.dispatchEvent(new MessageEvent(MessageEvent.MEssage_PRIVATE_MESSAGE_FAILED));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(Event.COMPLETE,restCreateGiftMessageHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restCreateGiftMessageFaultHandler);
		}
		
		/********************************************************
		 *			DELETE MESSAGE								*
		 *														*
		 *********************************************************/
		public function restDeleteMessage(in_messageid:String):void{
			
	/*		var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restDeleteMessageHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restDeleteMessageFaultHandler);
			var url:String = GlobalConstants.DRUPAL_PATH + "message/" + in_messageid;
			var urlRequest:URLRequest = new URLRequest(url);
			var delHeader:URLRequestHeader = new URLRequestHeader("X-HTTP-Method-Override", "DELETE");
			var acceptHeader:URLRequestHeader = new URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(delHeader);
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.POST;
			
			urlLoader.load(urlRequest);
		*/	
			
			
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restDeleteMessageHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restDeleteMessageFaultHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "message/"+in_messageid);
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.DELETE;
			
			urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
			
		}
		
		private function restDeleteMessageHandler(event:Event):void {
			
			dispatchEvent(new MessageEvent(MessageEvent.Message_DELETED,null));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restDeleteMessageFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restDeleteMessageHandler);
		}
		
		private function restDeleteMessageFaultHandler(event:IOErrorEvent):void {
			dispatchEvent(new MessageEvent(MessageEvent.Message_DELETE_FAILED,null));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restDeleteMessageFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restDeleteMessageHandler);
		}
		
	}
}