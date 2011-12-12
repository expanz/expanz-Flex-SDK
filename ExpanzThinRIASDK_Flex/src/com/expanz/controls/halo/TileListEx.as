package com.expanz.controls.halo
{
	import com.expanz.*;
	import com.expanz.interfaces.*;
	
	import mx.collections.ArrayCollection;
	import mx.controls.TileList;
	import mx.events.FlexEvent;

	public class TileListEx extends TileList implements IDataControl
	{
		public var harness:ControlHarness;
		public function TileListEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		private function onCreationComplete(event:FlexEvent):void
		{
			harness=new ControlHarness(this);
		}
		
//		public function get fieldId():String
//		{
//			return this.name;
//		}
//		
//		public function setControlVisible(visible:Boolean):void
//		{
//			this.visible=visible;
//		}
		
		private var items:ArrayCollection=new ArrayCollection();
		public function publishData(data:XML):void
		{
			var allProducts:Array = new Array();
			for each (var child:XML in data.Rows.children()) {
				//TODO: Remove shopping cart references 
				if (child.@id.length && child.@Type=="ERP.ItemForSale") {
					var product:Object = new Object();
					product.id = child.@id;
					//product.setUrls();
					product.name = child.Cell3;
					product.category = child.Cell4;
					allProducts.push(product);
				}	
			}
			dataProvider = new ArrayCollection(allProducts); //using arraycol so we can filter later
//			dataProvider = data.Rows.children();
			
			
//			items.removeAll();
//			var NULL:ListItemEx = new ListItemEx("0","(none)");
//			items.addItem(NULL);
//			var COLUMNS:XML;
//			var ROWS:XML;
//			for each (var child:XML in data.children())
//			{
//				if(child.localName()=="Columns") COLUMNS=child;
//				else if(child.localName()=="Rows") ROWS=child;
//			}
//			if(ROWS==null || COLUMNS==null) return;
//			var displayColumn:String;
//			for each (child in COLUMNS.children())
//			{
//				if(child.@["width"].length())
//				{
//					var width:int=parseInt(child.@["width"]);
//					if(width>0) {
//						displayColumn=child.@[MessageSchemaConstants.IDAttrib];
//						break;
//					}
//				}
//			}
//			if(displayColumn==null) return;
//			for each (child in ROWS.children())
//			{
//				var id:String=child.@[MessageSchemaConstants.IDAttrib];
//				var text:String = child["Cell"+displayColumn].valueOf();
//				var item:ListItemEx=new ListItemEx(id,text);
//				if(child.@["Type"].length())
//				{
//					item.Type=child.@["Type"];
//				}
//				items.addItem(item);
//			}
//			this.dataProvider=items;
//			this.labelFunction=itemLabel;
		}
		private var dataId:String;
		public function get DataId():String
		{
			return this.name;
		}
		public function set DataId(value:String):void
		{
		}
		private var queryId:String;
		public function get QueryID():String
		{
			return queryId;
		}
		public function set QueryID(value:String):void
		{
			queryId=value;
		}
		private var populateMethod:String;
		public function get PopulateMethod():String
		{
			return populateMethod;
		}
		public function set PopulateMethod(value:String):void
		{
			populateMethod=value;
		}
		private var modelObject:String;
		public function get ModelObject():String
		{
			return modelObject;
		}
		public function set ModelObject(value:String):void
		{
			modelObject=value;
		}
		private var autoPopulate:String;
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
	}
}