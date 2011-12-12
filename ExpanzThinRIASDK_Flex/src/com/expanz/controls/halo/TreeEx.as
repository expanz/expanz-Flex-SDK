package com.expanz.controls.halo
{
	import com.expanz.*;
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.interfaces.*;
	
	import mx.controls.Tree;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;

	/**
	 * TODO Document Tree
	 * 
	 * @author sh@expanz
	 * 
	 */
	public class TreeEx extends Tree implements IDataControl, IServerBoundControl
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function TreeEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			if(!localChangeHandler)
				addEventListener(ListEvent.CHANGE, onChange);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public function get fieldId():String
		{
			return this.name;
		}		
		
		//when using this component in MXML set the properties below to match your data structure (don't change the defaults here)
		public var nodeTagName: String = "Row";
		public var rootTagName: String = "Rows";
		public var runAfterPublish: Function;
		public var localChangeHandler: Boolean;

		[Bindable]
		public var selectedItemLabel:String ="Please select a Category";
		public var harness:ControlHarness;
		
		[Inspectable(category="Expanz")]
		public function get DataId():String
		{
			return this.name;
		}
		
		private var queryId:String;
		
		[Inspectable(category="Expanz")]
		public function get QueryID():String
		{
			return queryId;
		}
		public function set QueryID(value:String):void
		{
			queryId=value;
		}
		
		private var populateMethod:String;
		[Inspectable(category="Expanz")]
		public function get PopulateMethod():String
		{
			return populateMethod;
		}
		public function set PopulateMethod(value:String):void
		{
			populateMethod=value;
		}
		
		private var modelObject:String;
		[Inspectable(category="Expanz")]
		public function get ModelObject():String
		{
			return modelObject;
		}
		public function set ModelObject(value:String):void
		{
			modelObject=value;
		}
		private var autoPopulate:String;
		
		[Inspectable(category="Expanz")]
		public function get AutoPopulate():String
		{
			return autoPopulate;
		}
		public function set AutoPopulate(value:String):void
		{
			autoPopulate=value;
		}
		
		
		private var _type:String;
		[Inspectable(category="Expanz")]
		public function get Type():String
		{
			return _type;
		}
		public function set Type(value:String):void
		{
			_type = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  IDataControl Interface
		//--------------------------------------------------------------------------
		/**
		 * TODO: Document
		 * 
		 */
		public function fillServerRegistrationXml(dp:XML):XML
		{
			return dp;
		}
		
		
		//--------------------------------------------------------------------------
		//  IServerBoundControl Interface
		//--------------------------------------------------------------------------
		/**
		 * TODO: Document Who calls this? when do they call it and why? 
		 * 
		 */
		public function setControlVisible(visible:Boolean):void
		{
			this.visible = visible;
		}
		
		/**
		 * TODO: Document
		 * 
		 */
		public function publishData(data:XML):void
		{
			if(rootTagName != "")
			{
				dataProvider = data[rootTagName].children();
			}else
			{
				dataProvider = data.children();
			}
			runAfterPublish(this, data);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}
		
		protected function onChange(event:ListEvent):void
		{
			if(localChangeHandler)
				return;
			
			var delta:XML = harness.DeltaElement;
			delta.@[MessageSchemaAttributes.IDAttrib]= name;
			delta.@[MessageSchemaAttributes.Value]=event.itemRenderer.data.@id;
			harness.sendXml(delta);
			selectedItemLabel = event.itemRenderer.data[labelField]; //TODO: fix if using label function
		}
	}
}