package
{
/*	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mx.flash.UIMovieClip;
	
	public class CharacterAnimation extends UIMovieClip
	{
		//*******************
		// Properties:
		
		public var target:Character;
		public var states:Array;
		public var state:uint = 0;
		public var timer:Timer;
		public var timerDelay:Number = 1500; // in milliseconds
		
		public function CharacterAnimation()
		{
			// Create character instance
			target = new Character();
			target.x = (stage.stageWidth - target.width) / 2;
			target.y = (stage.stageHeight - target.height) / 2;
			addChild(target);
			
			// Create the animation queue
			states = new Array();
			states[0] = Character.BLINK;
			states[1] = Character.DEFAULT;
			states[2] = Character.LOOK_LEFT;
			states[3] = Character.LOOK_RIGHT;
			states[4] = Character.DEFAULT;
			states[5] = Character.BLINK;
			states[6] = Character.LOOK_UP;
			states[7] = Character.DEFAULT;
			states[8] = Character.BLINK;
			states[9] = Character.DEFAULT;
			
			// Create a timer to drive the animation
			timer = new Timer(timerDelay);
			timer.addEventListener(TimerEvent.TIMER, onTimerTick);
			timer.start();
		}
		
		//*******************
		// Events:
		
		private function onTimerTick(event:TimerEvent):void
		{
			// Play animation from states queue
			target.showState(states[state]);
			
			// Show next state next time around
			state++;
			
			// Loop if we've reached the end of the queue
			if( state == states.length ){
				state = 0;
			}
		}
	}
	*/
}