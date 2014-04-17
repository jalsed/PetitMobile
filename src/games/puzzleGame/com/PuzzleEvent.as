package games.puzzleGame.com
{
	import flash.events.Event;
	
	public class PuzzleEvent extends Event
	{
		public static const PUZZLECORRECT:String = "puzzlecorrect";
		
		
		public var data:Object;
		
		public function PuzzleEvent(type:String, data:Object=null,bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
} 
