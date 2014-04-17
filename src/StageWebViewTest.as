package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.desktop.NativeApplication;
	import flash.display.*;
	import flash.events.LocationChangeEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.*;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	
	public class StageWebViewTest extends Sprite
	{
		public var webView:StageWebView = new StageWebView();
		public var text1:TextField=new TextField();
		public var text2:TextField=new TextField();
		public var text3:TextField=new TextField();
		public var text4:TextField=new TextField();
		
		public function init():void
		{
			text1.htmlText="<b>Back</b>";
			text1.x=100;
			text1.y=-20;
			addChild(text1);
			
			text2.htmlText="<b>Forward</b>";
			text2.x=200;
			text2.y=-20;		
			addChild(text2);
			
			text3.htmlText="<b>CNN</b>";
			text3.x=300;
			text3.y=-80;		
			addChild(text3);
			
			text4.htmlText="<b>BBC</b>";
			text4.x=0;
			text4.y=-80;		
			addChild(text4);
			
			text1.addEventListener(MouseEvent.CLICK,moveBack);
			text2.addEventListener(MouseEvent.CLICK,moveForward);
			text3.addEventListener(MouseEvent.CLICK,goCNN);
			text4.addEventListener(MouseEvent.CLICK,goBBC);
		}
		public function StageWebViewTest()
		{
			init();
			webView.stage = this.stage;
			webView.viewPort = new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight );
			webView.loadURL("http://www.bbc.com");
		}
		
		public function moveBack(event:MouseEvent):void
		{
			if(webView.isHistoryBackEnabled)
			{
				webView.historyBack();
				
			}
			else
			{
				trace("No pages in the browsing history.")
			}		
		}
		public function moveForward(event:MouseEvent):void
		{
			if( webView.isHistoryForwardEnabled)
			{
				webView.historyForward();
			}
			else
			{
				trace("No pages in the browsing history.")
			}
		}
		public function goCNN(event:MouseEvent):void
		{
			webView.loadURL("http://www.cnn.com");
		}
		
		public function goBBC(event:MouseEvent):void
		{
			webView.loadURL("http://www.bbc.com");
		}
	}
}