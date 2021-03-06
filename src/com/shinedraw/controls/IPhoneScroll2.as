/****************************************************************************

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

-- A iPhone Scroll in AS3
-- Copyright 2009 Terence Tsang
-- admin@shinedraw.com
-- http://www.shinedraw.com
-- Your Flash vs Silverlight Repository

----------------------------------------------------------------------

-- Naftali: http://naftali.com.br --

This class was modified by Naftali to attend his needs in a 
project.

All the movement and core algorithms were not modified.
Below is a list of modifications I did.

08-25-2010:
	* Changed the extends from MovieClip to none
	* Removed myCanvas and added the listeners directly to the content
	* Created the release method to remove the listeners and the pointer to the movieclip
	* Added the stage property, which come as a parameter in the constructor
	* Changed _myScrollElement to be a DisplayObjectContainer, instead of a MovieClip
	* _canvasHeight receives the Height from the movieclip
	* Added the "canvasHeight" property for when that needs to be changed
	* Changed BOUNCING_SPRINGNESS from 0.08 to 0.2
	* Added percPosition property to make it easy to create a ScrollBar outside of this class
	* Added the "stop" property so that this item can be controlled outside without interfering with this process
	* created a property for "myScrollItem"
	* 
	* USE:
	* 	+ Initialize: 
	* 		var _scroller:IPhoneScroll = new IPhoneScroll( mcContent.mcPage, stage );
			_scroller.canvasHeight = 366;
		+ Destroy:
			_scroller.release();
			_scroller = null;
		+ Restart:
			_scroller.stop();
			_scroller.myScrollElement.y = 0;
			_scroller.start();

****************************************************************************/


package com.shinedraw.controls {
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.display.MovieClip;

	public class IPhoneScroll2 {

		// Constant variables
		public static var DECAY:Number = 0.93;
		public static var MOUSE_DOWN_DECAY:Number = 0.5;
		public static var SPEED_SPRINGNESS:Number = 0.4;
		public static var BOUNCING_SPRINGESS:Number = 0.2;

			// variables
		private var _mouseDown:Boolean = false;

		private var _velocityX:Number = 0;
		private var _velocityY:Number = 0;

		private var _mouseDownX:Number = 0;
		private var _mouseDownY:Number = 0;

		private var _mouseDownPoint:Point = new Point();
		private var _lastMouseDownPoint:Point = new Point();
				
		// elements
	        private var _canvasWidth:Number = 0;
		private var _canvasHeight:Number = 0;

		private var _myScrollElement:DisplayObjectContainer;
		private var _stage:Stage;
		private var _started:Boolean;
		
		public function IPhoneScroll2( pContent:DisplayObjectContainer, pStage:Stage ) {
			_stage = pStage;
			_myScrollElement = pContent;
			
			_canvasHeight = _myScrollElement.height;
			_canvasWidth = _myScrollElement.width;
			
			start();
			
			// add handlers
			_myScrollElement.addEventListener(MouseEvent.MOUSE_DOWN, on_mouse_down);
			_myScrollElement.addEventListener(Event.ENTER_FRAME, on_enter_frame);
		}
		
		private function on_enter_frame(e:Event):void {
			if ( started )
			{
				// decay the velocity
				if(_mouseDown){
					_velocityX *= MOUSE_DOWN_DECAY;
					_velocityY *= MOUSE_DOWN_DECAY;
				}else{
					_velocityX *= DECAY;
					_velocityY *= DECAY;
				}
				
				
				// if not mouse down, then move the element with the velocity
				if (!_mouseDown)
				{
					var textWidth:Number = _myScrollElement.width;
					var textHeight:Number = _myScrollElement.height;

					var x:Number = _myScrollElement.x;
					var y:Number = _myScrollElement.y;

					var bouncingX:Number = 0;
					var bouncingY:Number = 0;
					
					// calculate a bouncing when the text moves over the canvas size
					if (x > 0)
					{
						bouncingX = -x * BOUNCING_SPRINGESS;
					}else if( x + textWidth < _canvasWidth){
						bouncingX = (_canvasWidth - textWidth - x) * BOUNCING_SPRINGESS;
					}

					if (y > 0)
					{
						bouncingY = -y * BOUNCING_SPRINGESS;
					}else if( y + textHeight < _canvasHeight){
						bouncingY = (_canvasHeight - textHeight - y) * BOUNCING_SPRINGESS;
					}
					
					_myScrollElement.x = x + _velocityX + bouncingX;
					_myScrollElement.y = y + _velocityY + bouncingY;
				}
			}
		}
		
		// when mouse button up
        private function on_mouse_down(e:MouseEvent):void
        {
            if (!_mouseDown)
            {
                // get some initial properties
                _mouseDownPoint = new Point(e.stageX, e.stageY);
                _lastMouseDownPoint = new Point(e.stageX, e.stageY);
                _mouseDown = true;

                _mouseDownX = _myScrollElement.x;
		_mouseDownY = _myScrollElement.y;

		// add some more mouse handlers
                _stage.addEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
                _stage.addEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move);
            }
        }

        // when mouse is moving
        private function  on_mouse_move(e:MouseEvent):void
        {
            if (_mouseDown)
            {
                // update the element position
                var point:Point = new Point(e.stageX, e.stageY);
                
		_myScrollElement.x = _mouseDownX + (point.x - _mouseDownPoint.x);
		_myScrollElement.y = _mouseDownY + (point.y - _mouseDownPoint.y);

                // update the velocity
                _velocityX += ((point.x - _lastMouseDownPoint.x) * SPEED_SPRINGNESS);
		_velocityY += ((point.y - _lastMouseDownPoint.y) * SPEED_SPRINGNESS);
                _lastMouseDownPoint = point;
            }
        }

        // clear everythign when mouse up
        private function  on_mouse_up(e:MouseEvent):void
        {
            if (_mouseDown)
            {
                _mouseDown = false;
                _stage.removeEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
                _stage.removeEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move);
            }
        }
		
		public function release():void
		{
			_myScrollElement.removeEventListener(MouseEvent.MOUSE_DOWN, on_mouse_down);
			_myScrollElement.removeEventListener(Event.ENTER_FRAME, on_enter_frame);
			
			_myScrollElement = null;
		}
		
		public function start():void
		{
			_started = true;
		}
		
		public function stop():void
		{
			_started 	= false;

			_velocityX 	= 0;
			_velocityY 	= 0;
		}
		
		public function set canvasWidth( pVal:Number ):void
		{
			_canvasWidth = pVal;
		}
		
		public function get canvasWidth():Number
		{
			return _canvasWidth;
		}

		public function set canvasHeight( pVal:Number ):void
		{
			_canvasHeight = pVal;
		}
		
		public function get canvasHeight():Number
		{
			return _canvasHeight;
		}

		public function get percPositionX():Number
		{
			var finalPos:Number 	= _canvasWidth - _myScrollElement.width;
			var currentPos:Number 	= _myScrollElement.x;
			
			return currentPos / finalPos;
		}
		
		public function get percPositionY():Number
		{
			var finalPos:Number 	= _canvasHeight - _myScrollElement.height;
			var currentPos:Number 	= _myScrollElement.y;
			
			return currentPos / finalPos;
		}
		
		public function get started():Boolean { return _started; }
		
		public function set started(value:Boolean):void 
		{
			if ( value ) 	start();
			else			stop();
		}
		
		public function get myScrollElement():DisplayObjectContainer { return _myScrollElement; }
	}
}