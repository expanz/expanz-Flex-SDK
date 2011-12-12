package com.expanz.controls.halo
{
	import com.expanz.*;
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.controls.*;
	import com.expanz.controls.halo.dataGridClasses.GridColumnEx;
	import com.expanz.interfaces.IContextMenuPublisher;
	import com.expanz.interfaces.IDataControl;
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.*;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;


	public class SimpleGridEx extends DataGrid implements IDataControl, IContextMenuPublisher
	{
		private var harness:ControlHarness;
		private var lastRollOverIndex:int; 
//AIR	private var myContextMenu:NativeMenu;
		private var myContextMenu:ContextMenu;
		public function SimpleGridEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			this.doubleClickEnabled = true;
		}
		private function onCreationComplete(event:FlexEvent):void
		{
			harness=new ControlHarness(this);
			addEventListener(ListEvent.ITEM_ROLL_OVER,onRollOver);
			addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onDoubleClick);
			addEventListener(MouseEvent.RIGHT_CLICK, contextMenuSelect);
		}
		private function onDoubleClick(e:ListEvent):void
		{
			this.selectedIndex = e.rowIndex;
			var xml:XML = this.selectedItem as XML;
			var id:String=xml.@id;
			var type:String=xml.@Type;
			//build menu dynamically from server
			var nodes:ArrayCollection = harness.getDoubleClickRequest(id,type,modelObject);
			harness.sendXmlList(nodes);
		}
		private function onRollOver(e:ListEvent):void
		{
			lastRollOverIndex = e.rowIndex;
		}
		private var menuX:int;
		private var menuY:int;
		private function contextMenuSelect(e:MouseEvent):void
		{
			this.selectedIndex = lastRollOverIndex;
			var xml:XML = this.selectedItem as XML;
			var id:String=xml.@id;
			var type:String=xml.@Type;
			//build menu dynamically from server
			var nodes:ArrayCollection = harness.getContextMenuRequest(id,type,modelObject);
			ActivityHarness.ContextMenuPublisher = this;
			//fixe remember position to display
			menuX=e.stageX;
			menuY=e.stageY;
			harness.sendXmlList(nodes);
		}
		
		public function publishData(data:XML):void
		{
			var COLUMNS:XML;
			var ROWS:XML;
			var child:XML=data.firstChild;
			while(child!=null)
			{
				if(child.localName()=="Columns") COLUMNS=child;
				else if(child.localName()=="Rows") ROWS=child;
				child=child.nextSibling;
			}
			if(ROWS==null || COLUMNS==null) return;
			var cols:Array = new Array();
			child=COLUMNS.children()[0];
			while(child!=null)
			{
				if(child.@["width"]!=null)
				{
					var width:int=parseInt(child.@["width"]);
					if(width>0)
					{
						var id:String=child.@[MessageSchemaAttributes.IDAttrib];
						var label:String=child.@["label"];
						var col:GridColumnEx = new GridColumnEx();
						col.CellId=id;
						col.headerText=label;
						col.width=width;
						cols.push(col);
					}
				}
				child=child.nextSibling;
			}
			this.columns=cols;
			var rows:XML = new XML(ROWS.toString());
			var items:XMLListCollection = new XMLListCollection(rows.Row);
			this.dataProvider=items;
		}
		public function get DataId():String
		{
			return this.name;
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
		
		public function publishContextMenu(menu:XML):void
		{
			myContextMenu = new ContextMenu();
			myContextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,contextMenuSelect);
			harness.createContextMenu(myContextMenu,menu);
			myContextMenu.display(this.stage,menuX,menuY);
		}
		
		public function onMenuItemSelect(e:Event):void
		{
			if(e.currentTarget is ContextMenuItem) //AIR NativeMenuItem
			{
				var item:ContextMenuItem = e.target as ContextMenuItem;
				var action:String = item.data as String;
				var node:XML = harness.MenuActionElement(action,modelObject);
				harness.sendXml(node);
			}	
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