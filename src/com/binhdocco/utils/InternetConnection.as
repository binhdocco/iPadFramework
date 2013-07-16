package com.binhdocco.utils {
	import com.binhdocco.dispatcher.Dispatcher;
	import com.binhdocco.events.InternetConnectionEvent;
	import com.binhdocco.events.OutputEvent;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author binhdocco

	 */
	[Event(name="connected", type="com.binhdocco.events.InternetConnectionEvent")]
	[Event(name="disconnected", type="com.binhdocco.events.InternetConnectionEvent")]
	public class InternetConnection extends EventDispatcher {
		
		private var testUrl:String = "";
		public var connected: Boolean = false;
		
		private var timer: Timer;
		private var dispatcher: Dispatcher = new Dispatcher();
		
		public function InternetConnection(url: String = "", target:IEventDispatcher = null) {
			super(target);	
			
			this.testUrl = url;		
			
			timer = new Timer(5 * 1000, 1); // 60s to check
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, startChecking);
			
			startChecking();
		}
		
		public function destroy():void {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, startChecking);
		}
		
		public function counterToStartChecking():void {
			timer.stop();
			timer.reset();			
			timer.start();
		}
		
		private function onHTTPStatus(e:HTTPStatusEvent):void {
			dispatcher.dispatchEvent(new OutputEvent("[InternetConnection] onHTTPStatus: " + e.status));
			(e.currentTarget as URLLoader).removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);				
			(e.currentTarget as URLLoader).removeEventListener(IOErrorEvent.IO_ERROR, onError);	
			if (e.status > 0 ) {
				if (!connected) {
					dispatcher.dispatchEvent(new OutputEvent("[InternetConnection] Connected!"));
					connected = true;
					
					dispatchEvent(new InternetConnectionEvent(InternetConnectionEvent.CONNECTED));
				}
			} else {
				if (connected) {
					dispatcher.dispatchEvent(new OutputEvent("[InternetConnection] Disconnected!"));
					connected = false;
					dispatchEvent(new InternetConnectionEvent(InternetConnectionEvent.DISCONNECTED));
				}
				
				// checking again
				counterToStartChecking();
			}			
		}
		
		private function onError(e:*):void {}
		
		private function startChecking(e:TimerEvent = null):void {
			//trace("startChecking");
			dispatcher.dispatchEvent(new OutputEvent("[InternetConnection] startChecking file: " + testUrl));
			
			var request: URLRequest = new URLRequest(this.testUrl);
			var urlLoader: URLLoader = new URLLoader();			
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);		
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);		
			urlLoader.load(request);
		}
		
	}

}