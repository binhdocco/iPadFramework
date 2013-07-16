package com.binhdocco.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author binhdocco
	 */
	public class DataTransferEvent extends Event 
	{
		public static const SUCCESS: String = "success";
		public static const ERROR: String = "error";
		
		public var dataTrackings: Array;
		
		public function DataTransferEvent(type:String, trackings: Array = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			dataTrackings = trackings;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DataTransferEvent(type, dataTrackings, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DataTransferEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}