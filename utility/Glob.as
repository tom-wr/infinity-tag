package utility {
	import flash.display.MovieClip;
	import components.QuestionPanel;
	
	public class Glob extends MovieClip{
		
		private static var _instance:Glob;
		public var btnHelp:MovieClip;
		public var btnBack:MovieClip;
		public var helpDialog:MovieClip;
		public var banner:MovieClip;
		public var underlay:MovieClip;
		public var stats:MovieClip;
		

		public function Glob() {
			if(_instance) {
				throw new Error("Singleton... use getInstance()");
			}
			_instance = this;
		}
		
		public static function getInstance():Glob
		{
			if(!_instance)
			{
				new Glob();
			}
			return _instance;
		}
		
		public function go()
		{
		}
		
		public function toggleShow()
		{
			helpDialog.toggleShow();
			banner.toggleShow();
			underlay.toggleShow();
			stats.toggleShow();
		}
		
		public function hide(mc:MovieClip)
		{
			mc.visible = false;
		}
		
		public function show(mc:MovieClip)
		{
			mc.visible = true;
		}

	}
	
}