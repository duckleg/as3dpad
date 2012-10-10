package duckleg.dpad
{
	import flash.events.Event;

	public class DPadEvent extends Event
	{
		public static const TOUCH_PRESS:String = "touch_press";
		public static const TOUCH_RELEASE:String = "touch_release";
		
		public static const TOUCH_PRESS_A:String = "touch_press_a";
		public static const TOUCH_RELEASE_A:String = "touch_release_a";
		public static const TOUCH_PRESS_B:String = "touch_press_b";
		public static const TOUCH_RELEASE_B:String = "touch_release_b";
		public static const TOUCH_PRESS_C:String = "touch_press_c";
		public static const TOUCH_RELEASE_C:String = "touch_release_c";
		public static const TOUCH_PRESS_D:String = "touch_press_d";
		public static const TOUCH_RELEASE_D:String = "touch_release_d";
		
		public static const TOUCH_PRESS_9_GRID:String = "touch_press_9_grid";
		
		public function DPadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean = false){
			super(type, bubbles, cancelable);
		}
	}
}