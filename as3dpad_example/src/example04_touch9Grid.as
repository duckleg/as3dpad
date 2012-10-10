package
{
	import duckleg.dpad.DPad;
	import duckleg.dpad.DPadEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF")]
	public class example04_touch9Grid extends Sprite
	{
		[Embed(source="../embed/icon_music.png")]
		private var MusicPNG:Class;
		[Embed(source="../embed/icon_pause.png")]
		private var PausePNG:Class;
		[Embed(source="../embed/icon_setting.png")]
		private var SettingPNG:Class;
		
		private var _dPad:DPad;
		private var _music:Bitmap;
		private var _pause:Bitmap;
		private var _setting:Bitmap;
		private var _textFormat:TextFormat;
		private var _message:TextField;
		
		// **************************************************** main
		public function example04_touch9Grid()
		{
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// <----- add image
			_music = new MusicPNG() as Bitmap;
			_pause = new PausePNG() as Bitmap;
			_setting = new SettingPNG() as Bitmap;
			this.addChild(_music);
			this.addChild(_pause);
			this.addChild(_setting);
			
			// <----- add debug message
			_textFormat = new TextFormat("Arial", 16, 0x000000, true, false, false, null, null, "center");
			_message = new TextField();
			_message.width = 300;
			_message.text = "Please touch the icon.";
			_message.setTextFormat(_textFormat);
			this.addChild(_message);
			
			// <----- create DPad and enable touch9Grid
			_dPad = new DPad(null, null, true);
			this.addChild(_dPad);
			
			// <----- add listener
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			// !----- for desktop development - please press "123456789" on keyboard
			_dPad.addEventListener(DPadEvent.TOUCH_PRESS_9_GRID, touchPress9GridHandler);
		}
		
		// **************************************************** event - Sprite
		private function addedToStageHandler(event:Event):void{
			this.stage.addEventListener(Event.RESIZE, resizeHandler);
			
			// <----- the first setup
			resizeHandler(null);
		}
		private function resizeHandler(event:Event):void{
			var w:int = this.stage.stageWidth;
			var h:int = this.stage.stageHeight;
			
			_music.x = 0;
			_pause.x = w/2 - _pause.width/2;
			_setting.x = w - _setting.width;
			
			_message.x = w/2 - _message.width/2;
			_message.y = h/2;
		}
		
		// **************************************************** event - DPad
		private function touchPress9GridHandler(event:DPadEvent):void{
			if(_dPad.touch9Value & DPad.TOUCH_LEFT_TOP)
				_message.text = "You press the Music icon.";
			else if(_dPad.touch9Value & DPad.TOUCH_TOP)
				_message.text = "You press the Pause icon.";
			else if(_dPad.touch9Value & DPad.TOUCH_RIGHT_TOP)
				_message.text = "You press the Setting icon.";
			else
				_message.text = "No icon is pressed. (x:"+int(_dPad.touch.x)+", y:"+int(_dPad.touch.y)+")";
			
			_message.setTextFormat(_textFormat);
		}
	}
}