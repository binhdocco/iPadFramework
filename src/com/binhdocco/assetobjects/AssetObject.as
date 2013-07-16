package com.binhdocco.assetobjects { //com.binhdocco.assetobjects.AssetObject
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author binhdocco
	* How to use:
	* add stop(); at frame 1
	* add endedFrame(); at the last frame
	 */
	public class AssetObject extends MovieClip implements IAssetObject {
		
		public var hasPlayedDone: Boolean = false;
		
		public function AssetObject() {
			super();
			//this.cacheAsSurface = true;
			//this.cacheAsBitmap = true;
			//this.cacheAsBitmapMatrix = new Matrix();
		}
		
		/* INTERFACE com.binhdocco.assetobjects.IAssetObject */
		
		public function init():void {
			if (this.hasOwnProperty('doinit')) this["doinit"]();
			if (hasPlayedDone) return;	
			if (this.currentFrame+1 <= this.totalFrames)
				this.gotoAndPlay(this.currentFrame+1);
		}
		
		public function destroy():void {
			if (this.hasOwnProperty('dodestroy')) this["dodestroy"]();
			if (hasPlayedDone) return;
			this.stop();
		}

		/* FUNCTIONS*/
		
		public function endedFrame():void {
			hasPlayedDone = true;			
		}		
		
	}

}