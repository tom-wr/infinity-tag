package components {
	
	import flash.display.MovieClip;
	
	
	public class Tag extends MovieClip {
		
		
		public function Tag(xPos:Number, yPos:Number, tagName:String) {
			x = xPos;
			y = yPos;
			tag_text.text = tagName;						
		}
	}
	
}
