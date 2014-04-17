package events
{
	import flash.events.Event;
	
	public class PetEvent extends Event
	{
		public static const PET_REGISTERED:String = "pet_registered";
		public static const PET_REGISTERED_ERROR:String = "pet_registered_error";
		public static const PET_READY:String = "pet_ready";
		public static const PET_UPDATED:String = "pet_updated";
		public static const PET_UPDATE_ERROR:String = "pet_update_error";
		public static const PET_GET_MY_LIST_READY:String="pet_getmylist_ready";
		public static const PET_GET_MY_LIST_ERROR:String="pet_getmylist_error";
		public static const PET_GET_LIST_READY:String="pet_getlist_ready";
		public static const PET_GET_LIST_ERROR:String="pet_getlist_error";		
		public static const PET_GET_READY:String="pet_get_ready";
		public static const PET_GET_ERROR:String="pet_get_error";
		public static const PET_GET_THIS_PET_READY:String="pet_get_this_pet_ready";
		public static const PET_GET_THIS_PET_ERROR:String="pet_get_this_pet_error";
		
		public var data:Object;
		
		public function PetEvent(type:String, data:Object=null, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}