package dao
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import classes.GlobalConstants;
	
	import events.CompetitionEvent;
	import events.GameEvent;
	
	import models.CompetitionVO;
	 
	public class CompetitionDAO extends EventDispatcher 
	{
		  
		/********************************************************
		 *			GET COMPETITIONS (LIST)						*
		 *														*
		 ********************************************************/
		
		public function restGetCompetitions(petid:String):void {
		
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest : URLRequest;
			
			if(petid.length>0) {
				urlLoader.addEventListener(Event.COMPLETE, restGetCompetitionsCompleteHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetCompetitionsFailedHandler);
				urlRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "pet/" + petid + "/competitions.json");
				urlLoader.load(urlRequest);
			}
			else {
				urlLoader.addEventListener(Event.COMPLETE, restGetCompetitionsCompleteHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetCompetitionsFailedHandler);
				urlRequest = new URLRequest(GlobalConstants.DRUPAL_PATH  + "competition.json");
				urlLoader.load(urlRequest);
			}		
		}
		
		private function restGetCompetitionsFailedHandler(event:Event):void {
			trace("Couldn't get competitions from server.");	
			
			dispatchEvent(new CompetitionEvent(CompetitionEvent.COMPETITION_GETCOMPETITIONS_FAILED,null,true,true));
			
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restGetCompetitionsFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restGetCompetitionsCompleteHandler);
		}
		
		private function restGetCompetitionsCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader2.data);
			
			dispatchEvent(new CompetitionEvent(CompetitionEvent.COMPETITION_GETCOMPETITIONS_READY,obj,true,true));	
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restGetCompetitionsFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restGetCompetitionsCompleteHandler);
		}
	
		
		/********************************************************
		 *			GET COMPETITION DETAIL						*
		 *														*
		 *********************************************************/
		
		public function restGetCompetitionDetail(competitionID:String):void {
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restGetCompetitionDetailCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetCompetitionDetailFailedHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "node/" + competitionID + ".json");
			urlLoader.load(urlRequest);
		}
		
		
		private function restGetCompetitionDetailFailedHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new CompetitionEvent(CompetitionEvent.COMPETITION_GETCOMPETITIONDETAIL_FAILED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restGetCompetitionDetailFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restGetCompetitionDetailCompleteHandler);
		}
		
		private function restGetCompetitionDetailCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader2.data);
			
			dispatchEvent(new CompetitionEvent(CompetitionEvent.COMPETITION_GETCOMPETITIONDETAIL_READY,obj,true,true));
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restGetCompetitionDetailFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restGetCompetitionDetailCompleteHandler);
		}
		
		
		
		/********************************************************
		 *			ENTER COMPETITION 							*
		 *														*
		 *********************************************************/
		
		public function restEnterCompetition(in_competitionid:String,in_feedid:String):void {
			if(in_feedid.length>0) {
				var enterobj:Object = {};
				enterobj.bid=in_feedid;
				
				var urlLoader:URLLoader = new URLLoader();
				var urlRequest : URLRequest;
				urlLoader.addEventListener(Event.COMPLETE, restEnterCompetitionCompleteHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restEnterCompetitionFailedHandler);
				
				urlRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "competition/" + in_competitionid+"/enter?XDEBUG_SESSION_START=1");
				var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
				urlRequest.requestHeaders.push(acceptHeader);
				urlRequest.method = URLRequestMethod.POST;
				urlRequest.contentType = "application/json";
				urlRequest.data = JSON.stringify(enterobj);
				
				urlLoader.load(urlRequest);
			}
		}
		
		private function restEnterCompetitionFailedHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new CompetitionEvent(CompetitionEvent.COMPETITION_ENTERCOMPETITION_FAILED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restEnterCompetitionFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restEnterCompetitionCompleteHandler);
		}
		
		private function restEnterCompetitionCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			 
			dispatchEvent(new CompetitionEvent(CompetitionEvent.COMPETITION_ENTERCOMPETITION_READY,null,true,true));
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restEnterCompetitionFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restEnterCompetitionCompleteHandler);
		}

		
		/********************************************************
		 *			EXIT COMPETITION 							*
		 *														*
		 *********************************************************/
		
		public function restExitCompetition(in_competitionid:String,in_feedid:String):void {
			if(in_competitionid.length>0) {
				 
				var enterobj:Object = {};
				enterobj.bid=in_feedid;
				
				var urlLoader:URLLoader = new URLLoader();
				var urlRequest : URLRequest;
				urlLoader.addEventListener(Event.COMPLETE, restExitCompetitionCompleteHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restExitCompetitionFailedHandler);
				
				urlRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "competition/" + in_competitionid+"/exit?XDEBUG_SESSION_START=1");
				var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
				urlRequest.requestHeaders.push(acceptHeader);
				urlRequest.method = URLRequestMethod.POST;
				urlRequest.contentType = "application/json";
				urlRequest.data = JSON.stringify(enterobj);
				  
				urlLoader.load(urlRequest);
			}
		}
		
		private function restExitCompetitionFailedHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new CompetitionEvent(CompetitionEvent.COMPETITION_EXITCOMPETITION_FAILED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restExitCompetitionFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restExitCompetitionCompleteHandler);
		}
		
		private function restExitCompetitionCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new CompetitionEvent(CompetitionEvent.COMPETITION_EXITCOMPETITION_READY,null,true,true));
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restExitCompetitionFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restExitCompetitionCompleteHandler);
		}
		
	
		/********************************************************
		 *			VOTE FOR A COMPETITION 						*
		 *														*
		 *********************************************************/
		
		public function restVoteCompetition(in_competitionid:String,in_feedid:String):void {
			if(in_competitionid.length>0) {
				var voteobj:Object = {};
				voteobj.bid=in_feedid;
				
				var urlLoader:URLLoader = new URLLoader();
				var urlRequest : URLRequest;
				urlLoader.addEventListener(Event.COMPLETE, restVoteCompetitionCompleteHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restVoteCompetitionFailedHandler);
				
				urlRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "competition/" + in_competitionid+"/vote");
				var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
				urlRequest.requestHeaders.push(acceptHeader);
				urlRequest.method = URLRequestMethod.POST;
				urlRequest.contentType = "application/json";
				urlRequest.data = JSON.stringify(voteobj);
				
				urlLoader.load(urlRequest);
			}
		}
		
		private function restVoteCompetitionFailedHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new CompetitionEvent(CompetitionEvent.COMPETITION_VOTECOMPETITIONDETAIL_FAILED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restVoteCompetitionFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restVoteCompetitionCompleteHandler);
		}
		
		private function restVoteCompetitionCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new CompetitionEvent(CompetitionEvent.COMPETITION_VOTECOMPETITIONDETAIL_READY,null,true,true));
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restVoteCompetitionFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restVoteCompetitionCompleteHandler);
		}
		
		
		/********************************************************
		 *			GAME SCORES									*
		 *														*
		 *********************************************************/
		// GET
		public function restGetGameScores(in_competitionid:String):void {
			if(in_competitionid.length>0) {
			 
				var urlLoader:URLLoader = new URLLoader();
				var urlRequest : URLRequest;
				urlLoader.addEventListener(Event.COMPLETE, restGetGameScoreCompleteHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetGameScoreFailedHandler);
				
				urlRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "competition/" + in_competitionid+"/highscores");
				var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
				urlRequest.requestHeaders.push(acceptHeader);
				urlRequest.method = URLRequestMethod.GET;
				urlRequest.contentType = "application/json";
				 
				urlLoader.load(urlRequest);
			}
		}
		
		private function restGetGameScoreFailedHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new GameEvent(GameEvent.GETSCORE_FAILED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restGetGameScoreFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restGetGameScoreCompleteHandler);
		}
		
		private function restGetGameScoreCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader2.data);
			
			dispatchEvent(new GameEvent(GameEvent.GETSCORE_READY,obj,true,true));
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restGetGameScoreFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restGetGameScoreCompleteHandler);
		}
		
		
		// SET setScore 		returnerar 1 om highscore annars 2
		public function restSetGameScore(in_competitionid:String,in_petid:String,in_score:String):void {
			if(in_competitionid.length>0) {
				var scoreobj:Object = {};
				scoreobj.pid = in_petid;
				scoreobj.score = in_score;
				
				var urlLoader:URLLoader = new URLLoader();
				var urlRequest : URLRequest;
				urlLoader.addEventListener(Event.COMPLETE, restSetGameScoreCompleteHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restSetGameScoreFailedHandler);
				
				urlRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "competition/" + in_competitionid+"/setScore");
				var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
				urlRequest.requestHeaders.push(acceptHeader);
				urlRequest.method = URLRequestMethod.POST;
				urlRequest.contentType = "application/json";
				urlRequest.data = JSON.stringify(scoreobj);
				
				urlLoader.load(urlRequest);
			}
		}
		
		private function restSetGameScoreFailedHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new GameEvent(GameEvent.SETSCORE_FAILED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restSetGameScoreFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restSetGameScoreCompleteHandler);
		}
		
		private function restSetGameScoreCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new GameEvent(GameEvent.SETSCORE_READY,event.currentTarget.data,true,true));
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restSetGameScoreFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restSetGameScoreCompleteHandler);
		}
		
	}
}