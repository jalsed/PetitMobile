package models
{
	[RemoteClass(alias="BadgeVO")]
	[Bindable]
	public class BadgeVO {
		
		public var badgeid:Number;
		public var competitionid:Number;
		public var badgeImage:String;			//Denna ska hämtas via competition nu istället
		public var badgeDescription:String;
		public var timestamp:Number;
		 
	}
}