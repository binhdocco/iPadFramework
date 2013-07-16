package com.binhdocco.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name="click", type="flash.events.Event")]
	[Event(name="double", type="flash.events.Event")]
	
	public class CheckMouseDoubleClick extends EventDispatcher	{
		
		public static const CLICK_EVENT: String = "click";
		public static const DOUBLE_CLICK_EVENT: String = "double";
		
		private var timer: Timer;
		private var isSingleClick: Boolean = false;
		
		public function CheckMouseDoubleClick(target: Object, milliseconds: uint = 180)	{
			target.addEventListener(MouseEvent.CLICK, onSingleClicked);
			target.addEventListener(MouseEvent.DOUBLE_CLICK, onDbClicked);
			timer = new Timer(milliseconds, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleted);
			isSingleClick = false;
		}
		
		private function onTimerCompleted(e: TimerEvent): void {
			if (isSingleClick == true) {
				this.dispatchEvent(new Event(CheckMouseDoubleClick.CLICK_EVENT));
			}
			isSingleClick = false;
			timer.reset();
		}
		
		private function onSingleClicked(e: MouseEvent): void {
			isSingleClick = true;
			timer.start();
			e.stopImmediatePropagation();			
		}
		
		private function onDbClicked(e: MouseEvent): void {
			isSingleClick = false;			
			timer.stop();
			timer.reset();
			this.dispatchEvent(new Event(CheckMouseDoubleClick.DOUBLE_CLICK_EVENT));
			e.stopImmediatePropagation();
		}

	}
}