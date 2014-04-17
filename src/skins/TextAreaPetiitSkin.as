package skins
{
	/* For guidance on writing an ActionScript Skinnable Component please refer to the Flex documentation: 
	www.adobe.com/go/actionscriptskinnablecomponents */
	
	import spark.components.TextArea;
	import spark.skins.mobile.TextAreaSkin;	
	
	
	/* A component must identify the view states that its skin supports. 
	Use the [SkinState] metadata tag to define the view states in the component class. 
	[SkinState("normal")] */
	
	public class TextAreaPetiitSkin extends spark.skins.mobile.TextAreaSkin
	{
		/* To declare a skin part on a component, you use the [SkinPart] metadata. 
		[SkinPart(required="true")] */
		
		
/*		[Embed(source="/assets/images/textfield/Text-Field-left-edge.png")]
		public static const rightEdge:Class;
		
		[Embed(source="/assets/images/textfield/Text-Field-right-edge.png")]
		public static const leftEdge:Class;
		
		[Embed(source="/assets/images/textfield/Text-Field-center-horizontal-tile.png.png")]
		public static const centerEdge:Class;
*/		
		public function TextAreaPetiitSkin()
		{
			//TODO: implement function
			super();
		}
		
/*		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
*/		
		
		override protected function drawBackground(unscaledWidth:Number,unscaledHeight:Number):void {
			super.drawBackground(unscaledWidth, unscaledHeight);

			
			//gfx här
		}

	}
}