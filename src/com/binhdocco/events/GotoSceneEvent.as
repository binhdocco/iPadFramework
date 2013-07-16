package  com.binhdocco.events {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class GotoSceneEvent extends Event {
		
		public static const GOTO_SCENE_EVENT: String = "GOTO_SCENE_EVENT";
		public static const GOTO_FRAME_EVENT: String = "GOTO_FRAME_EVENT";
		public static const GOTO_SCENE_BY_OFFSET_EVENT: String = "GOTO_SCENE_BY_OFFSET_EVENT";
		public static const OPEN_PDF_EVENT: String = "OPEN_PDF_EVENT";
		public static const CLOSE_PDF_EVENT: String = "CLOSE_PDF_EVENT";
		
		public var sceneIndex: int = 0;
		public var sceneOffset: Array = [];
		public var pdfMovie: MovieClip;

		public function GotoSceneEvent(type: String = "GOTO_SCENE_EVENT", params: * = null) {
			// constructor code
			if (params != null) {
				if (params is Array) {
					sceneOffset = params as Array;
				} else if (params is MovieClip) {
					pdfMovie = params as MovieClip;
				} else sceneIndex = params as int;
			}			
			super(type);
		}

	}
	
}
