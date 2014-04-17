package utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MediaEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	import mx.graphics.codec.JPEGEncoder;
	
	import events.CameraEvent;


	//import mx.graphics.codec.PNGEncoder;
	
	[Event(name="fileReady", type="events.CameraEvent")]
	[Event(name="cameraCancel",type="flash.events.ErrorEvent.ERROR")]
	public class CameraUtil extends EventDispatcher
	{
		protected var camera:CameraUI;
		protected var loader:Loader;
		public var file:File;
		private var dataSource:IDataInput;
		private var imageBytes:ByteArray;
 
		
		public var currentImage:BitmapData;
		
		public function CameraUtil()
		{
			if (CameraUI.isSupported)
			{
				camera = new CameraUI();
				camera.removeEventListener(Event.CANCEL,cancelCamera);
				camera.removeEventListener(MediaEvent.COMPLETE, mediaEventComplete);
				camera.addEventListener(Event.CANCEL,cancelCamera);
				camera.addEventListener(MediaEvent.COMPLETE, mediaEventComplete);
			}
			
			imageBytes = new ByteArray();
		}
		
		private function cancelCamera():void {
			trace("Cancel");
			dispatchEvent(new CameraEvent(CameraEvent.CANCEL));
		}
		
		public function takePicture():void
		{
			if (camera) {
				camera.launch(MediaType.IMAGE);
			} else {
				var bmp:BitmapData = new BitmapData(2048, 1536); // iPhone 3gs camera reslution.
				bmp.perlinNoise(300, 300, 3, Math.random()*1000, true, true, 15);
				
				var matrix:Matrix = new Matrix();
				matrix.scale(1024 / bmp.width, 768 / bmp.height);
				
				var result:BitmapData = new BitmapData(1024, 768);
				result.draw(bmp, matrix, null, null, null, true);
				
				currentImage = result;
				
				savePicture(result);
			}
		}
		
		protected function mediaEventComplete(event:MediaEvent):void
		{
			trace( "Media selected..." );      
			var imagePromise:MediaPromise = event.data;
			dataSource = imagePromise.open();
			
			if( imagePromise.isAsync )
			{
				trace( "Asynchronous media promise." );
				var eventSource:IEventDispatcher = dataSource as IEventDispatcher;            
				eventSource.addEventListener( Event.COMPLETE, onMediaLoaded );         
			}
			else
			{
				trace( "Synchronous media promise." );
				readMediaData();
			}
		}
		
		private function onMediaLoaded( event:Event ):void
		{
var loaderInfo:LoaderInfo = event.target as LoaderInfo;
if(loaderInfo!=null) {
	trace("loaderinfow-width="+loaderInfo.width);
	trace("loaderinfow-height="+loaderInfo.height);
}
			//loaderInfo.height
			//var bitmap:Bitmap = loader.content as Bitmap;
			trace("Media load complete");
			readMediaData();
		}
		
		private var currentRotation:int=0;
		
		private function readMediaData():void
		{
			dataSource.readBytes( imageBytes );
	
			//find image Orientation
			var reader:ExifReader = new ExifReader();
			reader.processData(imageBytes);
			var ortn : Number = Number( reader.getValue("Orientation"));
			trace(ortn);
			
			switch(ortn) {
				case 0x10000:
					trace("Normal landscape: no rotation");
					currentRotation=0;		
					break;
				case 0x30000:
					trace("Reverse landscap: 180 deg rotation");
					currentRotation=180;		
					break;
				case 0x60000:
					trace("Normal portrait: 90 deg rotation");
					currentRotation=90;		
					break;
				case 0x80000:
					trace("Reverse portrait: 270 deg rotation");
					currentRotation=270;
					break;
				default:
					currentRotation=0;				
			}
			
			
			/*file = File.applicationStorageDirectory.resolvePath("ad_image" + new Date().time + ".jpg"); 
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(imageBytes);
			stream.close();*/ 
			
			var loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_COMPLETE);
			loader.loadBytes(imageBytes);
		}
		
		private function loader_COMPLETE(event:Event):void {
			var bitmap:Bitmap = event.target.content;
			
			//imageBytes = bitmap.bitmapData.getPixels(bitmap.bitmapData.rect);
			
			//Check rotation again (for android since it cant read exif)
			if(bitmap.bitmapData.height>bitmap.bitmapData.width)	
				currentRotation=90;
				
		 
			
			//Rotate
			if(currentRotation!=0) {
				var wd : Number = ( currentRotation ) ? bitmap.bitmapData.height : bitmap.bitmapData.width;
				var ht : Number = ( currentRotation ) ? bitmap.bitmapData.width : bitmap.bitmapData.height;
				var matrix2 : Matrix = new Matrix();
				
				matrix2.translate( -( bitmap.bitmapData.width >> 1 ), -( bitmap.bitmapData.height >> 1 ) );
				matrix2.rotate( currentRotation * ( Math.PI / 180 ) );
				matrix2.translate( wd >> 1, ht >> 1 );
				
				var bmd2:BitmapData = new BitmapData( wd, ht, true, 0x00000000 );
				bmd2.draw( bitmap.bitmapData, matrix2, null, null, null, true );
	
				bitmap.bitmapData = bmd2;
			}
			
			
			var result:BitmapData;
			var matrix:Matrix = new Matrix();
			if(bitmap.bitmapData.height>bitmap.bitmapData.width) {	//Portrait
				matrix.scale(768 / bitmap.bitmapData.width, 1024 / bitmap.bitmapData.height);
				result = new BitmapData(768, 1024);
			
			} else {	//Landscape
				matrix.scale(1024 / bitmap.bitmapData.width, 768 / bitmap.bitmapData.height);
				result = new BitmapData(1024, 768);
			}
			
			result.draw(bitmap.bitmapData, matrix, null, null, null, true);
			currentImage = result;
			savePicture(result);			
			currentRotation=0;
			result.dispose();
		}			
		
	 
		
		public function savePicture(bmd:BitmapData):void
		{
			file = File.applicationStorageDirectory.resolvePath("ad_image" + new Date().time + "_scaled.jpg");
			file.preventBackup=true;
			
			var jpgBytes:ByteArray = new ByteArray();
			trace("Encoding starts");
			if (camera) {
				bmd.encode(bmd.rect, new JPEGEncoderOptions(), jpgBytes);
			} else {
				var jpgEnc:JPEGEncoder = new JPEGEncoder();
				jpgBytes = jpgEnc.encode(bmd);
			}
			trace("Encoding ends");
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.position=0;
			stream.writeBytes(jpgBytes);
			stream.close();
			
			// Cleanup
			imageBytes.clear();
			jpgBytes.clear();
			
			bmd.dispose();
			
			dispatchEvent(new CameraEvent(CameraEvent.FILE_READY, file));
		}
		
		public function updatePicture(in_image:BitmapData,in_filename:String):void {
		 
			var tmpArr:Array = in_filename.split("/");
			
			file = File.applicationStorageDirectory.resolvePath(tmpArr[1]);
			
			if(file.exists)	//Remove it first
				file.deleteFile();
			
			var jpgBytes:ByteArray = new ByteArray();
			trace("Encoding starts");
			if (camera) {
				in_image.encode(in_image.rect, new JPEGEncoderOptions(), jpgBytes);
			} else {
				var jpgEnc:JPEGEncoder = new JPEGEncoder();
				jpgBytes = jpgEnc.encode(in_image);
			}
			trace("Encoding ends");
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.position=0;
			stream.writeBytes(jpgBytes);
			stream.close();
			
			// Cleanup
			in_image.dispose();
			jpgBytes.clear();
		}
		
		public function clear():void {
			if(imageBytes!=null) {
				imageBytes.clear();
			 
			}
			if(currentImage!=null) {
				currentImage.dispose();
			}
			 
		}
	}
}