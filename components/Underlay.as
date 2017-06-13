package components {
	
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;
	
	
	public class Underlay extends MovieClip {
		
		private var isOpen;
		
		public function Underlay() {
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
			visible = true;
			isOpen = true;
			var tweenY = new Tween(this, "alpha", Regular.easeOut, 0, 0.7, 1, true);
		}
		
		private function close()
		{
			isOpen = false;
			var tweenY = new Tween(this, "alpha", Regular.easeOut, 0.7, 0, 1, true);
			tweenY.addEventListener(TweenEvent.MOTION_FINISH, finishTween);
		}
		
		private function finishTween(e:TweenEvent)
		{
			visible = false;
		}
	}
}
