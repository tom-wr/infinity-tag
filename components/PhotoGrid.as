package components {
	import flash.display.MovieClip;
	import utility.Singleton;
	import flash.events.Event;
	import utility.EventManager;
	import utility.Glob;
	import components.QuestionPanel;
	import fl.transitions.Tween;

	public final class PhotoGrid extends MovieClip {
		
		private static var _instance:PhotoGrid;

		private var GRID_ROWS = 5;
		private var GRID_COLUMNS = 6;
		private var FRAME_WIDTH = 350;
		private var FRAME_HEIGHT = 300;
		private var START_X = -350;
		private var START_Y = -300;
		
		private var photoFrames:Array = new Array();
		private var newPhotoFrames:Array = new Array();
		
		private var FRAME_COUNT = 500;
		private var availableFrames:Array = new Array();
		private var completedFrames:Array = new Array();
		private var completedStartValue:Number = 100;
		
		private var scrollX = 0;
		private var scrollY = 0;
		
		public var questionPanel:QuestionPanel;
		
		public function PhotoGrid() {
			if(_instance) {
				throw new Error("Singleton... use getInstance()");
			}
			_instance = this;			
		}
		
		public static function getInstance():PhotoGrid
		{
			if(!_instance)
			{
				new PhotoGrid();
			}
			return _instance;
		}
		
		public function go()
		{	
			initQuestionPanel();
			initFrameArray();
			initCompleteArray();
			initGrid();
		}
		
		private function initGrid()
		{
			for(var i = 0; i < GRID_ROWS; i++)
			{
				for(var j = 0; j < GRID_COLUMNS; j++)
				{
					var newPhotoFrame:PhotoFrame = createPhotoFrame(START_X + (j * FRAME_WIDTH), START_Y + (i * FRAME_HEIGHT));
					checkComplete(newPhotoFrame);
					this.photoFrames.push(newPhotoFrame);
				}
			}
		}
		
		private function initQuestionPanel()
		{
			this.questionPanel = new QuestionPanel();
			addChild(questionPanel);
		}
		
		private function initFrameArray()
		{
			for(var i = 0; i < FRAME_COUNT; i++)
			{
				availableFrames.push(i + 1);
			}
		}
		
		private function initCompleteArray()
		{
			var tmpArray:Array = availableFrames.concat();
			for(var i = 0; i < completedStartValue; i++)
			{
				var rdm = Math.floor(Math.random() * (tmpArray.length));
				completedFrames.push(tmpArray[rdm]);
				tmpArray.splice(rdm, 1);
			}
			completedFrames.sort(Array.NUMERIC);
		}
		
		private function generateAlbumFrame():Number
		{
			if(availableFrames.length < 1)
			{
				initFrameArray();
			}
			var rdm = Math.floor(Math.random() * (availableFrames.length));
			var frame:Number = availableFrames[rdm];
			availableFrames.splice(rdm, 1);
			
			return frame;
		}
		
		private function createPhotoFrame(xPos:int, yPos:int):PhotoFrame
		{
			var photoFrame:PhotoFrame = new PhotoFrame(xPos, yPos);
			var frame:Number = generateAlbumFrame();
			photoFrame.load_photo(frame);
			addChild(photoFrame);
			return photoFrame;
		}
		
		public function panPhotos(moveX:Number, moveY:Number)
		{
			scrollX += moveX;
			scrollY += moveY;
			
			var scrollModX:Number = scrollX % FRAME_WIDTH;
			var scrollModY:Number = scrollY % FRAME_HEIGHT;
			
			for(var i = 0; i < photoFrames.length; i++)
			{
				panPhoto(photoFrames[i], moveX, moveY);
			}
			
			checkPhotoPositions();
			transferNewPhotoFrames();
		}
		
		private function panPhoto(photo:PhotoFrame, moveX:Number, moveY:Number)
		{
			photo.x += moveX;
			photo.y += moveY;
		}
		
		private function checkPhotoPositions()
		{
			for each(var photo:PhotoFrame in photoFrames)
			{
				checkPhotoPosition(photo);
			}			
		}
		
		private function checkPhotoPosition(photo:PhotoFrame)
		{
			var newX = null;
			var newY = null;
			var buffer:Number = 100;

			if(photo.x < -FRAME_WIDTH - buffer) 
			{
				newX = photo.x + (GRID_COLUMNS * FRAME_WIDTH);
			} 
			else if(photo.x > (stage.stageWidth + FRAME_WIDTH) + buffer )
			{
				newX = photo.x - (GRID_COLUMNS * FRAME_WIDTH)
			}
			
			if(photo.y < -FRAME_HEIGHT - buffer)
			{
				newY = photo.y + (GRID_ROWS * FRAME_HEIGHT);
			}
			else if(photo.y > (stage.stageHeight + FRAME_HEIGHT) + buffer)
			{
				newY = photo.y - (GRID_ROWS * FRAME_HEIGHT);
			}
			
			if(newX != null || newY != null)
			{
				newX = (newX == null) ? photo.x : newX;
				newY = (newY == null) ? photo.y : newY;
				var newPhoto:PhotoFrame = createPhotoFrame(newX, newY);
				checkComplete(newPhoto);
				this.newPhotoFrames.push(newPhoto);
				removePhotoFrame(photo);
			}
			
		}
		
		private function transferNewPhotoFrames()
		{
			this.photoFrames = this.photoFrames.concat(newPhotoFrames);
			this.newPhotoFrames = new Array();
		}
		
		private function removePhotoFrame(photo:PhotoFrame)
		{
			for each(var arrayPhoto:PhotoFrame in photoFrames)
			{
				if(arrayPhoto == photo)
				{
					removeChild(photo);
					photoFrames.splice(photoFrames.indexOf(photo), 1);
				}
			}
		}
		
		public function unfocus()
		{
			for each(var photo in photoFrames)
			{
				if(photo.focused)
				{
					photo.unfocus();
					Glob.getInstance().stats.fadeIn();
				}
			}
			this.questionPanel.unfocus();
		}
		
		private function checkComplete(photoFrame:MovieClip)
		{
			if(completedFrames.indexOf(photoFrame.mc_photo_album.currentFrame) > 0)
			{
				photoFrame.setAsCompleteQuick();
			}
		}
		
		public function addToComplete(frame:Number)
		{
			completedFrames.push(frame);
		}

	}
	
}
