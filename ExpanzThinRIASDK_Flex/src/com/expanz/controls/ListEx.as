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
	import com.expanz.interfaces.IDataControl;
	import com.expanz.utils.Util;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.events.FlexEvent;
	
	import spark.components.List;
	
	[IconFile("List.png")]
	/**
	 * ListEx an IDataControl which is skinnable with custom Item Renderers
	 *  
	 * Simply set the PopulateMethod or the QueryID properties to have the dataProvider 
	 * populated with a Data Publication from the server 
	 * 
	 * @see http://developer.expanz.com/schemas/ep/2008/docs/CreateActivity_Response.html#Data
	 * 
	 * @author expanz
	 * 
	 */
	public class ListEx extends List implements IDataControl
	{	
		//--------------------------------------------------------------------------
		//
		//  Class Variables
		//
		//--------------------------------------------------------------------------
		
		private var harness:ControlHarness;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ListEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			
			//By default allow double click of rows to launch	
			doubleClickEnabled = true;
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}
			
		//------------------------------------------------------
		// IDataControl Interface Implementation include
		//------------------------------------------------------
		include "../includes/IDataControlImpl.as";
		
		//--------------------------------------------------------------------------
		//
		//  Public Properties
		//
		//--------------------------------------------------------------------------		
		
		/**
		 * Function to call after Data Publishing is complete.
		 * 
		 * This can be a function in your view which may need to do something to the 
		 * views UX when the data is completed loading
		 *  
		 */
		public var runAfterPublish: Function;
		
		/**
		 * TODO DOCUMENT
		 */
		public var doXmlTrasform:Boolean = true; //does the renderer expect transformed or raw data?
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function publishData(data:XML):void
		{
			if (data == null) {
				return;
			}
			
			if (data.@clearOnly == 1) {
				if (dataProvider!= null) {
					dataProvider = null;
				}
				return;
			}
			if (data.hasOwnProperty('Rows')) {
				if (data.Rows.children().length() > 0 ) {
					//replace CellX elements with descriptive tag name & attributes from column Data
					
					if (doXmlTrasform) 
					{						
						dataProvider = new XMLListCollection(Util.transformXMLToDataBindableXML(data));
					} 
					else 
					{
						dataProvider = data.Rows.children(); // xml processing moved to itemRenderer, todo: pass info about columns so we don't have to hardcode
					}
					
				} else {
					dataProvider = null;
				}
			}
			
			if(runAfterPublish is Function)
				runAfterPublish(this, data);
		}
		
		public function refresh():void
		{
			var refresh:XML = harness.DataPublicationRefreshElement;
			refresh.@[MessageSchemaAttributes.IDAttrib] = this.DataId;
			refresh.@refresh = "1";
			harness.sendXml(refresh);
		}	
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------	
		
		private function doubleClickHandler(event:MouseEvent):void
		{
			if(!this.selectedItem)
				return;
			
			var contextXML:XML = <Context id={this.selectedItem.@id} Type={this.selectedItem.@Type}/>;			
			var menuActionXML:XML = <MenuAction defaultAction="1"/>;
			
			if (modelObject)
			{
				contextXML.@contextObject = modelObject;
				menuActionXML.@contextObject = modelObject;
			}
			
			harness.sendXmlList(new ArrayCollection([contextXML, menuActionXML]));
		}
	}
}