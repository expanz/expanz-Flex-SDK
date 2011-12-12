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

package com.expanz
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.ui.*;
	
	import mx.controls.Menu;
	import mx.core.UIComponent;
	import mx.events.MenuEvent;

	/**
	 * Provide context menu support to the Activity and Control Harness subclasses.
	 * 
	 * Here to provide future shared features between the harnesses
	 * 
	 * @author expanz
	 * 
	 */
	public class AbstractHarnessBase extends EventDispatcher
	{
		public function AbstractHarnessBase()
		{
			super();
		}
		
		/*
		expanz context menu XML 
		<ContextMenu>
			<Menu name="AP/AR">
				<MenuItem action="$QueryDateRange.Current" text="Current"/>
				<MenuItem action="$QueryDateRange.ThirtyDays" text="30 Days"/>
				<MenuItem action="$QueryDateRange.SixtyDays" text="60 Days"/>
				<MenuItem action="$QueryDateRange.NinetyDays" text="90+ Days"/>
			</Menu>
			<MenuItem action="$QueryDateRange.Today" text="Today"/>
			<MenuItem action="$QueryDateRange.ThisWeek" text="This Week"/>
			<MenuItem action="$QueryDateRange.LastWeek" text="Last Week"/>
			<MenuItem action="$QueryDateRange.CurrentMonth" text="This Month"/>
			<MenuItem action="$QueryDateRange.LastMonth" text="Last Month"/>
			<MenuItem action="$QueryDateRange.LastQuarter" text="Last Quarter"/>
			<MenuItem action="$QueryDateRange.ThisYear" text="This Year"/>
			<MenuItem action="$QueryDateRange.Clear" text="Clear"/>
		</ContextMenu>
		
		Flex menu XML 
		<xmlRoot>
			<menuitem label="MenuItem A" >
				<menuitem label="SubMenuItem A-1" enabled="false"/>
				<menuitem label="SubMenuItem A-2"/>
			</menuitem>
			<menuitem label="MenuItem B" type="check" toggled="true"/>
			<menuitem label="MenuItem C" type="check" toggled="false"/>
			<menuitem type="separator"/>     
			<menuitem label="MenuItem D" >
			<menuitem label="SubMenuItem D-1" type="radio" groupName="one"/>
			<menuitem label="SubMenuItem D-2" type="radio" groupName="one" toggled="true"/>
			<menuitem label="SubMenuItem D-3" type="radio" groupName="one"/>
		</menuitem>
		</xmlRoot>
		
		*/
		/**
		 * Transform expanz context menu data XML into Flex menu xml structure
		 */
		public function convertToFlexXMLMenuData(menu:XML):XML
		{
			var xmlString:String = menu.toXMLString();
			
			//replace Menu to menuitem
			xmlString = xmlString.replace(new RegExp("ContextMenu","/g"), "root");
			
			//replace Menu to menuitem
			xmlString = xmlString.replace(new RegExp("Menu","/g"), "menuitem");
					
			//lower case the MenuItem to menuitem
			xmlString = xmlString.replace(new RegExp("MenuItem","/g"), "menuitem");
			
			//replace text with label
			xmlString = xmlString.replace(new RegExp("text","/g"), "label");
			
			//replace text with label
			xmlString = xmlString.replace(new RegExp("name","/g"), "label");
			
			//replace action with data
			xmlString = xmlString.replace(new RegExp("action","/g"), "data");
			
			//replace Separator with menuitem type="separator"
			xmlString = xmlString.replace(new RegExp("Separator","/g"), "type=\"separator\"");
			
			return new XML(xmlString);
		}
		
		/**
		 * Creates a Context Menu for controls such as a datagrid
		 * @param cm
		 * @param menuXML
		 * 
		 */
		public function createContextMenu(cm:ContextMenu, menuXML:XML):void
		{
			var defaultAction:String = menuXML.@["defaultAction"];						
			for each (var menuItem:XML in menuXML.children()) 
			{
				processMenuElement(cm, menuItem, defaultAction);
			}
		}
		
		private function processMenuElement(cm:ContextMenu, xml:XML, theDefault:String):void
		{
			if (xml.localName() == "MenuItem")
			{
				var text:String = xml.@["text"];
				var item:ContextMenuItem = new ContextMenuItem(text);
				var action:String = xml.@["action"];
				item.data = action;
				
				if (ActivityHarness.ContextMenuPublisher != null)
				{
					item.addEventListener(Event.SELECT, ActivityHarness.ContextMenuPublisher.onMenuItemSelect);
				}
				
				if (action == theDefault)
				{
					//fixme: bold
					item.label += "*";
				}
				/*
				theElement.GetAttribute("clientAction")
				if (Common.boolValue(theElement.GetAttribute("checked")))
				theItem.Checked = true;
				if (theItem.Action == theDefault)
				theItem.DefaultItem = true;
				*/
				cm.addItem(item);
			}
			else if (xml.localName() == "Separator")
			{
				var sep:ContextMenuItem = new ContextMenuItem("", true);
				cm.addItem(sep);
			}
			else if (xml.localName() == "Menu") //sub menu
			{
				var name:String = xml.@["name"];
				var subMenu:ContextMenu = new ContextMenu();
				//TODO: How to handle?
				//cm.addSubmenu(subMenu, name);
				//processMenuElement(subMenu, xml, theDefault);
			}
		}
	}
}