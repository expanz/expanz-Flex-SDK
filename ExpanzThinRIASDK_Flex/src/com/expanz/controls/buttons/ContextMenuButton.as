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
	import com.expanz.ActivityHarness;
	import com.expanz.interfaces.IContextMenuPublisher;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Menu;
	import mx.events.MenuEvent;
	
	[IconFile("ContextMenuButton.png")]
	/**
	 * Renders Dynamic context menu items from the server.
	 * The menu can be heirarchical. It is by design that this context menu control is not 
	 * integrated with the flash player conext menu as it is restrictive, 
	 * does not support sub menus, looks ugly and non skinnable, is not supported on mobile and AIR apps 
	 * 
	 * @usage <ContextMenuButton >
	 * 
	 * @author expanz
	 */
	public class ContextMenuButton extends ButtonEx implements IContextMenuPublisher
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ContextMenuButton()
		{
			super();
			addEventListener(MouseEvent.CLICK, onClick_Handler, false, 0, true);
		}
		
		//------------------------------------------------------
		// IContextMenuPublisher
		//------------------------------------------------------		
		private var myContextMenu:Menu; 
		
		/**
		 * Custom implementation of the server Context Menu XML to create a context menu
		 * The framework will call this method passing the Context Menu XML from the server
		 */
		public function publishContextMenu(menu:XML):void
		{						
			var xmlMenuData:XML = harness.convertToFlexXMLMenuData(menu);
			
			// Create the menu and don't show the (single) XML root node in the menu.
			myContextMenu = Menu.createMenu(null, xmlMenuData, false);
			
			// Set the labelField explicitly for XML data providers.
			myContextMenu.labelField="@label"				
			
			myContextMenu.addEventListener(MenuEvent.ITEM_CLICK, onMenuItemSelect, false, 0, true);
			
			// Positioning
			var lp:Point = new Point(this.x, this.y);
			var gp:Point = parent.localToGlobal(lp)			
			myContextMenu.show(gp.x, gp.y + this.height);
		}
		
		/**
		 * Event handler for selecting a menu item.
		 * Sends the selected meu items action to the server for handling 
		 */
		public function onMenuItemSelect(event:Event):void
		{								
			var action:String = ((event as MenuEvent).item as XML).@data;
			var node:XML = harness.MenuActionElement(action, ModelObject);
			harness.sendXml(node);				
		}		
		
		private function onClick_Handler(event:MouseEvent):void
		{			
			//Developer may have a server method for creating the context menu
			if (MethodName=="")
			{
				var xml:XML
				var id:String=xml.@id;
				var type:String=xml.@Type;
				
				// build menu dynamically from server
				var nodes:ArrayCollection = harness.getContextMenuRequest(id, type, ModelObject);
				ActivityHarness.ContextMenuPublisher = this;
				
				harness.sendXmlList(nodes);
			}	
			//Tell the activity this is the current ContextMenuPublisher to publish to 
			ActivityHarness.ContextMenuPublisher = this;			
		}		
	}
}