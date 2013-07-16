package com.binhdocco.utils {
	import com.binhdocco.dispatcher.Dispatcher;
	import com.binhdocco.events.DataTransferEvent;
	import com.binhdocco.events.OutputEvent;
	import com.binhdocco.persistenceobjects.mailsender.MailObject;
	import com.binhdocco.persistenceobjects.TrackingObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author binhdocco

	 */
	[Event(name="success", type="com.binhdocco.events.DataTransferEvent")] 
	[Event(name="error", type="com.binhdocco.events.DataTransferEvent")] 
	
	public class DataTransfer extends EventDispatcher {
		
		private var SAVE_TRACKING_SERVICE_URL: String = "";
		
		private var service: URLLoader;
		private var request: URLRequest;
		
		private var dispatcher: Dispatcher;
		private var dataTranfers: Array;
		
		public var isSendingData: Boolean;
		
		public function DataTransfer(trackingUrl: String = "", target:IEventDispatcher = null) {
			super(target);
			
			isSendingData = false;
			dispatcher = new Dispatcher();
			if (trackingUrl != "") SAVE_TRACKING_SERVICE_URL = trackingUrl;
			
			service = new URLLoader();
			service.dataFormat = URLLoaderDataFormat.TEXT;
			service.addEventListener(Event.COMPLETE, onResult);
			service.addEventListener(IOErrorEvent.IO_ERROR, onError);
			service.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			request = new URLRequest(SAVE_TRACKING_SERVICE_URL);
			request.method = URLRequestMethod.POST;
		}
		
		private function onError(e:*):void {
			isSendingData = false;
			dispatcher.dispatchEvent(new OutputEvent("[DataTransfer] onError."));
			dispatchEvent(new DataTransferEvent(DataTransferEvent.ERROR, dataTranfers));
		}
		
		private function onResult(e:Event):void {
			isSendingData = false;
			dispatcher.dispatchEvent(new OutputEvent("[DataTransfer] onResult data: " + e.target.data));
			dispatchEvent(new DataTransferEvent(DataTransferEvent.SUCCESS, dataTranfers));
		}
		
		public function sendTracking(trackings: Array): void {			
			if (trackings.length > 0) {
				dataTranfers = trackings;
				var trackingXML: String = "<trackings>";				
				var getXML: Function = function(item: Object, index: int, vector: Array): void {				
					if (item) trackingXML += TrackingObject.toTrackingObect(item).toXMLString();
				}
				trackings.forEach(getXML);
				trackingXML += "</trackings>";
				
				//dispatcher.dispatchEvent(new OutputEvent("[DataTransfer] [sendTracking] trackings: " + trackingXML));
				
				var params: URLVariables = new URLVariables();
				params["data"] = trackingXML;
				request.data = params;
				service.load(request);
				
				isSendingData = true;
			}
		}
		
		public function sendEmail(mail: MailObject):void {
			//mail.status = MailObject.SENDING_STATUS;
			//service.dataFormat = URLLoaderDataFormat.TEXT;
			//trace("sendEmail:" + mail.toString());			
			dataTranfers = [mail];
			var params: URLVariables = new URLVariables();			
			if (mail.params) {
				//params = mail.params;			
				for (var ob:String in mail.params) {
					params[ob] = mail.params[ob];				
				}
			}
			
			params.from = mail.from;
			params.to = mail.to;
			params.body = mail.body;
			params.title = mail.title;

			request.data = params;
			request.method = URLRequestMethod.POST;
			service.load(request);
			
			isSendingData = true;
		}
		
	}

}