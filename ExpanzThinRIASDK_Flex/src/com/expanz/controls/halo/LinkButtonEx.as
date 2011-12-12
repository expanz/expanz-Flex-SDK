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

package com.expanz.controls.halo
{
	import com.expanz.ControlHarness;
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.interfaces.IEditableControl;
	import com.expanz.interfaces.IServerBoundControl;
	import com.expanz.interfaces.IServerMethodCaller;
	
	import flash.events.MouseEvent;
	
	import mx.controls.LinkButton;
	import mx.events.FlexEvent;
	
	/**
	 * @inheritDoc
	 */
	public class LinkButtonEx extends LinkButton implements IServerBoundControl, IEditableControl, IServerMethodCaller
	{	
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		public function LinkButtonEx()
		{
			super();
			init();
		}
	
		//------------------------------------------------------
		// IServerMethodCaller Interface Implementation
		//------------------------------------------------------
		include "../../includes/_ServerMethodCallerImpl.as";
		
		//------------------------------------------------------
		// IServerBoundControl Interface Implementation
		//------------------------------------------------------
		include "../../includes/IServerBoundControlImpl.as";
		
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
			delta.@[MessageSchemaAttributes.Value]=this.label;
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
			this.label="";
		}
		
		/**
		 * @inheritDoc
		 */
		public function setValue(text:String):void
		{
			this.label=text;
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
		}
	}
}