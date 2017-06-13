package components {
	
	import flash.display.MovieClip;
	import components.PhotoGrid;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	import fl.transitions.TweenEvent;
	import utility.TagManager;
	import utility.Glob;
	import components.AnswerPanel;
	
	public class QuestionPanel extends MovieClip {
		
		private var answerPanel:AnswerPanel;
		
		public function QuestionPanel()
		{
			answerPanel = new AnswerPanel();
			answerPanel.y = 600;
			addChild(answerPanel);
		}
		
		public function focus()
		{						
			var focusTween:Tween = new Tween(this, "alpha", Regular.easeOut, 0, 1, 0.4, true);
			focusTween.addEventListener(TweenEvent.MOTION_FINISH, completeFocusTween);
			answerPanel.reset();
			
			Glob.getInstance().stats.fadeOut();
			hideHelpButton();
		}
		
		public function unfocus()
		{
			var unfocusTween:Tween = new Tween(this, "alpha", Regular.easeOut, 1, 0, 0.4, true); 
		}
		
		public function completeFocusTween(e:TweenEvent)
		{
			trace('woof');
		}
		
		public function hideHelpButton()
		{
			var btnHelp = Glob.getInstance().btnHelp;
			//var focusTween:Tween = new Tween(btnHelp, "x", Regular.easeOut, btnHelp.x, btnHelp.x - (btnHelp.width + 20), 0.4, true);
		}
	
	}
	
}
