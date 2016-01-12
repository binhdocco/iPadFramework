package com.binhdocco.utils
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	[Event(name="click", type="flash.events.Event")]
	[Event(name="double", type="flash.events.Event")]
	
	public class CheckMouseDragClick extends EventDispatcher	{
		
		public static const DRAG_EVENT: String = "DRAG_EVENT";
		public static const DRAGGING_EVENT: String = "DRAGGING_EVENT";
		public static const CLICK_EVENT: String = "CLICK_CLICK_EVENT";
		
		private var mcTarget: MovieClip;
		private var thestage: Object;		
		private var isDragging: Boolean = false;
		
		
		public function CheckMouseDragClick(target: Object, mcstage: Object)	{
			target.addEventListener(MouseEvent.MOUSE_DOWN, onSingleClicked);
			this.mcTarget = target;
			thestage = mcstage;
			isDragging = false;
		}
		
		
		private function onSingleClicked(e: MouseEvent): void {
			mcTarget.addEventListener(MouseEvent.MOUSE_MOVE, onMMove);
			thestage.addEventListener(MouseEvent.MOUSE_UP, onMUp);				
		}
		
		private function onMMove(e: MouseEvent): void {
			if (!isDragging) {
				isDragging = true;	
				this.dispatchEvent(new Event(CheckMouseDragClick.DRAGGING_EVENT));		
			}					
		}
		private function onMUp(e: MouseEvent): void {
			mcTarget.removeEventListener(MouseEvent.MOUSE_MOVE, onMMove);
			thestage.removeEventListener(MouseEvent.MOUSE_UP, onMUp);		
			
			if (isDragging == true) {
				this.dispatchEvent(new Event(CheckMouseDragClick.DRAG_EVENT));
			} else			
				this.dispatchEvent(new Event(CheckMouseDragClick.CLICK_EVENT));
			isDragging = false;			
		}

	}
}