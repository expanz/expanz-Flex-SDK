package com.expanz.controls.halo
{
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.ControlHarness;
	import com.expanz.utils.Util;
	import com.expanz.interfaces.IEditableControl;
	import com.expanz.interfaces.IServerBoundControl;

	import flash.events.FocusEvent;

	import mx.controls.TextArea;
	import mx.events.FlexEvent;

	public class TextAreaEx extends TextArea implements IEditableControl, IServerBoundControl
	{

		private var harness:ControlHarness;
		private var focusValue:String;

		public var FieldLabel:String;

		public function TextAreaEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}

		private function onCreationComplete(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}

		private function onFocusIn(e:FocusEvent):void
		{
			focusValue = text;
		}

		private function onFocusOut(e:FocusEvent):void
		{
			if (this.editable && focusValue != text)
			{
				harness.sendXml(DeltaXml);
			}
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
			if (xml[MessageSchemaAttributes.PublishFieldMaxLength] != null)
			{
				try
				{
					var maxLength:int = parseInt(xml[MessageSchemaAttributes.PublishFieldMaxLength]);
					maxChars = maxLength;
				}
				catch (e:Error)
				{

				}
			}
		}

		public function get fieldId():String
		{
			return Util.underscoresToDots(this.id);
			//return this.name;
		}

		public function setControlVisible(visible:Boolean):void
		{
			this.visible = visible;
		}
	}
}