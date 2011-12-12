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

package com.expanz.controls
{
	import com.expanz.ControlHarness;
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.interfaces.IEditableControl;
	import com.expanz.interfaces.IServerBoundControl;
	
	import mx.controls.Label;
	import mx.events.FlexEvent;
	
	import spark.components.FormItem;
	
	[IconFile("FormItem.png")]
	/**
	 * Form Item Label and shows the hint / tooltip in the helpContent
	 * 
	 * @author expanz
	 *  
	 */
	public class FormItemEx extends FormItem implements IServerBoundControl, IEditableControl
	{
		private var harness:ControlHarness;		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FormItemEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		//------------------------------------------------------
		// IServerBoundControl Interface Implementation
		//------------------------------------------------------
		include "../includes/IServerBoundControlImpl.as";	
		
		
		//------------------------------------------------------
		// IEditableControl Interface Implementation
		//------------------------------------------------------
		
		public function get DeltaXml():XML
		{
			return null;
		}
		
		protected function setDeltaText(delta:XML):void
		{
		}
		
		public function setEditable(editable:Boolean):void
		{
		}
		
		public function setNull():void
		{	
		}
		
		public function setValue(value:String):void
		{	
		}
		
		public function setLabel(labelText:String):void
		{
			this.label=labelText;
		}
		
		public function setHint(hint:String):void
		{
			var toolTipLabel:Label = new Label();
			toolTipLabel.text = hint;
			this.helpContent = [toolTipLabel];
		}
		
		public function publishXml(xml:XML):void
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onCreationComplete(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}
	}
}