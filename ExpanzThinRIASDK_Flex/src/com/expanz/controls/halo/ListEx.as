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

package com.expanz.controls.halo
{
	import com.expanz.*;
	import com.expanz.interfaces.*;
	import com.expanz.utils.Util;
	
	import mx.controls.List;
	import mx.events.FlexEvent;

	public class ListEx extends List implements IDataControl
	{
		public var harness:ControlHarness;
		
		public var runAfterPublish: Function;
		
		include "../../includes/IDataControlImpl.as";
		
		public function ListEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			//By default allow double click of rows to launch
			doubleClickEnabled = true;
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			harness=new ControlHarness(this);
		}
			
		public var doXmlTrasform:Boolean = true; //does the renderer expect transformed or raw data?
		
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
					
					if (doXmlTrasform) {
						dataProvider = Util.transformXMLToDataBindableXML(data,"");
					} else {
						dataProvider = data.Rows.children(); // xml processing moved to itemRenderer, todo: pass info about columns so we don't have to hardcode
					}
					
				} else {
					dataProvider = null;
				}
			}
			
			if(runAfterPublish is Function)
				runAfterPublish(this, data);
		}
	}
}
