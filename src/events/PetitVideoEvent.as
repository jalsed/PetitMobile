package events
{
	import flash.events.Event;
	 
	public class PetitVideoEvent extends Event
	{
		public static const RESUME_VIDEO:String = "resumeVideo";
		public static const PAUSE_VIDEO:String = "pauseVideo";
		public static const STOP_VIDEO:String = "stopVideo";
		
		public var data:Object;
		
		public function PetitVideoEvent(type:String, data:Object=null,bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}