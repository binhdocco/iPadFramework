package com.binhdocco.managers {
	import com.binhdocco.dispatcher.Dispatcher;
	import com.binhdocco.events.AppEvent;
	import com.binhdocco.events.GotoSceneEvent;
	import com.binhdocco.events.LogEvent;
	import com.binhdocco.events.NavigationEvent;
	import com.binhdocco.events.SceneEvent;
	import com.binhdocco.navigationobjects.NavigationObject;
	import com.binhdocco.persistenceobjects.RestoreLastScreen;
	import com.binhdocco.sceneobjects.SceneObject;
	
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author binhdocco

	 */
	public class ApplicationManager {
		
		public static var SCENE_WIDTH: int = 1024;
		public static var SCENE_HEIGHT: int = 768;
		public static var SLIDE_TRANSITION_TIME: Number = 8;
		public static var CAN_RELOAD_WHEN_ACTIVE: Boolean = false;
		
		public var stage: Stage;
		private var sceneObj: SceneObject;
		private var navObj: NavigationObject;
		
		public var activeSceneIndex: int = 0;
		public var activeVerSubSceneIndex: int = 0;
		private var totalScene: int = -1;		
		
		private var timeObj: Object = new Object();
		public var canChangeScene: Boolean = true;
		private var dispatcher: Dispatcher;
		
		private static var instance: ApplicationManager;
		
		public var menuIndex: uint = 0;
		public var fromScene: uint = 0;
		public var getSceneMovie: Function;
		public var allMoviesLength: int = 0;
		
		public var log: String = "";
		public var runFirstTime: Boolean = true;
		
		private var restoreObj: RestoreLastScreen;
		public var sharedVars: Object = new Object();
		
		
		public static function getInstance(): ApplicationManager {
			if (instance == null) {
				instance = new ApplicationManager();
			}
			return instance;
		}
		
		
		public function initApp(stage: Stage, scene: SceneObject, nav: NavigationObject): void {
			this.stage = stage;
			this.sceneObj = scene;
			this.navObj = nav;
			this.dispatcher = new Dispatcher();
			this.restoreObj = RestoreLastScreen.getInstance();
			
			//listen GotoSceneEvent.GOTO_SCENE_EVENT
			dispatcher.addEventListener(GotoSceneEvent.GOTO_SCENE_EVENT, onGotoSceneHandler); 
			dispatcher.addEventListener(GotoSceneEvent.GOTO_SCENE_BY_OFFSET_EVENT, onGotoSceneByOffsetHandler); 
			dispatcher.addEventListener(GotoSceneEvent.OPEN_PDF_EVENT, onOpenPDFHandler); 
			dispatcher.addEventListener(GotoSceneEvent.CLOSE_PDF_EVENT, onClosePDFHandler); 
			
			//listen SceneEvent
			dispatcher.addEventListener(SceneEvent.CHANGE_UNAVAILABLE, onCanNotChangeScene);
			dispatcher.addEventListener(SceneEvent.CHANGE_AVAILABLE, onCanChangeScene);			
			//log event
			dispatcher.addEventListener(LogEvent.ADD_LOG, onAddLog);
		}
		
		private function onAddLog(e:LogEvent):void {
			if (log != "") log += "\n";
			log += e.textLog;
		}
		
		private function onClosePDFHandler(e:GotoSceneEvent):void {
			this.canChangeScene = true;
			dispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.SHOW));
			//if (this.stage) stage.quality = StageQuality.LOW;
			sceneObj.closePDF();
			
			onSlideComplete();
			
		}
		
		//PUBLIC COMMON FUNCS
		public function enableSliding(): void {
			onCanChangeScene(null);
		}
		
		public function disableSliding(): void {
			onCanNotChangeScene(null);
		}
		
		public function getDispatcher(): Dispatcher {
			return this.dispatcher;
		}
		
		public function gotoSceneWithIndex(sceneIndex: uint): void {
			dispatcher.dispatchEvent(new GotoSceneEvent(GotoSceneEvent.GOTO_SCENE_EVENT, sceneIndex));
		}
		
		public function showPDFWithName(pdfName: String): void {
			var pdfE: AppEvent = new AppEvent(AppEvent.SHOW_PDF);
			pdfE.pdfInstanceName = pdfName;
			dispatcher.dispatchEvent(pdfE);
		}
		
		public function hideCurrentPDF(): void {
			dispatcher.dispatchEvent(new GotoSceneEvent(GotoSceneEvent.CLOSE_PDF_EVENT));
		}
		
		// end
		
		private function onOpenPDFHandler(e:GotoSceneEvent):void {
			this.canChangeScene = false;
			dispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.HIDE));
			sceneObj.destroyScreen();

			
			/*var obj: Object = new Object();
			if (this.stage) stage.quality = StageQuality.LOW;
			obj.useFrames = true;
			obj.onComplete = onSlideComplete;
			obj.onCompleteParams = [0];				
			TweenNano.to(timeObj, SLIDE_TRANSITION_TIME, obj);*/
			sceneObj.openPDF(e.pdfMovie);
			
			onSlideComplete();
		}
		
		private function onCanChangeScene(e:SceneEvent):void {
			this.canChangeScene = true;
		}
		
		private function onCanNotChangeScene(e:SceneEvent):void {
			this.canChangeScene = false;
		}
		
		private function onGotoSceneHandler(e:GotoSceneEvent):void {
			this.gotoScene(e.sceneIndex);
		}		
		
		private function onGotoSceneByOffsetHandler(e:GotoSceneEvent):void {
			//check if we can not change scene
			if (!canChangeScene) return;
			
			this.gotoScene(e.sceneOffset[0]);
			setTimeout(goSceneByOffset, 800, e.sceneOffset);
			
		}	
		
		private function goSceneByOffset(sceneOffset: Array): void {
			//this.navObj.activeMenuAtOffset(sceneOffset);
			var evt: NavigationEvent = new NavigationEvent(NavigationEvent.CHANGED_BY_OFFSET);
			evt.offset = sceneOffset;
			dispatcher.dispatchEvent(evt);
		}

		private function activeSlide(index: int): void {
			//save last screen index
			restoreObj.saveLastScreen(index);
			//
			activeSceneIndex = index;	
			
			if (SceneObject.CHANGE_STAGE_QUALITY_WHEN_SLIDING) {
				if (this.stage) stage.quality = StageQuality.MEDIUM;
			}
			
			// dispatch NavigationEvent.CHANGED event
			var navChangedEvent: NavigationEvent = new NavigationEvent(NavigationEvent.CHANGED);
			navChangedEvent.navIndex = activeSceneIndex;
			dispatcher.dispatchEvent(navChangedEvent);
			
			navObj.slideScreen(activeSceneIndex, 0);
			
			onSlideComplete();
			
		}

		private function onSlideComplete(index: int = 0): void {
			//sceneObj.initScreen();
			//if (this.stage) stage.quality = StageQuality.HIGH;
		}
		
		/*PUBLIC FUNCS*/
		
		public function setActiveSceneIndex(index: int):void {
			activeSceneIndex = index;
		}
		
		public function slideScene(directionX: Number): void {
			//check if we can not change scene
			if (!canChangeScene) return;
			//
			
			/*if (totalScene == -1)*/ totalScene = sceneObj.getSceneLength();
			var tempIndex: int = activeSceneIndex;
			if (directionX < 0)  { // move left
				tempIndex ++;
				if (tempIndex < totalScene) {			
				} else {
					tempIndex = totalScene - 1;
				}
			} else if (directionX > 0) { //move right
				tempIndex --;
				if (tempIndex >= 0) {			
				} else {
					tempIndex = 0;
				}
			}
			
			activeSlide(tempIndex);
		}

		public function slideSubScene(directionY: int): void {
			//check if we can not change scene
			if (!canChangeScene) return;
			//
			if (Math.abs(directionY) > 0) {
				sceneObj.slideScreen(activeSceneIndex, directionY);
				navObj.slideScreen(activeSceneIndex, directionY);
			}
		}

		public function gotoScene(sceneIndex: int): void {
			//check if we can not change scene
			if (!canChangeScene) return;
			if (!ApplicationManager.CAN_RELOAD_WHEN_ACTIVE) if (sceneIndex == activeSceneIndex) return;
			//
			sceneObj.destroyScreen();
			activeSlide(sceneIndex);
		}
		
	}

}