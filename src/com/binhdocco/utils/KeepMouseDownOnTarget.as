package com.binhdocco.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name="down_mode", type="flash.events.Event")]
	[Event(name="click_mode", type="flash.events.Event")]
	
	public class KeepMouseDownOnTarget extends EventDispatcher {
		
		public static const KEEP_DOWN_MODE_EVENT: String = "down_mode";
		public static const CLICK_MODE_EVENT: String = "click_mode";
		
		private var timer: Timer;
		private var stillDown: Boolean = false;
		private var aStage: Object;
		
		public function KeepMouseDownOnTarget(astage: Object, target: Object, milliseconds: uint = 600)	{
			super(null);
			target.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			aStage = astage;
			timer = new Timer(milliseconds, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleted);
			stillDown = false;
		}
		
		private function onTimerCompleted(e: TimerEvent): void {
			stillDown = true;
			this.dispatchEvent(new Event(KeepMouseDownOnTarget.KEEP_DOWN_MODE_EVENT));
			timer.reset();
			timer.stop();
		}
		
		private function onDown(e: MouseEvent): void {	
			stillDown = false;
			timer.reset();
			timer.start();
			aStage.addEventListener(MouseEvent.MOUSE_UP, onUp);			
		}
		
		private function onUp(e: MouseEvent): void {			
			aStage.removeEventListener(MouseEvent.MOUSE_UP, onUp);		
			timer.stop();
			if (!stillDown) {
				this.dispatchEvent(new Event(KeepMouseDownOnTarget.CLICK_MODE_EVENT));
			}
		}
	}
}