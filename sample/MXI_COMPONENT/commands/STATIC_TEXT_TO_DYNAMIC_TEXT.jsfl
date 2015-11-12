var dom = fl.getDocumentDOM();
function convert(timeline) {
	if (timeline != undefined) {		
		if (timeline.layers != undefined) {
			fl.trace("++ TIMELINE LAYERS: " + timeline.layers.length);
			for(var layer in timeline.layers){		
				if (timeline.layers[layer].layerType == "normal") {
					var lFrames = timeline.layers[layer].frames;
					var fn = lFrames.length;
					//fl.trace("***LAYER " + layer + " == FRAME COUT: " + fn);
					for(var i =0; i < lFrames.length;i++){
						if (i==lFrames[i].startFrame) {//is key frame
							for(var element in lFrames[i].elements) {
								var item = lFrames[i].elements[element];
								//fl.trace("text type: " + item.textType);
								if (item.elementType == "text") {
									if (item.textType == "static") {
										item.textType = "input";
										item.selectable = true;						
									}
									fl.trace("[OUT TEXT]: " + item.textRuns[0].characters);
								} else {
									//fl.trace("==== TEXT ELEMENTTYPE: " + item.elementType);
									//convert(item.timeline);
									
									if (item.libraryItem != undefined) {
										//for (var ob in item.libraryItem) {
											//fl.trace(ob + ": " + item.libraryItem[ob]);
										//}
										convert(item.libraryItem.timeline);	
									} else if (item.elementType == "shape") {
										//for (var ob in item.layer) {
											//fl.trace(ob + ": " + item.layer[ob]);
										//}
										if (item.layer.layerType == "normal") {
											convertShape(item.layer);
										}
									}
								}
								//fl.trace("text elementType: " + item.elementType);
								
							}
						}
					}
				}
			}
		}
	}
}
function convertShape(layer) {
	var lFrames = layer.frames;
	var fn = lFrames.length;
	fl.trace("***SHAPE LAYER " + layer + " == FRAME COUT: " + fn);
	for(var i =0; i < lFrames.length;i++){
		if (i==lFrames[i].startFrame) {//is key frame
			for(var element in lFrames[i].elements) {
				var item = lFrames[i].elements[element];
				//fl.trace("text type: " + item.textType);
				if (item.elementType == "text") {
					if (item.textType == "static") {
						item.textType = "input";
						item.selectable = true;						
					}
					fl.trace("[SHAPE OUT TEXT]: " + item.textRuns[0].characters);
				} else {
					fl.trace("==== SHAPE TEXT ELEMENTTYPE: " + item.elementType);
					//convert(item.timeline);
					
					if (item.libraryItem != undefined) {
						//for (var ob in item.libraryItem) {
							//fl.trace(ob + ": " + item.libraryItem[ob]);
						//}
						convert(item.libraryItem.timeline);	
					} else if (item.elementType == "shape") {
						for (var ob in item.layer) {
							fl.trace(ob + ": " + item.layer[ob]);
						}
						//convertShape(item.layer);
					}
				}
				//fl.trace("text elementType: " + item.elementType);
				
			}
		}
	}

}
fl.outputPanel.clear();
convert(dom.getTimeline());
/*for(var i=0;i<dom.library.items.length;i++) {
	convert(dom.library.items[i].timeline)
}*/
