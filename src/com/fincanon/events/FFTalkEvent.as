package com.fincanon.events{
	import flash.events.Event;
	
	public class FFTalkEvent extends Event{
		public static const TALK_TO_FLEX:String = "TalkToFlex";
		public static const TALK_TO_FLASH:String = "TalkToFlash";
		public var said:String;
		
		public function FFTalkEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, sentString:String="") {
			this.said = sentString;
			super(type, bubbles, cancelable);
		}
	}
}