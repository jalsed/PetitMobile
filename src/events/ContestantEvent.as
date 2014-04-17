package events
{
	import flash.events.Event;
	
	import models.ContestantVO;
	
	public class ContestantEvent extends Event
	{
		public static const CONTESTANT_GETCONTESTANTS_READY:String="contestants_getcontestants_ready";
		public static const CONTESTANT_GETCONTESTANTS_FAILED:String="contestants_getcontestants_failed";
 
		
		public var data:Object;
		
		public function ContestantEvent(type:String, data:Object=null, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}