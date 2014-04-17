package models
{
    [Bindable]
	[RemoteClass(alias="ContestantVO")]
	public class ContestantVO
	{
		public var contestantID:Number = 0;
		public var competitionID:Number;
		public var uid:Number;
		public var feedID:Number;
		public var currentPosition:int;
		public var name:String;
		public var title:String;
		public var description:String;
		public var imageURL_thumb:String;
		public var imageURL_small:String;
		public var imageURL_large:String;
		public var soundURL:String;
		public var videoURL:String;
		public var videoOrientationRotation:int;
		public var voted:Boolean=false;
		public var timestamp:Number;
	 	public var myCurrentVoteEntryID:String="";
	}
}