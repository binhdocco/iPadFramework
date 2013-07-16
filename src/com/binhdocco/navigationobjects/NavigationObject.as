package com.binhdocco.navigationobjects { // com.binhdocco.navigationobjects.NavigationObject
	import com.binhdocco.dispatcher.Dispatcher;
	import com.binhdocco.events.GotoSceneEvent;
	import com.binhdocco.events.NavigationEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author binhdocco

	 */
	public class NavigationObject extends MovieClip {
		
		private var currentMenuItem: MovieClip;
		private var _btns: Array;
		private var _subs: Array;
		private var _truesubs: Array;		
		private var dispatcher:Dispatcher;
		
		public function NavigationObject() {
			super();		
			dispatcher = new Dispatcher();
			dispatcher.addEventListener(NavigationEvent.CHANGED, onNavChanged);
			dispatcher.addEventListener(NavigationEvent.CHANGED_BY_OFFSET, onNavChangedByOffset);
			dispatcher.addEventListener(NavigationEvent.HIDE, onHideNavHandler);
			dispatcher.addEventListener(NavigationEvent.SHOW, onShowNavHandler);
		}
		
		private function onShowNavHandler(e:NavigationEvent):void {
			this.visible = true;
			this.enabled = !this.visible;
		}
		
		private function onHideNavHandler(e:NavigationEvent):void {
			this.visible = false;
			this.enabled = !this.visible;
		}
		
		private function onNavChanged(e:NavigationEvent):void {
			if (btns) {
				activeMenuItem(e.navIndex);
			}
		}
		
		private function onNavChangedByOffset(e:NavigationEvent):void {			
			if (btns) {
				activeMenuAtOffset(e.offset);
			}
		}
		
		private function activeMenuItem(index: int): Boolean {
			resetAllSubMenus();
			var btn: MovieClip = btns[index] as MovieClip;
			
			//for Abilify (show hide nav)
			var checkNavItemEvent: NavigationEvent = new NavigationEvent(NavigationEvent.CHECK_ACTIVE_NAV_ITEM);
			checkNavItemEvent.navIndex = index;
			checkNavItemEvent.activeNavMC = btn;
			this.dispatchEvent(checkNavItemEvent);
			
			if (btn != currentMenuItem)	{
				if (currentMenuItem) resetCurrentMenuItem(currentMenuItem);
				currentMenuItem = btn;				
				animateButton(currentMenuItem);		
				return true;
			}
			return false;
		}
		
		public function slideScreen(index: int, directionY: int): void {
			if (subs[index] != null)	{
				subs[index].activeMenu(index, directionY);
			}
		}
		
		public function activeMenuAtOffset(offset: Array):void { // offset.length must >= 2 values: [top, bottom, side (optional)]
			if (offset.length >= 2) {
				var btn: MovieClip = btns[offset[0]] as MovieClip;
				if (btn != currentMenuItem)	{
					resetAllSubMenus();
					if (currentMenuItem) resetCurrentMenuItem(currentMenuItem);
					currentMenuItem = btn;				
					animateButton(currentMenuItem);							
				}
				subs[offset[0]].activeMenuAtOffset(offset.slice(1, offset.length)); // get bot and side
			}
		}
		
		protected function resetCurrentMenuItem(mc: MovieClip):void {
			mc.gotoAndStop(1);//for Ceemea and Sprycel
		}

		protected function animateButton(mc: MovieClip): void {		
			//TweenNano.to(mc, 0.2, {alpha: 0.5, scaleX: 1.3, scaleY: 1.3, onComplete: makeSmaller, onCompleteParams: [mc]});	// for Omega
			mc.gotoAndStop(2);//for Ceemea and Sprycel
			
			//for Sprycel (show hide nav)
			/*var checkNavItemEvent: NavigationEvent = new NavigationEvent(NavigationEvent.CHECK_ACTIVE_NAV_ITEM);
			checkNavItemEvent.activeNavMC = mc;
			this.dispatchEvent(checkNavItemEvent);*/
		}

		protected function makeSmaller(mc: MovieClip): void {
			//TweenNano.to(mc, 0.2, {alpha: 1, scaleX: 1, scaleY: 1});
		}		

		protected  function onTouchTap(e: MouseEvent): void {		
			e.stopImmediatePropagation();
			//(this.parent as MovieClip).gotoScene(btns.indexOf(e.currentTarget));
			var gotoScenEvent: GotoSceneEvent = new GotoSceneEvent();
			gotoScenEvent.sceneIndex = btns.indexOf(e.currentTarget);
			dispatcher.dispatchEvent(gotoScenEvent);
		}

		protected  function resetAllSubMenus(): void {
			for (var i: int = 0; i < truesubs.length; i++) {
				if (truesubs[i] != null) truesubs[i].deactive();
			}
		}
		
		public function get btns():Array { return _btns; }
		
		public function set btns(value:Array):void {
			_btns = value;
			for (var i: int = 0; i < btns.length; i++) {
				var btn: MovieClip = btns[i] as MovieClip;
				btn.buttonMode = true;
				if (!btn.hasEventListener(MouseEvent.MOUSE_DOWN))
					btn.addEventListener(MouseEvent.MOUSE_DOWN, onTouchTap);
			}
			currentMenuItem = btns[0];
		}
		
		public function get subs():Array { return _subs; }
		
		public function set subs(value:Array):void {
			_subs = value;
		}
		
		public function get truesubs():Array { return _truesubs; }
		
		public function set truesubs(value:Array):void {
			_truesubs = value;
		}
	}

}