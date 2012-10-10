package duckleg.dpad
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	public class DPad extends Sprite
	{
		public static const DEFAULT_PADDING:int = 130;
		
		public static const TOUCH_LEFT_TOP:int = 2;
		public static const TOUCH_TOP:int = 4;
		public static const TOUCH_RIGHT_TOP:int = 8;
		public static const TOUCH_LEFT_MIDDLE:int = 16;
		public static const TOUCH_MIDDLE:int = 32;
		public static const TOUCH_RIGHT_MIDDLE:int = 64;
		public static const TOUCH_LEFT_BOTTOM:int = 128;
		public static const TOUCH_BOTTOM:int = 256;
		public static const TOUCH_RIGHT_BOTTOM:int = 512;
		
		// <----- UI variable
		private var _lPad:BasePad;
		private var _rPad:BasePad;
		private var _padding:int = DEFAULT_PADDING;
		
		// <----- touch9Grid variable
		private var _touch9Grid:Boolean;
		private var _touch9Rects:Vector.<Rectangle>;
		private var _touch9Value:int;
		private var _touch9Ids:Vector.<int>;
		private var _touch9Keycodes:Vector.<int>;
		private var _touch:Point;
		
		// <----- keycode mapping
		private var _leftTopKeycode:int = 103;
		private var _topKeycode:int = 104;
		private var _rightTopKeycode:int = 105;
		private var _leftMiddleKeycode:int = 100;
		private var _middleKeycode:int = 101;
		private var _rightMiddleKeycode:int = 102;
		private var _leftBottomKeycode:int = 97;
		private var _bottomKeycode:int = 98;
		private var _rightBottomKeycode:int = 99;
		
		
		// **************************************************** main
		public function DPad(leftPad:BasePad=null, rightPad:BasePad=null, touch9Grid:Boolean=false){
			// <----- adjust arguments
			if(leftPad==null) leftPad = new AxisPad();
			if(rightPad==null) rightPad = new GroupPad();
			
			// <----- cache variable
			_lPad = leftPad;
			_rPad = rightPad;
			_touch9Grid = touch9Grid;
			
			// <----- create mapping for touch9Grid
			if(_touch9Grid){
				_touch9Ids = new Vector.<int>;
				_touch9Ids.push(TOUCH_LEFT_TOP);
				_touch9Ids.push(TOUCH_TOP);
				_touch9Ids.push(TOUCH_RIGHT_TOP);
				_touch9Ids.push(TOUCH_LEFT_MIDDLE);
				_touch9Ids.push(TOUCH_MIDDLE);
				_touch9Ids.push(TOUCH_RIGHT_MIDDLE);
				_touch9Ids.push(TOUCH_LEFT_BOTTOM);
				_touch9Ids.push(TOUCH_BOTTOM);
				_touch9Ids.push(TOUCH_RIGHT_BOTTOM);
				_touch9Keycodes = new Vector.<int>;
				_touch9Keycodes.push(_leftTopKeycode);
				_touch9Keycodes.push(_topKeycode);
				_touch9Keycodes.push(_rightTopKeycode);
				_touch9Keycodes.push(_leftMiddleKeycode);
				_touch9Keycodes.push(_middleKeycode);
				_touch9Keycodes.push(_rightMiddleKeycode);
				_touch9Keycodes.push(_leftBottomKeycode);
				_touch9Keycodes.push(_bottomKeycode);
				_touch9Keycodes.push(_rightBottomKeycode);
			}
			
			// <----- set property
			this.visible = false;
			
			// <----- add listener - Sprite
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			// <----- add child
			if(_lPad!=null) this.addChild(_lPad);
			if(_rPad!=null) this.addChild(_rPad);
		}
		
		// **************************************************** event - Sprite
		private function addedToStageHandler(event:Event):void{
			// <----- set input mode
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// <----- add listener - Stage
			this.stage.addEventListener(Event.RESIZE, resizeHandler);
			
			// <----- add listener - TouchEvent
			this.stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
			this.stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			this.stage.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
						
			// <----- add listener - KeyboardEvent
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			// <----- add listener for touch9Grid
			if(_touch9Grid){
				this.stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginTouch9GridHandler);
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownTouch9GridHandler);
			}
			
			// <----- set UI position
			resizeHandler(null);
			
			// <----- reset
			_lPad.reset();
			_rPad.reset();
			_touch9Value = 0;
		}
		private function removedFromStageHandler(event:Event):void{
			// <----- set input mode
			Multitouch.inputMode = MultitouchInputMode.NONE;
			
			// <----- add listener - Stage
			this.stage.removeEventListener(Event.RESIZE, resizeHandler);
			
			// <----- remove listener - TouchEvent
			this.stage.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
			this.stage.removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			this.stage.removeEventListener(TouchEvent.TOUCH_END, touchEndHandler);
			
			// <----- remove listener - KeyboardEvent
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			// <----- add listener for touch9Grid
			if(_touch9Grid){
				this.stage.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBeginTouch9GridHandler);
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownTouch9GridHandler);
			}
			
			// <----- reset
			_lPad.reset();
			_rPad.reset();
		}
		private function resizeHandler(event:Event):void{
			var w:int = this.stage.stageWidth;
			var h:int = this.stage.stageHeight;
			_lPad.x = _padding;
			_lPad.y = _lPad.valign==BasePad.VALIGN_BOTTOM?h - _padding:_padding;
			_rPad.x = w - _padding;
			_rPad.y = _rPad.valign==BasePad.VALIGN_BOTTOM?h - _padding:_padding;
			this.visible = true;
			
			// <----- touch 9 grid hit area
			if(_touch9Grid){
				var w3:Number = w/3;
				var w32:Number = w3*2;
				var h3:Number = h/3;
				var h32:Number = h3*2;
				_touch9Rects = new Vector.<Rectangle>;
				_touch9Rects.push(new Rectangle(0, 0, w3, h3));
				_touch9Rects.push(new Rectangle(w3, 0, w3, h3));
				_touch9Rects.push(new Rectangle(w32, 0, w3, h3));
				_touch9Rects.push(new Rectangle(0, h3, w3, h3));
				_touch9Rects.push(new Rectangle(w3, h3, w3, h3));
				_touch9Rects.push(new Rectangle(w32, h3, w3, h3));
				_touch9Rects.push(new Rectangle(0, h32, w3, h3));
				_touch9Rects.push(new Rectangle(w3, h32, w3, h3));
				_touch9Rects.push(new Rectangle(w32, h32, w3, h3));
			}
		}
		override public function toString():String{
			return "{leftPad:"+_lPad+", rightPad:"+_rPad+"}";
		}
		
		// **************************************************** event - TouchEvent
		private function touchBeginHandler(event:TouchEvent):void{
			_lPad.touchBegin(event.stageX, event.stageY, event.touchPointID);
			_rPad.touchBegin(event.stageX, event.stageY, event.touchPointID);
		}
		private function touchMoveHandler(event:TouchEvent):void{
			_lPad.touchMove(event.stageX, event.stageY, event.touchPointID);
			_rPad.touchMove(event.stageX, event.stageY, event.touchPointID);
		}
		private function touchEndHandler(event:TouchEvent):void{
			_lPad.touchEnd(event.stageX, event.stageY, event.touchPointID);
			_rPad.touchEnd(event.stageX, event.stageY, event.touchPointID);
		}
		private function touchBeginTouch9GridHandler(event:TouchEvent):void{
			// <----- find hit area, if touch9Grid is enabled
			_touch9Value = 0;
			_touch = new Point(event.stageX, event.stageY);
			for(var i:int=0; i<_touch9Rects.length; i++)
				if(_touch9Rects[i].containsPoint(_touch)){
					// <----- cache variable
					_touch9Value |= _touch9Ids[i];
					
					// <----- dispatch event
					this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_PRESS_9_GRID));
					
					// <----- break this method
					return;
				}
		}
		
		// **************************************************** event - KeyboardEvent
		private function keyDownHandler(event:KeyboardEvent):void{
			_lPad.keyDown(event.keyCode);
			_rPad.keyDown(event.keyCode);
		}
		private function keyUpHandler(event:KeyboardEvent):void{
			_lPad.keyUp(event.keyCode);
			_rPad.keyUp(event.keyCode);
		}
		private function keyDownTouch9GridHandler(event:KeyboardEvent):void{
			// <----- find hit area, if touch9Grid is enabled
			_touch9Value = 0;
			for(var i:int=0; i<_touch9Keycodes.length; i++)
				if(event.keyCode==_touch9Keycodes[i]){
					// <----- cache variable
					_touch9Value |= _touch9Ids[i];
					_touch = new Point(_touch9Rects[i].x+_touch9Rects[i].width/2, _touch9Rects[i].y+_touch9Rects[i].height/2);
					
					// <----- dispatch event
					this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_PRESS_9_GRID));
					
					// <----- break this method
					return;
				}
		}
		
		// **************************************************** setter
		public function set padding(value:int):void{
			_padding = value;
			resizeHandler(null);
		}
		
		// **************************************************** getter
		public function get padding():int{
			return _padding;
		}
		public function get leftPad():BasePad{
			return _lPad;
		}
		public function get rightPad():BasePad{
			return _rPad;
		}
		public function get touch9Value():int{
			return _touch9Value;
		}
		public function get touch():Point{
			return _touch;
		}
	}
}