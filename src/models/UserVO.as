package models
{
    [Bindable]
	[RemoteClass(alias="UserVO")]
	public class UserVO
	{
		public var uid:Number = 0;
		public var email:String;
        public var name:String;
		public var password:String;
      	public var points:Number;
		public var language:String;
		public var facebookid:String;
		public var location:String;
		public var zipcode:String;
	}
}