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
	 * The control will be an editable control so the user can input data. 
	 * 
	 * This interface will allow you to interact with the expanz framework to 
	 * get data from the control the send to the expanz server and
	 * set data on the control sent from the expanz server.
	 * 
	 * @author expanz
	 * 
	 */
	public interface IEditableControl
	{
		/**
		 * Gets the Delta or the new changed value the user has input
		 * @return 
		 */
		function get DeltaXml():XML;
		
		/**
		 * Make the control editable or not. 
		 * Some controls may just enable or disable or
		 * some may allow editing or be read only 
		 * 
		 * @param editable
		 */
		function setEditable(editable:Boolean):void;
		
		/**
		 * Set the controls value to null
		 */		
		function setNull():void;		
		
		/**
		 * Set the value of the control
		 * @param text
		 */
		function setValue(text:String):void;
		
		/**
		 * Sets the label display for the control. Showing the display text or label set in the metadata.
		 * @param label
		 */
		function setLabel(label:String):void;		
		
		/**
		 * Sets the tooltip for the control 
		 * @param hintthe tooltip message
		 */
		function setHint(hint:String):void;
				
		/**
		 * Publishes the XML metadata from the server to the client control
		 * @param xml
		 */
		function publishXml(xml:XML):void;
	}
}