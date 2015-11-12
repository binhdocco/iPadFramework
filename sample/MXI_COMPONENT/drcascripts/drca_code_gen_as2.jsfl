function genMouseEvent() {
	var doc = fl.getDocumentDOM();
	
	var instanceName = "this";
	if( doc.selection[0] != undefined) {
		var type = doc.selection[0].instanceType;
		if(type == "symbol") {
			instanceName = 	doc.selection[0].name;
		} 
		if( instanceName == "" ) {
			instanceName = "this";
		}		
	}
	
	var filecopyPath = fl.configURI + 'WindowSWF/' + "drcascripts/code_gen_mouseevent_as2.as";
	var connectionscripts = FLfile.read(filecopyPath);
	if (connectionscripts) {
		var actionScript = connectionscripts;
		actionScript = actionScript.split("instance").join(instanceName);
		prompt("Copy this text and insert into your script", actionScript);
	}  else{		
		alert("Can not read code_gen_as2.as. Gen failed.");	
	}				
	
}

function genReflection() {
	var doc = fl.getDocumentDOM();

	var timeline = doc.timelines[0];
	var layers = timeline.layers;
	var isLayerExisted = false;
	for (var i = 0; i < layers.length; i++) {
		var layer = layers[i];
		if (layer.name == 'reflection_as') {
			isLayerExisted = true;
			break;
		}
	}
	
	if (isLayerExisted) {		
	} else {
		var filecopyPath = fl.configURI + 'WindowSWF/' + "drcascripts/ReflectionAS2.as";
		var connectionscripts = FLfile.read(filecopyPath);
		if (connectionscripts) {
			var index = timeline.addNewLayer('reflection_as');
			timeline.layers[index].frames[0].actionScript = connectionscripts;//'#include "stratus_connection.as"' + "\n" + "//Insert your function below" + "\n";
		}  else{		
			alert("Can not read ReflectionAS2.as. Gen failed.");	
		}		
		
	}
	
	var instanceName = "this";
	if( doc.selection[0] != undefined) {
		var type = doc.selection[0].instanceType;
		if(type == "symbol") {
			instanceName = 	doc.selection[0].name;
		}	
		if( instanceName == "" ) {
			instanceName = "this";
		}
	}
	
	var filecopyPath = fl.configURI + 'WindowSWF/' + "drcascripts/code_gen_reflection_as2.as";
	var connectionscripts = FLfile.read(filecopyPath);
	if (connectionscripts) {
		var actionScript = connectionscripts;
		actionScript = actionScript.split("instance").join(instanceName);
		prompt("Copy this text and insert into your script", actionScript);
	}  else{		
		alert("Can not read code_gen_reflection_as2.as. Gen failed.");	
	}				
	
}
