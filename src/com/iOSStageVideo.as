package com 
{ 
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import flash.system.Capabilities;
	
	[Bindable] 
	public class iOSStageVideo extends Sprite 
	{ 
		private var videoPath:String; 
		public var videoWidth:Number; 
		public var videoHeight:Number; 
		private var _sv:StageVideo; 
		private var _vd:Video; 
		private var _obj:Object; 
		private var _ns:NetStream; 
		private var videoRotation:int;
		private var stageVideoAvail:Boolean;
		
		public var noStop:Boolean=false;
		
		public function iOSStageVideo( path:String , w:Number , h:Number,r:int ){ 
			 
			videoPath = path; 
			videoWidth = w; 
			videoHeight = h; 
			videoRotation=r;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);  
		}
		
		private function onAvail(e:StageVideoAvailabilityEvent):void
		{
			stageVideoAvail = (e.availability == StageVideoAvailability.AVAILABLE);
		} 
		
		//stage is ready 
		private function onAddedToStage(e:Event):void{ 
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onAvail);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.align = StageAlign.TOP_LEFT; 
			
			var nc:NetConnection = new NetConnection(); 
			nc.connect(null); 
			
			_ns =  new NetStream(nc); 
			_obj = new Object(); 
			
			_ns.client = _obj; 
			_ns.bufferTime = 2; 
			_ns.client = _obj; 
			
			_obj.onMetaData = MetaData; 
			
			if(videoRotation==90)
				this.stage.setOrientation(StageOrientation.ROTATED_LEFT);
			else
				this.stage.setOrientation(StageOrientation.DEFAULT);
			
			 if(Capabilities.manufacturer=="Adobe iOS") {	//if(stage.stageVideos.length>0) { //iOS
				_sv = stage.stageVideos[0]; 
				_sv.viewPort = new Rectangle(0, 0, videoWidth , videoHeight ); 
				
				_sv.attachNetStream(_ns); 
			}
			else {	//This makes it work on Android
				_vd = new Video(videoWidth, videoHeight);
				
if(stage.numChildren==2)
	stage.removeChildAt(0);
				
				stage.addChild(_vd);
				
				_vd.attachNetStream(_ns);
				_vd.x = 0;
				_vd.y = 0;
				
				trace("stage-children:"+stage.numChildren);
				stage.setChildIndex(_vd, 0);
			}
			 
			
			playVideo(); 
		} 
		
		
		//video is ready, play it 
		//public, can be called externally 
		public function playVideo():void{
//			_ns.play("http://petit-prod0.s3.amazonaws.com/petit/video/7/132/capturedvideo_mp4_1369334404.flv");	//DEUBGG 
			_ns.play(videoPath ); 
			_ns.addEventListener(NetStatusEvent.NET_STATUS, videoStatus); 
		} 
		
		public function pauseVideo():void {
			_ns.pause();
		}

		public function continueVideo():void {
			_ns.resume();
		}

		 
		
		//required metadata for stagevideo, even if not used 
		private function MetaData(info:Object):void{ 
		
		} 
		
		//get video status 
		private function videoStatus(e:NetStatusEvent):void{ 
			
			switch(e.info.code){ 
				case "NetStream.Play.StreamNotFound": 
					trace("StreamNotFound");
					//do something 
					break; 
				case "NetStream.Play.Start": 
					trace("Play.Start");
					dispatchEvent( new Event('videoPlays', true ) ); 
					//do something 
					break; 
				case "Netstream.Play.FileStructureInvalid":
					break;
				case "NetStream.Play.Stop": 
					trace("Play.Stop");
					stopVideo(); 
					break; 
				case "NetStream.Buffer.Empty":
					trace("Empty");
					//do something 
					break; 
				case "NetStream.Buffer.Full":
					trace("Full");
					//do something 
					break; 
				case "NetStream.Buffer.Flush":
					trace("Flush");
					//do something 
					break; 
			} 
		} 
		
		//stop and clear the video 
		//public, can be called externally 
		public function stopVideo():void{ 
			if(!noStop) {
				_ns.close(); 
				_ns.dispose(); 
				this.stage.setOrientation(StageOrientation.DEFAULT);
				dispatchEvent( new Event('videoDone', true ) ); 
				
				if(Capabilities.manufacturer!="Adobe iOS") { //android
					if(this.stage!=null && this.stage.numChildren==2)
						stage.removeChildAt(0);	//video is always 0 since we changed the index
				}
			}
			else {//loop
				//_ns.pause();
				_ns.seek(0);
				//_ns.resume();
			}
		} 
	} 
}
