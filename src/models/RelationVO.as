package models
{
    [Bindable]
	[RemoteClass(alias="RelationVO")]
	public class RelationVO
	{
		public var relationID:Number = 0;
		public var petid_a:String;
		public var petid_b:String;
		public var relationType:String;
		public var title:String;
		public var ownername:String;
		public var imageURL:String;
		public var imageURLthumb:String="";
		public var status:String;
		public var changed:String;
		 
	}
}