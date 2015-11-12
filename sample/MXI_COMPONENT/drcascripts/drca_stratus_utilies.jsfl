function initStratusConnection() {
	var doc = fl.getDocumentDOM();
	var timeline = doc.timelines[0];
	var layers = timeline.layers;
	var isLayerExisted = false;
	for (var i = 0; i < layers.length; i++) {
		var layer = layers[i];
		if (layer.name == 'insert_stratus_connection') {
			isLayerExisted = true;
			break;
		}
	}
	
	if (isLayerExisted) {
		alert("Layer [insert_stratus_connection] is already existed.");
	} else {
		var filecopyPath = fl.configURI + 'WindowSWF/' + "drcascripts/stratus_connection.as";
		var connectionscripts = FLfile.read(filecopyPath);
		if (connectionscripts) {
			var index = timeline.addNewLayer('insert_stratus_connection');
			timeline.layers[index].frames[0].actionScript = connectionscripts;//'#include "stratus_connection.as"' + "\n" + "//Insert your function below" + "\n";
			timeline.layers[index].frames[0].actionScript += "\n" + "// REMEMBER:  use _global.sendAction(string) to send action AND _global.root to access this movie.";
			timeline.layers[index].frames[0].actionScript += "\n" + "//Insert your function below" + "\n"
			alert("Inser layer [insert_stratus_connection] successful. Initialize connection completed.");	
		}  else{		
			alert("Can not read stratus_connection.as. Initialize connection failed.");	
		}		
		
	}
}

function initSharedDataConnection() {
	var doc = fl.getDocumentDOM();
	var timeline = doc.timelines[0];
	var layers = timeline.layers;
	var isLayerExisted = false;
	for (var i = 0; i < layers.length; i++) {
		var layer = layers[i];
		if (layer.name == 'insert_shared_data') {
			isLayerExisted = true;
			break;
		}
	}
	
	if (isLayerExisted) {
		alert("Layer [insert_shared_data] is already existed.");
	} else {
		var filecopyPath = fl.configURI + 'WindowSWF/' + "drcascripts/shared_data_stratus_connection.as";
		var connectionscripts = FLfile.read(filecopyPath);
		if (connectionscripts) {
			var index = timeline.addNewLayer('insert_shared_data');
			timeline.layers[index].frames[0].actionScript = connectionscripts;//'#include "stratus_connection.as"' + "\n" + "//Insert your function below" + "\n";			
			alert("Inser layer [insert_shared_data] successful. Initialize connection completed.");	
		}  else{		
			alert("Can not read shared_data_stratus_connection.as. Initialize connection failed.");	
		}		
		
	}
}

function addStratusFunciton(funcName, funcStatement) {
	if (funcName == "" || funcName == undefined || funcName == "undefined") {
		funcName = null;
	}
	if (funcStatement == "" || funcStatement == undefined || funcStatement == "undefined") {
		funcStatement = null;
	}
	if( funcName == null ) {
		alert("Please input function name.");	
	} else{
	
		var doc = fl.getDocumentDOM();
		var timeline = doc.timelines[0];
		var layers = timeline.layers;
		var isLayerExisted = false;
		var layer;
		for (var i = 0; i < layers.length; i++) {
			layer = layers[i];
			if (layer.name == 'insert_stratus_connection') {
				isLayerExisted = true;
				break;
			}
		}
		
		if (isLayerExisted) {	
			//var funcName = prompt("Enter function name", "");
			if (funcName != null) {
				//var funcStatement = prompt("Enter function statements", "");
				layer.frames[0].actionScript += "\n" + "//" + funcName;
				layer.frames[0].actionScript += "\n" + "function " + funcName + "() {";
				if (funcStatement != null) {
					layer.frames[0].actionScript += "\n\t" + funcStatement;
				}
				layer.frames[0].actionScript += "\n" + "}";
				prompt("Copy this text and insert into your script", '_global.sendAction("' + funcName + '");');
			}
		} else {
			alert("Please run [Init Stratus Connection] first.");	
		}
	}

}