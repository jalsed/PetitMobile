package events
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class AudioEvent extends Event
	{
		public static const WAV_FILE_READY:String = "wavFileReady";
		public static const MP3_FILE_READY:String = "mp3FileReady";
		public static const MP3_FILE_SAVED:String = "mp3FileSaved";
		public static const NO_AUDIO:String = "noaudio";
		
		public var file:File;
		
		public function AudioEvent(type:String, file:File=null, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.file = file;
		}
	}
}