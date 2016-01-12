package com.binhdocco.utils
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class SWFAssetPreloader extends EventDispatcher
	{
		public static var DEBUG: Boolean = true;
		
		private var lm: LoaderMax;
		private var alldone: Boolean = false;	
		private var loaderName: String;	
		
		public function SWFAssetPreloader(xmlUrl: String, loaderName: String, target:IEventDispatcher=null)
		{			
			super(target);
			this.loaderName = loaderName;
			LoaderMax.activate([SWFLoader]);
			var xmlLoader: XMLLoader = new XMLLoader(xmlUrl, {onComplete:xmlCompleteHandler, estimatedBytes:50000});
			xmlLoader.load();					
		}
		
		private function xmlCompleteHandler(e: LoaderEvent): void {			
			if (SWFAssetPreloader.DEBUG) trace("[SWFAssetPreloader] xmlCompleteHandler: " + e.data);
			(e.currentTarget as XMLLoader).removeEventListener(LoaderEvent.COMPLETE, xmlCompleteHandler);
			
			lm = LoaderMax.getLoader(loaderName);
			lm.addEventListener(LoaderEvent.CHILD_COMPLETE, childCompleteHandler);
			lm.addEventListener(LoaderEvent.COMPLETE, completeHandler);
			lm.addEventListener(LoaderEvent.PROGRESS, progressHandler);
			lm.load();			
		}
		
		private function progressHandler(e: LoaderEvent): void {			
			if (SWFAssetPreloader.DEBUG) trace("[SWFAssetPreloader] progressHandler: " + e.target.progress); 
			//dispatchEvent(e);
		}
		
		private function completeHandler(e: LoaderEvent): void {			
			if (SWFAssetPreloader.DEBUG) trace("[SWFAssetPreloader] completeHandler");
			lm.removeEventListener(LoaderEvent.CHILD_COMPLETE, childCompleteHandler);
			lm.removeEventListener(LoaderEvent.COMPLETE, completeHandler);
			lm.removeEventListener(LoaderEvent.PROGRESS, progressHandler);
			//dispatchEvent(e);
		}

		private function errorHandler(e: LoaderEvent): void {			
			if (SWFAssetPreloader.DEBUG) trace("[SWFAssetPreloader] errorHandler: " + e.target);
			//dispatchEvent(e);
		}

		public function pause(): void {
			if (SWFAssetPreloader.DEBUG) trace("[SWFAssetPreloader] pause, alldone: " + alldone);
			if (!alldone && !lm.paused) lm.pause();
		}
		
		public function resume(): void {
			if (SWFAssetPreloader.DEBUG) trace("[SWFAssetPreloader] resume, alldone: " + alldone);
			if (!alldone && lm.paused) lm.resume();			
		}
		
		public function cancel(): void {
			if (SWFAssetPreloader.DEBUG) trace("[SWFAssetPreloader] cancel");
			lm.cancel();		
		}
		
	}
}