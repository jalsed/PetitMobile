package models
{
    [Bindable]
	[RemoteClass(alias="FeedVO")]
	public class FeedVO
	{
		public var feedID:Number = 0;
		public var description:String;
		public var imageURL:String;
		public var videoURL:String;
		public var soundURL:String;
		public var restrictionType:uint=0;
		public var timestamp:Number;
	}
}