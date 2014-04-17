package models
{
	import flash.utils.ByteArray;
	
	[RemoteClass(alias="vos.FileVO")]
	[Bindable]
	public class FileVO	{
		
		public var filename:String;
		public var filedata:ByteArray;
		
		public function FileVO() {
		}

	}
}