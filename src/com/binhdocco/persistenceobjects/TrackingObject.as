package com.binhdocco.persistenceobjects {
	import com.binhdocco.utils.TronTime;
	/**
	 * ...
	 * @author binhdocco

	 */
	public class TrackingObject {
		
		public var storedDate: String;
		public var key: String = "";		
		public var id: String = "";
		private var tracking_name: String = "";
		public var duration: int = 1; // in seconds
		public var session: String = "";
		public var device: String = "";
		public var type: String = "goto";
		//public var synced: Boolean = false;
		
		public function TrackingObject() {
			var now: Date = new Date();
			id = now.getTime().toString();
			this.storedDate = TronTime.convertASDateToMySQLTimestamp(now); //return YYYY-MM-DD h:m:s
		}
		
		public function get trackingName():String { return tracking_name; }
		
		public function set trackingName(value:String):void {
			tracking_name = value;
		}
			
		public function clone(): TrackingObject {
			var cloneObj: TrackingObject = new TrackingObject();
			cloneObj.storedDate = this.storedDate;
			cloneObj.key = this.key;
			cloneObj.trackingName = this.trackingName;
			cloneObj.duration = this.duration;
			cloneObj.id = this.id;
			cloneObj.session = this.session;
			cloneObj.device = this.device;
			cloneObj.type = this.type;
			//cloneObj.synced = this.synced;
			
			return cloneObj;			
		}
		
		public function toString(): String {
			return "[" + device + "] [" + session + "] [" + trackingName + "] [" + type + "] [" + duration.toString() + "s]";
		}
		
		public function toXMLString(): String {
			if (trackingName == "") return "";
			var xmlstring: String = "<tracking>";
			xmlstring += "<app_name>" + key + "</app_name>";
			xmlstring += "<date_time>" + storedDate + "</date_time>";
			xmlstring += "<name>" + trackingName + "</name>";
			xmlstring += "<duration>" + duration + "</duration>";
			xmlstring += "<session>" + session + "</session>";
			xmlstring += "<type>" + type + "</type>";
			xmlstring += "<device>" + device + "</device>";
			xmlstring += "</tracking>";
			
			return xmlstring;
		}
		
		/*public function toSQLObject(): Object {
			var sqlObj: Object = new Object();
			sqlObj["@STOREDDATE"] = this.storedDate;
			sqlObj["@KEY"] = this.key;
			sqlObj["@TRACKINGNAME"] = this.trackingName;
			sqlObj["@DURATION"] = this.duration;
			sqlObj["@ID"] = this.id;		
			
			return sqlObj;	
		}*/
		
		public static function toTrackingObect(obj: Object): TrackingObject {
			var cloneObj: TrackingObject = new TrackingObject();
			cloneObj.storedDate = obj.storedDate;
			cloneObj.key = obj.key;
			cloneObj.trackingName = obj.trackingName;
			cloneObj.id = obj.id;
			cloneObj.duration = obj.duration;
			cloneObj.session = obj.session;
			cloneObj.type = obj.type;
			cloneObj.device = obj.device;
			//cloneObj.synced = obj.synced;
			
			return cloneObj;			
		}
		
		/*public static function buildCreateTables(): String {
			var fiels: Array = ["id", "key", "storedDate", "trackingName", "duration"];
			return QueryBuilder.buildCreate("trackings", fiels);
		}
		
		public static function buildGetQuery(): String {
			return QueryBuilder.buildGet("trackings");
		}
		
		public static function buildInsertQuery():String{
			return QueryBuilder.buildInsert("trackings",["id", "key", "storedDate", "trackingName", "duration"]);	
		}
		
		public static function buildDeleteTrackings(conditions: Array): String {
			return QueryBuilder.buildDeleteOR("trackings", conditions);
		}*/
		
	}

}