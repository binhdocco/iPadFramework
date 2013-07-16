package com.binhdocco.utils {
	import com.binhdocco.persistenceobjects.TrackingObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author binhdocco

	 */
	public class CounterTimer {
		
		private var _seconds: int;
		private var timer: Timer;
		
		private var _trackingObject: TrackingObject;
		
		public function CounterTimer() {
			seconds = 1;
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onTick);
		}
		
		public function destroy():void {
			stopCounter();
			timer.removeEventListener(TimerEvent.TIMER, onTick);
		}
		
		private function onTick(e:TimerEvent):void {
			seconds ++;
			if (trackingObject != null) {
				trackingObject.duration ++;
			}
		}
		
		public function get seconds():int { return _seconds; }
		
		public function set seconds(value:int):void {
			_seconds = value;
		}
		
		public function get trackingObject():TrackingObject { return _trackingObject; }
		
		public function set trackingObject(value:TrackingObject):void {
			_trackingObject = value;
		}
		
		public function startCounter(): void {
			seconds = 1;
			timer.reset();
			timer.start();
		}
		
		public function stopCounter():void {
			timer.stop();
		}
		
		public function pauseCounter():void {
			timer.stop();
		}
		
		public function unPauseCounter():void {
			timer.start();
		}
		
	}

}