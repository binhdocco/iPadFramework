package com.binhdocco.utils
{
	import flash.display.MovieClip;
	import flash.geom.Point;

	/**
	 * Extends MovieClip adding a dynamic registration point
	 *
	 * Based on AS2 work by Darron Schall (www.darronschall.com)
	 * Original AS1 code by Robert Penner (www.robertpenner.com)
	 *
	 * @author Oscar Trelles
	 * @version 1.0
	 * @created 12-Mar-2007 11:53:50 AM
	 */
	public class ZoomMovie
	{
		public var rp:Point;
		public var mc:MovieClip;

		function ZoomMovie(_mc:MovieClip)
		{	
			mc = _mc;
			setRegistration();
		}

		public function setRegistration(x:Number=0, y:Number=0):void
		{
			rp = new Point(x, y);
		}

		public function get x2():Number
		{
			var p:Point = mc.parent.globalToLocal(mc.localToGlobal(rp));
			return p.x;
		}

		public function set x2(value:Number):void
		{
			var p:Point = mc.parent.globalToLocal(mc.localToGlobal(rp));
			mc.x += value - p.x;
		}

		public function get y2():Number
		{
			var p:Point = mc.parent.globalToLocal(mc.localToGlobal(rp));
			return p.y;
		}

		public function set y2(value:Number):void
		{
			var p:Point = mc.parent.globalToLocal(mc.localToGlobal(rp));
			mc.y += value - p.y;
		}

		public function get scaleX2():Number
		{
			return mc.scaleX;
		}

		public function set scaleX2(value:Number):void
		{
			try{
				this.setProperty2("scaleX", value);
			}catch(e:Error){
				
			}
		}

		public function get scaleY2():Number
		{
			return mc.scaleY;
		}

		public function set scaleY2(value:Number):void
		{
			try{
				this.setProperty2("scaleY", value);
			}catch(e:Error){
				
			}
		}

		public function get rotation2():Number
		{
			return mc.rotation;
		}

		public function set rotation2(value:Number):void
		{
			try{
				mc.setProperty2("rotation", value);
			}catch(e:Error){
				
			}
		}

		public function get mouseX2():Number
		{
			return Math.round(mc.mouseX - rp.x);
		}

		public function get mouseY2():Number
		{
			return Math.round(mc.mouseY - rp.y);
		}

		public function setProperty2(prop:String, n:Number):void
		{
			try{
				var a:Point = mc.parent.globalToLocal(mc.localToGlobal(rp));
	
				mc[prop] = n;
	
				var b:Point = mc.parent.globalToLocal(mc.localToGlobal(rp));
	
				mc.x -= b.x - a.x;
				mc.y -= b.y - a.y;
			}catch(e:Error){
				
			}
		}
	}
}