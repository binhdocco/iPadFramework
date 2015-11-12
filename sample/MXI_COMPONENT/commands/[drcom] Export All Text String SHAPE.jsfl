//var filename = prompt("Enter name: (text will be save)")

// Look for text objects
fl.outputPanel.clear();
var doc = fl.getDocumentDOM();
var typeToSearchFor = "text";
/*
var results = fl.findObjectInDocByType(typeToSearchFor, doc);

for(var i = 0; i < results.length; i++)
{

     doWhatever(results[i].obj);
}*/

// Look for shapes

typeToSearchFor = "shape";
results = fl.findObjectInDocByType(typeToSearchFor, doc);

var textObjects;

for(var i = 0; i < results.length; i++)
{
    var members = results[i].obj.members;

    for(var j = 0; j < members.length; j++)
    {
     if(members[j].elementType == "text")
     {
      doWhatever(members[j]);
     }
    }
}


function doWhatever(textObj)
{
	//textObj.textType = "dynamic";
	textObj.selectable = true;	
	//textObj.lineType = "multiline";
	fl.trace("[OUT] " + textObj.getTextString());
}

fl.outputPanel.save("file:///C://[drcom]text_exporter_shape.txt");