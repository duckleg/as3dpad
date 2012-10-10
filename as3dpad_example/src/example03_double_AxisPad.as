package
{
	import com.greensock.TweenLite;
	
	import duckleg.dpad.AxisPad;
	import duckleg.dpad.BasePad;
	import duckleg.dpad.DPad;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import net.hires.debug.Stats;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF")]
	public class example03_double_AxisPad extends Sprite
	{
		[Embed(source="../embed/aeroplane.png")]
		private var AeroplanePNG:Class;
		
		[Embed(source="../embed/bullet.png")]
		private var BulletPNG:Class;
		
		private var _leftPad:AxisPad;
		private var _rightPad:AxisPad;
		private var _dPad:DPad;
		private var _bullets:Sprite;
		private var _aeroplane:Sprite;
		private var _bulletDistance:int = 0;
		
		// **************************************************** main
		public function example03_double_AxisPad()
		{
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// <----- add listener
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		// **************************************************** event - Sprite
		private function enterFrameHandler(event:Event):void{
			// <----- if the left pad is pressed, change rotation of the aeroplane
			if(_leftPad.value>0)
				TweenLite.to(_aeroplane, 0.5, {rotation:_leftPad.radians/Math.PI*180});
			
			// <----- if the right pad is pressed, create a bullet
			if(_rightPad.value>0){
				var bullet:Bitmap = new BulletPNG() as Bitmap;
				var targetX:Number = BasePad.getPolarX(_aeroplane.x, _rightPad.radians, _bulletDistance);
				var targetY:Number = BasePad.getPolarY(_aeroplane.y, _rightPad.radians, _bulletDistance);
				bullet.x = _aeroplane.x;
				bullet.y = _aeroplane.y;
				_bullets.addChild(bullet);
				
				// <----- animate the bullet
				TweenLite.to(bullet, 2, {x:targetX, y:targetY, onComplete:bulletCompleteHandler, onCompleteParams:[bullet]});
			}
		}
		private function addedToStageHandler(event:Event):void{
			// <----- add bullet container
			_bullets = new Sprite();
			this.addChild(_bullets);
			
			// <----- add image
			var bitmap:Bitmap = new AeroplanePNG() as Bitmap;
			bitmap.x = -bitmap.width/2;
			bitmap.y = -bitmap.height/2;
			bitmap.smoothing = true;
			_aeroplane = new Sprite();
			_aeroplane.addChild(bitmap);
			this.addChild(_aeroplane);
			
			// <----- create double AxisPad
			_leftPad = new AxisPad();
			_rightPad = new AxisPad();
			
			// <----- create DPad
			_dPad = new DPad(_leftPad, _rightPad);
			this.addChild(_dPad);
			
			// <----- add listener
			this.stage.addEventListener(Event.RESIZE, resizeHandler);
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			// <----- key mapping for the second AxisPad (just for desktop testing)
			_rightPad.leftKeycode = 37; // LeftArrow keycode
			_rightPad.rightKeycode = 39; // RightArrow keycode
			_rightPad.upKeycode = 38; // UpArrow keycode
			_rightPad.downKeycode = 40; // DownArrow keycode
			
			// <----- create monitor
			this.stage.addChild(new Stats());
			
			// <----- the first setup
			resizeHandler(null);
		}
		private function resizeHandler(event:Event):void{
			_aeroplane.x = this.stage.stageWidth/2;
			_aeroplane.y = this.stage.stageHeight/2;
			_bulletDistance = this.stage.stageWidth + this.stage.stageHeight;
		}
		
		// **************************************************** event - TweenLite
		private function bulletCompleteHandler(bullet:Bitmap):void{
			_bullets.removeChild(bullet);
		}
	}
}