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

package com.expanz.controls.buttons
{
	import com.expanz.ControlHarness;
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.interfaces.IDataControl;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.Button;

	[IconFile("RefreshButton.png")]
	/**	 
	 * RefreshButtonEx is used to target refreshing a particular IDataControl implementation
	 * on the screen, such as a DataGridEx, ListEx, TreeEx for instance.
	 * 
	 * To use simply set the DataControl Property to the refernce of the control.
	 * 
	 * <buttons:RefreshButtonEx DataControl="{ordersList}"/>
	 * 
	 * <controls:DataGridEx id="ordersList"/>
	 * 
	 * @author 	expanz
	 * 
	 */
	public class RefreshButton extends Button
	{
		protected var harness:ControlHarness;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function RefreshButton()
		{
			label = "Refresh";
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			buttonMode = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Properties
		//
		//--------------------------------------------------------------------------
		
		[Inspectable(category="Expanz")]
		/**
		 * The string ID of the IDataControl implementation to refresh
		 */
		public var DataId:String;
		
		[Inspectable(category="Expanz")]
		/**
		 * Reference to the IDataControl implementation to refresh
		 */
		public var DataControl:IDataControl;
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		protected override function clickHandler(event:MouseEvent):void
		{
			var refresh:XML = harness.DataPublicationRefreshElement;
			refresh.@[MessageSchemaAttributes.IDAttrib] = (DataControl!=null) ? DataControl.DataId : this.DataId;
			refresh.@refresh = "1";
			harness.sendXml(refresh);
		}		
		
		protected function creationCompleteHandler(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}
	}
}