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

package com.expanz.interfaces
{
	/**
	 * Implment on a custom control to show messages for an activity. 
	 * 
	 * You can place an IMessagePanel implementation inside any activity to view just its messages.
	 * If you place an IMessagePanel implementation on the root application and not as a child of an Activity
	 * It will recieve and show all messages for the application.
	 * 
	 * So you can choose if you want to display local messages to the screens context or have a global message display
	 * 
	 * @author expanz
	 * 
	 */
	public interface IMessagePanel
	{
		
		/**
		 * Called by the framework to clear the message panel 
		 */
		function clear():void;
		
		/**
		 * Called by the framework to add messages to the panel sent from the server
		 *  
		 * @param xmlmsg
		 * 
		 */
		function addMessage(xmlmsg:XML):void;
		
		function get popupErrors():Boolean;
		function set popupErrors(value:Boolean):void;
	}
}