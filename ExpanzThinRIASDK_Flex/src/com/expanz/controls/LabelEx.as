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
	
	import mx.events.FlexEvent;
	
	import spark.components.Label;

	[IconFile("Label.png")]
	/**
	 * Used to display a field label by default.
	 * set the fieldID property to your server model object field and the label will be displayed and the tooltip for it.
	 * 
	 * If you wish to use this control to show the field value instead set the showDataValue="true"  
	 * 
	 * @author expanz
	 *  
	 */
	public class LabelEx extends Label implements IEditableControl, IServerBoundControl
	{
		private var harness:ControlHarness;		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function LabelEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}			
		
		//--------------------------------------------------------------------------
		//
		//  Public Properties
		//
		//--------------------------------------------------------------------------
		
		[Inspectable(category="Expanz", enumeration="true, false", defaultValue="false" )]
		/**
		 * Set to true to display the field value rather than the field label
		 * Default is false 
		 */
		public var showDataValue:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
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
			setDeltaText(delta);
			return delta;
		}
		
		protected virtual function setDeltaText(delta:XML):void
		{
			delta.@[MessageSchemaAttributes.Value]=this.text;
		}
		
		public function setEditable(editable:Boolean):void
		{
			
		}
		
		public function setNull():void
		{
			if(showDataValue)
				this.text="";
		}
		
		public function setValue(valueText:String):void
		{
			if(showDataValue)
				this.text=valueText;
		}
		
		public function setLabel(labelText:String):void
		{
			if(!showDataValue)
				this.text=labelText;
		}
		
		public function setHint(hint:String):void
		{
			this.toolTip=hint;
		}
		
		public function publishXml(xml:XML):void
		{
			if (xml && showDataValue)
			{
				text = xml.@value.toString();
			}
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