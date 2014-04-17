package events
{
	import flash.events.Event;
	
	public class BadgeEvent extends Event
	{
		public static const MYBADGES_FAILED:String="mybadges_failed";
		public static const MYBADGES_READY:String= "mybadges_ready";
		public static const BADGEDETAILS_READY:String = "badgedetails_added";
		public static const BADGEDETAILS_FAILED:String = "badgedetails_failed";
		
		public var data:Object;
		
		public function BadgeEvent(type:String, data:Object=null, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}