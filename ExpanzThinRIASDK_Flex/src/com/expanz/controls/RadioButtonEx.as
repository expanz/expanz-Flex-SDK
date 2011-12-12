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
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.ControlHarness;
	import com.expanz.interfaces.IEditableControl;
	import com.expanz.interfaces.IServerBoundControl;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import spark.components.RadioButton;
	
	[IconFile("RadioButton.png")]
	/**
	 * RadiButtonEx Extends the spark.components.RadioButton and supports the 
	 * IServerBoundControl, IEditableControl interfaces
	 * 
	 * @see spark.components.RadioButtonGroup
	 * @see spark.skins.spark.RadioButtonSkin
	 * 
	 * @author expanz
	 */
	public class RadioButtonEx extends RadioButton implements IServerBoundControl, IEditableControl
	{
		//------------------------------------------------------
		// Class Variables
		//------------------------------------------------------
		private var harness:ControlHarness;
		
		//------------------------------------------------------
		// Constructor
		//------------------------------------------------------
		public function RadioButtonEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(Event.CHANGE, onClick);
		}		
		

		//------------------------------------------------------
		// Event Handlers
		//------------------------------------------------------		
		private function onCreationComplete(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}
		
		private function onClick(event:Event):void
		{
			harness.sendXml(DeltaXml);
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
			var delta:XML = harness.DeltaElement;
			delta.@[MessageSchemaAttributes.IDAttrib]= fieldId;
			delta.@[MessageSchemaAttributes.Value]=MessageSchemaAttributes.boolString(this.selected);
			return delta;
		}
		
		public function setEditable(editable:Boolean):void
		{
			this.enabled=editable;
		}
		
		public function setNull():void
		{
		}
		
		public function setValue(text:String):void
		{
			this.selected=MessageSchemaAttributes.boolValue(text);
		}
		
		public function setLabel(label:String):void
		{
			this.label=label;
		}
		
		public function setHint(hint:String):void
		{
			this.toolTip=hint;
		}
		
		public function publishXml(xml:XML):void
		{
		}
	}
}