function genIds() {
	var userName = prompt("id_name, id_numbers: ", "id_name,id_numbers");
	var splits = userName.split(",");
	var sub_numbers = Number(splits[1]);
	var id_name = splits[0];
	var code = "";
	
	for (var i = 0; i < sub_numbers; i++) {
		code += id_name + (i+1) + ";\n";		
	}
	
	prompt("Copy this text and insert into your script", code);
}

function genMcPages() {
	var userName = prompt("id_name, id_numbers: ", "id_name,id_numbers");
	var splits = userName.split(",");
	var sub_numbers = Number(splits[1]);
	var id_name = splits[0];
	
	var code = "var mcpages = [";	
	var news = [];
	for (var i = 0; i < sub_numbers; i++) {
		news.push("new " + id_name + (i+1) + "()");		
	}
	code += news.join(", \n\t\t\t")
	code += "];";
	prompt("Copy this text and insert into your script", code);
}

function genPageBtns() {
	var userName = prompt("page_numbers: ", "page_numbers");
	var sub_numbers = Number(userName);
	
	var code = "var btns = [";	
	var news = [];
	for (var i = 0; i < sub_numbers; i++) {
		news.push("btn" + (i+1));		
	}
	code += news.join(", \n\t\t\t")
	code += "];";
	prompt("Copy this text and insert into your script", code);
}

function genAssetPages() {
	
	var userName = prompt("page_name, linkage_id, from, to: ", "page_name,linkage_id,from,to");
	var splits = userName.split(",");
	
	var id_name = splits[0];
	var linkage = splits[1];
	var from = Number(splits[2]);
	var to = Number(splits[3]);
	var page;
	
	var lib = fl.getDocumentDOM().library;

	for (var i = from; i <= to; i++) {
		fl.getDocumentDOM().selectNone();
		page = id_name + i + ".jpg";

		lib.addNewItem('movie clip');
		if (lib.getItemProperty('linkageImportForRS') == true) {
			lib.setItemProperty('linkageImportForRS', false);
		}
		lib.setItemProperty('linkageExportForAS', true);
		lib.setItemProperty('linkageExportForRS', false);
		lib.setItemProperty('linkageExportInFirstFrame', true);
		lib.setItemProperty('linkageClassName', linkage + (i));

		//fl.getDocumentDOM().enterEditMode('inPlace');
		fl.getDocumentDOM().library.selectItem('Symbol ' + (i));
		fl.getDocumentDOM().library.renameItem(linkage + (i));
		fl.getDocumentDOM().library.editItem();
		fl.getDocumentDOM().library.selectItem(page);
		//fl.trace("width: " + fl.getDocumentDOM().selection[0].width);
		fl.getDocumentDOM().library.addItemToDocument({x:0, y:0});
		fl.getDocumentDOM().align('left', true);
		fl.getDocumentDOM().align('top', true);

	}
	
	fl.trace("genAssetPages completed!");
	

}

function genPrefixNames() {
	
	var userName = prompt("prefix name: ", "prefix_name");
	//var from = Number(userName);
	
	var lib = fl.getDocumentDOM().library;
	var selItems = lib.getSelectedItems();

	if (selItems.length > 0) {

		for (var i = 0; i < selItems.length; i++) {
			var item = selItems[i];

			item.name = userName + item.name;

		}
		
		fl.trace("genPrefixNames completed!");
	} else {
		fl.trace("No items in library selected!");
	}
	

}
/*
function genStructure() {
	var userName = prompt("structure: ", "1,2,3,4,5,...");
	var sub_numbers = userName.split(",");
	
	var code = "//" + userName;		
	
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
}*/