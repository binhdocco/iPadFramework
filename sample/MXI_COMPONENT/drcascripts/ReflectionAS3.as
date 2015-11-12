import flash.display.MovieClip;
import flash.display.DisplayObject;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.geom.Matrix;
import flash.display.GradientType;
import flash.display.SpreadMethod;


function makeReflection(mc: MovieClip, alpha: Number = 30, ratio: Number = 100, distance: Number = 0 ){
	alpha = alpha/100;
	//the distance at which the reflection visually drops off at
	var reflectionDropoff:Number = 1;

	var mcBMP:BitmapData;
	//the BitmapData object that will hold the reflected image
	var reflectionBMP:Bitmap;
	//the clip that will act as out gradient mask
	var gradientMask_mc:MovieClip;
	//the size the reflection is allowed to reflect within
	var bounds:Object;
	
	//store width and height of the clip
	var mcHeight = mc.height;
	var mcWidth = mc.width;
	
	//store the bounds of the reflection
	bounds = new Object();
	bounds.width = mcWidth;
	bounds.height = mcHeight;
	
	//create the BitmapData that will hold a snapshot of the movie clip
	mcBMP = new BitmapData(bounds.width, bounds.height, true, 0xFFFFFF);
	mcBMP.draw(mc);
	
	//create the BitmapData the will hold the reflection
	reflectionBMP = new Bitmap(mcBMP);
	//flip the reflection upside down
	reflectionBMP.scaleY = -1;
	//move the reflection to the bottom of the movie clip
	reflectionBMP.y = (bounds.height*2) + distance;
	
	//add the reflection to the movie clip's Display Stack
	var reflectionBMPRef:DisplayObject = mc.addChild(reflectionBMP);
	reflectionBMPRef.name = "reflectionBMP";
	
	//add a blank movie clip to hold our gradient mask
	var gradientMaskRef:DisplayObject = mc.addChild(new MovieClip());
	gradientMaskRef.name = "gradientMask_mc";
	
	//get a reference to the movie clip - cast the DisplayObject that is returned as a MovieClip
	gradientMask_mc = mc.getChildByName("gradientMask_mc") as MovieClip;
	//set the values for the gradient fill
	var fillType:String = GradientType.LINEAR;
	var colors:Array = [0xFFFFFF, 0xFFFFFF];
	var alphas:Array = [alpha, 0];
	var ratios:Array = [0, ratio];
	var spreadMethod:String = SpreadMethod.PAD;
	//create the Matrix and create the gradient box
	var matr:Matrix = new Matrix();
	//set the height of the Matrix used for the gradient mask
	var matrixHeight:Number;
	if (reflectionDropoff<=0) {
		matrixHeight = bounds.height;
	} else {
		matrixHeight = bounds.height/reflectionDropoff;
	}
	matr.createGradientBox(bounds.width, matrixHeight, (90/180)*Math.PI, 0, 0);
	//create the gradient fill
	gradientMask_mc.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
	gradientMask_mc.graphics.drawRect(0,0,bounds.width,bounds.height);
	//position the mask over the reflection clip			
	gradientMask_mc.y = mc.getChildByName("reflectionBMP").y - mc.getChildByName("reflectionBMP").height;
	//cache clip as a bitmap so that the gradient mask will function
	gradientMask_mc.cacheAsBitmap = true;
	mc.getChildByName("reflectionBMP").cacheAsBitmap = true;
	//set the mask for the reflection as the gradient mask
	mc.getChildByName("reflectionBMP").mask = gradientMask_mc;
				
}
	
	
	