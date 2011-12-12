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
	 * user this interface to make an custom control that is server bound to a model object field
	 * 
	 * @author expanz
	 * 
	 */
	public interface IServerBoundControl
	{	
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The server Model Object Field name
		 */
		function get fieldId():String
		//function set fieldId(String):void					
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Sets the control visibility on the screen.
		 * Called by the framework. 
		 */
		function setControlVisible(visible:Boolean):void;
	}
}