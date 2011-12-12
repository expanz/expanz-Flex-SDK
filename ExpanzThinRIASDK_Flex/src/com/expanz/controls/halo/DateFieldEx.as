package com.expanz.controls.halo
{
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.ControlHarness;
	import com.expanz.utils.Util;
	import com.expanz.interfaces.IEditableControl;
	import com.expanz.interfaces.IServerBoundControl;
	
	import flash.events.FocusEvent;
	
	import mx.controls.DateField;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.events.FlexEvent;

	[IconFile("DateField.png")]
	/**
	 * Bind DateFieldEx to Server date object
	 * 
	 * @author expanz
	 * 
	 */
	public class DateFieldEx extends DateField implements IEditableControl, IServerBoundControl
	{

		private var harness:ControlHarness;
		private var focusValue:String;

		public function DateFieldEx()
		{
			super();
			formatString = "DD/MM/YYYY";
			showToday = false;
			this.editable = true;
			this.yearNavigationEnabled = true;

			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			addEventListener(FocusEvent.FOCUS_IN, this_focusInHandler);
			addEventListener(FocusEvent.FOCUS_OUT, this_focusOutHandler);
			addEventListener(CalendarLayoutChangeEvent.CHANGE, this_calendarLayoutChangeHandler);
		}

		public function get DeltaXml():XML
		{
			var delta:XML = harness.DeltaElement;
			delta.@[MessageSchemaAttributes.IDAttrib] = fieldId;
			setDeltaText(delta);
			return delta;
		}

		protected virtual function setDeltaText(delta:XML):void
		{
			delta.@[MessageSchemaAttributes.Value] = this.text;
		}

		public function setEditable(editable:Boolean):void
		{
			this.editable = editable;
		}

		public function setNull():void
		{
			this.text = "";
		}

		public function setValue(text:String):void
		{
			this.text = text;
			focusValue = text;
		}

		public function setLabel(label:String):void
		{
		}

		public function setHint(hint:String):void
		{
			this.toolTip = hint;
		}

		public function publishXml(xml:XML):void
		{

		}

		//------------------------------------------------------
		// IServerBoundControl Interface Implementation
		//------------------------------------------------------
		include "../../includes/IServerBoundControlImpl.as";

		private function creationCompleteHandler(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}

		private function this_focusInHandler(e:FocusEvent):void
		{
			focusValue = text;
		}

		private function this_focusOutHandler(e:FocusEvent):void
		{
			tellServer();
		}
		private function tellServer():void
		{
			if (this.editable && focusValue != text)
			{
				harness.sendXml(DeltaXml);
			}
		}
		
		private function this_calendarLayoutChangeHandler(e:CalendarLayoutChangeEvent):void
		{
			tellServer();
		}
	}
}