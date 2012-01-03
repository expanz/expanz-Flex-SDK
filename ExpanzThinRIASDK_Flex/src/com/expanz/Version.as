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

package com.expanz
{
	/**
	 * Version number of the expanz Library
	 * 
	 * @author expanz
	 */
	public class Version
	{
		private var _expanzVersion:String = "1.0.0";
		private var _flexFramwork:String = "4.5.1";

		public final function get expanzVersion():String
		{
			return _expanzVersion;
		}

		public final function get flexFramwork():String
		{
			return _flexFramwork;
		}
		
	}
}