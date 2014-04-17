package events
{
	import flash.events.Event;
	 
	public class PetitSoundEvent extends Event
	{
		public static const UPLOAD_READY:String = "upload_ready";
		public static const UPLOAD_FAILURE:String = "upload_failure";
		
		public var data:Object;
		
		public function PetitSoundEvent(type:String, data:Object=null,bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}