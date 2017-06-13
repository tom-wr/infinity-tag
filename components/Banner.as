package components {
	
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	
	
	public class Banner extends MovieClip {
		
		private var isOpen;
		
		public function Banner() {
			isOpen = true;
			x = 0;
			y = 10;
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
			var tweenY = new Tween(this, "x", Regular.easeOut, x, 0, 1, true);
		}
		
		private function close()
		{
			isOpen = false;
			var tweenY = new Tween(this, "x", Regular.easeOut, x, -width, 1, true);
		}
	}
}
