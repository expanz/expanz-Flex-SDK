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
	import com.expanz.constants.MessageSchemaElements;
	import com.expanz.controls.halo.ListItemEx;
	import com.expanz.interfaces.IDataControl;
	import com.expanz.interfaces.IEditableControl;
	import com.expanz.interfaces.IServerBoundControl;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import spark.components.DropDownList;
		
	[IconFile("DropDownList.png")]
	/**
	 * 
	 * @author expanz
	 * 
	 */
	public class DropDownListEx extends DropDownList implements IServerBoundControl, IEditableControl, IDataControl
	{	
		
		private var harness:ControlHarness;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DropDownListEx()
		{
			super();			
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(Event.CHANGE, onChange);
		}		
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------------------------
		// IServerBoundControl Interface Implementation
		//------------------------------------------------------
		include "../includes/IServerBoundControlImpl.as";
		
		//------------------------------------------------------
		// IEditableControl Interface Implementation
		//------------------------------------------------------
		
		public function get DeltaXml():XML
		{
			var delta:XML = harness.DeltaElement;
			delta.@[MessageSchemaAttributes.IDAttrib]= fieldId;
			if(selectedItem!=null && selectedItem is ListItemEx)
			{
				var item:ListItemEx = selectedItem as ListItemEx;
				delta.@[MessageSchemaAttributes.Value]=item.Id;
			}
			else
			{
				delta.@[MessageSchemaAttributes.Null]="1";
			}
			return delta;
		}
		
		public function setEditable(editable:Boolean):void
		{
			this.enabled=editable;
		}
		
		public function setNull():void
		{
			
		}
		
		public function setValue(text:String):void
		{
			for (var i:int = 0; i < items.length; i++)
			{
				var item:ListItemEx = items.getItemAt(i) as ListItemEx;
				if(text==item.Id)
				{
					this.selectedItem=item;
					break;
				}
			}
		}
		
		public function setLabel(label:String):void
		{
			
		}
		
		public function setHint(hint:String):void
		{
			this.toolTip=hint;
		}
		
		public function publishXml(xml:XML):void
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		private function itemLabel(item:Object):String
		{
			if(item is ListItemEx)
			{
				var i:ListItemEx = item as ListItemEx;
				return i.label;
			}
			else return "?";
		}
		
		private var items:ArrayCollection=new ArrayCollection();
		
		/**
		 * 
		 * 
		 */
		public function publishData(data:XML):void
		{
			items.removeAll();			
			var NULL:ListItemEx = new ListItemEx("0","(none)");
			items.addItem(NULL);
			var COLUMNS:XML;
			var ROWS:XML;
			for each (var child:XML in data.children())
			{
				if(child.localName()==MessageSchemaElements.Columns) COLUMNS=child;
				else if(child.localName()==MessageSchemaElements.Rows) ROWS=child;
			}
			if(ROWS==null || COLUMNS==null) return;
			var displayColumn:String;
			for each (var col:XML in COLUMNS.children())
			{
				if(col.@["width"].length())
				{
					var width:int=parseInt(col.@["width"]);
					if(width>0) 
					{
						displayColumn=col.@[MessageSchemaAttributes.IDAttrib];
						break;
					}
				}
			}
			
			if(displayColumn==null) return;
			for each (var row:XML in ROWS.children())
			{
				var rowID:String=row.@[MessageSchemaAttributes.IDAttrib];
				var text:String = row.Cell.(@id==displayColumn).valueOf();
				var item:ListItemEx=new ListItemEx(rowID, text);
				if(row.@["Type"].length())
				{
					item.Type=row.@[MessageSchemaAttributes.Type];
				}
				items.addItem(item);
			}
			this.dataProvider=items;
			this.labelFunction=itemLabel;
		}
		
		private var dataId:String;
		
		[Inspectable(category="expanz")]
		public function get DataId():String
		{
			return fieldId;
		}		
		public function set DataId(value:String):void
		{
		}
		
		private var queryId:String;
		
		[Inspectable(category="expanz")]
		public function get QueryID():String
		{
			return queryId;
		}
		public function set QueryID(value:String):void
		{
			queryId=value;
		}
		private var populateMethod:String;
		
		[Inspectable(category="expanz")]
		public function get PopulateMethod():String
		{
			return populateMethod;
		}
		public function set PopulateMethod(value:String):void
		{
			populateMethod=value;
		}
		private var modelObject:String;
		
		[Inspectable(category="expanz")]
		public function get ModelObject():String
		{
			return modelObject;
		}
		public function set ModelObject(value:String):void
		{
			modelObject=value;
		}
		private var autoPopulate:String;
		
		//[Inspectable(category="expanz", enumeration="0, 1, once, ", defaultValue="")]
		[Inspectable(category="expanz")]
		public function get AutoPopulate():String
		{
			return autoPopulate;
		}
		public function set AutoPopulate(value:String):void
		{
			autoPopulate=value;
		}
		
		public function fillServerRegistrationXml(dp:XML):XML
		{
			return dp;
		}
		
		private var type:String;
		public function get Type():String
		{
			return type;
		}
		public function set Type(value:String):void
		{
			type=value;
		}
		
		private var queryMode:String;
		[Inspectable(category="expanz")]
		public function get QueryMode():String
		{
			return queryMode;
		}
		public function set QueryMode(value:String):void
		{
			queryMode=value;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function onCreationComplete(event:FlexEvent):void
		{
			harness=new ControlHarness(this);
		}
		
		private function onChange(event:Event):void
		{
			harness.sendXml(DeltaXml);
		}	
		
		//--------------------------------------------------------------------------
		//
		//  Overriden Properties
		//
		//--------------------------------------------------------------------------
		
		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}		
	}
}