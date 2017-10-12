package components {
	
	import flash.display.MovieClip;
	
	
	public class Tag extends MovieClip {
		
		public var tag:String;
		
		public function Tag(xPos:Number, yPos:Number, tagName:String) {
			x = xPos;
			y = yPos;
			tag_text.text = tagName;
			tag = tagName;
		}
	}
	
}
