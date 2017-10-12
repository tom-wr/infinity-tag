package components {
	
	import flash.display.MovieClip;
	import utility.TagManager;
	import utility.Glob;
	import flash.text.ReturnKeyLabel;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	import fl.transitions.easing.Strong;
	import fl.transitions.TweenEvent;
	import flash.geom.Point;
	import components.BtnChoice;
	import flash.utils.setTimeout;
	
	public class AnswerPanel extends MovieClip {
		
		var startQuestionId:Number = 1;
		var currentQuestionId:Number
		var nextQuestionId:Number = 1;
		var question = {};
		var answerButtons:Array = [];
		var answerPanelWidth:Number = 1080;
		var questionText:TextField;
		
		public function AnswerPanel() {
			initListeners();
		}
		
		public function reset()
		{
			TagManager.getInstance().clearTags();
			question = TagManager.getInstance().getQuestion();
			initQuestionFrame();
			initAnswerButtons();
			initText();
		}
		
		private function initListeners() {
			btn_next_question.addEventListener(MouseEvent.CLICK, pulse)
		}
		
		private function initText()
		{
			questionText.text = question.question;
		}
		
		private function initAnswerButtons()
		{
			for each(var button in answerButtons)
			{
				removeChild(button);
			}
			answerButtons = new Array();
			createButtons();
			positionButtons();
		}
		
		private function initQuestionFrame()
		{
			if(question.kind == 1)
			{
				showMulti();
				answerPanelWidth = 1080;
				questionText = txt_question;
				
			} else {
				hideMulti();
				answerPanelWidth = 1280;
				questionText = txt_question_binary;
			}
		}
		
		private function hideMulti()
		{
			txt_question.visible = false;
			txt_question_binary.visible = true;
			txt_hint.visible = false;
			mc_done_panel.visible = false;
			btn_next_question.visible = false;
		}
		
		private function showMulti()
		{
			txt_question.visible = true;
			txt_question_binary.visible = false;
			txt_hint.visible = true;
			mc_done_panel.visible = true;
			btn_next_question.visible = true;
		}
		
		private function createButtons()
		{
			for(var choice in question.answers)
			{
				var newBtn = new BtnChoice();
				newBtn.ref = choice;
				newBtn.btn_text.text = question.answers[choice].title;
				answerButtons.push(newBtn);
			}
		}
		
		private function positionButtons()
		{
			var division:Number = answerPanelWidth / (answerButtons.length + 1);
			for(var i = 0; i < answerButtons.length; i++)
			{
				var button:MovieClip = answerButtons[i];
				button.y = 130;
				button.x = division * (i + 1);
				addChild(button);
				button.addEventListener(MouseEvent.CLICK, btnClick(button.ref));
			}
		}
		
		private function btnClick(id:String):Function
		{
			return function(e:MouseEvent):void
			{
				TagManager.getInstance().addQuestions(question.answers[id].next);
				var tagName:String = question.answers[id].tag;
				var tagPoint = localToGlobal(new Point(e.currentTarget.x, e.currentTarget.y));
				hideButton(id);

				if(tagName)
				{
					createNewTag(tagPoint.x, tagPoint.y, tagName);
				} 
				if(question.kind == 2)
				{
					pulse();
				}
			}
		}
		
		private function hideButtons()
		{
			for each(var button in answerButtons)
			{
				button.visible = false;
			}
		}
		
		private function hideButton(id:String)
		{
			for each(var button in answerButtons)
			{
				if(button.ref == id)
				{
					button.visible = false;
				}
			}
		}
		
		private function showButtons()
		{
			for each(var button in answerButtons)
			{
				button.visible = true;
			}
		}
		
		private function createNewTag(tagX:Number, tagY:Number, tagName:String)
		{
			Glob.getInstance().btnBack.visible = false;
			var tag =  new Tag(tagX, tagY, tagName);
			TagManager.getInstance().addTag(tag);
			var tagCount:Number = TagManager.getInstance().tagCount();		
			var tagTweenX:Tween = new Tween(tag, "x", Strong.easeOut, tag.x, stage.stageWidth - 90, 1, true);
			var tagTweenY:Tween = new Tween(tag, "y", Strong.easeOut, tag.y, (40 * (tagCount-1))+20, 1, true);
			tagTweenY.addEventListener(TweenEvent.MOTION_FINISH, finishTagTween);
		}
		
		private function finishTagTween(e:TweenEvent)
		{
			//pulse();
		}
		
		private function pulse(e:MouseEvent = null)
		{
			var panelFadeOut:Tween = new Tween(this, "alpha", Regular.easeOut, 1, 0, 0.32, true);
			panelFadeOut.addEventListener(TweenEvent.MOTION_FINISH, fadeIn);
		}
		
		private function fadeIn(e:TweenEvent)
		{			
			advanceQuestion();
			var panelFadeIn:Tween = new Tween(this, "alpha", Regular.easeOut, 0, 1, 0.32, true);
			//panelFadeIn.addEventListener(TweenEvent.MOTION_FINISH, finishTweenAndAdvance);
		}
		
		private function advanceQuestion()
		{
			if(loadQuestion())
			{
				initQuestionFrame();
				initAnswerButtons();
				initText();
				
			} else {
				submit();
			}
		}
		
		private function submit()
		{
			PhotoGrid.getInstance().unfocus();
			TagManager.getInstance().consolidateTags();
			setTimeout(Glob.getInstance().stats.updateStats, 800);
		}
		
		private function loadQuestion():Object
		{
			question = TagManager.getInstance().getQuestion();
			return question;
		}
		
	}
}
