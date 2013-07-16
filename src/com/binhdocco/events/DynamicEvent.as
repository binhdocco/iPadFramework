package com.binhdocco.events
{
	import flash.events.Event;

	public class DynamicEvent extends Event
	{
		public var params: Object;
		
		public function DynamicEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)	{
			super(type, bubbles, cancelable);
		}
		
	}
}