package
{
	import duckleg.starling.MyPenguin;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import starling.core.Starling;

	[SWF(frameRate="60", backgroundColor="#FFFFFF")]
	public class example05_starling extends Sprite
	{
		// **************************************************** main
		public function example05_starling()
		{
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// <----- add listener
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		// **************************************************** event - Sprite
		private function addedToStageHandler(event:Event):void{
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		private function enterFrameHandler(event:Event):void{
			// <----- remove listener
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			// <----- craete Starling
			var mStarling:Starling = new Starling(MyPenguin, this.stage);
			mStarling.start();
		}
	}
}