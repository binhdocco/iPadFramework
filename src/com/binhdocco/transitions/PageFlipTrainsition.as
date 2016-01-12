package com.binhdocco.transitions
{
	import com.greensock.TweenNano;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

	public class PageFlipTrainsition extends EventDispatcher {
		
		private var pageContainer: MovieClip;
		private var holder: MovieClip;
		
		private var page1: MovieClip;
		private var page2: MovieClip;
		
		private var obj: Object;
		private var dur: Number;
		public function PageFlipTrainsition(pageContainer: MovieClip, holder: MovieClip, duration: Number = 0.5)
		{
			this.pageContainer = pageContainer;
			this.holder = holder;
			page1 = holder.getChildAt(0);
			page2 = holder.getChildAt(1);
			
			page2.visible = false;
			page2.rotationY = 180;
			
			obj = new Object();
			obj.t = 0;
			
			dur = duration;
		}
		
		public function flip(): void {
			TweenNano.killTweensOf(obj, true);
			obj.t %= 360;
			
			TweenNano.to(obj, dur, {t: "180", onUpdate: this.onTweenUpdate});
		}
		
		private function onTweenUpdate(): void {
			var t = obj.t;			
			if ( (t < 90) || (t > 270) ) {
				page1.visible = true;
				page2.visible = false;
			}
			else {
				page1.visible = false;
				page2.visible = true;
			}
			pageContainer.rotationY = t;
		}
	}
}