package com.binhdocco.events {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author binhdocco

	 */
	public class NavigationEvent extends Event {
		
		public static const CHANGED: String = "NavigationEvent_Changed";
		public static const CHANGED_BY_OFFSET: String = "NavigationEvent_Changed_By_Offset";
		public static const CHECK_ACTIVE_NAV_ITEM: String = "check_active_nav_item";
		public static const SWAP_NAV_ITEM: String = "SWAP_NAV_ITEM";
		public static const RESET_NAV_ITEM: String = "RESET_NAV_ITEM";
		public static const HIDE: String = "hide";
		public static const SHOW: String = "show";
		public static const UPDATE_FLOW: String = "UPDATE_FLOW";
		
		public var navIndex: int;
		public var offset: Array;
		public var activeNavMC: MovieClip;
		public var activeFlow: int;
		
		public function NavigationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);			
		}
		
	}

}