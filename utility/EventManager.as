package utility {

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import components.PhotoGrid;
	import utility.Singleton;

	
	public final class EventManager extends MovieClip {
		private static var _instance:EventManager;
		private var dragX = null;
		private var dragY = null;
		private var decay:Number = 1;
		
		public var clickable = true;
		public var scrollable = true;

		public function EventManager() {
			if(_instance) {
				throw new Error("Singleton... use getInstance()");
			}
			_instance = this;
		}
		
		public static function getInstance():EventManager
		{
			if(!_instance)
			{
				new EventManager();
			}
			return _instance;
		}
		
		public function go()
		{
			parent.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		function mouseDown(e:MouseEvent)
		{
			if(this.scrollable)
			{
				dragX = stage.mouseX;
				dragY = stage.mouseY;
				parent.addEventListener(MouseEvent.MOUSE_MOVE, dragMouseMove);
				parent.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			}
		}

		function mouseUp(e:MouseEvent)
		{
			parent.removeEventListener(MouseEvent.MOUSE_MOVE, dragMouseMove);
			parent.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}

		function dragMouseMove(e:Event)
		{
			
			var moveX:Number = decay * (mouseX - dragX);
			var moveY:Number = decay * (mouseY - dragY);
			
			if((Math.abs(moveX) > 6) || (Math.abs(moveY) > 6))
			{
				clickable = false;
			}

			scrollable = false;
			PhotoGrid.getInstance().panPhotos(moveX, moveY);
			scrollable = true;
			dragX = mouseX;
			dragY = mouseY;
			
		}


	}
	
}
