package com.binhdocco.persistenceobjects {
	import com.binhdocco.dispatcher.Dispatcher;
	import com.binhdocco.events.DataTransferEvent;
	import com.binhdocco.events.InternetConnectionEvent;
	import com.binhdocco.events.OutputEvent;
	import com.binhdocco.events.PersistenceDataEvent;
	import com.binhdocco.utils.CounterTimer;
	import com.binhdocco.utils.DataTransfer;
	import com.binhdocco.utils.InternetConnection;
	
	import flash.events.Event;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author binhdocco

	 */
	public class PersistanceObject implements IPersistanceObject {
		
		protected const MAX_TRACKING_ITEM_SEND_PER_CALL: int = 10;
		
		private static var instance: PersistanceObject = null;
		
		protected var app_name: String;
		protected var app_key: String;
		protected var counter: CounterTimer;
		protected var previousTrackingObj: TrackingObject = null;		
		protected var dispatcher: Dispatcher = new Dispatcher();
		protected var soSize: uint;
		
		protected var internetConnection: InternetConnection;
		protected var dataTranfer: DataTransfer;
		
		public var isTestMode: Boolean = false;
		public var canNotInitSO: Boolean = false;
		
		private var allTrackings:Array;
		private var currentSession: String = "";
		public var currentDevice: String = "";
		private var SESSION_NAME: String = "main_session_";
		public var needToShowPopup: Boolean = false;
		
		public static var TRACKING_SURVEY_TYPE: Boolean = false;
		public static var NEED_DEVICE_NAME: Boolean = false;
		private var isEnded: Boolean = false;
		
		public function PersistanceObject(key: String = "", testMode: Boolean = false, sessionname: String = "", appName: String = "Default_App") {				
			if (key != "") {
				isTestMode = testMode;
				SESSION_NAME = sessionname;
				app_name = appName;
				app_key = key;
				allTrackings = [];
				//if (!isTestMode) {
					
					SharedObject.defaultObjectEncoding = ObjectEncoding.AMF3;
					
					var so: SharedObject;
					try {
						so = SharedObject.getLocal(app_key, "/");
						// clear all db
						//so.clear();
						// create trackings for this app
						if (so.data["trackings"] == null) {
							so.data["trackings"] = new Array();					
						}	
						if (so.data["device"] == null) {
							so.data["device"] = "";
						}
						this.currentDevice = so.data["device"];
					
						if (so.data["session"] == null) {
							so.data["sessionkey"] = 1;
							so.data["sessionclose"] = false;
							so.data["session"] = SESSION_NAME + so.data["sessionkey"].toString();					
							
							this.currentSession = so.data["session"];
						} else {
							if (so.data["sessionclose"] == true) { //create new session
								so.data["sessionclose"] = false;
								so.data["sessionkey"] = so.data["sessionkey"] + 1;								
								
								so.data["session"] = SESSION_NAME + so.data["sessionkey"].toString();								
								this.currentSession = so.data["session"];
							} else {
								// false will show a popup on HOMEPAGE
								this.currentSession = so.data["session"];
								
								//trace("NEED_DEVICE_NAME: " + NEED_DEVICE_NAME);
								//trace("this.currentDevice: " + (this.currentDevice == ""));
								if (NEED_DEVICE_NAME && (this.currentDevice == "")) {
								
								} else needToShowPopup = true;
								//trace("needToShowPopup: " + needToShowPopup);
							}
						}
						//trace("this.currentSession: " + this.currentSession);
						//trace("this.currentDevice: " + this.currentDevice);
						so.flush();
						allTrackings = so.data["trackings"];
						
					} catch (e: Error) {	
						canNotInitSO = true;
						isTestMode = true;						
					};
					
					//if (!isTestMode) {					
						soSize = so.size;
						counter = new CounterTimer();	
						
						//dispatcher.addEventListener(Event.CLOSING, onClosing);
					//}
				//}
				
				dispatcher.addEventListener(PersistenceDataEvent.SAVE_TRACKING, onSaveTracking);
				dispatcher.addEventListener(PersistenceDataEvent.SAVE_SURVEY, onSaveSurvey);
			}
		}
		
		public function createNewSession(updateLastTrackingSession: Boolean = true):void {
			var so: SharedObject = SharedObject.getLocal(app_key, "/");
			so.data["sessionclose"] = false;
			so.data["sessionkey"] = so.data["sessionkey"] + 1;							
			so.data["session"] = SESSION_NAME + so.data["sessionkey"].toString();								
			this.currentSession = so.data["session"];
			//trace("this.currentSession: " + this.currentSession);
			if (updateLastTrackingSession == true) {
				if (allTrackings.length > 0) {
					var count: int = allTrackings.length;				
					allTrackings[count-1].session = currentSession;
					so.data["trackings"] = allTrackings;
				}
			}
			so.flush();
		}
		
		public function usePreviousSession():void {
			var so: SharedObject = SharedObject.getLocal(app_key, "/");
			this.currentSession = so.data["session"];
			isEnded = false;
			//trace("this.currentSession: " + this.currentSession);
		}
		
		public function closeCurrentSession():void {
			var so: SharedObject = SharedObject.getLocal(app_key, "/");
			so.data["sessionclose"] = true;
			this.currentSession = "";			
			so.flush();
			
			isEnded = true;
		}
		
		public function saveDevice(deviceName: String): void {
			//trace("saveDevice: " + deviceName);	
			var so: SharedObject = SharedObject.getLocal(app_key, "/");
			so.data["device"] = deviceName;
			this.currentDevice = deviceName;			
			if (allTrackings.length > 0) {
				/*for (var i: int = 0; i < allTrackings.length; i++) {
					if (allTrackings[i].device == null || 
						allTrackings[i].device == "") {
						allTrackings[i].device = currentDevice;
						
					}
				}*/
				//only get the last tracking
				var track: Object = allTrackings[allTrackings.length-1];
				if (track.device == null || 
						track.device == "") {
						track.device = currentDevice;
				}
				allTrackings = new Array();
				allTrackings.push(track);
				so.data["trackings"] = allTrackings;
			}
			so.flush();
		}
		
		private function onSaveSurvey(e:PersistenceDataEvent):void {		
			if (isEnded) return;
			if (e.trackingName == "notracking") return;
			dispatcher.dispatchEvent(new OutputEvent("[PersistanceObject] [onSaveSurvey] trackingName: " + e.trackingName));
			saveSurvey(e.trackingName);
		}
		
		private function onSaveTracking(e:PersistenceDataEvent):void {		
			if (isEnded) return;
			//if (currentSession == "") return;
			if (e.trackingName == "notracking") return;
			dispatcher.dispatchEvent(new OutputEvent("[PersistanceObject] [onSaveTracking] trackingName: " + e.trackingName));
			saveTracking(e.trackingName);
		}
		
		protected function onClosing(e:Event):void {
			//destroy();
		}
		
		public function startCheckingInternetConnection(internetUrl: String = "", trackingUrl: String = ""):void {			
			//data transfer
			dataTranfer = new DataTransfer(trackingUrl);
			dataTranfer.addEventListener(DataTransferEvent.SUCCESS, onServiceResult);
			dataTranfer.addEventListener(DataTransferEvent.ERROR, onServiceError);
			
			// internet connection manager
			internetConnection = new InternetConnection(internetUrl);
			internetConnection.addEventListener(InternetConnectionEvent.CONNECTED, onInternetConnected);
			internetConnection.addEventListener(InternetConnectionEvent.DISCONNECTED, onInternetDisconnected);			
		}
		
		protected function onServiceError(e:DataTransferEvent):void {
			//checking the internet connection
			internetConnection.counterToStartChecking();
		}
		
		protected function onServiceResult(e:DataTransferEvent):void {
			var sentTrackings: Array = e.dataTrackings;
			var count: int = sentTrackings.length;
			//dispatcher.dispatchEvent(new OutputEvent("[PersistanceObject] [onServiceResult] trackings sent: " + count.toString()));
			
						
			while (count > 0) {
				allTrackings.shift();
				count --;				
			}
			
			var so: SharedObject = SharedObject.getLocal(app_key, "/");
			so.data["trackings"] = allTrackings;
			so.flush();
			
			sendTrackings();
		}
		
		protected function onInternetDisconnected(e:InternetConnectionEvent):void {
			
		}
		
		protected function onInternetConnected(e:InternetConnectionEvent):void {
			// send data to save trackings on server
			sendTrackings();
		}
		
		protected function sendTrackings():void {
			if (isTestMode) return;
			if (!internetConnection.connected) return;
			if (dataTranfer.isSendingData) return;
			if (NEED_DEVICE_NAME) {
				if (this.currentDevice == "") return;
			}
			
			//dispatcher.dispatchEvent(new OutputEvent("[PersistanceObject] [sendTrackings] current tracking length: " + allTrackings.length.toString()));
			
			if (!TRACKING_SURVEY_TYPE) {
				if (allTrackings.length > 1) { // dont send the last tracking because it is still in using
					
					var maxNoTracking: int = Math.min(MAX_TRACKING_ITEM_SEND_PER_CALL, allTrackings.length - 1);
					var trackingsToBeSent: Array = allTrackings.slice(0, maxNoTracking);
						
					dataTranfer.sendTracking(trackingsToBeSent);
				}
			} else {
				if (allTrackings.length > 0) { // send all trackings
					
					var maxNoTracking1: int = Math.min(MAX_TRACKING_ITEM_SEND_PER_CALL, allTrackings.length);
					var trackingsToBeSent1: Array = allTrackings.slice(0, maxNoTracking1);
						
					dataTranfer.sendTracking(trackingsToBeSent1);
				}
			}
		}
		
		public function destroy():void {
			internetConnection.destroy();
			counter.destroy();
		}
				
		public static function getInstance(key: String = "", testMode: Boolean = false, sessionname: String = "main_session_", appName: String = "Default_App"): PersistanceObject {
			if (instance == null) {
				instance = new PersistanceObject(key, testMode, sessionname, appName);
			}
			return instance;
		}
		
		public function toString(): String {
			if (isTestMode) return "[PersistanceObject] TESTING MODE.";
			
			var newline: String = "\n";
			var trackings: String = "-- LOCAL SO INFO -- " + newline;
			trackings += "[SO SIZE] = " + soSize.toString() + " bytes." + newline;			
			trackings += "[TRACKINGS LENGTH] = " + allTrackings.length.toString() + newline;			
			/*if (allTrackings.length > 0) {
				trackings += "-- [DATE] [NAME] [DURATION] -- " + newline;
				var showFunc: Function = function(item: Object, index: int, vector: Array): void {				
					if (item) trackings += TrackingObject.toTrackingObect(item).toString() + newline;
				}
				allTrackings.forEach(showFunc);
			}*/
			trackings += "-- END OF LOCAL SO INFO -- ";
			return trackings;
		}
		
		/* INTERFACE com.binhdocco.persistenceobjects.IPersistanceObject */
		
		public function store(data:TrackingObject):void{
			counter.stopCounter();			
			
			if (data != null) {
				previousTrackingObj = data;
				
				var tempTrackingObj: TrackingObject = data.clone();
				counter.trackingObject = tempTrackingObj;
				counter.startCounter();
				
				//if (tempTrackingObj.trackingName !=  "")
				//dispatcher.dispatchEvent(new OutputEvent("[PersistanceObject] storeTracking: " + tempTrackingObj.toString()));
					allTrackings.push(tempTrackingObj);		
					
					var so: SharedObject = SharedObject.getLocal(app_key, "/");
					so.data["trackings"] = allTrackings;
					so.flush();
				
				// check to send trackings
				sendTrackings();
			}
		}
		
		public function saveTracking(tracking_name: String = "", type: String = "goto"):void {
			if (canNotInitSO) dispatcher.dispatchEvent(new OutputEvent("[PersistanceObject] CAN NOT INITIALIZE SO. THE TRACKINGS CAN NOT BE SAVED."));
			if (isTestMode) return;
			
			//if (tracking_name != "") {
				var trackObj: TrackingObject = new TrackingObject();
				trackObj.trackingName = tracking_name;
				trackObj.key = this.app_name;
				trackObj.session = this.currentSession;
				trackObj.type = type;
				trackObj.device = currentDevice;				
				store(trackObj);
			//} 
		}
		
		public function saveSurvey(tracking_name: String = "", type: String = "survey"):void {
			if (canNotInitSO) dispatcher.dispatchEvent(new OutputEvent("[PersistanceObject] CAN NOT INITIALIZE SO. THE TRACKINGS CAN NOT BE SAVED."));
			if (isTestMode) return;
			
			//if (tracking_name != "") {
				var trackObj: TrackingObject = new TrackingObject();
				trackObj.trackingName = tracking_name;
				trackObj.key = this.app_name;
				trackObj.session = this.currentSession;
				trackObj.type = type;
				trackObj.device = currentDevice;	
				trackObj.duration = 0;
				
				//allTrackings.unshift(trackObj);
				//insert new survey tracking to n-1 position
				allTrackings.splice(allTrackings.length-1,0,trackObj);		
					
				var so: SharedObject = SharedObject.getLocal(app_key, "/");
				so.data["trackings"] = allTrackings;
				so.flush();
			
				// check to send trackings
				sendTrackings();
			//} 
		}
		
	}

}