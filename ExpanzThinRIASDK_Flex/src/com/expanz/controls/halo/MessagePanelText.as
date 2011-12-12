package com.expanz.controls.halo
{
	import com.expanz.*;
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.interfaces.IMessagePanel;
	
	import mx.controls.Alert;
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import spark.effects.Fade;
	import spark.effects.animation.RepeatBehavior;

	/**
	 * Componnent for showing messages to the 
	 * 
	 * @author expanz
	 * 
	 */
	public class MessagePanelText extends TextArea implements IMessagePanel
	{
		private var harness:ControlHarness;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------	
		private var flashEffect:Fade;
		public function MessagePanelText()
		{
			super();
			this.editable = false;	
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			flashEffect = new Fade(this);
			flashEffect.alphaFrom = .2;
			flashEffect.alphaTo = 1;
			flashEffect.repeatCount = 5;
			flashEffect.repeatBehavior = RepeatBehavior.REVERSE;
			flashEffect.duration = 300
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Properties
		//
		//--------------------------------------------------------------------------	
		public var popupWarnings:Boolean = false;		
		
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
			this.htmlText = "";
		}

		/**
		 * @inheritdoc
		 */
		public function addMessage(xmlmsg:XML):void
		{
			var msg:String = xmlmsg.valueOf();
			var severity:String = xmlmsg.@[MessageSchemaAttributes.Type].toString().toUpperCase();
			var colour:String = "#00ff00";

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

			if (this.htmlText.length > 0)
				this.htmlText = "<BR/>" + this.htmlText;
			this.htmlText = "<font color='" + colour + "'>" + msg + "</font>" + this.htmlText;
			
			flashEffect.play();
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