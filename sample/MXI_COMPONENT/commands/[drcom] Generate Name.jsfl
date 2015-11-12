var selItems = fl.getDocumentDOM().library.getSelectedItems();

var now = new Date();
var newname = now.getTime().toString();
if (selItems.length > 0) {
	for (var i = 0; i < selItems.length; i++) {
		var item = selItems[i];
		 
		fl.trace(item.name);
		item.name += "_" + newname;
	}
} else {
	alert("No selected items");
}

