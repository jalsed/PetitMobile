package models
{
	
	//	type=0:	own feed
	//  type=1: other's feed
	//	type=2: relation request
	//	type=3: competition result
	//	type=4: competition reminder
	//  type=5: competition announcement
	//	type=6:	vote information
	//	type=7:	private message
	//	type=8:	admin message
	
	[RemoteClass(alias="vos.MessageVO")]
	[Bindable]
	public class MessageVO {
		public var messageID:int;
		public var type:int;
		public var converted:Boolean=false;
		public var title:String;
		public var description:String;
		public var imageURL:String;
		public var videoURL:String;
		public var feedID:int;
		public var relationID:int;
		public var competitionID:int;
		public var petID:int;
		public var petName:String;
		public var ownerID:String;
		public var ownerName:String;
		public var timestampDate:String;
		 
	
		public function MessageVO() {
		}
	}
}