package events
{
	import flash.events.Event;
	
	public class DialogEvent extends Event
	{
		public static const DIALOG_OK:String = "dialog_ok";
		public static const DIALOG_CANCEL:String = "dialog_cancel";
		
		public var data:Object;
		
		public function DialogEvent(type:String, data:Object=null, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}