package
{
	import duckleg.dpad.AxisPad;
	import duckleg.dpad.DPad;
	import duckleg.dpad.DPadEvent;
	import duckleg.dpad.GroupPad;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import net.hires.debug.Stats;

	[SWF(frameRate="60", backgroundColor="#FFFFFF")]
	public class example01_basic extends Sprite
	{
		[Embed(source="../embed/penguin.png")]
		private var PenguinPNG:Class;
		
		private var _dPad:DPad;
		private var _penguin:Sprite;
		
		// **************************************************** main
		public function example01_basic()
		{
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// <----- add image
			var bitmap:Bitmap = new PenguinPNG() as Bitmap;
			bitmap.x = -bitmap.width/2;
			bitmap.y = -bitmap.height/2;
			bitmap.smoothing = true;
			_penguin = new Sprite();
			_penguin.x = 200;
			_penguin.y = 100;
			_penguin.addChild(bitmap);
			this.addChild(_penguin);
			
			// <----- use default DPad
			_dPad = new DPad();
			this.addChild(_dPad);
			
			// <----- add listener
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			// !----- for desktop development - please press "WASD" on keyboard
			_dPad.leftPad.addEventListener(DPadEvent.TOUCH_PRESS, touchPressHandler);
			_dPad.leftPad.addEventListener(DPadEvent.TOUCH_RELEASE, touchReleaseHandler);
			
			// !----- for desktop development - please press "m,./" on keyboard
			_dPad.rightPad.addEventListener(DPadEvent.TOUCH_PRESS_A, touchPressAHandler);
			_dPad.rightPad.addEventListener(DPadEvent.TOUCH_PRESS_B, touchPressBHandler);
			_dPad.rightPad.addEventListener(DPadEvent.TOUCH_RELEASE_A, touchReleaseAHandler);
			_dPad.rightPad.addEventListener(DPadEvent.TOUCH_RELEASE_B, touchReleaseBHandler);
			
			// <----- create monitor
			this.stage.addChild(new Stats());
		}
		
		// **************************************************** event - Sprite
		private function enterFrameHandler(event:Event):void{
			var v1:int = _dPad.leftPad.value; // <----- values of X and Y-axes
			var v2:int = _dPad.rightPad.value; // <----- values of A and B buttons
			
			if(v1 & AxisPad.LEFT)
				_penguin.x -= 10;
			if(v1 & AxisPad.RIGHT)
				_penguin.x += 10;
			if(v1 & AxisPad.UP)
				_penguin.y -= 10;
			if(v1 & AxisPad.DOWN)
				_penguin.y += 10;
			
			if(v2 & GroupPad.A_BUTTON)
				_penguin.rotation -= 5;
			if(v2 & GroupPad.B_BUTTON)
				_penguin.rotation += 5;
		}
		
		// **************************************************** event - AxisPad
		private function touchPressHandler(event:DPadEvent):void{
			trace("press AxisPad: " + event.target);
		}
		private function touchReleaseHandler(event:DPadEvent):void{
			trace("release AxisPad: " + event.target);
		}
		
		// **************************************************** event - GroupPad
		private function touchPressAHandler(event:DPadEvent):void{
			trace("press A: " + event.target);
		}
		private function touchPressBHandler(event:DPadEvent):void{
			trace("press B: " + event.target);
		}
		private function touchReleaseAHandler(event:DPadEvent):void{
			trace("release A: " + event.target);
		}
		private function touchReleaseBHandler(event:DPadEvent):void{
			trace("release B: " + event.target);
		}
	}
}