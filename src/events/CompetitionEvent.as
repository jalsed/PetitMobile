package events
{
	import flash.events.Event;
	
	import models.CompetitionVO;
	
	public class CompetitionEvent extends Event
	{
		public static const COMPETITION_GETCOMPETITIONS_READY:String="competitions_getcompetitions_ready";
		public static const COMPETITION_GETCOMPETITIONS_FAILED:String="competitions_getcompetitions_failed";
		public static const COMPETITION_GETCOMPETITIONDETAIL_READY:String="competitions_getcompetitiondetail_ready";
		public static const COMPETITION_GETCOMPETITIONDETAIL_FAILED:String="competitions_getcompetitiondetail_failed";
		public static const COMPETITION_ENTERCOMPETITION_READY:String="competitions_entercompetition_ready";
		public static const COMPETITION_ENTERCOMPETITION_FAILED:String="competitions_entercompetition_failed";
		public static const COMPETITION_EXITCOMPETITION_READY:String="competitions_exitcompetition_ready";
		public static const COMPETITION_EXITCOMPETITION_FAILED:String="competitions_exitcompetition_failed";
		public static const COMPETITION_VOTECOMPETITIONDETAIL_READY:String="competitions_votecompetitiondetail_ready";
		public static const COMPETITION_VOTECOMPETITIONDETAIL_FAILED:String="competitions_votecompetitiondetail_failed";

		public var data:Object;
		
		public function CompetitionEvent(type:String, data:Object=null, bubbles:Boolean = true, cancelable:Boolean = true)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}