package events
{
	import flash.events.Event;
	 
	public class VideoEvent extends Event
	{
		public static const UPLOAD_READY:String = "upload_ready";
		public static const UPLOAD_FAILURE:String = "upload_failure";
		
		public var data:Object;
		
		public function VideoEvent(type:String, data:Object=null,bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}