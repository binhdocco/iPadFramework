//-------------------------------------------------------
// 
//	COMMON FUNCS
//	 
//-------------------------------------------------------
function clean_library(  ) {
	var dom = fl.getDocumentDOM();
	var lib = dom.library;
	var items = dom.library.items;

	if (lib.itemExists('movieclips') == false) lib.newFolder('movieclips');
	if (lib.itemExists('buttons') == false) lib.newFolder('buttons');
	if (lib.itemExists('assets') == false) {
		lib.newFolder('assets');
		lib.newFolder('assets/graphics');
		lib.newFolder('assets/bitmaps');
		lib.newFolder('assets/others');
	}

	if (items.length > 0) {
		for (var i = 0; i < items.length; i++) {
			var item = items[i];		
			if (item.itemType == "folder") {
			} else if (item.itemType == "movie clip") {
				lib.moveToFolder("movieclips", item.name);
			} else if (item.itemType == "button") {
				lib.moveToFolder("buttons", item.name);
			} else if (item.itemType == "graphic") {
				lib.moveToFolder("assets/graphics", item.name);
			} else if (item.itemType == "bitmap") {
				lib.moveToFolder("assets/bitmaps", item.name);
			} else {
				lib.moveToFolder("assets/others", item.name);
			}
		}
	}

}

//-------------------------------------------------------
// 
//	AS2 FUNCS 
//	
//-------------------------------------------------------
function createTransparentMovieButtonAS2(  ) {
	var dom = fl.getDocumentDOM();
	var lib = dom.library;

	var itemname = "transparent_button_autogen";

	if( lib.itemExists(itemname) ) {
		alert("This button has already created in your library.");
		
	} else{

		if (lib.addNewItem('movie clip') == true) {	
			lib.renameItem(itemname);
			lib.editItem();
			var tl = dom.getTimeline();
			dom.addNewRectangle({left:0, top:0, right:200, bottom:200}, 0);	
			tl.addNewLayer("as");
			tl.layers[tl.currentLayer].frames[0].actionScript = "//made by binhdocco\nstop(); \nthis.onRelease = function(){}\nthis._alpha = 0;\nthis.useHandCursor = false;";
			dom.exitEditMode();
			lib.addItemToDocument({x:100, y:100});
		}
	}
}

function convertObjectToMovieButtonAS2(  ) {
	var dom = fl.getDocumentDOM();
	var lib = dom.library;
	if (fl.getDocumentDOM().selection.length > 0)
	{
		var mcName = prompt("Item's Name", "");
		if (mcName != null)
		{
			if( lib.itemExists(mcName) ) {
				alert("This button has already created in your library.");
				
			} else{
				var newMc = fl.getDocumentDOM().convertToSymbol("movie clip", mcName, "top left");
				fl.getDocumentDOM().selection[0].name = mcName;
				fl.getDocumentDOM().enterEditMode("inPlace");
				var tl = fl.getDocumentDOM().getTimeline();
				tl.insertFrames(2);
				tl.insertFrames(3);
				tl.convertToKeyframes(2, 1);
				tl.addNewLayer("LABELS");
				tl.convertToKeyframes(3, 1);
				tl.layers[tl.currentLayer].frames[0].name = "_up";
				tl.layers[tl.currentLayer].frames[1].name = "_over";
				tl.layers[tl.currentLayer].frames[2].name = "_down";
				tl.addNewLayer("AS");
				tl.layers[tl.currentLayer].frames[0].actionScript = "stop();\nthis.onRelease = function(){}";
				fl.getDocumentDOM().exitEditMode();
			}
		}
	} else{
		alert("Please select a object (shape, text, image)");
	}
}


//-------------------------------------------------------
// 
//	AS3 FUNCS 
//	
//-------------------------------------------------------
function createTransparentMovieButtonAS3(  ) {
	var dom = fl.getDocumentDOM();
	var lib = dom.library;

	var itemname = "transparent_movie_button_autogen";

	if( lib.itemExists(itemname) ) {
		alert("This button has already created in your library.");		
	} else{
		if (lib.addNewItem('movie clip') == true) {	
			lib.renameItem(itemname);
			lib.editItem();
			var tl = dom.getTimeline();
			dom.addNewRectangle({left:0, top:0, right:200, bottom:200}, 0);	
			tl.addNewLayer("as");
			tl.layers[tl.currentLayer].frames[0].actionScript = "//made by binhdocco\nstop(); \nthis.buttonMode = false;\nthis.alpha=0;";
			dom.exitEditMode();
			lib.addItemToDocument({x:100, y:100});
		}
	}
}

function convertObjectToMovieButtonAS3(  ) {
	var dom = fl.getDocumentDOM();
	var lib = dom.library;
	if (fl.getDocumentDOM().selection.length > 0)
	{
		var mcName = prompt("Item's Name", "");
		if (mcName != null)
		{
			if( lib.itemExists(mcName) ) {
				alert("This button has already created in your library.");				
			} else{
				var newMc = fl.getDocumentDOM().convertToSymbol("movie clip", mcName, "top left");
				fl.getDocumentDOM().selection[0].name = mcName;
				fl.getDocumentDOM().enterEditMode("inPlace");
				var tl = fl.getDocumentDOM().getTimeline();
				tl.insertFrames(2);				
				tl.convertToKeyframes(0, 1);
				tl.addNewLayer("LABELS");
				tl.convertToKeyframes(0, 1);
				tl.layers[tl.currentLayer].frames[0].name = "up";
				tl.layers[tl.currentLayer].frames[1].name = "over";			
				tl.addNewLayer("AS");
				tl.layers[tl.currentLayer].frames[0].actionScript = "stop();\nthis.addEventListener(MouseEvent.CLICK, function(){})\nthis.addEventListener(MouseEvent.ROLL_OVER, function(){gotoAndStop('over')})\nthis.addEventListener(MouseEvent.ROLL_OUT, function(){gotoAndStop('up')})\nthis.buttonMode = true;";
				fl.getDocumentDOM().exitEditMode();
			}
		}
	} else{
		alert("Please select a object (shape, text, image)");
	}
}