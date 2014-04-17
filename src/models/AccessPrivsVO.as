package models
{
    [Bindable]
    [RemoteClass(alias="AccessPrivsVO")]
	public class AccessPrivsVO
	{
		public var userRole:String;
        public var sessionID:String;
        public var userID:int;
	}
}