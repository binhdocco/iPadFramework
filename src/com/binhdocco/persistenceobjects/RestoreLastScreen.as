package com.binhdocco.persistenceobjects {
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author binhdocco
	 */
	public class RestoreLastScreen {
		
		private static var instance: RestoreLastScreen = null;
		
		private var appKey: String;
		
		public function RestoreLastScreen(key: String = "") {
			appKey = key;
			SharedObject.defaultObjectEncoding = ObjectEncoding.AMF3;
					
			var so: SharedObject;
			try {
				so = SharedObject.getLocal(appKey + "_restore_so", "/");
				// clear all db
				//so.clear();
				// create trackings for this app
				if (so.data["lastScreenIndex"] == null) {
					so.data["lastScreenIndex"] = -1;			
				}						
				if (so.data["sharedData"] == null) {
					so.data["sharedData"] = new Object();			
				}				
				so.flush();
				
			} catch (e: Error) {					
			};
		}
		
		public static function getInstance(key: String = ""): RestoreLastScreen {
			if (instance == null) {
				instance = new RestoreLastScreen(key);
			}
			return instance;
		}
		
		public function saveLastScreen(screenIndex: int):void {
			var so: SharedObject = SharedObject.getLocal(appKey + "_restore_so", "/");
			so.data["lastScreenIndex"] = screenIndex;			
			so.flush();
		}
		
		public function saveSharedData(name: String, value: Object):void {
			var so: SharedObject = SharedObject.getLocal(appKey + "_restore_so", "/");
			so.data["sharedData"][name] = value;			
			so.flush();
		}
		
		public function removeAction():void {
			var so: SharedObject = SharedObject.getLocal(appKey + "_restore_so", "/");
			so.data["lastScreenIndex"] = -1;			
			so.flush();
		}
		
		public function getLastScreen(): int {
			var so: SharedObject = SharedObject.getLocal(appKey + "_restore_so", "/");
			return so.data["lastScreenIndex"];		
		}
		
		public function getSharedData():Object {
			var so: SharedObject = SharedObject.getLocal(appKey + "_restore_so", "/");
			return so.data["sharedData"];
		}
		
		public function getSharedDataOfName(name: String):Object {
			var so: SharedObject = SharedObject.getLocal(appKey + "_restore_so", "/");
			return so.data["sharedData"][name];
		}
	}

}