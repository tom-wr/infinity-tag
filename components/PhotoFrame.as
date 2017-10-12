package components {
	
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import utility.EventManager;
	import utility.TagManager;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import components.QuestionPanel;

	import utility.Glob;
	import fl.transitions.TweenEvent;
	

	public class PhotoFrame extends MovieClip {
		
		private var FOCUS_HEIGHT:int = 600;
		private var PHOTO_THUMB_WIDTH:int = 350;
		private var PHOTO_THUMB_HEIGHT:int = 300;
		
		private var anchorX = null;
		private var anchorY = null;
		
		private var originalHeight = 0;
		private var originalWidth = 0;
		
		public var rowRail = 0;
		public var columnRail = 0;
		
		public var focused = false;
		public var completed = false;
		
		public function PhotoFrame(x:int = 0, y:int = 0) {
			this.x = x;
			this.y = y;
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function load_photo(frame:Number)
		{
			this.mc_photo_album.gotoAndStop(frame);
			this.originalHeight = mc_photo_album.height;
			this.originalWidth = mc_photo_album.width;
			resizePhotoAlbum();
		}
		
		public function resizePhotoAlbum()
		{
			var scaleValue:Number = 0;
			if(this.mc_photo_album.height > this.mc_photo_album.width)
			{
				scaleValue = PHOTO_THUMB_WIDTH/this.mc_photo_album.width + 0.1;				
			}
			else
			{
				scaleValue = PHOTO_THUMB_HEIGHT/this.mc_photo_album.height + 0.1;				
			}
			this.mc_photo_album.width = this.mc_photo_album.width * scaleValue;
			this.mc_photo_album.height = this.mc_photo_album.height * scaleValue;
		}
		
		private function onClick(e:MouseEvent)
		{
			if(EventManager.getInstance().clickable)
			{
				if(!focused && !completed)
				{					
					focus();
					Glob.getInstance().btnBack.visible = true;
				}
			}
			EventManager.getInstance().clickable = true;

		}
		
		private function focus()
		{
			anchorX = x;
			anchorY = y;
			this.focused = true;
			EventManager.getInstance().scrollable = false;
			
			parent.setChildIndex(PhotoGrid.getInstance().questionPanel, parent.numChildren - 1);
			PhotoGrid.getInstance().questionPanel.focus();
			parent.setChildIndex(this, parent.numChildren - 1);
			
			focusTween();
			
		}
		
		private function focusTween()
		{
			var focusTweenX:Tween = new Tween(this, "x", Regular.easeOut, x, stage.stageWidth/2, 0.4, true);
			var focusTweenY:Tween = new Tween(this, "y", Regular.easeOut, y, 300, 0.4, true);
			
			var scaleValue = FOCUS_HEIGHT / this.mc_photo_album.height;
			
			var focusTweenW:Tween = new Tween(this.mc_photo_album, "width", Regular.easeOut, this.mc_photo_album.width, this.mc_photo_album.width * scaleValue, 0.4, true);
			var focusTweenH:Tween = new Tween(this.mc_photo_album, "height", Regular.easeOut, this.mc_photo_album.height, this.mc_photo_album.height * scaleValue, 0.4, true);
			
			var focusMaskTweenW:Tween = new Tween(this.mc_photo_mask, "width", Regular.easeOut, this.mc_photo_mask.width, this.mc_photo_album.width * scaleValue, 0.4, true);
			var focusMaskTweenH:Tween = new Tween(this.mc_photo_mask, "height", Regular.easeOut, this.mc_photo_mask.height, this.mc_photo_album.height * scaleValue, 0.4, true);
		}
		
		public function unfocus():Tween
		{
			this.focused = false;
			parent.setChildIndex(PhotoGrid.getInstance().questionPanel, 0);
			return unfocusTween();
		}
		
		private function unfocusTween():Tween
		{
			var focusTweenX:Tween = new Tween(this, "x", Regular.easeOut, x, anchorX, 0.32, true);
			var focusTweenY:Tween = new Tween(this, "y", Regular.easeOut, y, anchorY, 0.32, true);
			
			var scaleValue:Number = generateThumbnailScaleValue();
			
			var focusTweenW:Tween = new Tween(this.mc_photo_album, "width", Regular.easeOut, this.mc_photo_album.width, this.mc_photo_album.width * scaleValue, 0.32, true);
			var focusTweenH:Tween = new Tween(this.mc_photo_album, "height", Regular.easeOut, this.mc_photo_album.height, this.mc_photo_album.height * scaleValue, 0.32, true);
			
			var focusMaskTweenW:Tween = new Tween(this.mc_photo_mask, "width", Regular.easeOut, this.mc_photo_mask.width, PHOTO_THUMB_WIDTH + 1, 0.32, true);
			var focusMaskTweenH:Tween = new Tween(this.mc_photo_mask, "height", Regular.easeOut, this.mc_photo_mask.height, PHOTO_THUMB_HEIGHT + 1, 0.32, true);
			focusMaskTweenH.addEventListener(TweenEvent.MOTION_FINISH, completeUnfocusTween);
			return focusMaskTweenH;
		}
		
		private function generateThumbnailScaleValue()
		{
			var scaleValue:Number = 0;
			if(this.mc_photo_album.height > this.mc_photo_album.width)
			{
				scaleValue = PHOTO_THUMB_WIDTH/this.mc_photo_album.width + 0.1;				
			}
			else
			{
				scaleValue = PHOTO_THUMB_HEIGHT/this.mc_photo_album.height + 0.1;				
			}
			return scaleValue;
		}
		
		private function completeUnfocusTween(e:TweenEvent)
		{
			EventManager.getInstance().scrollable = true;
			var tagsSubmitted:Number = TagManager.getInstance().submitTags(x, y);
			if(tagsSubmitted)
			{
				setAsComplete();
				PhotoGrid.getInstance().addToComplete(mc_photo_album.currentFrame);
			}
		}
		
		public function setAsComplete()
		{
			this.completed = true;
			var completeTween:Tween = new Tween(this.mc_complete_screen, "alpha", Regular.easeOut, 0, 0.75, 1, true);
			//completeTween.addEventListener(TweenEvent.MOTION_FINISH, finishCompleteTween);
		}
		
		private function finishCompleteTween(e:TweenEvent)
		{
			setTimeout(thanksFade, 2000);			
		}
		
		private function thanksFade()
		{
			var completeTween:Tween = new Tween(this.mc_complete_screen.mc_thank_you, "alpha", Regular.easeIn, 1, 0, 4, true);
		}
		
		public function setAsCompleteQuick()
		{
			this.completed = true;
			var completeTween:Tween = new Tween(this.mc_complete_screen, "alpha", Regular.easeOut, 0, 0.75, 0.8, true);
			this.mc_complete_screen.mc_thank_you.alpha = 0;
		}
		
		
	}
	
}
