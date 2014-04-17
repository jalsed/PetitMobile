package utils
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import classes.GlobalConstants;
	
	import events.AudioEvent;
	
	public class AudioUtil extends EventDispatcher			//Mobile version
	{
		
		protected var loader:Loader;
	 	public var file:File;
	
		public var mic:Microphone;
		public var nowRecording:Boolean = false;
		public var nowPlaying:Boolean = false;
		public var recordedBytes:ByteArray;
		private var s:Sound;
		public var channel:SoundChannel;
		public var recordedSeconds:Number=0;
		
		public function AudioUtil()
		{
			initAudio();
		}
			
		public function initAudio():void {
				mic = Microphone.getMicrophone(0);		//-1 = use default mic	//0
	//			mic.codec = SoundCodec.NELLYMOSER; //Better code for speech? Only available when streaming to flash media server
				
				mic.gain = 65;	//100=max.Default is 50.  Maybe put in settings?
				mic.rate = 44;	//kHz samplefrequency
	//			mic.encodeQuality = 10;	//10 is best. 6=default
				mic.setSilenceLevel(0);	//10 is default. The required volume to trigger the mic (0-100)
	//			mic.setUseEchoSuppression(true);
	//			mic.setLoopBack(false);
	//			mic.noiseSuppressionLevel=-10;	
				
				
	/***SPEECH2TEXT***	
				// Speech API supports 8khz and 16khz rates
				mic.rate = 8;
				// Select the SPEEX codec
				mic.codec = SoundCodec.SPEEX;
				// I don't know what effect this has...
				mic.framesPerPacket = 1;
	****/	 	
		}
		 
		public function cleanAudio():void {
			if(recordedBytes!=null) {
				recordedBytes.clear();
				recordedBytes.position = 0;
				recordedBytes.length = 0;
				recordedSeconds=0;
				recordedBytes=null;
				nowRecording = false;
				if(s!=null && s.url != null)
					s.close();
				 
			}
			
			recordedSeconds=0;
			this.s =null;
			 
			initAudio();
		}
		
		public function onRec():void {
			if (nowRecording) {	//Stop recording
				trace("stopped");
				mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataReceived);
				nowRecording = false;
				
			} else {			//Start recording
				trace("recording");
				recordedBytes = new ByteArray();
				recordedBytes.position = 0;
				recordedBytes.length = 0;
				mic.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataReceived);
				nowRecording = true;
			}
		}
		 
		public function stopRecordingIfRolling():void {
			if (nowRecording) {	//Stop recording
				trace("stopped");
				mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataReceived);
				nowRecording = false;
			} 
		}
		
		
		public function onPlay():void {
			if (nowRecording) {	//Firts stop if recording
				mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataReceived);
				nowRecording = false;
			}
			
			if (nowPlaying) {	//Stop playing
				trace("stopped");	
				
				channel.stop();
				
				if(mp3sound!=null)
					if(mp3sound.length==0)
						s.removeEventListener(SampleDataEvent.SAMPLE_DATA, playAudio);
				
				nowPlaying = false;	
			} else {	//Start playing
				trace("playing");
				nowPlaying = true;
				
				if(mp3sound!=null && mp3sound.length>0) {
					channel = mp3sound.play();
					channel.addEventListener(Event.SOUND_COMPLETE, stopPlayback);
				}
				else {
					recordedBytes.position = 0;
					s = new Sound();
					s.addEventListener(SampleDataEvent.SAMPLE_DATA, playAudio);
					channel = s.play();
					channel.addEventListener(Event.SOUND_COMPLETE, stopPlayback);
				}
			}
		}
		
		private function onComplete(e:Event):void {
			trace("stopped");
			s.removeEventListener(SampleDataEvent.SAMPLE_DATA, playAudio);
			nowPlaying = false;
		}

		private function onSampleDataReceived(event:SampleDataEvent):void {
			var sample:Number = event.data.readFloat();
			recordedBytes.writeBytes(event.data);
			
			if(recordedBytes.length>0)
				recordedSeconds = Math.round(recordedBytes.length / 176400);	//44.1kHz, 16 bit, stereo 
		}
		
		private function playAudio(e:SampleDataEvent):void {	//Plays recorded audio

			if(!recordedBytes.bytesAvailable>0)
				return;
			
			for(var i:int = 0;  i<8192;i++) {
				var sample:Number=0;
				if(recordedBytes.bytesAvailable>0) {
					sample = recordedBytes.readFloat();
				}
				e.data.writeFloat(sample);	//left channel
				e.data.writeFloat(sample);	//right channel
				
			}
		}

		private function stopPlayback(event:Event):void {
			
		}
		
		/************************************************************
		 * FILE HANDLING											*
		 * 															*
		 ************************************************************/
		
		public function saveSoundToFile(in_filename:String):String {
			if(recordedBytes!=null && recordedBytes.length>0) {
				var outputFile:File = File.applicationStorageDirectory.resolvePath("sound_"+in_filename);
				var outputStream:FileStream = new FileStream();
				outputStream.open(outputFile,FileMode.WRITE);
				outputStream.writeBytes(recordedBytes,0,recordedBytes.length);
				outputStream.close();
				
				// Convert to WAV
				var wav:ByteArray = new ByteArray();
				var wavwrite:WAVWriter = new WAVWriter();
				wavwrite.numOfChannels = 1; // mono
				wavwrite.sampleBitRate = 16; // or 8
				wavwrite.samplingRate = 44100; // or 22000
				recordedBytes.position=0;
				wavwrite.processSamples(wav, recordedBytes, 44100, 1);  //Making it into a WAV
				wav.position=0;
				trace("WAV encoding ready");
				//Convert to MP3
				mp3filename="sound_"+in_filename+".mp3";
				convertSoundToMP3(wav);
				
				return outputFile.url;
			}
			else
				return "";
		}
		
		private var	mp3sound:Sound;  
		public var mp3filename:String="";
		
		private function saveMP3toFile():void {
			var outputFile:File = File.applicationStorageDirectory.resolvePath(mp3filename);
			var outputStream:FileStream = new FileStream();
			outputStream.open(outputFile,FileMode.WRITE);
		 	outputStream.writeBytes(encoder.mp3Data,0,encoder.mp3Data.length);
			outputStream.close();	
			
			dispatchEvent(new AudioEvent(AudioEvent.MP3_FILE_SAVED,null,true,true));
			
			if(encoder!=null) {
				encoder.mp3Data.clear();
				encoder.wavData.clear();
				encoder=null;
			}
		}
	 
		public function loadSoundFromURL(_filename:String,_userid:String):void {
			 
			var soundURL:String = "";
			 
			soundURL = GlobalConstants.STATIC_URL + "smorgasbord/audio/" + _userid + "/" + _filename;	
			
			mp3sound = new Sound();   
			mp3sound.addEventListener(IOErrorEvent.IO_ERROR,noAudio);
			mp3sound.addEventListener(Event.COMPLETE, loadMP3Complete);
			mp3sound.load(new URLRequest(soundURL));    
			recordedSeconds = 1;	//So we get buttons
		 
			 	 
		}
		
		
		public function loadSoundFromFile(_filename:String):void {
			var bytes:ByteArray = new ByteArray();
			var inputFile:File = File.applicationStorageDirectory.resolvePath("sound_"+_filename) ;
			if(inputFile.exists) {	//load wav
				var inputStream:FileStream = new FileStream();
				inputStream.open(inputFile,FileMode.READ);
				inputStream.readBytes(bytes,0,inputStream.bytesAvailable);
				inputStream.close();		
				
				recordedBytes = bytes;
				if(recordedBytes.length>0) {
					recordedSeconds =  Math.round((recordedBytes.length / 176400));	//44.1kHz, 16 bit, stereo 
					dispatchEvent(new AudioEvent(AudioEvent.WAV_FILE_READY,null,true,true));
				}
			}
			else {
				inputFile = File.applicationStorageDirectory.resolvePath("sound_"+_filename+".mp3") ;
				if(inputFile.exists) {	//load mp3
					mp3sound = new Sound();   
					mp3sound.addEventListener(IOErrorEvent.IO_ERROR,noAudio);
			 		mp3sound.addEventListener(Event.COMPLETE, loadMP3Complete);
					mp3sound.load(new URLRequest(inputFile.url));    
					recordedSeconds = 1;	//So we get buttons
				}
				else
					noAudio(null);
			}	
		}
		
		private function noAudio(event:Event):void {
			trace("no audio or other audio file error");
			dispatchEvent(new AudioEvent(AudioEvent.NO_AUDIO,null,true,true));
		}
		
		private function loadMP3Complete(event:Event):void {
			trace("mp3 loaded");
			recordedSeconds =  Math.floor(mp3sound.length / 1000) % 60;	
			
			dispatchEvent(new AudioEvent(AudioEvent.MP3_FILE_READY,null,true,true));
		}
		
		private var encoder:utils.ShineMP3Encoder;
		
		public function convertSoundToMP3(in_soundBytes:ByteArray):void {
			  
			trace(in_soundBytes.length);
			if(in_soundBytes.length>0) {
				encoder = new utils.ShineMP3Encoder(in_soundBytes);
				encoder.wavData = in_soundBytes;
				encoder.addEventListener(Event.COMPLETE, onEncodingReady);
				encoder.addEventListener(ProgressEvent.PROGRESS, onEncodingProgress);
				encoder.addEventListener(ErrorEvent.ERROR, onEncodingError);
				encoder.start();
			}
			 
			
		}
		
		private function onEncodingReady(event:Event):void {
			if(encoder!=null) {
				encoder.removeEventListener(Event.COMPLETE,onEncodingReady);
				trace(encoder.mp3Data.length);
			}
			trace("MP3 encoding ready!");
			
			saveMP3toFile();
			
		}
		
		private function onEncodingError(event:Event):void {
			trace("MP3 encoding error!");
		}
		
		private function onEncodingProgress(event:Event):void {
			trace("Encoding mp3!");
		}
		
		public function deleteAudioFile(in_filename:String):void {
			var deleteFile:File =File.applicationStorageDirectory.resolvePath("sound_"+in_filename);
			if(deleteFile.exists)			
				deleteFile.deleteFile();
			
			deleteFile =File.applicationStorageDirectory.resolvePath("sound_"+in_filename+".mp3");
			if(deleteFile.exists)			
				deleteFile.deleteFile();
		}
		
		
		/************************************************************
		 * BACKGROUND MUSIC											*
		 * 															*
		 ************************************************************/
		private var backgroundMusicSound:Sound;
		private var backgroundMusicChannel:SoundChannel;
		private var backgroundMusicStarttime:Number=0;
		
		public function loadBackgroundMusic(_filename:String,starttime:Number):void {

			backgroundMusicStarttime = starttime;
			backgroundMusicSound = new Sound();   
			backgroundMusicSound.addEventListener(IOErrorEvent.IO_ERROR,loadBackgroundMusicError);
			backgroundMusicSound.addEventListener(Event.COMPLETE, loadBackgroundMusicComplete);
			backgroundMusicSound.load(new URLRequest("/assets/music/" + _filename));    
		}
		
		private function playBackgroundMusic():void {
			backgroundMusicChannel = backgroundMusicSound.play(backgroundMusicStarttime,1000, new SoundTransform(1,0));
		}
		
		public function increaseBackgroundMusicVolume():void {
			if(backgroundMusicChannel!=null)
				backgroundMusicChannel.soundTransform = new SoundTransform(1,0);
		}

		public function decreaseBackgroundMusicVolume():void {
			if(backgroundMusicChannel!=null)
				backgroundMusicChannel.soundTransform = new SoundTransform(0.15,0);
		}

		public function decreaseBackgroundMusicVolumeTo(in_vol:Number):void {
			if(backgroundMusicChannel!=null)
				backgroundMusicChannel.soundTransform = new SoundTransform(in_vol,0);
		}
		
		public function stopBackgroundMusic():void {
			if(backgroundMusicChannel!=null)
				backgroundMusicChannel.stop();
			backgroundMusicChannel=null;
			backgroundMusicSound=null;
		}
		
		private function loadBackgroundMusicComplete(event:Event):void {
			playBackgroundMusic();
		}
		
		private function loadBackgroundMusicError(event:IOErrorEvent):void {
			trace("error");
		}
		
		/************************************************************
		 * SOUND FX													*
		 * 															*
		 ************************************************************/
		public function playSoundFX(in_file:String):void {
			var soundURL:String = "";
			
			soundURL = in_file;	
	
			if(channel!=null)
				channel.stop();
			mp3sound = new Sound();   
			mp3sound.addEventListener(IOErrorEvent.IO_ERROR,noAudio);
			mp3sound.addEventListener(Event.COMPLETE, loadSoundFXComplete);
			mp3sound.load(new URLRequest(soundURL));   
			 
		}
			
		public function stopSoundFX():void {
			if(channel!=null) {
				channel.stop();
			}

		}
		
		
		private function loadSoundFXComplete(event:Event):void {
			if(channel!=null)
				channel.stop();
			channel = mp3sound.play();
		}
	}		
}







