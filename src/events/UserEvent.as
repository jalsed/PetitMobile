package events
{
	import flash.events.Event;
	
	public class UserEvent extends Event
	{
		public static const LOGIN_READY:String = "user_login_ready";
		public static const LOGIN_FAILED:String = "user_login_failed";
		public static const LOGOUT_READY:String = "user_logout_ready";
		public static const ALREADY_LOGGED_IN:String = "user_arealdy_logged_in";
		public static const ACCOUNT_CREATED:String = "user_account_created";
		public static const REGISTER_ERROR_NAME:String = "register_error_name";
		public static const REGISTER_ERROR_EMAIL:String = "register_error_email";
		public static const REGISTER_ERROR_ALREADYREGISTERED:String ="register_error_alreadyregistered";
		
		public static const USER_READY:String = "user_ready"; 
		public static const USER_UPDATED:String = "user_updated"; 
		public static const USER_UPDATE_ERROR:String = "user_update_error"; 
			
		
		public var data:Object;
		
		public function UserEvent(type:String, data:Object=null, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}