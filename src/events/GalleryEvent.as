package events
{
	import flash.events.Event;
	 
	public class GalleryEvent extends Event
	{
		public static const VIDEO_UPLOAD_READY:String = "video_upload_ready";
		public static const VIDEO_UPLOAD_FAILURE:String = "video_upload_failure";
		public static const IMAGE_UPLOAD_READY:String = "image_upload_ready";
		public static const IMAGE_UPLOAD_FAILURE:String = "image_upload_failure";
		
		public var data:Object;
		
		public function GalleryEvent(type:String, data:Object=null,bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}