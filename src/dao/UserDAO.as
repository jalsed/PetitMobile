package dao
{
	import classes.GlobalConstants;
	
	import events.UserEvent;
	
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
	
	import models.UserVO;
	 
	public class UserDAO extends EventDispatcher 
	{
		[Bindable]
		public var user:UserVO = new UserVO();
		
		private var retryCount:int = 0;
		private var timeoutID:uint;
		 
		/********************************************************
		*			SERVER FUNCTIONALITY						*
		*														*
		*********************************************************/
		
		public function restConnect():void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restConnectCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restConnectFaultHandler);

			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "system/connect");
			var acceptHeader:URLRequestHeader = new URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			acceptHeader = new URLRequestHeader("Cache-control","private");
			urlRequest.requestHeaders.push(acceptHeader);
			
			urlRequest.method = URLRequestMethod.POST;
			var params:URLVariables = new URLVariables();
			params.key = "value";
			urlRequest.data = params;
			urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
		}
		 
	
		private function restConnectFaultHandler(event:IOErrorEvent):void {
			if (retryCount < 1) {	//3
				retryCount++;
				timeoutID=setTimeout(restConnect, 1000);	//1000
			} else {
				trace("connect failed");
				//Alert.show(parentApplication.Language.viewUser_alert_loginFailure);	//"Sorry! Either your User Name or your password are incorrect. Please try again.");
				dispatchEvent(new UserEvent(UserEvent.LOGIN_FAILED,null,true,true));
			}
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restConnectFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restConnectCompleteHandler);
		}
		
		private function restConnectCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader2.data);

			if (retryCount < 1) {	//3
				retryCount++;
				timeoutID=setTimeout(restConnect, 300);	//1000
			}
			else {
				clearTimeout(timeoutID);
				retryCount = 0;
				
				if (obj.user.uid > 0)
				{
					restGetUser(obj.user.uid);
				}
				else {
					restLoginUser("");
				}
				
				//Clean
				loader2.removeEventListener(IOErrorEvent.IO_ERROR,restConnectFaultHandler);
				loader2.removeEventListener(Event.COMPLETE,restConnectCompleteHandler);
			
				//dispatchEvent(new UserEvent(UserEvent.LOGIN_READY,null,true,true));
			}
		}
		public function restLogoutUser():void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restLogoutHandler);
			var urlRequest:URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "user/logout");
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.contentType = "application/json";
			urlRequest.data = "logout";
			urlLoader.load(urlRequest);
			
			user.email = ""; 
			user.password = "";  
			user.name= "";
			user.facebookid="";
			user.zipcode="";
			user.points=0;
//			restConnect();
		}
		
		private function restLogoutHandler(event:Event):void {
			dispatchEvent(new UserEvent(UserEvent.LOGOUT_READY,null,true,true));
			 
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(Event.COMPLETE, restLogoutHandler);
		}
		
		public function restLoginUser(in_type:String):void {
			var rpcParams:Object = {};
			rpcParams['username'] =	user.email;	 
			rpcParams['password'] = user.password;	 
			rpcParams['remember'] = false;
			/*if (cbremember.selected) {
				rpcParams['remember'] = true;
			}*/
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restLoginHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restLoginFaultHandler);
			if(in_type=="check")
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, restLoginRememberCheck);

			var loginUrl:String = GlobalConstants.DRUPAL_PATH + "user/login_remember";
			var urlRequest:URLRequest = new URLRequest(loginUrl);
			var acceptHeader:URLRequestHeader = new URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.POST;
			
			urlRequest.data = JSON.stringify(rpcParams);
			urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
		}
		
		private function restLoginFaultHandler(event:IOErrorEvent):void {
			//Alert.show(parentApplication.Language.viewUser_alert_loginFailure);	//"Sorry! Either your User Name or your password are incorrect. Please try again.");
			trace("login failed");
			dispatchEvent(new UserEvent(UserEvent.LOGIN_FAILED,null,true,true));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restLoginFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restLoginHandler);
		}
		
		private function restLoginRememberCheck(event:HTTPStatusEvent):void {
			if(event.responseHeaders.status==406) {	//remember login ID correctly
				//We're already logged in on the server but the user.uid is still -1. So we might need to do a getUser here too before the dispatchEvent.
				restConnect();	//just connect again
				//dispatchEvent(new UserEvent(UserEvent.ALREADY_LOGGED_IN,user.uid,true,true));	
			}
		}
		
		
		private function restLoginHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			if(loader2.data != "null" && loader2.data!= "[null]") {
				var obj:Object = JSON.parse(loader2.data);
				if (obj.user.uid > 0) {
					user.uid = obj.user.uid;
					user.name = obj.user.name;
					user.email = obj.user.mail;
					if(obj.user.field_postalcode.und!=null && obj.user.field_postalcode.und.length>0)
						user.zipcode = obj.user.field_postalcode.und[0].value;	//zipcode;
					user.points = parseInt(obj.user.field_karma.und[0].value);
					user.facebookid = "";
				}
			
				dispatchEvent(new UserEvent(UserEvent.LOGIN_READY,user.uid,true,true));
			}
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restLoginFaultHandler);
			loader2.removeEventListener(Event.COMPLETE,restLoginHandler);
		}
		
		public function restFacebookConnectUser(fbid:String):void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restFacebookConnectHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restFacebookConnectFaultHandler);
			var restUrl:String = GlobalConstants.DRUPAL_PATH + "user/" + user.uid + "/fbconnect";
			var urlRequest:URLRequest = new URLRequest(restUrl);
			var acceptHeader:URLRequestHeader = new URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.POST;
			
			urlRequest.data = JSON.stringify({'fbid': fbid});
			urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
		}
		
		private function restFacebookConnectHandler(event:Event):void {
			//dispatchEvent(new UserEvent(UserEvent.FBCONNECT_READY,user.uid,true,true));
			trace("fbconnect success");
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restFacebookConnectFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restFacebookConnectHandler);
		}
		
		private function restFacebookConnectFaultHandler(event:IOErrorEvent):void {
			//Alert.show(parentApplication.Language.viewUser_alert_loginFailure);	//"Sorry! Either your User Name or your password are incorrect. Please try again.");
			trace("fbconnect failed");
			//dispatchEvent(new UserEvent(UserEvent.LOGIN_FAILED,null,true,true));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restFacebookConnectFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restFacebookConnectHandler);
		}
		
		public function restRegisterUser(email:String,password:String,ownername:String,locationObj:Object,in_zipcode:String,language:String):void{
	 
			if(locationObj==null)
				locationObj =  {'latitude':59.3, 'longitude':18.1};	//Default is Stockholm 
			
			var userCreate:Object = {};
			userCreate.mail = email; 
			userCreate.pass = password;  
			userCreate.name=email;
			userCreate.facebookid="";
			userCreate.field_fullname = {'und': [{'value': ownername}]};
			userCreate.field_postalcode = {'und': [{'value': in_zipcode}]};	
			userCreate.field_location = {"und":[{"address":{"field":userCreate.field_postalcode},"lat":locationObj.latitude,"lng":locationObj.longitude}]}; 
			userCreate.field_karma = {'und': [{'value': "10"}]};
			userCreate.language = language;  
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restRegisterHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restRegisterFaultHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "user");
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.POST;
			
			urlRequest.data = JSON.stringify(userCreate);
			urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
		}
		
		private function restRegisterHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader.data);
			user.uid=obj.uid;
			if (obj.uid > 0) {
				restGetUser(obj.uid);
			}
			
			dispatchEvent(new UserEvent(UserEvent.ACCOUNT_CREATED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restRegisterFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restRegisterHandler);
		}
		
		private function restRegisterFaultHandler(event:IOErrorEvent):void {
			var loader:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader.data);
			if(obj.length==1 && obj.form_errors==null) {
				trace("Login error");	
				dispatchEvent(new UserEvent(UserEvent.REGISTER_ERROR_ALREADYREGISTERED,null,true,true));
			}
			else if (obj.form_errors.hasOwnProperty('name')) {
				trace("Login error"); //Alert.show(parentApplication.Language.viewUser_alert_createError + "name");	//"Sorry! Either your User Name or your password are incorrect. Please try again.");
				dispatchEvent(new UserEvent(UserEvent.REGISTER_ERROR_NAME,null,true,true));
			} else if (obj.form_errors.hasOwnProperty('mail')) {
				trace("Login error"); //Alert.show(parentApplication.Language.viewUser_alert_createError + "mail");	//"Sorry! Either your User Name or your password are incorrect. Please try again.");
				dispatchEvent(new UserEvent(UserEvent.REGISTER_ERROR_EMAIL,null,true,true));
			}
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restRegisterFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restRegisterHandler);
		}
		
		public function restGetUser(userid:String):void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restGetCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetFailedHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "user/" + userid + ".json");
			urlLoader.load(urlRequest);
		}
		
		private function restGetFailedHandler(event:Event):void {
			trace("Couldn't get user from server.");	
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restGetFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restGetCompleteHandler);
		}
		
		private function restGetCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader2.data);
			if (obj.uid > 0)
			{
				user.uid = obj.uid;
				if(obj.field_fullname.length>0)
					user.name = obj.field_fullname.und[0].value;
				user.email = obj.name;
				user.zipcode = obj.zipcode;
				user.facebookid="";
				user.points=parseInt(obj.field_karma.und[0].value);
				
				dispatchEvent(new UserEvent(UserEvent.LOGIN_READY,user.uid,true,true));	//A user was successfully retrieved
			}
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restGetFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restGetCompleteHandler);
		}
		
		public function restGetThisUser(userid:String):void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restGetCompleteHandler2);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetFailedHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "user/" + userid + ".json");
			urlLoader.load(urlRequest);
		}
		
		private function restGetCompleteHandler2(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader2.data);
		 
			dispatchEvent(new UserEvent(UserEvent.USER_READY,obj,true,true));	//A user was successfully retrieved
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restGetFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restGetCompleteHandler2);
		}
		
		public function setLoginParameters(in_email:String,in_password:String):void {
			user.email = in_email;		
			user.password = in_password;
		}
		
		
		
		/************************************************
		 * UPDATE USER									*
		 * 												*
		 ************************************************/
		public function restUpdateUser(userID:String,ownername:String,email:String,password:String,locationObj:Object,in_zipcode:String,language:String):void {
			
			if(locationObj==null)
				locationObj =  {'latitude':59.3, 'longitude':18.1};	//Default is Stockholm 
			
			var userUpdate:Object = {};
			
			//userUpdate.type="user";
			userUpdate.language = language;
			userUpdate.mail = email;
			userUpdate.pass=password;
			userUpdate.field_fullname = {'und': [{'value': ownername}]};
			
			userUpdate.field_postalcode = {'und': [{'value': in_zipcode}]};	
			userUpdate.field_location = {"und":[{"address":{"field":in_zipcode},"lat":locationObj.latitude,"lng":locationObj.longitude}]};	//HARDCODED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			
			//userUpdate.field_karma = {'und':[{'value':'1500'}]};		//Ska inte kunna ändra poängen
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restUpdateUserHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restUpdateUserFaultHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "user/" + user.uid.toString());
			urlRequest.requestHeaders.push(new URLRequestHeader("Accept", "application/json"));
			urlRequest.requestHeaders.push(new URLRequestHeader("X-HTTP-Method-Override", "PUT"));
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.contentType = "application/json";
			urlRequest.data = JSON.stringify(userUpdate);
			urlLoader.load(urlRequest);
		}
		
		private function restUpdateUserHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new UserEvent(UserEvent.USER_UPDATED,null,true,true));
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restUpdateUserFaultHandler);
			loader2.removeEventListener(Event.COMPLETE,restUpdateUserHandler);
		}
		
		private function restUpdateUserFaultHandler(event:IOErrorEvent):void {
			var loader2:URLLoader = URLLoader(event.target);
			dispatchEvent(new UserEvent(UserEvent.USER_UPDATE_ERROR,null,true,true));
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restUpdateUserFaultHandler);
			loader2.removeEventListener(Event.COMPLETE,restUpdateUserHandler);
		}
		  
	}
}