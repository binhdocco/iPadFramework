package com.binhdocco.transitions.hardcode { //binhpro.hardcode.ZoomFixMC
	import com.greensock.TweenMax;	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author binhdocco
		Example
			var mcs: Array = [mc1, mc2, mc3, mc4];
			var att: Array = [];
			
			var mc1_att: Object = new Object();
			mc1_att.active = true;
			mc1_att.att = new Array();
			mc1_att.att = [{scaleX:0.93, scaleY: 0.93, x: -443, y: -141.8, onComplete: showChart, onCompleteParams: [mc1], onStart: hideChart, onStartParams: [mc1]},
							 {scaleX:0.4, scaleY: 0.4, x: 68.3, y: 14.6},
							 {scaleX:0.5, scaleY: 0.5, x: 103, y: -20, onStart: hideChart, onStartParams: [mc3]},
							 {scaleX:0.8, scaleY: 0.8,  x: -180.2, y: -74.0, alpha: 0}];
			
			var mc2_att: Object = new Object();
			mc2_att.active = true;
			mc2_att.att = [{scaleX:0.4, scaleY: 0.4, x: -487.8, y: 14.6},
							 {scaleX:0.93, scaleY: 0.93, x: -234.1, y: -141.8, onComplete: showChart, onCompleteParams: [mc2], onStart: hideChart, onStartParams: [mc2]},
							 {scaleX:0.5, scaleY: 0.5, x: 103, y: -20, onStart: hideChart, onStartParams: [mc3]},
							  {scaleX:0.8, scaleY: 0.8,  x: -180.2, y: -74.0, alpha: 0}];
			
			var mc3_att: Object = new Object();
			mc3_att.active = true;
			mc3_att.att = [{scaleX:0.4, scaleY: 0.4, x: -487.8, y: 14.6},
							 {scaleX:0.4, scaleY: 0.4, x: -278.8, y: 14.6},
							 {scaleX:1.1, scaleY: 1.1, x: -387.8, y: -213.4},
							 {scaleX:0.8, scaleY: 0.8, x: -180.2, y: -74.0, alpha: 1}];
			
			var mc4_att: Object = new Object();
			mc4_att.active = false;
			
			att.push(mc1_att);
			att.push(mc2_att);
			att.push(mc3_att);
			att.push(mc4_att);
			
			import com.binhdocco.transitions.hardcode.HardcordSettingTransition;
			
			new HardcordSettingTransition(mcs, att);
			
			
			function showChart(mc) {
				mc.showChart();
			}
			function hideChart(mc) {
				mc.hideChart();	
			}

	 */
	public class HardcordSettingTransition extends EventDispatcher {
		
		protected var mcs: Array;
		protected var attributes: Array;
		protected var activeMC: MovieClip = null;
		protected var saveInitAtt: Array;
		
		protected var runFunc: Function;
		protected var normalFunc: Function;
		
		public function HardcordSettingTransition(mcs: Array, attributes: Array, runFunc: Function = null, normalFunc: Function = null) {
			this.mcs = mcs;			
			this.attributes = attributes;
			this.runFunc = runFunc;
			this.normalFunc = normalFunc;
			saveInitAtt = [];
			init();
		}
		
		protected function init():void{
			for (var i:int = 0; i < this.mcs.length; i++) {
				var mc: MovieClip = this.mcs[i] as MovieClip;
				
				if (this.attributes[i].active == true) {
					mc.mouseChildren = false;
					mc.buttonMode = true;
					mc.pos = i;
					mc.addEventListener(MouseEvent.CLICK, onClicked);					
				}
				
				saveInitAtt.push({scaleX: mc.scaleX, scaleY: mc.scaleY, x: mc.x, y: mc.y, alpha: mc.alpha});
			}
		}
		
		protected function onReturnNormal(e:MouseEvent = null):void {
			activeMC = null;
			for (var i:int = 0; i < saveInitAtt.length; i++) {
				var tempmc: MovieClip = this.mcs[i] as MovieClip;
				if (this.attributes[i].active == true) {
					tempmc.mouseChildren = false;				
					tempmc.buttonMode = true;
				}				
				if (normalFunc) normalFunc(tempmc);
				TweenMax.to(tempmc, 0.5, saveInitAtt[i] as Object);
			}
		}
		
		protected function onClicked(e:MouseEvent):void {
			TweenMax.killAllTweens(true);
			var mc: MovieClip = e.currentTarget as MovieClip;
			if (activeMC) {
				if (mc.name == activeMC.name) {									
					onReturnNormal();
					return;
				}
			}
			activeMC = mc;
			var att: Array = this.attributes[mc.pos].att as Array;						
			for (var i:int = 0; i < att.length; i++) {
				var tempmc: MovieClip = this.mcs[i] as MovieClip;
				if (this.attributes[i].active == true && tempmc.name != mc.name) {
					tempmc.mouseChildren = false;							
				}				
				if (runFunc) runFunc(tempmc);
				TweenMax.to(tempmc, 0.5, att[i] as Object);
			}
			mc.mouseChildren = true;			
		}		
	}
	
}