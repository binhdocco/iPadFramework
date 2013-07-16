package com.binhdocco.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class IdleTimer extends EventDispatcher	{
		
		public static const ON_IDLE_EVENT: String = "on_idle";
		
		private var timer: Timer;		
		
		public function IdleTimer(stage: Object, miliseconds: uint = 30000)	{
			super(null);		
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMDown);
			timer = new Timer(miliseconds, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerDone);
			timer.start();
		}
		
		private function onMDown(e: MouseEvent): void {
			timer.stop();
			timer.reset();
			timer.start();
		}
		
		private function onTimerDone(e: TimerEvent): void {
			timer.stop();
			timer.reset();
			this.dispatchEvent(new Event(IdleTimer.ON_IDLE_EVENT));
		}

	}
}