package com.binhdocco.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author binhdocco

	 */
	public class InternetConnectionEvent extends Event {
		
		public static const CONNECTED: String = "connected";
		public static const DISCONNECTED: String = "disconnected";
		
		public function InternetConnectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new InternetConnectionEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("InternetConnectionEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}