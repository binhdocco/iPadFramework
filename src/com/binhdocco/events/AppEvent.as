package com.binhdocco.events {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author binhdocco
	 */
	public class AppEvent extends Event {
		
		public static const EXIT: String = "exit";
		public static const EXITING: String = "exiting";
		
		public static const SHOW_MESSAGE_POPUP: String = "show_message_popup";		
		public static const SAVE_MOVIE_TO_IMAGE: String = "save_movie_to_image";
		public static const SHOW_PDF: String = "show_pdf";
		
		public static const OPEN_URL: String = "open_url";
		public static const OPEN_MAIL: String = "open_mail";
		public static const OPEN_TEL: String = "open_tel";
		public static const OPEN_SMS: String = "open_sms";
		
		public var message: String = ""; // for SHOW_MESSAGE_POPUP
		public var movie: MovieClip; // for SAVE_MOVIE_TO_IMAGE
		public var pdfInstanceName: String = ""; // for SHOW_PDF
		
		public var link: String = "";// for OPEN_URL, OPEN_MAIL, OPEN_TEL, OPEN_SMS
		
		public function AppEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new AppEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("AppEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}