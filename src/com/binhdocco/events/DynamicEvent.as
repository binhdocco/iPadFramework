package com.binhdocco.events
{
	import flash.events.Event;

	public class DynamicEvent extends Event
	{
		public var params: Object;
		
		public function DynamicEvent(type:String, obj: Object = null, bubbles:Boolean=false, cancelable:Boolean=false)	{
			this.params = obj;
			super(type, bubbles, cancelable);
		}
		
	}
}