package events
{
	import flash.events.Event;
	
	public class CommentEvent extends Event
	{
		public static const COMMENTS_FAILED:String="comments_failed";
		public static const COMMENTS_READY:String= "comments_ready";
		public static const COMMENT_ADDED:String = "comment_added";
		public static const COMMENT_FAILED:String = "comment_failed";
		
		public var data:Object;
		
		public function CommentEvent(type:String, data:Object=null, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}