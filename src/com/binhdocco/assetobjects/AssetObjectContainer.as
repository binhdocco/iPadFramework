package com.binhdocco.assetobjects { // com.binhdocco.assetobjects.AssetObjectContainer
	import com.binhdocco.managers.ApplicationManager;
	import com.binhdocco.sceneobjects.SceneObject;
	import com.greensock.TweenNano;
	
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	
	/**
	 * ...
	 * @author binhdocco

	 */
	public class AssetObjectContainer extends MovieClip implements IAssetObject {
		
		public static var INVERT_DIRECTION: Boolean = false;

		private var activeSub: MovieClip = null;
		private var _subs: Array;
		private var currentIndex: int = 0;
		
		public function AssetObjectContainer() {
			super();			
		}
				
		/* INTERFACE com.binhdocco.assetobjects.IAssetObject */
		
		public function init():void{
			if (activeSub) {
				if (activeSub.hasOwnProperty("init")) {
					activeSub.init();
				}
			}
		}
		
		public function destroy():void{
			if (activeSub) {
				if (activeSub.hasOwnProperty("destroy")) {
					activeSub.destroy();
				}
			}
		}
		
		/* FUNCTIONS */
		
		public function get subs():Array { return _subs; }
		
		public function set subs(value:Array):void {
			_subs = value;
			if (value.length > 0)
				activeSub = this.subs[0] as MovieClip;
			ApplicationManager.getInstance().activeVerSubSceneIndex = 0;
		}
		
		public function slideUpDown(directionY: int):void {
			//destroy();
			var index: int = subs.indexOf(activeSub);
			if (directionY > 0) { // go down 
				index ++;
			} else { // go up
				index --;
			}		
			ApplicationManager.getInstance().activeVerSubSceneIndex = index;	
			slideUpDownAt(index);			
		}
		
		public function slideUpDownAt(index: int):void {			
			if (index < 0 || index >= subs.length) return;
			destroy();
			if (SceneObject.CHANGE_STAGE_QUALITY_WHEN_SLIDING) {
				if (this.stage) stage.quality = StageQuality.MEDIUM;
			}
			currentIndex = index;
			activeSub = subs[index];  				
			
			if (SceneObject.USE_SLIDE_TRANSITION) {
				TweenNano.killTweensOf(this);
				if (AssetObjectContainer.INVERT_DIRECTION) {
					TweenNano.to(this, ApplicationManager.SLIDE_TRANSITION_TIME, {useFrames: true, y: -index * ApplicationManager.SCENE_HEIGHT, onComplete: onSlideComplete } );			
				} else {
					TweenNano.to(this, ApplicationManager.SLIDE_TRANSITION_TIME, {useFrames: true, y: index * ApplicationManager.SCENE_HEIGHT, onComplete: onSlideComplete } );
				}			
			} else {
				if (AssetObjectContainer.INVERT_DIRECTION) {
					this.y = -index * ApplicationManager.SCENE_HEIGHT;			
				} else 
					this.y = index * ApplicationManager.SCENE_HEIGHT;	
				
				init();
				if (this.stage) stage.quality = StageQuality.HIGH;
			}
		}
		
		private function onSlideComplete():void {
			if (SceneObject.USE_CACHING) {
				//this.cacheAsBitmapMatrix = null;
			}
			init();
			if (SceneObject.CHANGE_STAGE_QUALITY_WHEN_SLIDING) {
				if (this.stage) stage.quality = StageQuality.HIGH;
			}
		}
		
		/*public function getBoundMatrix(): Matrix {
			var matrix: Matrix = new Matrix();			
			matrix.translate(0, currentIndex*ApplicationManager.SCENE_HEIGHT);			
			return matrix;
		}*/
	}

}