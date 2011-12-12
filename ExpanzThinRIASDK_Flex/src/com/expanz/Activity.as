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
	 * Activity Configuration class used with com.expanz.FormMappings.
	 * 
	 * Configure properties to map Forms(Views) to Activities
	 * 
	 * @author expanz
	 */
	public class Activity
	{		
		
		/**
		 * Name of the Activity 
		 */
		public var name:String;		
		
		/**
		 * Style of the Activity, "Browse" is built in to support viewing a list of the 
		 * the activities root Model Object. e.g. Browsing a list of customers.
		 */
		public var style:String = "";
		
		/**
		 * Class Reference to the form (View) component
		 */
		public var form:Object;
		
		/**
		 * Set to true to load the activity as the initial view once the user has been authenticated 
		 */
		public var defaultActivity:Boolean;		
		
		/**
		 * TODO:DOCUMENT
		 */
		public var tabItem:String;
	}
}