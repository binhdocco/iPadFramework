package com.binhdocco.dispatcher {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author binhdocco

	 */
	public class Dispatcher implements IEventDispatcher {
		
		protected static var disp: EventDispatcher;
		
		public function Dispatcher() {			
			if (disp == null)
				disp = new EventDispatcher();
		}
		
		/* INTERFACE flash.events.IEventDispatcher */
		
		public function addEventListener(type:String, listener:Function, 
										useCapture:Boolean = false, priority:int = 0, 
										useWeakReference:Boolean = false):void{
			disp.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean {			
			return disp.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean{
			return disp.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, 
											useCapture:Boolean = false):void{
			disp.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean{
			return disp.willTrigger(type);
		}
		
	}

}