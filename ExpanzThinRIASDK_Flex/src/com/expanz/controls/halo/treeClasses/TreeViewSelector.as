package com.expanz.controls.halo.treeClasses
{
	import com.expanz.*;
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.interfaces.*;
	
	import mx.collections.XMLListCollection;
	import mx.controls.Tree;
	import mx.controls.listClasses.*;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;

	public class TreeViewSelector extends Tree implements IServerBoundControl, IDataControl, IEditableControl
	{
		private var harness:ControlHarness;
		public function TreeViewSelector()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
			addEventListener(ListEvent.ITEM_CLICK, onClick);
		}
		private function onCreationComplete(event:FlexEvent):void
		{
			this.editable=false;
			harness=new ControlHarness(this);
		}
		private function onClick(event:ListEvent):void
		{
			harness.sendXml(DeltaXml);
		}
		
		public function get fieldId():String
		{
			return MessageSchemaAttributes.makeServerName(this.name);
		}
		
		public function setControlVisible(visible:Boolean):void
		{
			this.visible=visible;
		}
		private var publishing:Boolean;
		private var treeData:XML;
		private var myData:XMLListCollection;
		public function publishData(data:XML):void
		{
			if(data.@["clearOnly"]!=null && MessageSchemaAttributes.boolValue(data.@["clearOnly"]))
			{
				//fixme clear
				return;
			}
			var TYPES:XML;
			var ROWS:XML;
			var child:XML=data.firstChild;
			while(child!=null)
			{
				if(child.localName()=="Types") TYPES=child;
				else if(child.localName()=="Rows") ROWS=child;
				child=child.nextSibling;
			}
			if(ROWS==null) return;
			publishing=true;
			var selectedType:String=ROWS.@["selectedType"];
			var selectedId:String=ROWS.@["selectedId"];
			treeData = new XML(ROWS.toString());
			myData = new XMLListCollection(treeData.Row);
			this.dataProvider=myData;
			this.labelField="@value";
			this.dataTipField="@hint";
				
			publishing=false;
			validateNow();
		}
		

		private var dataId:String;
		public function get DataId():String
		{
			if(dataId==null) dataId=fieldId;
			return dataId;
		}
		public function set DataId(value:String):void
		{
			dataId=value;
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
			dp.@["Type"] = "recursiveList";
			return dp;
		}
		
		public function get DeltaXml():XML
		{
			var delta:XML = harness.DeltaElement;
			delta.@[MessageSchemaAttributes.IDAttrib]= fieldId;
			if(selectedItem!=null && selectedItem is XML)
			{
				var item:XML = selectedItem as XML;
				delta.@[MessageSchemaAttributes.Value]=item.@id;
			}
			else
			{
				delta.@[MessageSchemaAttributes.Null]="1";
			}
			return delta;
		}
		
		public function setEditable(editable:Boolean):void
		{
			this.selectable=editable;
		}
		
		public function setNull():void
		{
			this.selectedIndex=-1;
		}
		private var myCurrentValue:String="?";
		public function setValue(text:String):void
		{
			if (!publishing && text!=myCurrentValue)
			{
				findNodeById(text);
				myCurrentValue=text;
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

		private function expandParents(xmlNode:XML):void
		{
			while (xmlNode.parent() != null)
			{
				xmlNode = xmlNode.parent();
				this.expandItem(xmlNode,true, false);
			}
		}
		      
		private function findNodeById(sId:String):void
		{
			var list:XMLList  = myData.descendants().(@id == sId);
			if(list.length()==0) list=treeData.elements().(@id == sId);
			var node:XML = list[0];
			expandParents(node);
			this.selectedItem = node;
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