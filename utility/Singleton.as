package utility {
	import flash.display.MovieClip;
	
	public class Singleton extends MovieClip{
		private static var _instance:Singleton;

		public function Singleton() {
			if(_instance) {
				throw new Error("Singleton... use getInstance()");
			}
			_instance = this;
		}
		
		public static function getInstance():Singleton
		{
			if(!_instance)
			{
				new Singleton();
			}
			return _instance;
		}

	}
	
}
