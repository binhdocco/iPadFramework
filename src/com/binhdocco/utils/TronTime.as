package com.binhdocco.utils {
	/**
	 * ...
	 * @author binhdocco

	 */
	public class TronTime {
		
		public function TronTime(){}
		
		/**
		 * 	Convert numeric time to English
		 * 	Example: 71 --> 1 hour and 21 minutes
		 */
		public static function convertTime_minutesToHoursMin( minutes:int ):String {
			var _hours:int = Math.floor( minutes / 60 );
			var _min:int = minutes % 60;
			
			if( minutes == 0 ) {
				return "less than a minute";
			}
			
			var _time:String;
			if( _hours > 0 ) { // get hours and mintutes
				_time = ( _hours > 1 ) ? _hours + " hours " : _hours + " hour ";
				if( _min > 0 ) {
					_time += ( _min > 1 ) ? "and " + _min + " minutes" : "and 1 minute";
				}
			} else { // just get minutes
				_time = ( _min > 1 ) ? _min + " minutes" : "1 minute";
			}
			return _time;
		}
		
		/**
		 * Get the name of the day from the date
		 */
		public static function getDayNameFromDate( date:Date ):String {
			switch( date.day ) {
				case 0 :
					return 'Sunday';
				case 1 :
					return 'Monday';
				case 2 :
					return 'Tuesday';
				case 3 :
					return 'Wednesday';
				case 4 :
					return 'Thursday';
				case 5 :
					return 'Friday';
				case 6 :
					return 'Saturday';
				default :
					return '';
			}
		}
		
		/**
		 * Get the month name from the date
		 */
		public static function getMonthNameFromDate( date:Date ):String {
			switch( date.month ) {
				case 0 :
					return 'January';
				case 1 :
					return 'February';
				case 2 :
					return 'March';
				case 3 :
					return 'April';
				case 4 :
					return 'May';
				case 5 :
					return 'June';
				case 6 :
					return 'July';
				case 7 :
					return 'August';
				case 8 :
					return 'September';
				case 9 :
					return 'October';
				case 10 :
					return 'November';
				case 11 :
					return 'December';
				default :
					return '';
			}
		}
		
		/**
		 * 	Get MySQL string from date
		 */
		public static function getMySQLDate( date:Date ):String {
			var s:String = date.fullYear + '-';
			
			// add the month
			if( date.month < 10 ) {
				s += '0' + ( date.month + 1 ) + '-';
			} else {
				s += ( date.month + 1 ) + '-';
			}
			
			// add the day
			if( date.date < 10 ) {
				s += '0' + date.date;
			} else {
				s += date.date;
			}
			
			return s;
		}
		
		/**
		 * Make a Date object from a MySQL date string
		 */
		public static function convertMySQLDateToActionscript( s:String ):Date {
			var a:Array = s.split( '-' );
			return new Date( a[0], a[1] - 1, a[2] );
		}
		
		/**
		 * 	Convert an MySQL Timestamp to an Actionscript Date
		 * 	Thanks to Pascal Brewing brewing@alice-dsl.de for the beautiful simplicity.
		 */
		public static function convertMySQLTimeStampToASDate( time:String ):Date{
			var pattern:RegExp = /[: -]/g;
			time = time.replace( pattern, ',' );
			var timeArray:Array = time.split( ',' );
			var date:Date = new Date( 	timeArray[0], timeArray[1]-1, timeArray[2],
										timeArray[3], timeArray[4], timeArray[5] );
			return date as Date;
		}
		
		/**
		 * 	Convert an MySQL Timestamp to an Actionscript Date
		 * 	Thanks to Pascal Brewing brewing@alice-dsl.de for the beautiful simplicity.
		 */
		public static function convertASDateToMySQLTimestamp( d:Date ):String {
			var s:String = d.fullYear + '-';
			s += prependZero( d.month + 1 ) + '-';
			s += prependZero( d.date ) + ' ';
			
			s += prependZero( d.hours ) + ':';
			s += prependZero( d.minutes ) + ':';
			s += prependZero( d.seconds );			
			
			return s;
		}
		
		private static function prependZero( n:Number ):String {
			var s:String = ( n < 10 ) ? '0' + n : n.toString();
			return s;
		}
		
		/********************************
		 * 	The following three methods are useful for video player time displays
		 ********************************/
		
		/**
		 * 	Input the seconds and return a string of the form: hours:mins:secs
		 */
		public static function convertSecondsTo_HoursMinsSec( seconds:int ):String {
			var timeOut:String;
			var hours:int = int( seconds / 3600 );
			var mins:int = int( ( seconds - ( hours * 3600 ) ) / 60 )
			var secs:int = seconds % 60;
			
			if( isNaN( hours ) || isNaN( mins ) || isNaN( secs ) ) {
				return "--:--:--";
			}
			
			var minS:String = ( mins < 10 ) ? "0" + mins : String( mins );
			
			var secS:String = ( secs < 10 ) ? "0" + secs : String( secs );
			
			var hourS:String = String( hours );
			timeOut = hourS + ":" + minS + ":" + secS;
			return timeOut;	
		}
		
		/**
		 * 	Input the seconds and return a string of the form: mins:sec
		 */
		public static function convertSecondsTo_MinsSec( seconds:int ):String {
			var timeOut:String;
			var mins:int = int( seconds / 60 )
			var secs:int = seconds % 60;
			
			if( isNaN( mins ) || isNaN( secs ) ) {
				return "--:--";
			}
			
			var minS:String = ( mins < 10 ) ? "0" + mins : String( mins );
			var secS:String = ( secs < 10 ) ? "0" + secs : String( secs );
			
			timeOut = minS + ":" + secS;
			return timeOut;	
		}
		
		/**
		 * 	Input seconds and return a string of the form: hours:min
		 */
		public static function getHoursMinutes( seconds:int ):String {
			var timeOut:String;
			var hours:int = int( seconds / 3600 );
			var mins:int = int( ( seconds - ( hours * 3600 ) ) / 60 )
			var secs:int = seconds % 60;
			
			if( isNaN( hours ) || isNaN( mins ) || isNaN( secs ) ) {
				return "--:--";
			}
			
			var minS:String = ( mins < 10 ) ? "0" + mins : String( mins );
			
			var hourS:String = String( hours );
			timeOut = hourS + ":" + minS;
			return timeOut;	
		}
	}

}