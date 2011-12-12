package com.expanz.controls
{
	import com.expanz.ControlHarness;
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.interfaces.IMessagePanel;
	
	import mx.events.FlexEvent;
	
	import spark.components.TextArea;
	
	public class MessagePanelTextArea extends TextArea implements IMessagePanel
	{
		private var harness:ControlHarness;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------	
		
		public function MessagePanelTextArea()
		{
			super();
			this.editable = false;	
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Properties
		//
		//--------------------------------------------------------------------------	
		
		private var _popupErrors:Boolean = false;
		[Inspectable(category="expanz")]
		/**
		 * @inheritdoc
		 */
		public function get popupErrors():Boolean
		{
			return _popupErrors;
		}
		public function set popupErrors(value:Boolean):void
		{
			_popupErrors = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------	
		
		/**
		 * @inheritdoc
		 */
		public function clear():void
		{
			this.text = "";
		}
		
		/**
		 * @inheritdoc
		 */
		public function addMessage(xmlmsg:XML):void
		{
			var msg:String = xmlmsg.valueOf();
			var severity:String = xmlmsg.@[MessageSchemaAttributes.Type].toString().toUpperCase();
			var colour:String = "#00ff00";
			/*
			if (severity == "WARNING")
			{
				colour = "#666600";
				
				if (popupWarnings)
				{
					Alert.show(msg, "Warning");
				}
				
			}
			else if (severity == "ERROR")
			{
				colour = "#ff0000";
				
				if (popupErrors)
				{
					Alert.show(msg, "Problem");
				}
			}
			*/
			
			/*if (this.text.length > 0){
				this.text = "/n" + this.text;			
			}*/
			this.text = msg + "/n" + this.text;
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