package models
{
    [Bindable]
	[RemoteClass(alias="PetVO")]
	public class PetVO
	{
		public var petID:Number=0;
		public var ownerID:Number;
		public var ownerFullname:String;
		public var ownerZipcode:String;
		public var location:String;
		public var title:String;	//was fullname
		public var pet_race:String;
		public var pet_breed:String;
		public var colors:String;
		public var birthday:String;
		public var description:String;
		public var gender:String;
		public var salesstatus:int;
		public var saleprice:int;
		public var matingstatus:int;
		public var imageURL:String;
		public var imageURLthumb:String="";
		public var timestamp:Number;
	}
}