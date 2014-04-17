package events
{
	import flash.events.Event;
	
	public class FeedEvent extends Event
	{
		public static const FEED_GETFEED_READY:String="feed_getfeed_ready";
		public static const FEED_GETFEED_FAILED:String="feed_getfeed_failed";
		public static const FEED_GETFEEDLIST_READY:String="feed_getfeedlist_ready";
		public static const FEED_GETFEEDLIST_FAILED:String="feed_getfeedlist_failed";
		public static const FEED_UPDATED:String = "feed_updated";
		public static const FEED_UPDATED_FAILED:String = "feed_updated_failed";
 		public static const FEED_DELETED:String = "feed_deleted";
		public static const FEED_DELETE_FAILED:String = "feed_delete_failed";
		public static const FEED_PUBLISHED:String = "feed_published";
		public static const FEED_PUBLISH_FAILED:String = "feed_publish_failed";
		public static const FEED_REFRESH:String = "feed_refresh";
		public static const FEED_REPORTED:String="feed_reported";
		public static const FEED_REPORT_FAILED:String="feed_reported_failed";
		
		public var data:Object;
		
		public function FeedEvent(type:String, data:Object=null, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}