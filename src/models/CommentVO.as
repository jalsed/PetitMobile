package models
{
	[RemoteClass(alias="vos.CommentVO")]
	[Bindable]
	public class CommentVO	{
		
		public var uid:Number;
		public var pseudonym:String;
		public var pid:Number;
		public var body:String;
		public var timestamp:Number;
		
		public function CommentVO() {
		}
	}
}