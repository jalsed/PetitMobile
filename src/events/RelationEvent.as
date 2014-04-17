package events
{
	import flash.events.Event;
	
	public class RelationEvent extends Event
	{
		public static const RELATION_GETRELATION_READY:String="relation_getRelation_ready";
		public static const RELATION_GETRELATION_FAILED:String="relation_getRelation_failed";
		public static const RELATION_GETRELATIONLIST_READY:String="relation_getRelation_list_ready";
		public static const RELATION_GETRELATIONLIST_FAILED:String="relation_getRelation_list_failed";
		public static const RELATION_UPDATED:String = "relation_updated";
		public static const RELATION_UPDATED_FAILED:String = "relation_updated_failed";
 		public static const RELATION_DELETED:String = "relation_deleted";
		public static const RELATION_DELETE_FAILED:String = "relation_delete_failed";
		public static const RELATION_SAVED:String = "relation_saved";
		public static const RELATION_SAVED_FAILED:String = "relation_save_failed";
  		public static const RELATION_ACCEPTED:String = "relation_accepted";
		public static const RELATION_ACCEPT_FAILED:String = "relation_accept_failed";
		public static const INVITATION_READY:String = "invitation_ready";
		public static const INVITATION_FAILED:String = "invitation_failed";
		
		public var data:Object;
		
		public function RelationEvent(type:String, data:Object=null, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}