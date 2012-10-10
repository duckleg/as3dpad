package duckleg.starling
{	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import duckleg.dpad.AxisPad;
	import duckleg.dpad.DPad;
	import duckleg.dpad.GroupPad;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class MyPenguin extends Sprite
	{	
		[Embed(source="../embed/landscape.jpg")]
		private var LandscapeJPG:Class;
		[Embed(source="../embed/grass.png")]
		private var GrassPNG:Class;
		
		[Embed(source="../embed/penguin_moving.xml", mimeType="application/octet-stream")]
		private var MovingXML:Class;
		[Embed(source="../embed/penguin_moving.png")]
		private var MovingTexture:Class;
		
		[Embed(source="../embed/penguin_waving.xml", mimeType="application/octet-stream")]
		private var WavingXML:Class;
		[Embed(source="../embed/penguin_waving.png")]
		private var WavingTexture:Class;
		
		[Embed(source="../embed/bullet.png")]
		private var BulletPNG:Class;

		private var _landscape:Image;
		private var _landY:int;
		private var _penguin:Sprite;
		private var _grass:Image;
		private var _moving:MovieClip;
		private var _waving:MovieClip;
		
		private var _dPad:DPad;
		private var _leftPad:AxisPad;
		private var _rightPad:GroupPad;
		
		private var _bullets:Sprite;
		private var _bulletDistance:int = 0;
		
		// **************************************************** main
		public function MyPenguin()
		{	
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			// <----- create DPad
			_dPad = new DPad();
			_leftPad = _dPad.leftPad as AxisPad;
			_rightPad = _dPad.rightPad as GroupPad;
			Starling.current.nativeStage.addChild(_dPad);
			
			// <----- create monitor
			Starling.current.nativeStage.addChild(new Stats());
		}
		
		// **************************************************** event - Sprite
		private function addedToStageHandler(event:Event):void
		{
			var w:int = this.stage.stageWidth;
			var h:int = this.stage.stageHeight;
			
			// <----- cache variable
			_bulletDistance = w/2;
			
			// <----- add landscape
			_landscape = Image.fromBitmap(new LandscapeJPG());
			_landscape.scaleX = _landscape.scaleY = h/_landscape.height;
			this.addChild(_landscape);
			
			// <----- add bullet container
			_bullets = new Sprite();
			this.addChild(_bullets);
			
			// <----- add penguin
			_penguin = new Sprite();
			this.addChild(_penguin);
			
			// <----- add grass
			_grass = Image.fromBitmap(new GrassPNG());
			_grass.scaleX = _grass.scaleY = _landscape.scaleX;
			this.addChild(_grass);
			
			// <----- create texture
			var movingTexture:Texture = Texture.fromBitmap(new MovingTexture());
			var movingXml:XML = XML(new MovingXML());
			var movingAtlas:TextureAtlas = new TextureAtlas(movingTexture, movingXml);
			var wavingTexture:Texture = Texture.fromBitmap(new WavingTexture());
			var wavingXml:XML = XML(new WavingXML());
			var wavingAtlas:TextureAtlas = new TextureAtlas(wavingTexture, wavingXml);
			
			// <----- create MovieClip
			_moving = new MovieClip(movingAtlas.getTextures("Penguin Moving"), 30);
			_waving = new MovieClip(wavingAtlas.getTextures("Penguin Waving"), 30);
			_penguin.addChild(_moving);
			_penguin.addChild(_waving);
			
			// <----- activate MovieClip
			Starling.juggler.add(_moving);
			Starling.juggler.add(_waving);
			
			// <----- set properties
			_moving.x = _waving.x = -_moving.width/2;
			_moving.y = _waving.y = -_moving.height;
			_penguin.x = w/2;
			_penguin.y = _landY = int(h/9*8);
			_moving.visible = true;
			_waving.visible = false;
			_moving.stop();
			_waving.stop();
			
			// <----- add listener
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		private function enterFrameHandler(event:Event):void{
			var v1:int = _leftPad.value;
			var v2:int = _rightPad.value;
			
			if(v1 & AxisPad.LEFT)
				_penguin.x -= 2;
			if(v1 & AxisPad.RIGHT)
				_penguin.x += 2;
			if((v1 & AxisPad.UP) && _penguin.y==_landY)
				TweenLite.to(_penguin, 0.2, {y:_landY-50, onComplete:jumpCompleteHandler, ease:Quad.easeOut});
			if(v1>0)
				playMoving();
			
			if(v2 & GroupPad.A_BUTTON)
				playWaving();
			if(v2 & GroupPad.B_BUTTON && _bullets.numChildren==0){
				// <----- create a bullet
				var bullet:Image = Image.fromBitmap(new BulletPNG());
				var targetX:Number = _penguin.x + _bulletDistance;
				bullet.x = _penguin.x;
				bullet.y = _penguin.y - 80;
				_bullets.addChild(bullet);
				
				// <----- animate the bullet
				TweenLite.to(bullet, 1, {x:targetX, onComplete:bulletCompleteHandler, onCompleteParams:[bullet], ease:Linear.easeNone});
			}
			
			if(v1+v2==0)
				stopMotion();
		}
		
		// **************************************************** private method
		private function playMoving():void{
			_moving.visible = true;
			_waving.visible = false;
			_moving.play();
			_waving.stop();
		}
		private function playWaving():void{
			_moving.visible = false;
			_waving.visible = true;
			_moving.stop();
			_waving.play();
		}
		private function stopMotion():void{
			_moving.visible = true;
			_waving.visible = false;
			_moving.stop();
			_waving.stop();
		}
		
		// **************************************************** event - TweenLite
		private function jumpCompleteHandler():void{
			TweenLite.to(_penguin, 0.2, {y:_landY, ease:Quad.easeIn});
		}
		private function bulletCompleteHandler(bullet:Image):void{
			_bullets.removeChild(bullet);
		}
	}
}