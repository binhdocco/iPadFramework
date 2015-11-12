function createSubMenu() {
	var userName = prompt("sub_numbers, start_index and has_ver_sub: ", "sub_numbers,start_index,false");
	var splits = userName.split(",");
	var sub_numbers = Number(splits[0]);
	var start_index = splits[1];
	var has_ver_sub = String(splits[2]);
	var code = "";
	
	var indexs = [];
	var menus = [];
	var subs = [];
	code += "var index = " + start_index + ";// -> " + (Number(start_index) + (sub_numbers - 1)); 
	code += "\n";
	for (var i = 0; i < sub_numbers; i++) {
		code += "var menu_" + (i + 1) + ";\n";
		indexs.push("index+" + i);
		menus.push("menu_" + (i+1));
		if (has_ver_sub == "false") subs.push("null");
		else subs.push("submenu_" + (i+1));
	}
	code += "\n";
	code += "this.mcIndexs = [" + indexs.join(", ") + "]; \n";
	code += "this.menus = [" + menus.join(", ") + "]; \n";
	code += "this.subs = [" + subs.join(", ") + "]; \n";
	code += "\n";
	
	if (sub_numbers > 1) {
		code += "var contextmenu;\n";
		code += "var context_mc;\n";
		code += "contextmenu.context = context_mc;\n";
		code += "context_mc.contextmenu = contextmenu;\n";
		code += "\n";
		
		for (i = 0; i < sub_numbers - 1; i++) {
			code += "menu_" + (i+2) + ".context = context_mc.context_" + (i+1) + ";\n";
		}
		code += "\n";
	} 
	if (start_index == 0) {		
		code += "activeFirstItem();";
	}
	prompt("Copy this text and insert into your script", code);
}

function createContextMenu() {
	var userName = prompt("context_numbers, start_index: ", "context_numbers,start_index");
	var splits = userName.split(",");
	var sub_numbers = Number(splits[0]);
	var start_index = Number(splits[1]);
	var code = "";
	
	code += "import com.binhdocco.events.GotoSceneEvent;\n";
	code += "import com.binhdocco.dispatcher.Dispatcher;\n"
	code += "import flash.events.MouseEvent;\n\n"
	code += "var dispatcher: Dispatcher = new Dispatcher();\n"
	code += "var contextmenu;\n\n"	
	code += "this.visible = false;\n"; 
	code += "\n";
	
	for (var i = 0; i < sub_numbers; i++) {
		code += "context_" + (i+1) + ".addEventListener(MouseEvent.MOUSE_DOWN, onGoto);\n";		
	}
	code += "\n";
	code += "function onGoto(e: MouseEvent) { \n";
		code += "\tswitch (e.currentTarget) { \n";
			for (i = 0; i < sub_numbers; i++) {
				code += "\t\tcase context_" + (i + 1) + ":\n";
					code += "\t\t\tdispatcher.dispatchEvent(new GotoSceneEvent(GotoSceneEvent.GOTO_SCENE_EVENT, " + (start_index + i + 1)  + "));\n";		
					code += "\t\t\tbreak;\n";		
			}
		code += "\t} \n";
		code += "\tif (contextmenu) { \n";
		code += "\t\tcontextmenu.close(); \n";
		code += "\t} \n";
	code += "}\n\n";
	
	code += "function goHome() {\n";
		code += "\tdispatcher.dispatchEvent(new GotoSceneEvent(GotoSceneEvent.GOTO_SCENE_EVENT, " + start_index + "));\n";
	code += "}\n";
	
	prompt("Copy this text and insert into your script", code);
}

function genVariables() {
	var userName = prompt("menu_var_numbers: ", "menu_var_numbers");
	var sub_numbers = Number(userName);
	
	var code = "";		
	
	var menus = [];
	var submenus = [];
	var truemenus = [];
	
	for (var i = 0; i < sub_numbers; i++) {
		menus.push("var menu" + i + "_mc;");
		submenus.push("var submenu_" + i + ";");
		truemenus.push("submenu_" + i);
	}
	code += menus.join("\n") + "\n\n";
	code += submenus.join("\n") + "\n\n";
	code += "this.truesubs = [" + truemenus.join(",\n\t\t\t\t") + "\n];"
	
	prompt("Copy this text and insert into your script", code);
}

function genStructure() {
	var userName = prompt("structure: ", "1,2,3,4,5,...");
	var sub_numbers = userName.split(",");
	
	var code = "//" + userName + "\n\n";		
	
	var menus = [];
	var submenus = [];
	
	var allmenus = [];
	var allsubmenus = [];
	
	for (var i = 0; i < sub_numbers.length; i++) {
		var num = Number(sub_numbers[i]);
		menus = [];
		submenus = [];
		for (var j = 0; j < num; j++) {
			menus.push("menu" + i + "_mc");
			submenus.push("submenu_" + i);
		}
		allmenus.push(menus.join(", "));
		allsubmenus.push(submenus.join(", "));
	}
	code += "this.btns = [" + allmenus.join(", \n\t\t\t") + "];\n\n";	
	code += "this.subs = [" + allsubmenus.join(", \n\t\t\t") + "];"
	
	prompt("Copy this text and insert into your script", code);
}

function createLinkageAndPublish() {
	// Symbol Properties: movie clip, true, false, true, main_mc, false
	var lib = fl.getDocumentDOM().library;

	var userName = prompt("Linkage Id: ", "");
	if (userName != "") {

		if (lib.getItemProperty('linkageImportForRS') == true) {
			lib.setItemProperty('linkageImportForRS', false);
		}
		lib.setItemProperty('linkageExportForAS', true);
		lib.setItemProperty('linkageExportForRS', false);
		lib.setItemProperty('linkageExportInFirstFrame', true);
		lib.setItemProperty('linkageClassName', userName);
		lib.setItemProperty('scalingGrid',  false);

		fl.getDocumentDOM().publish();
	}
}

function duplicateInstance() {
	var doc = fl.getDocumentDOM();	
	if (doc.selection.length == 1) {
		var userName = prompt("duplicate_numbers, dX, dY,instance name, from: ", "numbers,dX,dY,name,from");
		var splits = userName.split(",");
		
		var numbers = splits[0];
		var dX = Number(splits[1]);
		var dY = Number(splits[2]);
		var iname = String(splits[3]);
		var from = Number(splits[4]);
		var to = Number(splits[5]);
		
		var ddX = doc.selection[0].width + dX;
		if (dX < 0) ddX = - doc.selection[0].width + dX;
		if (dX == 0) ddX = 0;
		var ddY = doc.selection[0].height + dY;
		if (dY < 0) ddY = - doc.selection[0].height + dY;
		if (dY == 0) ddY = 0;
		for (var i = 1; i <= numbers; i++) {		
			doc.duplicateSelection();
			doc.moveSelectionBy({x:ddX, y:ddY});
			doc.selection[0].name = iname + (from + i - 1);
		}	
	} else {
		fl.trace("[ERROR] Need only 1 instance selected.");
	}
	
	
}