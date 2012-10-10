package duckleg.dpad
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TouchEvent;

	public class GroupPad extends BasePad
	{
		private static const DEFAULT_PADDING:int = 40;
		
		// <----- const value
		public static const A_BUTTON:int = 2;
		public static const B_BUTTON:int = 4;
		public static const C_BUTTON:int = 16;
		public static const D_BUTTON:int = 32;
		
		private var _buttons:Vector.<GroupButton>;
		private var _value:int;
		
		// <----- keycode mapping
		private var _aKeycode:int = 77;
		private var _bKeycode:int = 188;
		private var _cKeycode:int = 190;
		private var _dKeycode:int = 191;
		
		// **************************************************** main
		public function GroupPad(valign:String="bottom", buttons:Vector.<GroupButton>=null, defaultPosition:Boolean=true){
			super(valign);
			
			// <----- adjust arguments
			if(buttons==null || buttons.length==0){
				buttons = new Vector.<GroupButton>;
				buttons.push(new GroupButton(A_BUTTON));
				buttons.push(new GroupButton(B_BUTTON));
			}
			
			// <----- cache variable
			_buttons = buttons;
			
			// <----- set default position
			if(defaultPosition){
				switch(_buttons.length){
					case 1:
						_buttons[0].x = -_buttons[0].width/2;
						_buttons[0].y = -_buttons[0].height/2;
						break;
					case 2:
						_buttons[0].x = -_buttons[0].width - DEFAULT_PADDING;
						_buttons[0].y = 0;
						_buttons[1].x = 0;
						_buttons[1].y = -_buttons[1].height;
						break;
					case 3:
						_buttons[0].x = -_buttons[0].width - DEFAULT_PADDING;
						_buttons[0].y = 0;
						_buttons[1].x = DEFAULT_PADDING;
						_buttons[1].y = 0;
						_buttons[2].x = -_buttons[2].width/2;
						_buttons[2].y = -_buttons[2].height - DEFAULT_PADDING;
						break;
					case 4:
						_buttons[0].x = -_buttons[0].width - DEFAULT_PADDING;
						_buttons[0].y = -_buttons[0].height/2;
						_buttons[1].x = DEFAULT_PADDING;
						_buttons[1].y = -_buttons[1].height/2;
						_buttons[2].x = -_buttons[2].width/2;
						_buttons[2].y = -_buttons[2].height - _buttons[0].height/2;
						_buttons[3].x = -_buttons[3].width/2;
						_buttons[3].y = _buttons[0].height/2;
						break;
				}
			}
			
			// <----- add child
			for(var i:int=0; i<_buttons.length; i++)
				this.addChild(_buttons[i]);
		}
		
		// **************************************************** override public method
		override public function reset():void{
			for(var i:int=0; i<_buttons.length; i++)
				_buttons[i].touchPointID = -1;
			_value = 0;
		}
		override public function touchBegin(stageX:Number, stageY:Number, touchPointID:int):void{
			for(var i:int=0; i<_buttons.length; i++)
				if(_buttons[i].hitTestPoint(stageX, stageY)){
					// <----- cache variable
					_buttons[i].touchPointID = touchPointID;
					_value |= _buttons[i].id;
					
					// <----- dispatch event
					switch(_buttons[i].id){
						case A_BUTTON:
							this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_PRESS_A));
							break;
						case B_BUTTON:
							this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_PRESS_B));
							break;
						case C_BUTTON:
							this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_PRESS_C));
							break;
						case D_BUTTON:
							this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_PRESS_D));
							break;
					}
					
					// <----- break this looping
					return;
				}
		}
		override public function touchEnd(stageX:Number, stageY:Number, touchPointID:int):void{
			for(var i:int=0; i<_buttons.length; i++)
				if(_buttons[i].touchPointID==touchPointID){
					// <----- reset variable
					_buttons[i].touchPointID = -1;
					_value &= ~_buttons[i].id;
					
					// <----- dispatch event
					switch(_buttons[i].id){
						case A_BUTTON:
							this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_RELEASE_A));
							break;
						case B_BUTTON:
							this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_RELEASE_B));
							break;
						case C_BUTTON:
							this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_RELEASE_C));
							break;
						case D_BUTTON:
							this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_RELEASE_D));
							break;
					}
					
					// <----- break this looping
					return;
				}
		}
		override public function keyDown(keyCode:uint):void{
			var button:GroupButton;
			switch(keyCode){
				case _aKeycode:
					if(!(_value&A_BUTTON)){
						// <----- set variable
						button = findGroupButton(A_BUTTON);
						_value |= A_BUTTON;
						
						// <----- change UI
						if(button!=null)
							button.touchPointID = 999;
						
						// <----- dispatch event
						this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_PRESS_A));
					}
					break;
				case _bKeycode:
					if(!(_value&B_BUTTON)){
						// <----- set variable
						button = findGroupButton(B_BUTTON);
						_value |= B_BUTTON;
						
						// <----- change UI
						if(button!=null)
							button.touchPointID = 999;
						
						// <----- dispatch event
						this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_PRESS_B));
					}
					break;
				case _cKeycode:
					if(!(_value&C_BUTTON)){
						// <----- set variable
						button = findGroupButton(C_BUTTON);
						_value |= C_BUTTON;
						
						// <----- change UI
						if(button!=null)
							button.touchPointID = 999;
						
						// <----- dispatch event
						this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_PRESS_C));
					}
					break;
				case _dKeycode:
					if(!(_value&D_BUTTON)){
						// <----- set variable
						button = findGroupButton(D_BUTTON);
						_value |= D_BUTTON;
						
						// <----- change UI
						if(button!=null)
							button.touchPointID = 999;
						
						// <----- dispatch event
						this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_PRESS_D));
					}
					break;
			}
		}
		override public function keyUp(keyCode:uint):void{
			var button:GroupButton;
			switch(keyCode){
				case _aKeycode:
					if(_value&A_BUTTON){
						// <----- set variable
						button = findGroupButton(A_BUTTON);
						_value &= ~A_BUTTON;
						
						// <----- change UI
						if(button!=null)
							button.touchPointID = -1;
						
						// <----- dispatch event
						this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_RELEASE_A));
					}
					break;
				case _bKeycode:
					if(_value&B_BUTTON){
						// <----- set variable
						button = findGroupButton(B_BUTTON);
						_value &= ~B_BUTTON;
						
						// <----- change UI
						if(button!=null)
							button.touchPointID = -1;
						
						// <----- dispatch event
						this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_RELEASE_B));
					}
					break;
				case _cKeycode:
					if(_value&C_BUTTON){
						// <----- set variable
						button = findGroupButton(C_BUTTON);
						_value &= ~C_BUTTON;
						
						// <----- change UI
						if(button!=null)
							button.touchPointID = -1;
						
						// <----- dispatch event
						this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_RELEASE_C));
					}
					break;
				case _dKeycode:
					if(_value&D_BUTTON){
						// <----- set variable
						button = findGroupButton(D_BUTTON);
						_value &= ~D_BUTTON;
						
						// <----- change UI
						if(button!=null)
							button.touchPointID = -1;
						
						// <----- dispatch event
						this.dispatchEvent(new DPadEvent(DPadEvent.TOUCH_RELEASE_D));
					}
					break;
			}
		}
		override public function toString():String{
			return "{value:"+_value+", buttons:["+_buttons+"]}";
		}
		
		// **************************************************** setter
		public function set aKeycode(value:int):void{
			_aKeycode = value;
		}
		public function set bKeycode(value:int):void{
			_bKeycode = value;
		}
		public function set cKeycode(value:int):void{
			_cKeycode = value;
		}
		public function set dKeycode(value:int):void{
			_dKeycode = value;
		}
		
		// **************************************************** getter
		public function get buttons():Vector.<GroupButton>{
			return _buttons;
		}
		
		// **************************************************** overrite getter
		override public function get value():int{
			return _value;
		}
		
		// **************************************************** private method
		private function findGroupButton(id:int):GroupButton{
			for(var i:int=0; i<_buttons.length; i++)
				if(_buttons[i].id==id)
					return _buttons[i];
			return null;
		}
	}
}