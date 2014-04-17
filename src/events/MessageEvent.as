package events
{
	import flash.events.Event;
	
	public class MessageEvent extends Event
	{
		public static const Message_GET_READY:String="Message_getMessage_ready";
		public static const Message_GET_FAILED:String="Message_getMessage_failed";
		public static const Message_GETLIST_READY:String="Message_getMessagelist_ready";
		public static const Message_GETLIST_FAILED:String="Message_getMessagelist_failed";
		public static const Message_DELETED:String = "Message_deleted";
		public static const Message_DELETE_FAILED:String = "Message_delete_failed";
		public static const Message_PRIVATE_MESSAGE_SENT:String = "Message_private_message_sent";
		public static const MEssage_PRIVATE_MESSAGE_FAILED:String="Message_private_message_failed";
		
		public var data:Object;
		
		public function MessageEvent(type:String, data:Object=null, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}