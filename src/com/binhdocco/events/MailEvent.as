package com.binhdocco.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author binhdocco
	 */
	public final class MailEvent extends Event {
		
		public static const SEND_MAIL: String = "send_mail";
		
		public var from: String = "";
		public var to: String = "";
		public var body: String = "";
		public var title: String = "";
		public var params: Object = new Object();
		
		public function MailEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);			
		}
		
	}

}