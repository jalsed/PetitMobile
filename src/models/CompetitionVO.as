package models
{
    [Bindable]
	[RemoteClass(alias="CompetitionVO")]
	public class CompetitionVO
	{
		public var competitionID:Number = 0;
		public var startdate:String;
		public var enddate:String;
		public var prize:String;
		public var prizeImage:String;
		public var rules:String;
		public var title:String;
		public var description:String;
		public var background_imageURL:String;
		public var badge_imageURL:String;
		public var soundURL:String;
		public var gameURL:String;
		public var entered:Boolean=false;
		public var status:int=1;
		public var currentlyPlaying:Boolean = true;
		public var timestamp:Number;
	}
}