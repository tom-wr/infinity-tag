package components {
	
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	import fl.transitions.easing.Bounce;
	import flash.globalization.NumberFormatter;
	import fl.transitions.TweenEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import flash.text.TextFormat;
	
	
	public class StatsPanel extends MovieClip {
		
		private var isOpen;
		
		private var completed = 1467;
		private var today = 87;
		private var tags = 5673;
		
		private var hopAmount = 10;
		private var yAnchor:Number;
		
		public function StatsPanel() {
			x = 1280 + 142;
			y = 720;
			isOpen = false;
			yAnchor = txt_stats_tags.y;
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
			var tweenY = new Tween(this, "x", Regular.easeOut, x, 1280 + 142, 1, true);
		}
		
		public function fadeOut()
		{
			var tweenY = new Tween(this, "alpha", Regular.easeOut, 1, 0, 0.4, true);
			var tween = new Tween(this, "y", Regular.easeOut, y, y + height, 0.4, true);
		}
		
		public function fadeIn()
		{
			var tweenY = new Tween(this, "alpha", Regular.easeIn, 0, 1, 0.4, true);
			var tween = new Tween(this, "y", Regular.easeIn, y, y - height, 0.4, true);
		}
		
		public function updateStats()
		{
			completed++;
			today++
			renderStats();
		}
		
		private function renderStats()
		{
			var ns:NumberFormatter = new NumberFormatter("en-US");
			ns.fractionalDigits = 0; 
			txt_stats_completed.text = ns.formatNumber(completed);
			animateText(txt_stats_completed);
			txt_stats_today.text = ns.formatNumber(today);
			animateText(txt_stats_today);				
		}
		
		public function updateTagStats()
		{
			tags += 1;
			renderTagStats();
		}
		
		private function renderTagStats()
		{
			var ns:NumberFormatter = new NumberFormatter("en-US");
			ns.fractionalDigits = 0; 
			txt_stats_tags.text = ns.formatNumber(tags);
			animateText(txt_stats_tags);
		}
		
		private function animateText(txt:TextField){
			setTextColour(txt, 0xFFCC00, 38);
			var tween = new Tween(txt, "y", Regular.easeOut, yAnchor, yAnchor - hopAmount, 0.1, true);
			tween.addEventListener(TweenEvent.MOTION_FINISH, downHop(txt));
		}
		
		private function downHop(txt:TextField):Function
		{
			return function(e:TweenEvent)
			{
				var tween = new Tween(txt, "y", Regular.easeIn, yAnchor - hopAmount, yAnchor, 0.2, true);
				tween.addEventListener(TweenEvent.MOTION_FINISH, endHop(txt));
			}
		}
		
		private function setTextColour(txt:TextField, colour:Number, size:Number)
		{
			var tf:TextFormat = txt.getTextFormat();
			tf.color = colour;
			tf.size = size;
			txt.setTextFormat(tf);
		}
		
		private function endHop(txt:TextField):Function
		{
			return function(e:TweenEvent)
			{
				setTextColour(txt, 0x339999, 32);
			}
		}
	}
}
