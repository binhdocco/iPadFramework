package com.binhdocco.transitions { // com.binhdocco.display.SimpleCoverFlow
	import com.binhdocco.dispatcher.Dispatcher;
	import com.binhdocco.events.DynamicEvent;
	import com.greensock.TweenNano;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;	
	
	/**
	 * ...
	 * @author binhdocco

	 */
	public class SimpleCoverFlow extends EventDispatcher {
		
		public static const MOVIE_CLICKED_DEVENT: String = "movie_clicked";
		public static const MOVIE_ACTIVE_CLICKED_DEVENT: String = "movie_active_clicked";
		
		private var pages: Array;
		private var positions: Array;
		private var temppages: Array;
		private var activepage: MovieClip;
		private var dispatcher: Dispatcher;
		
		public function SimpleCoverFlow(mcs: Array) {
			this.pages = mcs;
			dispatcher = new Dispatcher();
			initEvents();
		}
		
		private function initEvents(): void {
			positions = new Array();
			//trace(this.pages.length);
			for (var i:Number = 0; i < this.pages.length; i++) {
				var page: MovieClip = this.pages[i] as MovieClip;
				positions.push({ x : page.x, y : page.y, scaleX: page.scaleX, scaleY: page.scaleY });
				
				page.index = i;
				page.active = false;
				page.addEventListener(MouseEvent.CLICK, onPageClick);
				//page.buttonMode = true;
				page.mouseChildren = false;
				page.doubleClickEnabled = true;
			}
			activepage = this.pages[0];
			
			//activepage.addEventListener(MouseEvent.DOUBLE_CLICK, onDouble);
			//activepage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);					
		}
		
		private function onDouble(e: MouseEvent): void {
			var page: MovieClip = e.currentTarget as MovieClip;
			page.scaleX = 1;
			page.scaleY = 1;
		}
		
		private function onPageClick(e:MouseEvent):void {
			e.stopImmediatePropagation();
			var page: MovieClip = e.currentTarget as MovieClip;
			var dE: DynamicEvent;
			if (page != activepage) {
				dE = new DynamicEvent(SimpleCoverFlow.MOVIE_CLICKED_DEVENT);
				dE.params = page;
				this.dispatchEvent(dE);
				activePage(page);		
			} else {
				dE = new DynamicEvent(SimpleCoverFlow.MOVIE_ACTIVE_CLICKED_DEVENT);
				dE.params = page;
				this.dispatchEvent(dE);				
			} 			
		}
		
		
		
		private function activePage(page: MovieClip):void {			
			var savePos: Object = {x: page.x, y: page.y, scaleX: page.scaleX, scaleY: page.scaleY };
			TweenNano.to(activepage, 0.5, savePos );				
			//activepage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);
			//activepage.removeEventListener(MouseEvent.DOUBLE_CLICK, onDouble);
			activepage = page;
			TweenNano.to(page, 0.5, this.positions[0] );				
			activepage.parent.setChildIndex(activepage, activepage.parent.numChildren - 1);	
			//activepage.addEventListener(MouseEvent.DOUBLE_CLICK, onDouble);
			//page.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);
		}
		/*
		private function onZoom(e: TransformGestureEvent): void {
			e.stopImmediatePropagation();
			var mc: MovieClip = (e.currentTarget as MovieClip);
			mc.scaleX *= e.scaleX;
			mc.scaleY *= e.scaleX;
			
			if (mc.scaleX > 1.8) {
				mc.scaleX = 1.8;
				mc.scaleY = 1.8;
			} else if (mc.scaleX < 1) {
				mc.scaleX = 1;
				mc.scaleY = 1;
			}
		}
		
		public function init(): void {
			activepage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);
			activepage.addEventListener(MouseEvent.DOUBLE_CLICK, onDouble);
		}

		public function destroy(): void {
			activepage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);
			activepage.removeEventListener(MouseEvent.DOUBLE_CLICK, onDouble);
		}
		*/
	}
	
}