//time: seconds: 0.5 means: .5s
//att: object contains {_x, _y, _xscale, _yscale, _alpha, _width, _height, onComplete, onCompleteParams, transition}
//transition values: easeNone, easeIn, easeOut
//					 bounceIn, bounceOut, bounceInOut
//					 elasticIn, elasticOut, elasticInOut
_global.bEngine = new Object();

_global.bEngine.to = function (mc: MovieClip, time: Number, att: Object) {
	if (mc.__bEngine_isTweening == true) {
		_global.bEngine.kill(mc, false);
	}
	mc.__bEngine_duration = time*1000;
	mc.__bEngine_isTweening == true;
	mc.__bEngine_tweenAtt = new Object();
	for (var ob in att) {
		if (ob == "onComplete") {
			mc.__bEngine_onComplete = att[ob];
		} else if (ob == "onCompleteParams") {
			mc.__bEngine_onCompleteParams = att[ob];
		} else if (ob == "transition") {
			mc.__bEngine_transition = att[ob];
		} else if (ob == "delay") {
			//not implementation
			//mc.__bEngine_delay = att[ob];
		}else {
			mc.__bEngine_tweenAtt[ob] = new Object();
			mc.__bEngine_tweenAtt[ob]["endValue"] = att[ob];
			mc.__bEngine_tweenAtt[ob]["startValue"] = mc[ob];
			mc.__bEngine_tweenAtt[ob]["change"] = att[ob] - mc[ob];			
		}		
	}	
	if (mc.__bEngine_transition == undefined) mc.__bEngine_transition = "easeNone";
	//if (mc.__bEngine_delay == undefined) mc.__bEngine_delay = 0;
	mc.__bEngine_update = function() {
		// get progress
		var currentDuration = getTimer() - this.__bEngine_startTime;				
		var _progress = _global.bEngine[this.__bEngine_transition](currentDuration, 0, 1, this.__bEngine_duration);
		
		if ( _progress > 1 ) _progress = 1;		
		for (var ob in this.__bEngine_tweenAtt) {			
			this[ob] = this.__bEngine_tweenAtt[ob]["startValue"] +  this.__bEngine_tweenAtt[ob]["change"]*_progress;
		}	
		//end animation
		if ( currentDuration >= this.__bEngine_duration ) {			
			delete this.onEnterFrame;
			if (this.__bEngine_onComplete != undefined) {
				this.__bEngine_onComplete(this.__bEngine_onCompleteParams);
			}
		}
	}
	mc.__bEngine_startTime = getTimer();
	//trace("begin tween");
	mc.onEnterFrame = function() {		
		this.__bEngine_update();
	}
}

_global.bEngine.kill = function(mc: MovieClip, forceFinish: Boolean) {
	delete mc.onEnterFrame;
	mc.__bEngine_isTweening == false;
	mc.__bEngine_onComplete = undefined;
	if (forceFinish == true) {
		for (var ob in mc.tweenAtt) {
			if (ob == "_x" || ob == "_y" || 
				ob == "_xscale" || ob == "_yscale" || 
				ob == "_width" || ob == "_height" || 
				ob == "_alpha") {
				mc[ob] = mc.tweenAtt[ob];			
			}
		}	
	}
}

//TRANSITION TYPE
_global.bEngine.easeNone = function(t:Number, b:Number, c:Number, d:Number):Number { return c*t/d+b; }
_global.bEngine.easeIn = function(t:Number, b:Number, c:Number, d:Number):Number { return c*(t /= d)*t*t*t*t+b; }
_global.bEngine.easeOut = function(t:Number, b:Number, c:Number, d:Number):Number { return c*((t=t/d-1)*t*t*t*t+1)+b; }

_global.bEngine.bounceOut = function(t:Number, b:Number, c:Number, d:Number):Number {
		if ((t/=d) < (1/2.75)) {
			return c*(7.5625*t*t) + b;
		} else if (t < (2/2.75)) {
			return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
		} else if (t < (2.5/2.75)) {
			return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
		} else {
			return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
		}
}
_global.bEngine.bounceIn = function (t:Number, b:Number, c:Number, d:Number):Number {
	return (c - _global.bEngine.bounceOut(d-t, 0, c, d) + b);
}
_global.bEngine.bounceInOut = function(t:Number, b:Number, c:Number, d:Number):Number {
	if (t < d/2) return _global.bEngine.bounceIn (t*2, 0, c, d) * .5 + b;
	else return _global.bEngine.bounceOut (t*2-d, 0, c, d) * .5 + c*.5 + b;
}

var _2PI:Number = Math.PI * 2;
_global.bEngine.elasticIn = function (t:Number, b:Number, c:Number, d:Number, a:Number, p:Number):Number {
	if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
	var s:Number;
	if (!a || a < Math.abs(c)) { a=c; s=p/4; }
	else s = p/_2PI * Math.asin (c/a);
	return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*_2PI/p )) + b;
}
_global.bEngine.elasticOut = function (t:Number, b:Number, c:Number, d:Number, a:Number, p:Number):Number {
	if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
	var s:Number;
	if (!a || a < Math.abs(c)) { a=c; s=p/4; }
	else s = p/_2PI * Math.asin (c/a);
	return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*_2PI/p ) + c + b);
}
_global.bEngine.elasticInOut = function (t:Number, b:Number, c:Number, d:Number, a:Number, p:Number):Number {
	if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
	var s:Number;
	if (!a || a < Math.abs(c)) { a=c; s=p/4; }
	else s = p/_2PI * Math.asin (c/a);
	if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*_2PI/p )) + b;
	return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*_2PI/p )*.5 + c + b;
}

MovieClip.prototype.setBrightness = function(level, wide){
	//USAGE:
	/*
	mc.setBrightness(0, true);//true mean use from -255 to 255
	mc.setBrightness(0, false);//true mean use from -100 to 100
	*/
     this.brightness = this.brightness ? this.brightness : new Color(this);
     var lb = Math.round(level * (wide ? 1 : 2.55));
     this.levels = {ra:100,rb:lb,ga:100,gb:lb,ba:100,bb:lb,aa:100,ab:lb};
     this.brightness.setTransform(this.levels);
}

