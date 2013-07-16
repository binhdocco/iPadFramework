package com.binhdocco.events {
	import com.binhdocco.utils.TronTime;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author binhdocco
	 */
	public class LogEvent extends Event {
		
		public static const ADD_LOG: String = "ADD_LOG";
		public var textLog: String;
		
		public function LogEvent(log: String, type:String = ADD_LOG, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			var now: Date = new Date();			
			var datetime:String = TronTime.convertASDateToMySQLTimestamp(now); //return YYYY-MM-DD h:m:s
			this.textLog = "[" + datetime + "] " + log;
		}
		
	}

}