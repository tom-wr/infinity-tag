package components {
	
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	
	public class HelpDialog extends MovieClip {
		
		private var isOpen:Boolean;
		
		public function HelpDialog() {		
			y = 465;
			x = 640;
			isOpen = true;
		}
		
		public function toggleShow()
		{
			if(isOpen)
			{
				close();
			} else {
				open();
			}
		}
		
		private function open()
		{
			isOpen = true;
			gotoAndStop(1);
			var tweenY = new Tween(this, "x", Regular.easeOut, -width, 640, 1, true);
		}
		
		private function close()
		{
			isOpen = false;
			var tweenY = new Tween(this, "x", Regular.easeOut, x, -width, 1, true);
		}
	}
	
}
