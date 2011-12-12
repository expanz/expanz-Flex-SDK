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
	
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.PopUpMenuButton;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.events.MenuEvent;
	
	import spark.components.TextInput;
	
	[IconFile("TextInput.png")]
	/**
	 * User can Load a know serach code 
	 * or user can search for a wider search?
	 * or open an more advanced search screen 
	 * 
	 * 
	 * @author expanz
	 * 
	 */
	public class SearchInputEx extends TextInput implements IServerBoundControl, IEditableControl
	{
		//--------------------------------------------------------------------------
		//
		//  Class Variables
		//
		//--------------------------------------------------------------------------
		
		private var harness:ControlHarness;
		private var focusValue:String;
		private var buttonsArray:ArrayCollection = new ArrayCollection( 
			[
				{label:"Load", toolTip:"Quick Search & Load", action:"TEXTMATCH"}, 
				{label:"List", toolTip:"Search All", action:"TEXTMATCHALL"} 
			]);
		
		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//--------------------------------------------------------------------------
		
		[SkinPart(required="false")]
		public var buttonBar:PopUpMenuButton;
		
		//--------------------------------------------------------------------------
		//
		//    Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SearchInputEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(FlexEvent.ENTER, inputEnterHandler);			
		}
		
		//--------------------------------------------------------------------------
		//
		//    Public Properties
		//
		//--------------------------------------------------------------------------
		
				
		[Inspectable(category="Expanz")]
		public var referenceObject:String;
		
		[Inspectable(category="Expanz")]
		public var promptText:String="search";
		
		[Inspectable(category="Expanz")]
		public var methodName:String;		
		
		//--------------------------------------------------------------------------
		//
		//    IEditableControl Implementation
		//
		//--------------------------------------------------------------------------
		
		public function get DeltaXml():XML
		{
			var delta:XML = harness.DeltaElement;
			delta.@[MessageSchemaAttributes.IDAttrib] = fieldId;
			setDeltaText(delta);
			return delta;
		}
		
		public function setEditable(editable:Boolean):void
		{
			super.editable = editable;
		}
		
		public function setNull():void
		{
			super.text = "";
		}
		
		public function setValue(text:String):void
		{
			super.text = text;
		}
		
		public function setLabel(label:String):void
		{
			//TODO: implement function
		}
		
		public function setHint(hint:String):void
		{
			super.toolTip = hint;
		}
		
		public function publishXml(xml:XML):void
		{
			if (xml[MessageSchemaAttributes.PublishFieldMaxLength] != null)
			{
				try
				{
					var maxLength:int = parseInt(xml[MessageSchemaAttributes.PublishFieldMaxLength]);
					super.maxChars = maxLength;
				}
				catch (e:Error)
				{
					
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//    IServerBoundControl Implementation
		//
		//--------------------------------------------------------------------------		
		include "../includes/IServerBoundControlImpl.as";		
		
		//--------------------------------------------------------------------------
		//
		//    Protected Methods
		//
		//--------------------------------------------------------------------------
		
		protected virtual function setDeltaText(delta:XML):void
		{
			delta.@[MessageSchemaAttributes.Value] = super.text;
		}
		
		protected function sendTextValueToServer():void
		{
			//TODO: potentially use Enter event either exclusivly or not
			//if (textField.contains(event.target as DisplayObject) && event.relatedObject != searchButtons && textField.editable && focusValue != textField.text)
			if (super.editable && focusValue != super.text)
			{
				harness.sendXml(DeltaXml);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == buttonBar)
			{
				//buttonBar.addEventListener(ItemClickEvent.ITEM_CLICK, searchButtons_itemClickHandler, false, 0, true);
				buttonBar.addEventListener(MenuEvent.ITEM_CLICK, searchButtons_itemClickHandler, false, 0, true);
				buttonBar.dataProvider = buttonsArray;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function focusInHandler(event:FocusEvent):void
		{
			super.focusInHandler(event);
			
			if (super.contains(event.target as DisplayObject))
			{
				focusValue = super.text;
			}
		}
		
		override protected function focusOutHandler(event:FocusEvent):void
		{
			super.focusOutHandler(event);
			sendTextValueToServer();
		}
		
		//--------------------------------------------------------------------------
		//
		//  protected event handlers
		//
		//--------------------------------------------------------------------------
		
		protected function searchButtons_itemClickHandler(event:MenuEvent):void
		{
			//<MenuAction referenceObject="Client" action="TEXTMATCHALL" />

			var delta:XML = DeltaXml;
			var menuAction:XML = <MenuAction/>;
			
			if (referenceObject && referenceObject.length > 0)
			{
				menuAction.@referenceObject = referenceObject;
			}
			
			//delta.@bypassAKProcessing = "1";
			
			menuAction.@action = event.item.action;
			
			harness.sendXml(menuAction);
			//harness.sendXmlList(new ArrayCollection([delta, menuAction]));
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}
		
		protected function inputEnterHandler(event:FlexEvent):void
		{
			sendTextValueToServer();
		}		
	}
}