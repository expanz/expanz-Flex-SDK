////////////////////////////////////////////////////////////////////////////////
//
//  EXPANZ
//  Copyright 2008-2011 EXPANZ
//  All Rights Reserved.
//
//  NOTICE: Expanz permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.expanz.logging
{
	import flash.utils.getQualifiedClassName;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	/**
	 * Class for helper functions for Logging
	 * 
	 * @author expanz
	 * 
	 */
	public class LogUtil
	{				
		/**
		 * Returns a registered logger object but allow the caller
		 * to pass in a reference to the type directly.
		 * 
		 * This helps refactoring as the logger categories get updated as well as
		 * it should stop categories getting out of sync with the actual 
		 * class name and package.
		 *  
		 * @param object The class reference which contains the logger
		 * 
		 * @return a Logger 
		 * 
		 */
		public static function getLogger(object:Object):ILogger 
		{
			var className:String="";
			
			if (object is Class) {
				className = getQualifiedClassName(object).replace("::", ".");
			} else {
				className = object.toString();
			}
			
			return Log.getLogger(className);
		}
	}
}