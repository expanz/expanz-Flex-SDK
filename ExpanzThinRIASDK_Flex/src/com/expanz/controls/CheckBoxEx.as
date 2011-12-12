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
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.CheckBox;
	
	[IconFile("CheckBox.png")]
	/**
	 * expanz Check box
	 *  
	 * @author expanz
	 * 
	 */
	public class CheckBoxEx extends CheckBox implements IServerBoundControl, IEditableControl
	{
		//------------------------------------------------------
		// IServerBoundControl Interface Implementation
		//------------------------------------------------------
		include "../includes/IServerBoundControlImpl.as";
		
		private var harness:ControlHarness;
		
		public function CheckBoxEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
		}
		
		//------------------------------------------------------
		// Event Handlers
		//------------------------------------------------------
		
		private function onCreationComplete(event:FlexEvent):void
		{
			harness=new ControlHarness(this);
		}
		
		protected override function clickHandler(event:MouseEvent):void
		{
			harness.sendXml(DeltaXml);
		}
		
		//------------------------------------------------------
		// IEditableControl Implementation
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