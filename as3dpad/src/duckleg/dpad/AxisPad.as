package duckleg.dpad
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	public class AxisPad extends BasePad
	{
		[Embed(source="../embed/dpad/axisBase.png")]
		public static const DEFAULT_AXIS_BASE:Class;
		
		[Embed(source="../embed/dpad/axisStick.png")]
		public static const DEFAULT_AXIS_STICK:Class;
		
		[Embed(source="../embed/dpad/axisStickPress.png")]
		public static const DEFAULT_AXIS_STICK_PRESS:Class;
		
		// <----- const value
		public static const LEFT:int = 2;
		public static const RIGHT:int = 4;
		public static const UP:int = 8;
		public static const DOWN:int = 16;
		
		// <----- for speed up calculation
		private static const PI0:Number = Math.PI/8;
		private static const PI1:Number = PI0*3;
		private static const PI2:Number = PI0*5;
		private static const PI3:Number = PI0*7;
		private static const PI4:Number = -Math.PI/8;
		private static const PI5:Number = PI4*3;
		private static const PI6:Number = PI4*5;
		private static const PI7:Number = PI4*7;
		private static const PI_RIGHT:Number = 0;
		private static const PI_RIGHT_DOWN:Number = PI0*2;
		private static const PI_DOWN:Number = PI0*4;
		private static const PI_LEFT_DOWN:Number = PI0*6;
		private static const PI_LEFT:Number = Math.PI;
		private static const PI_LEFT_UP:Number = PI4*6;
		private static const PI_UP:Number = PI4*4;
		private static const PI_RIGHT_UP:Number = PI4*2;
		
		// <----- UI variable
		private var _stickBitmapData:BitmapData;
		private var _stickPressBitmapData:BitmapData;
		private var _base:Bitmap;
		private var _stick:Bitmap;
		
		// <----- const for a instance
		private var _buttonX:int;
		private var _buttonY:int;
		private var _buttonW:int;
		private var _maxDistance:int;
		
		// <----- status variable
		private var _touchPointID:int;
		private var _touch:Point;
		private var _distance:Number;
		private var _radians:Number;
		private var _value:int;
		
		// <----- keycode mapping
		private var _leftKeycode:int = 65;
		private var _rightKeycode:int = 68;
		private var _upKeycode:int = 87;
		private var _downKeycode:int = 83;
		
		// **************************************************** main
		public function AxisPad(valign:String="bottom", base:BitmapData=null, stick:BitmapData=null, stickPress:BitmapData=null){
			super(valign);
			
			// <----- adjust arguments
			if(base==null) base = (new DEFAULT_AXIS_BASE() as Bitmap).bitmapData;
			if(stick==null) stick = (new DEFAULT_AXIS_STICK() as Bitmap).bitmapData;
			if(stickPress==null) stickPress = (new DEFAULT_AXIS_STICK_PRESS() as Bitmap).bitmapData;
			
			// <----- cache variable
			_stickBitmapData = stick;
			_stickPressBitmapData = stickPress;
			
			// <----- create instance
			_base = new Bitmap(base);
			_stick = new Bitmap(_stickBitmapData);
			
			// <----- set property
			_base.x = -base.width/2;
			_base.y = -base.height/2;
			_stick.x = _buttonX = -int(_stickBitmapData.width/2);
			_stick.y = _buttonY = -int(_stickBitmapData.height/2);
			_maxDistance = int((Math.max(base.width, base.height) - Math.max(_stickBitmapData.width, _stickBitmapData.height))/2);
			
			// <----- add child
			this.addChild(_base);
			this.addChild(_stick);
		}
		
		// **************************************************** override public method
		override public function reset():void{
			_touchPointID = -1;
			_touch = new Point(0, 0);
			_distance = 0;
			_radians = 0;
			_stick.x = _buttonX;
			_stick.y = _buttonY;
			_value = 0;
		}
		override public function touchBegin(stageX:Number, stageY:Number, touchPointID:int):void{
			if(_base.hitTestPoint(stageX, stageY)){
				// <----- cache touch id
				_touchPointID = touchPointID;
				
				// <----- change UI
				_stick.bitmapData = _stickPressBitmapData;
				
				// <----- dispatch event
				this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_PRESS));
			}
		}
		override public function touchMove(stageX:Number, stageY:Number, touchPointID:int):void{
			if(_touchPointID==touchPointID){
				// <----- cache variable
				_touch = globalToLocal(new Point(stageX, stageY));
				_distance = Math.min(BasePad.getDistance(0, 0, _touch.x, _touch.y), _maxDistance);
				_radians = BasePad.getRadians(0, 0, _touch.x, _touch.y);
				
				// <----- set UI
				_stick.x = BasePad.getPolarX(0, _radians, _distance) + _buttonX;
				_stick.y = BasePad.getPolarY(0, _radians, _distance) + _buttonY;
				
				// <----- set value
				if(_radians>=0){
					if(_radians<PI0)
						_value = RIGHT;
					else if(_radians<PI1)
						_value = RIGHT | DOWN;
					else if(_radians<PI2)
						_value = DOWN;
					else if(_radians<PI3)
						_value = LEFT | DOWN;
					else
						_value = LEFT;
				}else{
					if(_radians>PI4)
						_value = RIGHT;
					else if(_radians>PI5)
						_value = RIGHT | UP;
					else if(_radians>PI6)
						_value = UP;
					else if(_radians>PI7)
						_value = LEFT | UP;
					else
						_value = LEFT;
				}
			}
		}
		override public function touchEnd(stageX:Number, stageY:Number, touchPointID:int):void{
			if(_touchPointID==touchPointID){
				// <----- change UI
				_stick.bitmapData = _stickBitmapData;
				
				// <----- dispatch event
				this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_RELEASE));
				
				// <----- reset
				reset();
			}
		}
		override public function keyDown(keyCode:uint):void{
			var press:Boolean = false;
			var v:int = _value;
			switch(keyCode){
				case _leftKeycode:
					if(!(_value&LEFT)){
						_value |= LEFT;
						press = true;
					}
					break;
				case _rightKeycode:
					if(!(_value&RIGHT)){
						_value |= RIGHT;
						press = true;
					}
					break;
				case _upKeycode:
					if(!(_value&UP)){
						_value |= UP;
						press = true;
					}
					break;
				case _downKeycode:
					if(!(_value&DOWN)){
						_value |= DOWN;
						press = true;
					}
					break;
			}
			
			if(press){
				// <----- cache variable
				_distance = _maxDistance;
				_radians = findPI(_value);
				
				// <----- set UI
				_stick.x = BasePad.getPolarX(0, _radians, _distance) + _buttonX;
				_stick.y = BasePad.getPolarY(0, _radians, _distance) + _buttonY;
				
				if(v==0){
					// <----- change UI
					_stick.bitmapData = _stickPressBitmapData;
					
					// <----- dispatch event
					this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_PRESS));
				}
			}
		}
		override public function keyUp(keyCode:uint):void{
			var release:Boolean = false;
			switch(keyCode){
				case _leftKeycode:
					if(_value&LEFT){
						_value -= LEFT;
						release = true;
					}
					break;
				case _rightKeycode:
					if(_value&RIGHT){
						_value -= RIGHT;
						release = true;
					}
					break;
				case _upKeycode:
					if(_value&UP){
						_value -= UP;
						release = true;
					}
					break;
				case _downKeycode:
					if(_value&DOWN){
						_value -= DOWN;
						release = true;
					}
					break;
			}
			
			if(release){
				// <----- cache variable
				_distance = _maxDistance;
				_radians = findPI(_value);
				
				// <----- set UI
				_stick.x = BasePad.getPolarX(0, _radians, _distance) + _buttonX;
				_stick.y = BasePad.getPolarY(0, _radians, _distance) + _buttonY;
				
				if(_value==0){
					// <----- change UI
					_stick.bitmapData = _stickBitmapData;
					
					// <----- dispatch event
					this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_RELEASE));
					
					// <----- reset
					reset();
				}
			}
		}
		override public function toString():String{
			return "{value:"+_value+", radians:"+_radians+", distance:"+_distance+", maxDistance:"+_maxDistance+"}";
		}
		
		// **************************************************** getter
		public function get touch():Point{
			return _touch;
		}
		public function get maxDistance():int{
			return _maxDistance;
		}
		public function get distance():Number{
			return _distance;
		}
		public function get radians():Number{
			return _radians;
		}
		
		// **************************************************** overrite getter
		override public function get value():int{
			return _value;
		}
		
		// **************************************************** setter
		public function set leftKeycode(value:int):void{
			_leftKeycode = value;
		}
		public function set rightKeycode(value:int):void{
			_rightKeycode = value;
		}
		public function set upKeycode(value:int):void{
			_upKeycode = value;
		}
		public function set downKeycode(value:int):void{
			_downKeycode = value;
		}
		
		// **************************************************** private method
		private function findPI(value:int):Number{
			switch(value){
				case 4:
					return PI_RIGHT;
					break;
				case 20:
					return PI_RIGHT_DOWN;
					break;
				case 16:
					return PI_DOWN;
					break;
				case 18:
					return PI_LEFT_DOWN;
					break;
				case 2:
					return PI_LEFT;
					break;
				case 10:
					return PI_LEFT_UP;
					break;
				case 8:
					return PI_UP;
					break;
				case 12:
					return PI_RIGHT_UP;
					break;
			}
			return 0;
		}
	}
}