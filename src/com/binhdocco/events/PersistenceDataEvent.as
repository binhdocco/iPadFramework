package com.binhdocco.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author binhdocco
	 */
	public class PersistenceDataEvent extends Event {
		
		public static const OPEN_DB_SUCCESS: String = "open_success";
		public static const OPEN_DB_ERROR: String = "open_error";
		public static const SAVE_TRACKING: String = "save_tracking";
		public static const SAVE_SURVEY: String = "save_survey";
		
		public var trackingName: String;
		
		public function PersistenceDataEvent(type:String, trackingName: String = "", bubbles:Boolean = false, cancelable:Boolean = false) { 
			this.trackingName = trackingName;
			super(type, bubbles, cancelable);			
		} 
		
		public override function clone():Event { 
			return new PersistenceDataEvent(type, trackingName, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("PersistenceDataEvent", "type", "trackingName", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}