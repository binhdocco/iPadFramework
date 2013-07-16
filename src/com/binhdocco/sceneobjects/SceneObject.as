package com.binhdocco.sceneobjects { // com.binhdocco.sceneobjects.SceneObject
	import com.binhdocco.dispatcher.Dispatcher;
	import com.binhdocco.events.NavigationEvent;
	import com.binhdocco.events.PersistenceDataEvent;
	import com.binhdocco.managers.ApplicationManager;
	import com.greensock.TweenNano;
	
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.system.System;
	
	/**
	 * ...
	 * @author binhdocco

	 */
	public class SceneObject extends MovieClip implements ISceneObject {
		
		public static var USE_CACHING: Boolean = false;
		public static var USE_SLIDE_TRANSITION: Boolean = true;
		public static var KILL_CHILDREN: Boolean = true;
		public static var CHANGE_STAGE_QUALITY_WHEN_SLIDING: Boolean = false;
		
		private var currentLoader: MovieClip = null;
		private var currentLoaderIndex: int = 0;
		private var currentIndex: int = 0;
		private var _loaders: Array; // include 2 movies
		private var _mcIds: Array = []; // include all the screens of app
		private var _screenTrackings: Array = []; // include trackings of all screens of app
		private var tempLoader:MovieClip;
		
		//tracking so		
		private var dispatcher:Dispatcher;
		private var appManager: ApplicationManager = ApplicationManager.getInstance();
		
		private var saveChangeSceneState: Boolean;

		public function SceneObject() {
			super();
			dispatcher = new Dispatcher();
			dispatcher.addEventListener(NavigationEvent.CHANGED, onNavChanged);
			dispatcher.addEventListener(NavigationEvent.CHANGED_BY_OFFSET, onNavChangedByOffset);
		}
		
		private function onNavChanged(e:NavigationEvent):void {
			addSceneOn(e.navIndex);
		}
		
		private function onNavChangedByOffset(e:NavigationEvent):void {			
			if (e.offset.length > 2) {
				var slide: MovieClip = currentLoader.getChildAt(0) as MovieClip;
				if (slide.hasOwnProperty("slideUpDown")) {
					(currentLoader.getChildAt(0) as MovieClip).slideUpDownAt(e.offset[2]);	
				}
			}
		}
		
		/* INTERFACE com.binhdocco.sceneobjects.ISceneObject */
		
		public function initScreen():void{
			var slide: MovieClip = currentLoader.getChildAt(0) as MovieClip;
			if (slide.hasOwnProperty("init")) {		
				slide.init();
			}
			// save trackings to SO
			var trackingName: String = this.getScreenTrackingAt(currentIndex);
			//if (trackingName == null) trackingName = "";
			dispatcher.dispatchEvent(new PersistenceDataEvent(PersistenceDataEvent.SAVE_TRACKING, trackingName));
			
			if (CHANGE_STAGE_QUALITY_WHEN_SLIDING) {
				if (appManager.stage) appManager.stage.quality = StageQuality.HIGH;
			}
		}
		
		public function destroyScreen():void{
			var slide: MovieClip = currentLoader.getChildAt(0) as MovieClip;
			if (slide.hasOwnProperty("destroy")) {
				slide.destroy();
			}	
		}
		
		public function slideScreen(index: int, directionY: int): void {	
			var slide: MovieClip = currentLoader.getChildAt(0) as MovieClip;
			if (slide.hasOwnProperty("slideUpDown")) {
				(currentLoader.getChildAt(0) as MovieClip).slideUpDown(directionY);	
			}
		}
		
		private function addSceneOn(index: int): void {
			if (!ApplicationManager.CAN_RELOAD_WHEN_ACTIVE) {
				 if (index == currentIndex) return;			
			}
			destroyScreen();
			
			
			if (index < currentIndex) {
				addSceneOnLeft(index);
			} else if (index > currentIndex) {
				addSceneOnRight(index);
			} else {
				addSceneAt(index);
			}
			currentIndex = index;
			if (!USE_SLIDE_TRANSITION) initScreen();
		}
		
		public function getSceneLength(): int {
			//return mcIds.length;
			return appManager.allMoviesLength;
		}
		
		/*PROTECTED FUNCS*/

		protected function getNext(): int {
			currentLoaderIndex ++;
			currentLoaderIndex = currentLoaderIndex % loaders.length;
			return currentLoaderIndex;
		}

		protected function addSceneAt(index: int): void {
			currentIndex = index;
			currentLoader = loaders[currentLoaderIndex];	
			if (currentLoader.numChildren) {
				var child: MovieClip = currentLoader.getChildAt(0) as MovieClip;				
				currentLoader.removeChild(child);
				if (KILL_CHILDREN) child = null;
			}	
			var newscene: MovieClip = appManager.getSceneMovie(index) as MovieClip;
			currentLoader.addChild(newscene);	
			//newscene.visible= true;
			//initScreen();
		}	

		protected function addSceneOnLeft(index: int): void {		
			tempLoader = loaders[getNext()];				
			if (tempLoader.numChildren) {
				var child: MovieClip = tempLoader.getChildAt(0) as MovieClip;
				//child.visible = false;
				tempLoader.removeChild(child);
				if (KILL_CHILDREN) child = null;
			}	
			var newscene: MovieClip = appManager.getSceneMovie(index) as MovieClip;
			tempLoader.x = - ApplicationManager.SCENE_WIDTH;
			tempLoader.addChild(newscene);	
			//newscene.visible = true;		
			//move 2 mcs to right
			var child2: MovieClip = currentLoader.getChildAt(0) as MovieClip;
			if (!USE_SLIDE_TRANSITION) {
				tempLoader.x = 0;
				currentLoader.x = -2000;				
				currentLoader.removeChild(child2);
				if (KILL_CHILDREN) child2 = null;
				System.gc();
				
			} else {
				saveChangeSceneState = appManager.canChangeScene;
				appManager.disableSliding();
				
				TweenNano.killTweensOf(tempLoader, false);
				TweenNano.killTweensOf(currentLoader, false);
				TweenNano.to(tempLoader, ApplicationManager.SLIDE_TRANSITION_TIME, {useFrames: true, x: ApplicationManager.SCENE_WIDTH.toString()});
				TweenNano.to(currentLoader, ApplicationManager.SLIDE_TRANSITION_TIME, {onComplete: onTweenComplete, onCompleteParams: [child2],useFrames: true, x: ApplicationManager.SCENE_WIDTH.toString()});
			}
			
			currentLoader = tempLoader;
			
		}

		protected function addSceneOnRight(index: int): void {	
			tempLoader = loaders[getNext()];	
		if (tempLoader.numChildren) {
				var child: MovieClip = tempLoader.getChildAt(0) as MovieClip;
				//child.visible = false;		
				tempLoader.removeChild(child);
				if (KILL_CHILDREN) child = null;
			}	
			var newscene: MovieClip = appManager.getSceneMovie(index) as MovieClip;
			tempLoader.x = ApplicationManager.SCENE_WIDTH;
			tempLoader.addChild(newscene);		
			//newscene.visible = true;	
			//move 2 mcs to left
			var child2: MovieClip = currentLoader.getChildAt(0) as MovieClip;
			if (!USE_SLIDE_TRANSITION) {
				tempLoader.x = 0;			
				currentLoader.x = -2000;				
				currentLoader.removeChild(child2);
				if (KILL_CHILDREN) child2 = null;
				System.gc();				
			} else {
				saveChangeSceneState = appManager.canChangeScene;
				appManager.disableSliding();
				
				TweenNano.killTweensOf(tempLoader, false);
				TweenNano.killTweensOf(currentLoader, false);
				TweenNano.to(tempLoader, ApplicationManager.SLIDE_TRANSITION_TIME, {useFrames: true, x: (0-ApplicationManager.SCENE_WIDTH).toString()});
				TweenNano.to(currentLoader, ApplicationManager.SLIDE_TRANSITION_TIME, {onComplete: onTweenComplete, onCompleteParams: [child2], useFrames: true, x: (0-ApplicationManager.SCENE_WIDTH).toString()});
			}
			currentLoader = tempLoader;			
		}			
		
		private function onTweenComplete(child: MovieClip): void {
			(child.parent as MovieClip).removeChild(child);
			if (KILL_CHILDREN) child = null;
			System.gc();
			initScreen();	
			if (USE_SLIDE_TRANSITION) {
				appManager.canChangeScene = saveChangeSceneState;
			}		
		}
	
		
		/*GET SET FUNCS*/
		public function get loaders():Array { return _loaders; }
		
		public function set loaders(value:Array):void {
			_loaders = value;
		}
		
		public function get mcIds():Array { return _mcIds; }
		
		public function set mcIds(value:Array):void {
			_mcIds = value;
			for (var i:int = 0; i < value.length; i++) {
				value[i].visible = false;				
				//(value[i] as MovieClip).cacheAsBitmap = true;
			}
		}
		
		public function get screenTrackings():Array { return _screenTrackings; }
		
		public function getScreenTrackingAt(index: int): String { 
			return (_screenTrackings[index] != null) ? _screenTrackings[index] : "";
		}
		
		public function set screenTrackings(value:Array):void {
			_screenTrackings = value;
		}
		
		//PDF scece handlers
		public function openPDF(pdfMovie: MovieClip):void {
			tempLoader = loaders[getNext()];	
			if (tempLoader.numChildren) {
				var child: MovieClip = tempLoader.getChildAt(0) as MovieClip;
				//child.visible = false;		
				tempLoader.removeChild(child);
				//child = null;
			}	
			var newscene: MovieClip = pdfMovie;
			tempLoader.x = currentLoader.x + ApplicationManager.SCENE_WIDTH;
			tempLoader.addChild(newscene);		
			//newscene.visible = true;	
			tempLoader.x = 0;			
			currentLoader.x = -2000;		
			currentLoader.visible = false;
			currentLoader = tempLoader;
			initScreen();
		}
		public function closePDF():void {
			tempLoader = loaders[getNext()];	
			tempLoader.x = currentLoader.x + ApplicationManager.SCENE_WIDTH;			
			//move 2 mcs to left
			tempLoader.x = 0;			
			tempLoader.visible = true;
			currentLoader.x = -2000;
			var child2: MovieClip = currentLoader.getChildAt(0) as MovieClip;
			currentLoader.removeChild(child2);
			if (KILL_CHILDREN) child2 = null;		
			System.gc();
			currentLoader = tempLoader;
			
			initScreen();
		}
		//end PDF scece handlers
	}

}