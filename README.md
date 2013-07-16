iPadFramework
=====

AS3 engine to play presentation on iOS, Android

+ Version 1.1.7	

+ Version 1.1.4 (08 Aug 2012)
	Change code-behind com.binhdocco.utils.DynamicMovie class to new class com.binhdocco.utils.ZoomMovie.

+ Version 1.1.4 (08 Aug 2012)
	SceneObject: not allow change scene when sliding.

+ Version 1.1.3 (25 Jun 2012)
	Add AppManager public functions: getDispatcher, gotoSceneWithIndex, showPDFWithName, hideCurrentPDF


+ Version 1.1.2 (25 Jun 2012)
	Add com.binhdocco.transitions: SimpleCoverFlow
	Add AppManager public functions: enableSliding, disableSliding
	
+ Version 1.1.1 (01 Jun 2012)
	Add com.binhdocco.utils.DynamicMovie
	
+ Version 1.1.0 (14 Dec 2011)
	Add transition package: SwitchTransition

+ Version 1.0.10 (16 Nov 2011)
	Add UIDUtil class to generate uid.
	
+ Version 1.0.9 (06 Oct 2011)
	Add KeepMouseDownOnTarget class for checking click mode or stand down mode.

+ Version 1.0.8 (06 Oct 2011)
	Add CheckMouseDoubleClick class for checking click or double click event.


+ Version 1.0.7 (27 Sept 2011)
	Add Utilities class for checking email, phone numbers.
	Fix bug device != "" on tracking.


+ Version 1.0.6 (Sept 2011)
	Add app_name in PersistenceObject.
	Add DynamicEvent class.
	
+ Version 1.0.5 (Aug 2011)
	Add IPhoneScroll2.
	
+ Version 1.0.4 (June 2011)
	_ Add IPhoneScroll class from http://www.shinedraw.com
		USE:
	 	+ Initialize: 
	 		var _scroller:IPhoneScroll = new IPhoneScroll( mcContent.mcPage, stage );
			_scroller.canvasHeight = 366;
		+ Destroy:
			_scroller.release();
			_scroller = null;
		+ Restart:
			_scroller.stop();
			_scroller.myScrollElement.y = 0;
			_scroller.start();

+ Version 1.0.3 (April 2011)
	_ Fix tracking bugs