package com.expanz.controls.halo
{
	import com.expanz.*;
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.interfaces.*;
	import com.expanz.utils.Util;
	
	import mx.containers.HBox;
	import mx.events.FlexEvent;

	public class SizeChooserEx extends HBox implements IServerBoundControl, IEditableControl //do we need???  , IDataControl
	{
		private var harness:ControlHarness;
		public function SizeChooserEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
//			addEventListener(Event.CHANGE, onChange);
		}
		private function onCreationComplete(event:FlexEvent):void
		{
			harness=new ControlHarness(this);
		}
		
		private var lastEditedElement: SizeChooserElement;
		public function onChange(subElement:SizeChooserElement):void
		{
			var delta:XML = harness.DeltaElement;
			delta.@[MessageSchemaAttributes.IDAttrib] = fieldId.replace("_", "."); // fix for multiple occurences of _
			delta.@[MessageSchemaAttributes.Key] = subElement.key
			delta.@[MessageSchemaAttributes.Value] = subElement.field.text;
			harness.sendXml(delta);
			lastEditedElement = subElement;
		}
		
		public function get fieldId():String
		{
			return this.name;
		}
		
		public function setControlVisible(visible:Boolean):void
		{
			this.visible=visible;
		}
		
		public function get DeltaXml():XML //not used here
		{
			var delta:XML = harness.DeltaElement;
			delta.@[MessageSchemaAttributes.IDAttrib]= fieldId;
//			if(selectedItem!=null && selectedItem is ListItemEx)
//			{
//				var item:ListItemEx = selectedItem as ListItemEx;
//				delta.@[MessageSchemaConstants.Value]=item.Id;
//			}
//			else
//			{
//				delta.@[MessageSchemaConstants.Null]="1";
//			}
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
//			for (var i:int = 0; i < items.length; i++)
//			{
//				var item:ListItemEx = items.getItemAt(i) as ListItemEx;
//				if(text==item.Id)
//				{
//					this.selectedItem=item;
//					break;
//				}
//			}
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
			if (xml.children().length() <1) {
				trace(xml);
				if (lastEditedElement!=null && xml.@id==Util.underscoresToDots(id) && xml.@valid!="1") {
					lastEditedElement.field.text = ""; //change wasn't accepted
				}
				//init:
				//<Field id="StockTranItem.PlanQuantity" label="Quantity" disabled="0" nullable="0" valid="0" null="1" value="" valueIsApportioned="0" datatype="number"/>
				//confirm:
				//<Field id="StockTranItem.PlanQuantity" null="0" valid="1" value="4" valueIsApportioned="1" />
				return; //TODO: handle success
			}
			removeAllChildren(); //optimize me
			for each (var item:XML in xml.children()) {
				var element:SizeChooserElement = new SizeChooserElement();
				element.key = item.@key;
				element.hint = item.@hint;
				element.value = item;
				element.control = this;
				addChild(element);
			}
		}

//		private var items:ArrayCollection=new ArrayCollection();
		public function publishData(data:XML):void
		{
		}
		private var dataId:String;
		public function get DataId():String
		{
			return fieldId;
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
	}
}