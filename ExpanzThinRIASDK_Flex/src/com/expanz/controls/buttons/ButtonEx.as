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
	import com.expanz.ControlHarness;
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.interfaces.IServerMethodCaller;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.Button;

	[IconFile("Button.png")]
	
	/**
	 * The Expanz ButtonEx extends spark.components.Button. 
	 * To call server methods on a Model Object set the MethodName property
	 * 
	 * @author 	expanz
	 * @date	4/2010
	 * 
	 */
	public class ButtonEx extends Button implements IServerMethodCaller
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ButtonEx()
		{
			super();
			init();
			buttonMode = true;
		}
		
		//------------------------------------------------------
		// IServerMethodCaller Interface Implementation
		//------------------------------------------------------
		include "../../includes/_ServerMethodCallerImpl.as";
		
		//------------------------------------------------------
		// IServerBoundControl Interface Implementation
		//------------------------------------------------------
		include "../../includes/IServerBoundControlImpl.as";
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		protected override function clickHandler(event:MouseEvent):void
		{
			click();
		}
	}
}