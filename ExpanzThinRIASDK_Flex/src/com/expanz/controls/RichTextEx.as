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
	
	import spark.components.RichText;
	
	[IconFile("RichText.png")]
	/**
	 * Read only display of text or data values of a Model Object field.
	 * 
	 * @author expanz
	 * 
	 */
	public class RichTextEx extends RichText implements IServerBoundControl, IEditableControl
	{
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		private var harness:ControlHarness;		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function RichTextEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
		}	
					
		private function onCreationComplete(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}
				
		//------------------------------------------------------
		// IServerBoundControl Interface Implementation
		//------------------------------------------------------
		include "../includes/IServerBoundControlImpl.as";	
		
		//--------------------------------------------------------------------------
		//
		//  Public Properties
		//
		//--------------------------------------------------------------------------
		[Inspectable(category="Expanz")]
		/**
		 * Show the text value of a field rather than a label. 
		 * Some field will be represented by a number or enumeration but have no human meaning
		 * the text value of the Field element will have the human readable value.
		 */
		public var showTextValue:Boolean=false;
		
		//------------------------------------------------------
		// IEditableControl Interface Implementation
		//------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get DeltaXml():XML
		{
			var delta:XML = harness.DeltaElement;
			delta.@[MessageSchemaAttributes.IDAttrib]= fieldId;
			setDeltaText(delta);
			return delta;
		}
		
		/**
		 * @inheritDoc
		 */
		protected virtual function setDeltaText(delta:XML):void
		{
			delta.@[MessageSchemaAttributes.Value]=this.text;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setEditable(editable:Boolean):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function setNull():void
		{
			this.text="";
		}
		
		/**
		 * @inheritDoc
		 */
		public function setValue(value:String):void
		{
			if(!showTextValue)
				this.text=value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLabel(label:String):void
		{

		}
		
		/**
		 * @inheritDoc
		 */
		public function setHint(hint:String):void
		{
			this.toolTip=hint;
		}
		
		/**
		 * @inheritDoc
		 */
		public function publishXml(xml:XML):void
		{
			if (xml && showTextValue)
			{
				text = xml.@text.toString();
			}
		}
	}
}