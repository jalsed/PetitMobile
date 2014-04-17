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
	
	import events.RelationEvent;
	
	public class RelationDAO extends EventDispatcher 
	{
		
		/********************************************************
		*			CREATE RELATION								*
		*														*
		*********************************************************/
			 
		public function restCreateRelation(in_petid_a:String,in_petid_b:String,in_relationtype:String):void{
	 		var relationObj:Object = {};
			relationObj.type = in_relationtype; 
			relationObj.petid_a = in_petid_a;
			relationObj.petid_b = in_petid_b;
			   
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restCreateRelationHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restCreateRelationFaultHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "relation");
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.POST;
			
			urlRequest.data = JSON.stringify(relationObj);
			urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
		}
		
		private function restCreateRelationHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			var obj:Object;
			
			if(loader.data !=null && loader.data.length>0)
				obj= JSON.parse(loader.data);
			
			dispatchEvent(new RelationEvent(RelationEvent.RELATION_SAVED,null,true,true));
		
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restCreateRelationFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restCreateRelationHandler);
		}
		
		private function restCreateRelationFaultHandler(event:IOErrorEvent):void {
			var loader:URLLoader = URLLoader(event.target);
				 
			dispatchEvent(new RelationEvent(RelationEvent.RELATION_SAVED_FAILED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restCreateRelationFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restCreateRelationHandler);
		}
		
		/********************************************************
		 *	DELETE RELATION										*
		 *														*
		 ********************************************************/
		public function restDeleteRelation(in_relationID:String):void{
			 
		 	var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restDeleteRelationHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restDeleteRelationFaultHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "relation/"+in_relationID);
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.DELETE;
			
		 	urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
		}
		
		private function restDeleteRelationHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader.data);
			
			dispatchEvent(new RelationEvent(RelationEvent.RELATION_DELETED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restDeleteRelationFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restDeleteRelationHandler);
		}
		
		private function restDeleteRelationFaultHandler(event:IOErrorEvent):void {
			var loader:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new RelationEvent(RelationEvent.RELATION_DELETE_FAILED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restDeleteRelationFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restDeleteRelationHandler);
		}
		
		/********************************************************
		 *			GET RELATIONS (LIST)						*
		 *														*
		 ********************************************************/
		
		public function restGetRelations(petid:String):void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restGetRelationsCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetRelationsFailedHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "pet/" + petid + "/relations.json");
			 
			urlLoader.load(urlRequest); 
		}
		 
		
		private function restGetRelationsFailedHandler(event:Event):void {
			trace("Couldn't get relations from server.");	
			
			dispatchEvent(new RelationEvent(RelationEvent.RELATION_GETRELATIONLIST_FAILED,null,true,true));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restGetRelationsFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restGetRelationsCompleteHandler);
		}
		
		private function restGetRelationsCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object;
			if(loader2.data!=null && loader2.data.length>0)
				obj = JSON.parse(loader2.data);
				
			dispatchEvent(new RelationEvent(RelationEvent.RELATION_GETRELATIONLIST_READY,obj,true,true));	 
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restGetRelationsFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restGetRelationsCompleteHandler);
		}
		
		
		
		
		/********************************************************
		 *	ACCEPT RELATION										*
		 *														*
		 ********************************************************/ 
		
		public function restAcceptRelation(in_relationID:String):void{
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restAcceptRelationHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restAcceptRelationFaultHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "relation/"+in_relationID+"/accept");
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.POST;
			
			urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
		}
		
		private function restAcceptRelationHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			//var obj:Object = JSON.parse(loader.data);
			
			dispatchEvent(new RelationEvent(RelationEvent.RELATION_ACCEPTED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restAcceptRelationFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restAcceptRelationHandler);
		}
		
		private function restAcceptRelationFaultHandler(event:IOErrorEvent):void {
			var loader:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new RelationEvent(RelationEvent.RELATION_ACCEPT_FAILED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restAcceptRelationFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restAcceptRelationHandler);
		}
		
		
		
		/********************************************************
		 *	INVITATION											*
		 *														*
		 ********************************************************/ 
		
		public function restSendInvitation(in_me_id:String,in_email:String, in_pet:String,in_header:String,in_body:String):void {
			var relationObj:Object = {};
			relationObj.email = in_email; 
			relationObj.name= in_pet;
			relationObj.header = in_header;
			relationObj.body = in_body;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restSendInvitationHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restSendInvitationFaultHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "pet/"+in_me_id+"/invitefriend");
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.POST;
			
			urlRequest.data = JSON.stringify(relationObj);
			urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
		}
		
		private function restSendInvitationHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new RelationEvent(RelationEvent.INVITATION_READY,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restSendInvitationFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restSendInvitationHandler);
		}
		
		private function restSendInvitationFaultHandler(event:IOErrorEvent):void {
			var loader:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new RelationEvent(RelationEvent.INVITATION_FAILED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restSendInvitationFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restSendInvitationHandler);
		}
		
		
	}
}