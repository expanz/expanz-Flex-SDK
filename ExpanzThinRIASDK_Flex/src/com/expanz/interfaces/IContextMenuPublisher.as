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
	import flash.events.Event;
		
	/**
	 * Implement for creating a custom Context Menu control 
	 * @author expanz
	 */
	public interface IContextMenuPublisher
	{
		/**
		 * Custom implementation of the server Context Menu XML to create a context menu
		 * The framework will call this method passing the Context Menu XML from the server
		 */
		function publishContextMenu(menu:XML):void;
		
		/**
		 * Event handler for selecting a menu item.
		 * Sends the selected meu items action to the server for handling 
		 */
		function onMenuItemSelect(event:Event):void;
	}
}