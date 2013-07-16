package com.binhdocco.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author binhdocco

	 */
	public class SceneEvent extends Event {
		
		public static var CHANGE_AVAILABLE: String = "SceneEvent_CHANGE_AVAILABLE";
		public static var CHANGE_UNAVAILABLE: String = "SceneEvent_CHANGE_UNAVAILABLE";
		public static var ORIENTATION_CHANGED: String = "SceneEvent_ORIENTATION_CHANGED";
		
		public function SceneEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);			
		}
		
	}

}