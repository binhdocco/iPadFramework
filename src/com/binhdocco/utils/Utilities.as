package com.binhdocco.utils
{
	public class Utilities	{
		/*
			 var validEmail:String = "name@domain.com";
            trace(validateEmail(validEmail));        // true
            
            var invalidEmail:String = "foo";
            trace(validateEmail(invalidEmail));  // false
			*/
		public static function validateEmail(str:String):Boolean {
			
            var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
            var result:Object = pattern.exec(str);
            if(result == null) {
                return false;
            }
            return true;
        }
        /*
         var validPhoneNumber:String = "415-555-1212";
            trace(validatePhoneNumber(validPhoneNumber));    // true
            
            var invalidPhoneNumber:String = "312-867-530999";
            trace(validatePhoneNumber(invalidPhoneNumber));  // false

        */
        public static function validatePhoneNumber(str:String):Boolean {
            var pattern:RegExp = /^\d{3}-\d{3}-\d{4}$/;
            var result:Object = pattern.exec(str);
            if(result == null) {
                return false;
            }
            return true;
        }
	}
}