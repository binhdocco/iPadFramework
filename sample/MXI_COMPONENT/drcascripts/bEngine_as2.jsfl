function initbEngineAS2() {
	var doc = fl.getDocumentDOM();
	var timeline = doc.timelines[0];
	var layers = timeline.layers;
	var isLayerExisted = false;
	for (var i = 0; i < layers.length; i++) {
		var layer = layers[i];
		if (layer.name == 'bEngine') {
			isLayerExisted = true;
			break;
		}
	}
	
	if (isLayerExisted) {
		alert("Layer [bEngine] is already existed.");
	} else {
		var filecopyPath = fl.configURI + 'WindowSWF/' + "drcascripts/bEngine_as2.as";
		var connectionscripts = FLfile.read(filecopyPath);
		if (connectionscripts) {
			var index = timeline.addNewLayer('bEngine');
			timeline.layers[index].frames[0].actionScript = connectionscripts;//'#include "stratus_connection.as"' + "\n" + "//Insert your function below" + "\n";
			//timeline.layers[index].frames[0].actionScript += "\n" + "// REMEMBER:  use _global.sendAction(string) to send action AND _global.root to access this movie.";
			//timeline.layers[index].frames[0].actionScript += "\n" + "//Insert your function below" + "\n"
			alert("Inser layer [bEngine] successful. Initialize bEngine completed.");	
		}  else{		
			alert("Can not read bEngine_as2.as. Initialize bEngine failed.");	
		}		
		
	}
}