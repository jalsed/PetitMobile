package dao
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.graphics.codec.PNGEncoder;
	
	import classes.GlobalConstants;
	
	import events.CommentEvent;
	import events.PetEvent;
	 
	public class PetDAO extends EventDispatcher 
	{
		
		private var petID:String="";
		
		[Bindable]
		private var petname:String="";
		[Bindable]
		private var password:String="";
		private var raceID:String="";
		[Bindable]
		private var colors:String="";
		private var birthday:String="";
		[Bindable]
		private var description:String="";
		private var gender:int=0;
	 
		private var salesstatus:int=0;
		private var saleprice:int=0;
		private var matingstatus:int=0;
		private var imageURLs:Array;
		private var countryCode:String="";
		
		
		[Bindable]
		public var currentPetName:String="";
		[Bindable]
		public var currentPetDescription:String="";
		
		public var currentPetID:String="";
		
		public var currentPetImageURL:String="";
		
		/************************************************
		 * GET/SEARCH list of pets						*
		 * 												*
		 ************************************************/
		public function restGetPets(searcharr:Array):void {
			
			var urlLoader:URLLoader = new URLLoader();
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlLoader.addEventListener(Event.COMPLETE, restGetPetsCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetPetsFailedHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "pet/find");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.contentType = "application/json";
			urlRequest.method= URLRequestMethod.POST;
			urlRequest.data = JSON.stringify(searcharr);
			urlLoader.load(urlRequest);
		}
		
		private function restGetPetsFailedHandler(event:Event):void {
			trace("Couldn't get pets from server.");	
			
			dispatchEvent(new PetEvent(PetEvent.PET_GET_LIST_ERROR,null,true,true));	 
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restGetPetsFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restGetPetsCompleteHandler);
		}
		
		private function restGetPetsCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader2.data);
			dispatchEvent(new PetEvent(PetEvent.PET_GET_LIST_READY,obj,true,true));	
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restGetPetsFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restGetPetsCompleteHandler);
		}
		
		/************************************************
		 * Get list of my pets							*
		 * 												*
		 ************************************************/
		public function restGetMyPets(in_userid:int):void {
			var urlLoader:URLLoader = new URLLoader();
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlLoader.addEventListener(Event.COMPLETE, restGetMyPetsCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetMyPetsFailedHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "user/"+in_userid.toString()+"/pets");
		 
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method= URLRequestMethod.GET;
			urlLoader.load(urlRequest);
		}
		
		private function restGetMyPetsFailedHandler(event:Event):void {
			trace("Couldn't get pets from server.");	
			
			dispatchEvent(new PetEvent(PetEvent.PET_GET_MY_LIST_ERROR,null,true,true));	 
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restGetMyPetsFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restGetMyPetsCompleteHandler);
		}
		
		private function restGetMyPetsCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader2.data);
			
			var counter:int=0;
			for each(var pet:Object in obj) {	//Find & set first pet as currentpetID
				if(counter==0) {
					currentPetID=pet.nid.toString();
					if(pet.field_pet_image.hasOwnProperty("und"))
						currentPetImageURL=pet.field_pet_image.und[0].uri;
					counter++;
				}
			}
			
			dispatchEvent(new PetEvent(PetEvent.PET_GET_MY_LIST_READY,obj,true,true));	 
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restGetMyPetsFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restGetMyPetsCompleteHandler);
		}
		
		
		/************************************************
		 * Register/Create Pet							*
		 * 												*
		 ************************************************/
		public function restRegisterPet(ownerid:String,name:String,raceid:String,breed:String,colors:String,birthday_year:String,birthday_month:String,birthday_day:String,description:String,gender:String,salesstatus:int,saleprice:int,matingstatus:int,language:String,imageName:String):void{
			
			var petCreate:Object = {};
			
			petCreate.type="pet";
			petCreate.language = language;
			petCreate.title = name;
			
			petCreate.body= { 
				"und":[
					{
						"value":description,
						 "format":"filtered_html"
					}
				]
			};
			
			petCreate.field_pet_race={
				"und":raceid
			};
			
			petCreate.field_pet_breed={
				"und":breed
			};

			petCreate.field_gender= 
				{
					"und":gender
				};
			
		 
			
			petCreate.field_birthday={
				"und":[
					{
						"value":{
							"month":birthday_month,
							"day":birthday_day,
							"year":birthday_year
						}
					}
				]
			};
			
			petCreate.field_colors= {
				"und":[
					{
						"value":colors
					}
				]
			};
			
			petCreate.field_pet_image = {'und': []};
			if(imageName!=null && imageName.length>0) {
				petCreate.field_pet_image.und.push({"fid":imageName,"display":1});
			}
			
		
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restRegisterPetHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restRegisterPetFaultHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "node");
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method = URLRequestMethod.POST;
			
			urlRequest.data = JSON.stringify(petCreate);
			urlRequest.contentType = "application/json";
			urlLoader.load(urlRequest);
		}
		
		private function restRegisterPetHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader.data);
			
			dispatchEvent(new PetEvent(PetEvent.PET_REGISTERED,null,true,true));
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restRegisterPetFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restRegisterPetHandler);
		}
		
		private function restRegisterPetFaultHandler(event:IOErrorEvent):void {
			var loader:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader.data);
			 
			trace("Register error");
			dispatchEvent(new PetEvent(PetEvent.PET_REGISTERED_ERROR,null,true,true));
			
			
			//Clean
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restRegisterPetFaultHandler);
			loader.removeEventListener(Event.COMPLETE,restRegisterPetHandler);
		}
		
		/************************************************************
		 * UPDATE PET												*
		 * 															*
		 ************************************************************/
		public function restUpdatePet(ownerid:String,petID:String,name:String,raceID:String,breed:String,gender:String,description:String,colors:String,salesstatus:String,saleprice:String,matingstatus:String,birthday_year:String,birthday_month:String,birthday_day:String,language:String,imageName:String):void {
			
			var petUpdate:Object = {};
			 
			petUpdate.type="pet";
			petUpdate.language = language;
			petUpdate.title = name;
			
			petUpdate.body= { 
				"und":[
					{
						"value":description,
						 "format":"filtered_html"
					}
				]
			};
			
			petUpdate.field_pet_race={
				"und":raceID
			};

			petUpdate.field_pet_breed={
				"und":[
					{"value":breed}
					]
			};

			petUpdate.field_gender= 
				{
					"und":gender
				};
			 
			petUpdate.field_sale_status= {
				"und":salesstatus
			};
			
			petUpdate.saleprice= {
				"und":[
					{
						"value":saleprice
					}
				]
			};
			
			petUpdate.matingstatus={ 
				"und":matingstatus
			};
			
			petUpdate.field_birthday={
				"und":[
					{
						"value":{
							"month":birthday_month,
							"day":birthday_day,
							"year":birthday_year
						}
					}
				]
			};
			
			petUpdate.field_colors= {
				"und":[
					{
						"value":colors
					}
				]
			};
			
			petUpdate.field_pet_image = {'und': []};
			if(imageName!=null && imageName.length>0) {
				petUpdate.field_pet_image.und.push({"fid":imageName,"display":1});
			}
					
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, restUpdatePetHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restUpdatePetFaultHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "node/" + petID);
			urlRequest.requestHeaders.push(new URLRequestHeader("Accept", "application/json"));
			urlRequest.requestHeaders.push(new URLRequestHeader("X-HTTP-Method-Override", "PUT"));
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.contentType = "application/json";
			urlRequest.data = JSON.stringify(petUpdate);
			urlLoader.load(urlRequest);
		 
			 
		}
		
		private function restUpdatePetHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			
			dispatchEvent(new PetEvent(PetEvent.PET_UPDATED,null,true,true));
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restUpdatePetFaultHandler);
			loader2.removeEventListener(Event.COMPLETE,restUpdatePetHandler);
		}
		
		private function restUpdatePetFaultHandler(event:IOErrorEvent):void {
			dispatchEvent(new PetEvent(PetEvent.PET_UPDATE_ERROR,null,true,true));
		}
		
	
		
		/************************************************
		 * GET PET DETAILS								*
		 * 												*
		 ************************************************/
		public function restGetThisPet(in_petid:int):void {
			var urlLoader:URLLoader = new URLLoader();
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlLoader.addEventListener(Event.COMPLETE, restGetThisPetCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetThisPetFailedHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "node/"+in_petid.toString());
			
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.method= URLRequestMethod.GET;
			urlLoader.load(urlRequest);
		}
		
		private function restGetThisPetFailedHandler(event:Event):void {
			trace("Couldn't get this pet from server.");	
			
			dispatchEvent(new PetEvent(PetEvent.PET_GET_THIS_PET_ERROR,null,true,true));	 
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restGetThisPetFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restGetThisPetCompleteHandler);
		}
		
		private function restGetThisPetCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader2.data);
			dispatchEvent(new PetEvent(PetEvent.PET_GET_THIS_PET_READY,obj,true,true));	 
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restGetThisPetFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restGetThisPetCompleteHandler);
		}
		 
		
		/************************************************
		 * GET LIST OF NEARBY PETS						*
		 * 												*
		 ************************************************/
		public function restGetNearbyPets(in_user:String):void {			
			
			var urlLoader:URLLoader = new URLLoader();
			var acceptHeader:URLRequestHeader = new  URLRequestHeader("Accept", "application/json");
			urlLoader.addEventListener(Event.COMPLETE, restGetNearbyPetsCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, restGetNearbyPetsFailedHandler);
			var urlRequest : URLRequest = new URLRequest(GlobalConstants.DRUPAL_PATH + "user/"+in_user+"/findnearby");
			urlRequest.requestHeaders.push(acceptHeader);
			urlRequest.contentType = "application/json";
			urlRequest.method= URLRequestMethod.GET;
			urlLoader.load(urlRequest);
		}
		
		private function restGetNearbyPetsFailedHandler(event:Event):void {
			trace("Couldn't get pets from server.");	
			
			dispatchEvent(new PetEvent(PetEvent.PET_GET_LIST_ERROR,null,true,true));	 
			//Clean
			var loader:URLLoader = URLLoader(event.target);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,restGetNearbyPetsFailedHandler);
			loader.removeEventListener(Event.COMPLETE,restGetNearbyPetsCompleteHandler);
		}
		
		private function restGetNearbyPetsCompleteHandler(event:Event):void {
			var loader2:URLLoader = URLLoader(event.target);
			var obj:Object = JSON.parse(loader2.data);
			dispatchEvent(new PetEvent(PetEvent.PET_GET_LIST_READY,obj,true,true));	
			
			//Clean
			loader2.removeEventListener(IOErrorEvent.IO_ERROR,restGetNearbyPetsFailedHandler);
			loader2.removeEventListener(Event.COMPLETE,restGetNearbyPetsCompleteHandler);
		}
		
		
	}
}