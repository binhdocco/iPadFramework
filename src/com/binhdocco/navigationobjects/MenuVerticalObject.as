package com.binhdocco.navigationobjects { // com.binhdocco.navigationobjects.MenuVerticalObject
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author binhdocco

	 */
	public class MenuVerticalObject extends MovieClip {
		
		private var activeSub: MovieClip = null;
		private var _subs: Array;
		
		public function MenuVerticalObject() {
			super();
		}
		
		public function slideUpDown(directionY: int): void {
			if (directionY == 0) return;
			var index: int = subs.indexOf(activeSub);
			if (directionY > 0) { // go down 
				index ++;
			} else { // go up
				index --;
			}			
			activeItemAt(index);
		}
		
		public function activeItemAt(index: int):void {
			if (index < 0 || index >= subs.length) return;
			activeSub.deactive();
			activeSub = subs[index];
			activeSub.active();
		}
		
		public function get subs():Array { return _subs; }
		
		public function set subs(value:Array):void {
			_subs = value;
			for (var i: int = 1; i < subs.length; i++) {
				subs[i].deactive();
			}
			activeSub = subs[0] as MovieClip;
		}
		
	}

}