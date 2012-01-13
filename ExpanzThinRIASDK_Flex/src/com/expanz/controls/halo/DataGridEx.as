package com.expanz.controls.halo
{
	import com.expanz.ControlHarness;
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.controls.halo.dataGridClasses.DataGridColumnEx;
	import com.expanz.interfaces.IDataControl;
	import com.expanz.utils.Util;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.utils.ObjectUtil;

	[IconFile("DataGrid.png")]
	/**
	 * expanz DataGrid for binding to Queries.
	 * 
	 * Simply set the PopulateMethod or the QueryID properties.
	 * 
	 **/
	public class DataGridEx extends DataGrid implements IDataControl
	{
		
		private var _harness:ControlHarness;

		public function DataGridEx()
		{
			super();
			
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			//addEventListener(ListEvent.CHANGE, changeHandler);
			addEventListener(DataGridEvent.ITEM_EDIT_END, itemEditEndHandler);
			
			//By default allow double click of rows to launch
			doubleClickEnabled = true;
		}

		private var displayWidth:Number; // I wish this was protected, or internal so I didn't have to recalculate it myself.		


		public function get harness():ControlHarness
		{
			return _harness;
		}

		public function set harness(value:ControlHarness):void
		{
			_harness = value;
		}
		
		
		//------------------------------------------------------
		// IDataControl Interface Implementation include
		//------------------------------------------------------
		include "../../includes/IDataControlImpl.as";
		
		[Bindable]
		public var dataPublicationSource:XML;

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			if (displayWidth != unscaledWidth - viewMetrics.right - viewMetrics.left)
			{
				displayWidth = unscaledWidth - viewMetrics.right - viewMetrics.left;
			}
		}

		override protected function drawRowBackground(s:Sprite, rowIndex:int,
													  y:Number, height:Number, color:uint, dataIndex:int):void
		{
			if (dataIndex < (this.dataProvider as ListCollectionView).length)
			{
				var item:Object = (this.dataProvider as ListCollectionView).getItemAt(dataIndex);
/*
				if (item.@displayStyle.toString() != "")
				{
					switch (item.@displayStyle.toString())
					{
						case "hilite":
							color = 0xf7ec2c;
							break;
						case "warning":
							color = 0xe6451f;
							break;
					}
				}*/
				if (item.displayStyle.toString() != "")
				{
					switch (item.displayStyle.toString())
					{
						case "hilite":
							color = 0xf7ec2c;
							break;
						case "warning":
							color = 0xe6451f;
							break;
					}
				}
			}

			super.drawRowBackground(s, rowIndex, y, height, color, dataIndex);
		}

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
		
		public function refresh():void
		{
			var refresh:XML = harness.DataPublicationRefreshElement;
			refresh.@[MessageSchemaAttributes.IDAttrib] = this.DataId;
			refresh.@refresh = "1";
			harness.sendXml(refresh);
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

		private function changeHandler(event:ListEvent):void
		{
			var contextXML:XML = <Context id={event.itemRenderer.data.@id} Type={event.itemRenderer.data.@Type}/>;

			if (modelObject)
			{
				contextXML.@contextObject = modelObject;
			}

			harness.sendXml(contextXML);
		}



		private function onCreationComplete(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}


		public var lastColumn:DataGridColumn;

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
			
			if (!columns.length)
			{ // do not autgenerate columns if user definded 
				var cols:Array = new Array();

				for each (var colData:XML in data.Columns.children())
				{ 
					//Dont create the column if the width is LT 1. 
					//The server metadata declares these are are hidden fields 
					//so dont render them on the screen but we need the data 
					//still in the dataprovider
					if (colData.@width <= 1 )
						break;
					
					var col:DataGridColumnEx = new DataGridColumnEx();
					col.column = colData;									
					col.dataField = Util.formatColumnName(colData);
					col.headerText = colData.@label;
					col.width = colData.@width;

					// TODO: this needs cleaning up esp. setEditable
					col.setEditable(colData.@editable == "1");
					col.dataType = colData.@datatype;

					if (colData.@editable == "1")
					{
						editable = true;
					}
					
					//text alignment based on col.dataType
					if (col.dataType == "number")
					{
						col.setStyle("textAlign", "right");
					}

					cols.push(col);
				}

				if (lastColumn)
				{
					cols.push(lastColumn); //an ability to leave auto column generation, but slot a column at the end
				}
				columns = cols;
			}
			
			dataProvider = dataBindableXML;
		}


		private function doubleClickHandler(event:MouseEvent):void
		{
			if((event.currentTarget is DataGridColumnEx))
				return;
			
			var harness:ControlHarness = harness;
			var type:String = event.target.data.@Type;
			var contextXML:XML = <Context id={event.target.data.@id} Type={type}/>;			
			var menuActionXML:XML = <MenuAction defaultAction="1"/>;

			if (modelObject)
			{
				contextXML.@contextObject = modelObject;
				menuActionXML.@contextObject = modelObject;
			}

			harness.sendXmlList(new ArrayCollection([contextXML, menuActionXML]));
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
