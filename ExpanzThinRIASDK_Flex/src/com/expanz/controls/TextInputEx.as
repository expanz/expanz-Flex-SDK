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
	import com.expanz.interfaces.IFieldErrorMessage;
	import com.expanz.interfaces.IServerBoundControl;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	import mx.validators.IValidator;
	import mx.validators.StringValidator;
	import mx.validators.Validator;
	
	import spark.components.TextInput;
	import spark.validators.NumberValidator;
	
	[IconFile("TextInput.png")]
	/**
	 * Will handle updating the field on the server and display the fields value.
	 * 
	 * Set the fieldID property
	 * 
	 * @author expanz
	 * 
	 */
	public class TextInputEx extends TextInput implements IEditableControl, IServerBoundControl, IFieldErrorMessage
	{
		//--------------------------------------------------------------------------
		//
		//  Class Variables
		//
		//--------------------------------------------------------------------------
		
		private var harness:ControlHarness;
		private var focusValue:String;
		public  var validator:IValidator;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------		
		public function TextInputEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
			addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
			addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
			addEventListener(FlexEvent.ENTER, onEnter);			
		}
		
		//------------------------------------------------------
		// IServerBoundControl Interface Implementation
		//------------------------------------------------------
		include "../includes/IServerBoundControlImpl.as";		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onEnter(event:FlexEvent):void
		{
			if(this.enabled && focusValue!=text)
			{
				harness.sendXml(DeltaXml);
				focusValue = text;
			}
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}
		
		private function onFocusIn(e:FocusEvent):void
		{
			focusValue = text;
		}
		
		private function onFocusOut(event:FocusEvent):void
		{
			if(this.enabled && focusValue!=text)
			{
				harness.sendXml(DeltaXml);
			}
		}
		
		//------------------------------------------------------
		// IEditableControl Interface Implementation
		//------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		public function get DeltaXml():XML
		{
			hideError();
			
			var delta:XML = harness.DeltaElement;
			delta.@[MessageSchemaAttributes.IDAttrib]= fieldId;
			setDeltaText(delta);
			return delta;
		}
		
		/**
		 * @inheritDoc
		 */
		protected function setDeltaText(delta:XML):void
		{
			delta.@[MessageSchemaAttributes.Value]=this.text;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setEditable(editable:Boolean):void
		{
			this.enabled=editable;
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
		public function setValue(text:String):void
		{
			this.text=text;
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
			//Set properties based on metadata rules
			
			//maxChars
			if(xml.@[MessageSchemaAttributes.PublishFieldMaxLength]!=null)
			{
				var maxLength:int = parseInt(xml.@[MessageSchemaAttributes.PublishFieldMaxLength]);
				maxChars = maxLength;
			}			
			
			//Check expanz type and setup appropriate validator			
			switch(xml.@datatype.toString())
			{
				case "string":
				case "number":
				{
					//<Field id="Street" label="Street" maxLength="200" null="0" value="50 Lucky Street" datatype="string" valid="1"/>
					validator = new StringValidator();
					(validator as StringValidator).source = this;
					(validator as StringValidator).property = "text";
					//(validator as StringValidator).maxLength = maxLength;
					if(xml.@required == true)
					{
						(validator as StringValidator).required = true;						
					}
					else
					{
						(validator as StringValidator).required = false;
					}
					break;
					
					//TODO: Implement MASK
					//<Field id="Phone" label="Telephone No" maxLength="20" null="0" value="(07) 3396 0612" datatype="string" mask="(00) 0000 0000" valid="1"/>
					break;
				}
				/*
				case "number":
				{
					//<Field id="Op1" minValue="0" maxValue="10000" null="0" valid="1" value="0" datatype="number"/>
					validator = new NumberValidator();
					(validator as NumberValidator).source = this;
					(validator as NumberValidator).property = "text";
					(validator as NumberValidator).maxValue = xml.@maxValue;
					(validator as NumberValidator).minValue = xml.@minValue;				
					break;
				}		
				*/
				default:
				{
					break;
				}				
			}
		}		

		//------------------------------------------------------
		// IFieldErrorMessage Interface Implementation
		//------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		public function hideError():void
		{
			if(!validator)
				return;
			
			if(validator is StringValidator)
			{
				//force validation
				(validator as StringValidator).required = false;
				(validator as StringValidator).requiredFieldError = "";				
			}
			else if(validator is NumberValidator)
			{
				(validator as NumberValidator).minValue = 0;
				(validator as NumberValidator).lessThanMinError = ""
			}	

			validator.validate();
			validator.enabled = false;
		}

		/**
		 * @inheritDoc
		 */
		public function showError(xml:XML):void
		{	
			if(!validator)
				return;
			
			validator.enabled = true;	
			
			if(validator is StringValidator)
			{
				//force validation
				(validator as StringValidator).required = true;
				(validator as StringValidator).requiredFieldError = xml.text();
				validator.validate("");
			}
			else if(validator is NumberValidator)
			{
				//force validation
				(validator as NumberValidator).minValue = 0.1;
				(validator as NumberValidator).lessThanMinError = xml.text();
				validator.validate(0);
			}
			else
			{
				validator.validate();
			}				
				
			this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
		}
	}
}