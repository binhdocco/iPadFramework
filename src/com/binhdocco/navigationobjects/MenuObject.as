package com.binhdocco.navigationobjects { // com.binhdocco.navigationobjects.MenuObject
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author binhdocco

	 */
	public class MenuObject extends MovieClip implements IMenuObject {
		
		private var _mcIndexs: Array;
		private var _menus: Array;
		private var _subs: Array;
		private var currentMenu: MovieClip = null;
		
		public function MenuObject() {
			super();
			
		}
		
		/* INTERFACE com.binhdocco.navigationobjects.IMenuObject */
		
		public function deactive():void{
			for (var i: int = 0; i < subs.length; i++) {
				(menus[i] as MovieClip).deactive();
				if (subs[i] != null) subs[i].visible = false;
			}
		}
		
		public function activeFirstItem():void{
			(menus[0] as MovieClip).active();
			if (subs[0] != null) subs[0].visible = true;
		}
		
		public function activeMenu(index: int, directionY: int): void {
			var i: int = mcIndexs.indexOf(index);			
			if (i >= 0) {
				deactive();		
				if (subs[i] != null) subs[i].visible = true;
				currentMenu = menus[i] as MovieClip;
				currentMenu.active();
				
				if (subs[i] != null) {
					subs[i].slideUpDown(directionY);
				}
			}
		}
		
		public function activeMenuAtOffset(offset: Array): void {
		//trace("activeMenuAtOffset: " + offset[0] + "- " + offset[1]);
			var i: int = offset[0];			
			if (i >= 0) {
				deactive();		
				if (subs[i] != null) subs[i].visible = true;
				currentMenu = menus[i] as MovieClip;
				currentMenu.active();
				
				if (subs[i] != null && offset.length >= 2) {
					subs[i].activeItemAt(offset[1]);
				}
			}
		}
		
		public function get mcIndexs():Array { return _mcIndexs; }
		
		public function set mcIndexs(value:Array):void {
			_mcIndexs = value;
		}
		
		public function get menus():Array { return _menus; }
		
		public function set menus(value:Array):void {
			_menus = value;
		}
		
		public function get subs():Array { return _subs; }
		
		public function set subs(value:Array):void {
			_subs = value;
			deactive();
		}
		
	}

}