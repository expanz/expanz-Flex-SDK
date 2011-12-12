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

package com.expanz.events
{
	import flash.events.Event;
	
	/**
	 * Expanz events around the authentication and session mangement of a user session
	 *  
	 * @author expanz
	 * 
	 */
	public class SessionEvent extends Event
	{
		/**
		 * Dispatched when a user logs in with incorrect username and password
		 */
		public static const AUTHENTICATION_FAILED:String = "authenticationFailed";

		/**
		 * Dispatched when a session is created
		 */
		public static const SESSION_CREATED:String = "sessionCreated";
		
		/**
		 * Dispatched when a session is destroyed. Dispatched after loggingOff to confirm the Session is destroyed on the server
		 */
		public static const SESSION_DESTOYED:String = "sessionDestroyed";
		
		/**
		 * Dispatched to indicate when a user logs off
		 */
		public static const USER_LOGGING_OFF:String = "loggingOff";
		
		/**
		 * The session data returned after login. 
		 * The app server may append some custom data here you might utilize in your app.
		 * 
		 * i.e Dashboard data or some display only data.
		 * 
		 */
		public var sessionData:XML;
		
		public function SessionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}