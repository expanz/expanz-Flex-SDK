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
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.Button;

	[IconFile("CloseButton.png")]
	
	/**
	 * CloseButtonEx will close the current Activity/Screen.
	 * 
	 * Will call the CloseButtonEx parent Activity Container and will initial the kill sequence. 
	 * The activity instance will be destroyed on the server and the activity container will close.
	 * 
	 * If its a WindowEx it will be removed. If a Tab the tab will be removed / closed.
	 * 
	 * @author expanz
	 */
	public class CloseButton extends Button
	{
		private var harness:ControlHarness;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function CloseButton()
		{
			super();
			label = "Close";
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			addEventListener(MouseEvent.CLICK, this_clickHandler);
			
			buttonMode = true;
		}

		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}

		private function this_clickHandler(event:MouseEvent):void
		{
			harness.parentActivityContainer.close();
		}
	}
}