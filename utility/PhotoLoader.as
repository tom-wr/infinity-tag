package utility {
	
	public class PhotoLoader {
		
		

		public function PhotoLoader() {
			
		}
		
		public function load()
		{
			var loader:Loader = new Loader();
			loader.load(new URLRequest("images/test.jpg"));
			addChild(loader);
			
		}
		
		

	}
	
}
