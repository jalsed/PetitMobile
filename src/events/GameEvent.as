package events
{
	import flash.events.Event;
	 
	public class GameEvent extends Event
	{
		public static const END_GAME:String = "endgame";
		public static const RETURN_SCORE:String = "returnscore";
		public static const GET_HIGHSCORE:String = "gethighscore";
		public static const SETSCORE_READY:String = "setscoreready";
		public static const SETSCORE_FAILED:String = "setscorefailed";
		public static const GETSCORE_READY:String = "getscoreready";
		public static const GETSCORE_FAILED:String = "getscorefailed";		
		
		public var data:Object;
		
		public function GameEvent(type:String, data:Object=null,bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}