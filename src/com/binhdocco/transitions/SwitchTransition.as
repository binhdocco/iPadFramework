package com.binhdocco.transitions
{
	import com.binhdocco.events.DynamicEvent;
	import com.greensock.TweenNano;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class SwitchTransition extends EventDispatcher
	{
		public static const MOVIE_CLICKED_DEVENT: String = "movie_clicked";
		
		private var pages: Array;
		private var positions: Array;
		private var temppages: Array;
		private var activepage: MovieClip;
		
		public function SwitchTransition(mcs: Array) {
			super(null);
			
			this.pages = mcs;			
			init();
		}
		
		private function init(): void {
			positions = new Array();
			//trace(this.pages.length);
			for (var i:Number = 0; i < this.pages.length; i++) {
				var page: MovieClip = this.pages[i] as MovieClip;
				positions.push({ x : page.x, y : page.y, scaleX: page.scaleX, scaleY: page.scaleY, alpha: page.alpha });
				
				page.index = i;
				page.active = false;
				page.addEventListener(MouseEvent.CLICK, onPageClick);
				page.buttonMode = true;
				page.mouseChildren = false;
			}
			activepage = this.pages[0];
			activepage.mouseChildren = true;
			//activepage.useHandCursor = false;		
		}
		
		private function onPageClick(e:MouseEvent):void {
			activePage(e.currentTarget as MovieClip);		
			var event: DynamicEvent = new DynamicEvent(SwitchTransition.MOVIE_CLICKED_DEVENT);
			event.params = e.currentTarget as MovieClip;
			this.dispatchEvent(event);
		}
		
		
		
		private function activePage(page: MovieClip):void {			
			//trace("activePage: " + page.index);
			var index: Number = page.index;
			if (activepage != null) {
				activepage.mouseChildren = false;
				//activepage.useHandCursor = true;
			}
			for (var i:Number = 0; i < this.pages.length; i++) {
				var p: MovieClip = this.pages[i];
				var dis: Number = p.index - index;
				
				var pos: Number = 0;
				if (dis > 0) {
					pos = dis;
				} else if (dis < 0) {
					pos = this.pages.length + dis;
				}		
				p.index = pos;	
				
				TweenNano.to(p, 0.8, { x: positions[pos].x, y: positions[pos].y, scaleX: positions[pos].scaleX, scaleY: positions[pos].scaleY, alpha: positions[pos].alpha} );				
				p.parent.setChildIndex(p, this.pages.length - pos - 1);				
			}	
			
			activepage = page;
			activepage.mouseChildren = true;
			//activepage.useHandCursor = false;
		}
	}
}