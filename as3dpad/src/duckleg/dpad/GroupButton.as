package duckleg.dpad
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class GroupButton extends Bitmap
	{
		[Embed(source="../embed/dpad/axisStick.png")]
		public static const DEFAULT_BUTTON:Class;
		
		[Embed(source="../embed/dpad/axisStickPress.png")]
		public static const DEFAULT_BUTTON_PRESS:Class;
		
		// <----- status variable
		private var _id:int;
		private var _touchPointID:int;
		
		// <----- UI variable
		private var _buttonBitmapData:BitmapData;
		private var _buttonPressBitmapData:BitmapData;
		
		// **************************************************** main
		public function GroupButton(id:int, button:BitmapData=null, buttonPress:BitmapData=null){
			// <----- adjust arguments
			if(button==null) button = (new DEFAULT_BUTTON() as Bitmap).bitmapData;
			if(buttonPress==null) buttonPress = (new DEFAULT_BUTTON_PRESS() as Bitmap).bitmapData;
			
			// <----- cache variable
			_id = id;
			_buttonBitmapData = button;
			_buttonPressBitmapData = buttonPress;
			
			// <----- set UI
			this.bitmapData = button;
		}
		
		// **************************************************** override public method
		override public function toString():String{
			return "{id:"+_id+", pressed:"+(_touchPointID>=0)+"}";
		}
		
		// **************************************************** getter
		public function get id():int{
			return _id;
		}
		public function get touchPointID():int{
			return _touchPointID;
		}
		
		// **************************************************** setter
		public function set touchPointID(value:int):void{
			_touchPointID = value;
			
			// <----- change UI
			if(value>=0)
				this.bitmapData = _buttonPressBitmapData;
			else
				this.bitmapData = _buttonBitmapData;
		}
	}
}