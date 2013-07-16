package com.binhdocco.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author binhdocco

	 */
	public class OutputEvent extends Event {
		
		public static const TRACE: String = "OutputEvent_TRACE";
		public var dataString: String;
		
		public function OutputEvent(dataString: String = "", type:String = TRACE, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			this.dataString = dataString;
		} 
		
		public override function clone():Event { 
			return new OutputEvent(dataString, type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("OutputEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}