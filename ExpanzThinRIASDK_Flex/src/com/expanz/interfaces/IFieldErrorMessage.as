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
	 * Implement to show/hide messages on the control.
	 * 
	 * You can show 
	 * - Info
	 * - Warning
	 * - Errors
	 * 
	 * Useful for validation error messages of users input.
	 * 
	 * @author expanz
	 * 
	 */
	public interface IFieldErrorMessage
	{		
		
		/**
		 * Handle the implementation to show a message on the control
		 * @param xml
		 */
		function showError(xml:XML):void;
		
		/**
		 * Hide / Destroy the current active message dispayed on the control 
		 */
		function hideError():void;		
	}
}