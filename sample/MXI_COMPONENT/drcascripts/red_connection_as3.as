import flash.events.StatusEvent;
import flash.net.SharedObject;
import flash.net.ObjectEncoding;

var swfkey:String =  "_swfLc";//_root['swfkey'];
var flexkey:String =  "";//_root['flexkey'];

var runOnSimulator = false;
if (this.loaderInfo.parameters) {
	//trace("conkey: " + this.loaderInfo.parameters["conkey"]);
	if (this.loaderInfo.parameters["conkey"] != null) {
		flexkey = this.loaderInfo.parameters["conkey"];
		runOnSimulator = false;
		trace("[AS3 SWF flexkey get this.loaderInfo.parameters.conkey] flexkey : " + flexkey);
	} 
}  

if (flexkey == "") {
	SharedObject.defaultObjectEncoding = ObjectEncoding.AMF0;
	var shareObj: SharedObject = SharedObject.getLocal("drca_sharedobject", "/");
	flexkey = shareObj.data.drcaLc;
	runOnSimulator = shareObj.data.runOnSimulator;
	trace("[AS3 SWF flexkey get shareObj] flexkey : " + flexkey);
}


var now:Date = new Date();
swfkey += String(now.getTime());

var receivelc:LocalConnection = new LocalConnection();
receivelc.allowDomain("*");
var thisObj = this;
var clientCon = new Object();

receivelc.client = clientCon;

clientCon.callfromflex = function(target: String, func: String, params: Object) {    
	//both call this fun
	thisObj[func](params);
};
clientCon.callfromflex_showHitBg = function() {    
	//only inviter call this fun
};
clientCon.callfromflex_destroy = function() {    
	//both call this fun
};
clientCon.callfromflex_get_users_info = function(presenter: Object, attendee: Object) {    
	//both call this fun
};

receivelc.addEventListener(StatusEvent.STATUS, onStatusHandler);
function onStatusHandler(e: StatusEvent) {}

receivelc.connect(swfkey);
receivelc.send(flexkey, "addTransferSwf", swfkey);

function sendLC(targetName: String, func: String, params: Object) {
	//trace("[sendLC func]: " + func);
	if (runOnSimulator == true) receivelc.send(flexkey, "callfromswf", targetName, func, params, swfkey);
	else receivelc.send(flexkey, "callfromswf", targetName, func, params);
}

GlobalVars.getInstance().sendAction = function (func: String, params: Object = null) {	
	thisObj.sendLC("_root", func, params)
}

/* create new GlobalVars.as if not existed.
package  {	
	public class GlobalVars {		
		
		public var sharedData: Object = new Object();
		public var sendAction: Function;
		private static var instance: GlobalVars;

		public function GlobalVars() {
		}		
		public static function getInstance(): GlobalVars {
			if (!instance) {
				instance = new GlobalVars();
			}
			return instance;
		}
	}	
}
*/
//Insert your function below