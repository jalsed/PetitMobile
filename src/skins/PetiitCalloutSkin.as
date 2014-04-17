package skins
{
	import mx.core.DPIClassification;
	import spark.skins.mobile.CalloutSkin;
	import spark.skins.mobile.supportClasses.CalloutArrow;
	
	public class PetiitCalloutSkin extends CalloutSkin
	{
		public function PetiitCalloutSkin()
		{
			
			this.useBackgroundGradient=false;
		
			switch (applicationDPI)
			{
				// add in other cases for 240 and 320 DPI above if needed
				// right now most tablets are 160
				case DPIClassification.DPI_160:
				{
/*					backgroundCornerRadius = 8;
					frameThickness = 2;
					arrowWidth = 82; //default is 52 at 160 DPI
					arrowHeight = 46; // default is 26 at 160 DPI
					borderColor=0xffffff;
					borderThickness=1;
					 
					contentCornerRadius = 40;
*/					break;
				}
				case DPIClassification.DPI_320:
				{
					backgroundCornerRadius = 2;
					frameThickness = 8;
					arrowWidth = 82; //default is 52 at 160 DPI
					arrowHeight = 46; // default is 26 at 160 DPI
					borderColor=0x4a3151;
					borderThickness=1;
					
					this.dropShadowVisible=true;
				//	this.opaqueBackground();
					contentCornerRadius = 8;
					break;
				}
			}
		}
		
		override protected function createChildren():void
		{
			// BoxyCalloutArrow subclasses CalloutArrow
			
			// create arrow first, super will skip default arrow creation
			arrow = new spark.skins.mobile.supportClasses.CalloutArrow();
			arrow.id = "arrow";
			arrow.styleName = this;
			arrow.setStyle("contentBackgroundColor","#4a3151");
			arrow.setStyle("color","#4a3151");
			arrow.setStyle("useBackgroundGradient","false");
			arrow.setStyle("borderColor","#ffffff");
			
			
			// call super
			super.createChildren();
			
			// add arrow above all other children
			addChild(arrow);
		}
	}
}