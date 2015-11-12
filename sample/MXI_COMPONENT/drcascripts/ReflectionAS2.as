/**
 * ...
 * @author binhdocco
 */

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;

		
_global.makeReflection = function(mc, alpha, ratio, distance) {
	//the BitmapData object that will hold a visual copy of the mc
	var mcBMP:BitmapData;
	//the BitmapData object that will hold the reflected image
	var reflectionBMP:MovieClip;
	//the clip that will act as out gradient mask
	var gradientMask_mc:MovieClip;
	//the size the reflection is allowed to reflect within
	var bounds:Object;
	//the distance the reflection is vertically from the mc
	var reflectionBMPRef:MovieClip;

	var reflectionDropoff:Number = 1;
	
	//store width and height of the clip
	var mcHeight = mc._height;
	var mcWidth = mc._width;
	
	//store the bounds of the reflection
	bounds = new Object();
	bounds.width = mcWidth;
	bounds.height = mcHeight;
	
	//create the BitmapData that will hold a snapshot of the movie clip
	mcBMP = new BitmapData(bounds.width, bounds.height, true, 0xFFFFFF);
	mcBMP.draw(mc);
	
	//add the reflection to the movie clip's Display Stack
	reflectionBMPRef = mc.createEmptyMovieClip("reflectionBMPRef", mc.getNextHighestDepth());
	reflectionBMPRef.attachBitmap(mcBMP, 2);
	//flip the reflection upside down
	reflectionBMPRef._yscale = -100;
	//move the reflection to the bottom of the movie clip
	reflectionBMPRef._y = (bounds.height * 2) + distance;
	
	//add a blank movie clip to hold our gradient mask
	var gradientMaskRef:MovieClip = mc.createEmptyMovieClip("gradientMask_mc", mc.getNextHighestDepth());
	//create the Matrix and create the gradient box
	var matr:Matrix = new Matrix();
	//set the height of the Matrix used for the gradient mask
	var matrixHeight:Number;
	if (reflectionDropoff<=0) {
		matrixHeight = bounds.height;
	} else {
		matrixHeight = bounds.height/reflectionDropoff;
	}		
	matr.createGradientBox(bounds.width, matrixHeight, (90 / 180) * Math.PI, 0, 0);
	
	//set the values for the gradient fill
	var fillType:String = "linear";
	var colors:Array = [0xFFFFFF, 0xFFFFFF];
	var alphas:Array = [alpha, 0];
	var ratios:Array = [0, ratio];
	var spreadMethod:String = "pad";
	gradientMaskRef.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);  
	drawRect(gradientMaskRef, 0, 0, bounds.width, bounds.height);
	gradientMaskRef.endFill();
	//position the mask over the reflection clip			
	gradientMaskRef._y = reflectionBMPRef._y - reflectionBMPRef._height;
	//cache clip as a bitmap so that the gradient mask will function
	gradientMaskRef.cacheAsBitmap = true;
	reflectionBMPRef.cacheAsBitmap = true;
	//set the mask for the reflection as the gradient mask
	reflectionBMPRef.setMask(gradientMaskRef);	
}

function drawRect(mc: MovieClip, x: Number, y: Number, w: Number, h: Number):Void {
	mc.moveTo(x, y);
	mc.lineTo(x, y+h);
	mc.lineTo(x+w, y+h);
	mc.lineTo(x+w, y);
	mc.lineTo(x, y);
}


	
