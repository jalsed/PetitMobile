package games.puzzleGame.com
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import games.puzzleGame.com.PuzzleEvent;
	
	/**
	 * ...
	 * @author ami hanya ami@orn.co.il
	 */
	public class Piece extends Sprite
	{
		private var image:Bitmap;
		private var obj:Object
		private var gap:Number = 60;//40;//20;	Makes it easier since the drop doesn't have to be pixel perfect 
		private var piecesstartpos:int = 420;//360;
		
		public function Piece()
		{
		
		}
		
		public function init($obj:Object):void
		{
			obj = $obj;
			x = obj.x;
			y = obj.y;
			var offsetX:Number = obj.width * obj.i;
			var offsetY:Number = obj.height * obj.j;
			var x8:Number = Math.round(obj.width / 8);
			var y8:Number = Math.round(obj.height / 8);
			var i:Number = obj.i;
			var j:Number = obj.j;
			var tileObj:Object = obj.tileObj;
			var s:Shape = new Shape
			var context:Graphics = s.graphics;
			
			if (obj.draggable)
			{
				context.lineStyle(2, 0, 1, true, "round");
				context.beginBitmapFill(obj.image);
				
			}
			else
			{
				context.lineStyle(2, 0, .5, true, "round");
				context.beginFill(0xFFFFFF, .5);
				
			}
			context.moveTo(offsetX, offsetY);
			s.x = -offsetX;
			s.y = -offsetY;
			
			if (j != 0)
			{
				context.lineTo(offsetX + 3 * x8, offsetY);
				if (tileObj.up == 1)
				{
					context.curveTo(offsetX + 2 * x8, offsetY - 2 * y8, offsetX + 4 * x8, offsetY - 2 * y8);
					context.curveTo(offsetX + 6 * x8, offsetY - 2 * y8, offsetX + 5 * x8, offsetY);
				}
				else
				{
					context.curveTo(offsetX + 2 * x8, offsetY + 2 * y8, offsetX + 4 * x8, offsetY + 2 * y8);
					context.curveTo(offsetX + 6 * x8, offsetY + 2 * y8, offsetX + 5 * x8, offsetY);
				}
			}
			context.lineTo(offsetX + 8 * x8, offsetY);
			if (i != obj.horizontalPieces - 1)
			{
				context.lineTo(offsetX + 8 * x8, offsetY + 3 * y8);
				if (tileObj.right == 1)
				{
					context.curveTo(offsetX + 10 * x8, offsetY + 2 * y8, offsetX + 10 * x8, offsetY + 4 * y8);
					context.curveTo(offsetX + 10 * x8, offsetY + 6 * y8, offsetX + 8 * x8, offsetY + 5 * y8);
				}
				else
				{
					context.curveTo(offsetX + 6 * x8, offsetY + 2 * y8, offsetX + 6 * x8, offsetY + 4 * y8);
					context.curveTo(offsetX + 6 * x8, offsetY + 6 * y8, offsetX + 8 * x8, offsetY + 5 * y8);
				}
			}
			context.lineTo(offsetX + 8 * x8, offsetY + 8 * y8);
			if (j != obj.verticalPieces - 1)
			{
				context.lineTo(offsetX + 5 * x8, offsetY + 8 * y8);
				if (tileObj.down == 1)
				{
					context.curveTo(offsetX + 6 * x8, offsetY + 10 * y8, offsetX + 4 * x8, offsetY + 10 * y8);
					context.curveTo(offsetX + 2 * x8, offsetY + 10 * y8, offsetX + 3 * x8, offsetY + 8 * y8);
				}
				else
				{
					context.curveTo(offsetX + 6 * x8, offsetY + 6 * y8, offsetX + 4 * x8, offsetY + 6 * y8);
					context.curveTo(offsetX + 2 * x8, offsetY + 6 * y8, offsetX + 3 * x8, offsetY + 8 * y8);
				}
			}
			context.lineTo(offsetX, offsetY + 8 * y8);
			if (i != 0)
			{
				context.lineTo(offsetX, offsetY + 5 * y8);
				if (tileObj.left == 1)
				{
					context.curveTo(offsetX - 2 * x8, offsetY + 6 * y8, offsetX - 2 * x8, offsetY + 4 * y8);
					context.curveTo(offsetX - 2 * x8, offsetY + 2 * y8, offsetX, offsetY + 3 * y8);
				}
				else
				{
					context.curveTo(offsetX + 2 * x8, offsetY + 6 * y8, offsetX + 2 * x8, offsetY + 4 * y8);
					context.curveTo(offsetX + 2 * x8, offsetY + 2 * y8, offsetX, offsetY + 3 * y8);
				}
			}
			addChild(s)
			if (obj.draggable)
			{
				//330 är y positionen där pusselbitarna trillar ner vid start.
				//TweenMax.to(this, .5, {x: Math.round(Math.random() * (obj.image.width - obj.width)), y: Math.round(Math.random() * (obj.image.height - obj.height))+piecesstartpos, delay: 2 + Math.random(), ease: Back.easeInOut, onComplete: addMouseEvent});
				TweenMax.to(this, .5, {x: Math.round(Math.random() * (obj.image.width - obj.width)), y: Math.round(Math.random() * (obj.image.height - obj.height))+piecesstartpos, delay: 1.5 + Math.random(), ease: Back.easeInOut, onComplete: addMouseEvent});
			}
			else
			{
				mouseChildren = false;
				mouseEnabled = false;
			}
		
		}
		
		private function addMouseEvent():void
		{
			if (obj.draggable)
			{
				buttonMode = true;
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			}
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			startDrag();
			parent.setChildIndex(this, parent.numChildren - 1);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		
		}
		
		private function mouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stopDrag();
			x = Math.round(x);
			y = Math.round(y);
			if (x < obj.x + gap / 2 && x > obj.x - gap / 2 && y < obj.y + gap / 2 && y > obj.y - gap / 2)
			{
				x = obj.x;
				y = obj.y;
				mouseEnabled = false;
				mouseChildren = false;
				parent.setChildIndex(this, 0);
				
				trace("got puzzle right");
				this.dispatchEvent(new PuzzleEvent(PuzzleEvent.PUZZLECORRECT,null,true,true));
			}
		}
	
	}

}