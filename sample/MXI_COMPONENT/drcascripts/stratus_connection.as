var swfkey:String =  "_swfLc";//_root['swfkey'];
var flexkey:String =  "";//_root['flexkey'];
var runOnSimulator = false;

if (_root.conkey != undefined) {
	flexkey = String(_root.conkey);
	runOnSimulator = false;
	trace("[AS2 SWF flexkey get _root.conkey] flexkey : " + flexkey);
} else {
	var shareObj: SharedObject = SharedObject.getLocal("drca_sharedobject", "/");
	flexkey = shareObj.data.drcaLc;
	runOnSimulator = shareObj.data.runOnSimulator;	
	trace("[AS2 SWF flexkey get shareObj] flexkey : " + flexkey);
}

var now:Date = new Date();
swfkey += String(now.getTime());

var receivelc:LocalConnection = new LocalConnection();
receivelc.allowDomain("*");
var thisObj = this;
receivelc.callfromflex = function(target: String, func: String, params: Object) {    
	//both call this fun
	thisObj[func](params);
};
receivelc.callfromflex_showHitBg = function() {    
	//only inviter call this fun
};
receivelc.callfromflex_destroy = function() {    
	//both call this fun
};
receivelc.callfromflex_get_users_info = function(presenter: Object, attendee: Object) {    
	//both call this fun
};
receivelc.connect(swfkey);

receivelc.send(flexkey, "addTransferSwf", swfkey);
//con.close();


function sendLC(targetName: String, func: String, params: Object) {
	//trace("[sendLC func]: " + func);
	if (runOnSimulator == true) receivelc.send(flexkey, "callfromswf", targetName, func, params, swfkey);
	else receivelc.send(flexkey, "callfromswf", targetName, func, params);
}

_global.sendAction = function (func: String, params: Object) {
	sendLC("_root", func, params)
}

_global.root = this;