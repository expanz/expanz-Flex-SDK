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
	import com.expanz.controls.gridClasses.GridColumnEx;
	import com.expanz.interfaces.IDataControl;
	import com.expanz.utils.Util;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.XMLListCollection;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	
	import spark.components.DataGrid;
	
	[IconFile("DataGrid.png")]
	/**
	 * Spark expanz DataDrid control.
	 * 
	 * Simply set the PopulateMethod or the QueryID properties.
	 * 
	 * @author expanz
	 * 
	 */
	public class DataGridEx extends DataGrid implements IDataControl
	{
		private var _harness:ControlHarness;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DataGridEx()
		{
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);			
			addEventListener(DataGridEvent.ITEM_EDIT_END, itemEditEndHandler);
			
			//By default allow double click of rows to launch
			doubleClickEnabled = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  dataPublicationSource
		//----------------------------------
		[Bindable]
		/**
		 * 
		 * @return 
		 * 
		 */
		public var dataPublicationSource:XML;
		
		//----------------------------------
		//  harness
		//----------------------------------
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get harness():ControlHarness
		{
			return _harness;
		}
		
		public function set harness(value:ControlHarness):void
		{
			_harness = value;
		}		

		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------		
		
		
		/**
		 * Force refresh of the data programaticaly.
		 * Usefull for multiuser systems and you want a refresh button to force the 
		 * data to be updated. 
		 */
		public function refresh():void
		{
			var refresh:XML = harness.DataPublicationRefreshElement;
			refresh.@[MessageSchemaAttributes.IDAttrib] = this.DataId;
			refresh.@refresh = "1";
			harness.sendXml(refresh);
		}
		
		/**
		 * 
		 * @param col
		 * @param value
		 * @param id
		 * @param type
		 * 
		 */
		public function sendDelta(col:uint, value:String, id:String, type:String):void
		{
			var delta:XML = harness.DeltaElement;
			
			delta.@[MessageSchemaAttributes.IDAttrib] = columns[col].column.@field;
			
			if (value)
			{
				delta.@[MessageSchemaAttributes.Value] = value;
			}
			else
			{
				delta.@[MessageSchemaAttributes.Null] = "1";
			}
			
			var context:XML = <Context id={id} Type={type}/>;
			
			if (modelObject)
			{
				context.@contextObject = modelObject;
			}
			
			
			harness.sendXmlList(new ArrayCollection([context, delta]));
		}
		
		//------------------------------------------------------
		// IDataControl Interface Implementation
		//------------------------------------------------------
		
		public var lastColumn:com.expanz.controls.gridClasses.GridColumnEx;
		
		/**
		 * @inheritDoc
		 */
		public function publishData(data:XML):void
		{
			if (data == null || data.@clearOnly == "1" || !data.hasOwnProperty('Rows'))
			{
				dataProvider = null;
				return; //todo
			}
			
			//store the orginal data Publication
			dataPublicationSource = data;
			
			//transform Data to databindable XML from generic expanz data schema
			var dataBindableXML:XMLList = Util.transformXMLToDataBindableXML(data, "");						
			
			// do not autgenerate columns if user definded 
			if (!columns)
			{ 
				var cols:Array = new Array();
				
				for each (var colData:XML in data.Columns.children())
				{ 
					//Dont create the column if the width is LT 1. 
					//The server metadata declares these are are hidden fields 
					//so dont render them on the screen but we need the data 
					//still in the dataprovider
					if (colData.@width <= 1 )
						break;
					
					var col:GridColumnEx = new GridColumnEx();
					col.column = colData;									
					col.dataField = Util.formatColumnName(colData.@field);
					col.headerText = colData.@label;
					col.width = colData.@width;
					
					// TODO: this needs cleaning up esp. setEditable
					col.setEditable(colData.@editable == "1");
					col.dataType = colData.@datatype;
					
					if (colData.@editable == "1")
					{
						editable = true;
					}					
					
					cols.push(col);
				}
				
				if (lastColumn)
				{
					cols.push(lastColumn); //an ability to leave auto column generation, but slot a column at the end
				}
				columns = new ArrayList(cols);
			}
			var xmlListCollection:XMLListCollection = new XMLListCollection(dataBindableXML);
			xmlListCollection.disableAutoUpdate();
			dataProvider = xmlListCollection;		
		}
		
		/**
		 * @inheritDoc
		 */
		public function get DataId():String
		{
			return this.id;
		}
		
		
		[Inspectable(category="expanz")]
		/**
		 * @inheritDoc
		 */
		public function get QueryID():String
		{
			return queryId;
		}
		public function set QueryID(value:String):void
		{
			queryId = value;
		}
		private var queryId:String;
		
		[Inspectable(category="expanz")]
		/**
		 * @inheritDoc
		 */
		public function get PopulateMethod():String
		{
			//Set to "ListMe" to have the DataGrid be populated with the containing activities Model Object
			if(!populateMethod || populateMethod == ""){
				populateMethod = "ListMe";
			}
			return populateMethod;
		}
		public function set PopulateMethod(value:String):void
		{
			populateMethod = value;
		}
		private var populateMethod:String;
		
		[Inspectable(category="expanz")]
		/**
		 * @inheritDoc
		 */
		public function get ModelObject():String
		{
			return modelObject;
		}
		
		public function set ModelObject(value:String):void
		{
			modelObject = value;
		}
		private var modelObject:String;
		
		[Inspectable(category="expanz",enumeration="true, false", defaultValue="true")]		
		/**
		 * @inheritDoc
		 */
		public function get AutoPopulate():String
		{
			return autoPopulate;
		}
		
		public function set AutoPopulate(value:String):void
		{
			autoPopulate = value;
		}
		private var autoPopulate:String;
		
		public function fillServerRegistrationXml(dp:XML):XML
		{
			return dp;
		}
		
		private var type:String;
		
		/**
		 * @inheritDoc
		 */
		public function get Type():String
		{
			return type;
		}
		
		public function set Type(value:String):void
		{
			type = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------		
		
		private function onCreationComplete(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}	
		
		private function doubleClickHandler(event:MouseEvent):void
		{
			if(!event.target.data)
				return;
							
			var contextXML:XML = <Context id={event.target.data.@id} Type={event.target.data.@Type}/>;			
			var menuActionXML:XML = <MenuAction defaultAction="1"/>;
			
			if (modelObject)
			{
				contextXML.@contextObject = modelObject;
				menuActionXML.@contextObject = modelObject;
			}
			
			harness.sendXmlList(new ArrayCollection([contextXML, menuActionXML]));
		}
		
		private function itemEditEndHandler(event:DataGridEvent):void
		{
			sendDelta(event.columnIndex, event.itemRenderer[columns[event.columnIndex].editorDataField], event.itemRenderer.data.@id, event.itemRenderer.data.@Type);
			/*			var delta:XML = harness.DeltaElement;
			
			delta.@[MessageSchemaConstants.IDAttrib] = columns[event.columnIndex].column.@field;
			
			if (event.itemRenderer[columns[event.columnIndex].editorDataField])
			{
			delta.@[MessageSchemaConstants.Value] = event.itemRenderer[columns[event.columnIndex].editorDataField];
			}
			else
			{
			delta.@[MessageSchemaConstants.Null] = "1";
			}
			
			var context:XML = <Context id={event.itemRenderer.data.@id} Type={event.itemRenderer.data.@Type}/>;
			
			if (modelObject)
			{
			context.@contextObject = modelObject;
			}
			
			
			harness.sendXmlList(new ArrayCollection([context, delta]));*/
		}		
		
		/*  protected override function selectItem(item:IListItemRenderer,
		shiftKey:Boolean, ctrlKey:Boolean,
		transition:Boolean = true):Boolean
		{
		// only run selection code if a checkbox was hit and always
		// pretend we're using ctrl selection
		if (item is ItemEditor)
		//return super.selectItem(item, false, true, transition);
		return false;
		} */
	
	}
}