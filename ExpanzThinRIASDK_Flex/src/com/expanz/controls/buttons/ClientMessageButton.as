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

package com.expanz.controls.buttons
{
	import com.expanz.forms.ClientMessageWindow;
	
	import flash.events.MouseEvent;
	
	import spark.components.Button;

	/**
	 * Instances are created by the Client Message Window as part 
	 * of the Server Client Messages feature. You will not ever need to 
	 * instanciate this component in your applications
	 * 
	 * @author expanz
	 * @date 10/2010
	 * 
	 */
	public class ClientMessageButton extends Button
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ClientMessageButton(label:String, request:XMLList, response:XMLList, clientMessageWindow:ClientMessageWindow)
		{
			super();
			super.label = label;
			this.request = request;
			this.response = response;
			this.clientMessageWindow = clientMessageWindow;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  request
		//----------------------------------
		
		/**
		 *  The XML Request to send on click of this button instance
		 */
		public var request:XMLList;
		
		//----------------------------------
		//  response
		//----------------------------------
		
		/**
		 * The XML Response to consume on click of this button instance
		 */
		public var response:XMLList;
		
		//----------------------------------
		//  clientMessageWindow
		//----------------------------------
		/**
		 * Reference to the host ClientMessageWindow
		 */
		public var clientMessageWindow:ClientMessageWindow
		
		//--------------------------------------------------------------------------
		//
		//  Overriden methods
		//
		//--------------------------------------------------------------------------
		
		protected override function clickHandler(event:MouseEvent):void
		{
			if (clientMessageWindow != null)
				clientMessageWindow.messageButtonClick(this);
		}
		
	}
}
