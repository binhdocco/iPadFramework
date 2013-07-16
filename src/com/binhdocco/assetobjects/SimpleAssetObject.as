package com.binhdocco.assetobjects { // com.binhdocco.assetobjects.SimpleAssetObject
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author binhdocco

	 */
	public class SimpleAssetObject extends MovieClip implements IAssetObject{

		public function SimpleAssetObject() {
			super();			
		}
		
		/* INTERFACE com.binhdocco.assetobjects.IAssetObject */
		
		// ==> Importance: add 'doinit' and 'dodestroy' functions in FLA file if you want to init or destroy this movie
	
		public function init():void{
			if (this.hasOwnProperty('doinit')) this["doinit"]();
		}
		
		public function destroy():void{
			if (this.hasOwnProperty('dodestroy')) this["dodestroy"]();
		}		
	}

}