package duckleg.dpad
{
	import flash.display.Sprite;

	public class BasePad extends Sprite
	{
		public static const VALIGN_TOP:String = "top";
		public static const VALIGN_BOTTOM:String = "bottom";
		
		protected var _valign:String;
		
		// **************************************************** main
		public function BasePad(valign:String="bottom"){
			_valign = valign;
		}
		
		// **************************************************** getter
		public function get valign():String{
			return _valign;
		}
		public function get value():int{
			return -1;
		}
		
		// **************************************************** public method for overriding
		public function reset():void{}
		public function touchBegin(stageX:Number, stageY:Number, touchPointID:int):void{}
		public function touchMove(stageX:Number, stageY:Number, touchPointID:int):void{}
		public function touchEnd(stageX:Number, stageY:Number, touchPointID:int):void{}
		public function keyDown(keyCode:uint):void{}
		public function keyUp(keyCode:uint):void{}
		
		// **************************************************** static public method
		public static function getRadians(x1:Number, y1:Number, x2:Number, y2:Number):Number{
			return Math.atan2(y2 - y1, x2 - x1);
		}
		public static function getDistance(x1:Number, y1:Number, x2:Number,  y2:Number):Number{
			return Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
		}
		public static function getPolarX(x:Number, radians:Number, distance:Number):Number{
			return x + Math.round(distance*Math.cos(radians));
		}
		public static function getPolarY(y:Number, radians:Number, distance:Number):Number{
			return y + Math.round(distance*Math.sin(radians));
		}
	}
}