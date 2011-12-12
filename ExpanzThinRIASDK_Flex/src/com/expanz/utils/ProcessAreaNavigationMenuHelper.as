////////////////////////////////////////////////////////////////////////////////
//
//  expanz 2008 - 2012
//  All Rights Reserved.
//
//  NOTICE: expanz permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.expanz.utils
{
	import com.expanz.interfaces.IProcessAreaNavigationMenu;
	import com.expanz.logging.LogUtil;
	import com.expanz.vo.ActivityVO;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;

	/**
	 * Helper class providing static methods for handling the Process Map menu rendering
	 * 
	 * @see com.expanz.controls.ProcessMapNavigationMenuList
	 * @see com.expanz.controls.halo.MenuBarEx
	 *   
	 * @author expanz 
	 */
	public class ProcessAreaNavigationMenuHelper
	{
		private static var LOGGER:ILogger = LogUtil.getLogger(ProcessAreaNavigationMenuHelper);
		
		
		/**
		 * Staic helper to serialize the Process Areas into ActivityVOs for databinding
		 *  
		 * @param currentParent
		 * @param element
		 * @param suppressSingleProcessAreas if a ProcessArea has only one Activity child 
		 * element bring the Activity Menu Item to the Top level to avoid the user having 
		 * to click twice to launch the activity 
		 * 
		 */
		public static function processMenu(currentParent:ArrayCollection, element:XML, suppressSingleProcessAreas:Boolean=true):void
		{
			var activity:ActivityVO;
			
			for each (var child:XML in element.children())
			{
				if(element.localName() == "ProcessArea" && element.children().length() == 0)
				{
					continue;
				}
				
				activity = new ActivityVO();
				activity.title = child.@title;		
				
				if (child.localName() == "Activity")
				{
					activity.name = child.@name;
					activity.style = child.@style;
					activity.original = child as XML;
					currentParent.addItem(activity);
				}
				else if (child.localName() == "ProcessArea")
				{
					if(child.children().length() == 0)
					{
						//Do not render empty Process Areas
						continue;
					}
					else if(child.children().length() == 1 && suppressSingleProcessAreas)
					{
						activity.name = child.child(0).@name;
						activity.style = child.child(0).@style;
						activity.title = child.child(0).@title;
						activity.imageURL = String(child.child(0).@image);
						activity.original = new XML(child.child(0).toXMLString());
						currentParent.addItem(activity);											
					}
					else if(child.children().length() >= 1)
					{
						activity.isCategory = true;
						activity.children = new ArrayCollection();
						currentParent.addItem(activity);
						processMenu(activity.children, child, suppressSingleProcessAreas);					
					}					
				}
			}
		}
		
		/**
		 * 
		 * @param IProcessAreaNavigationMenu
		 * @return 
		 * 
		 */
		public static function loadApplicationMenuData(menuData:XML, processAreaNavigationMenuRegister:Array):void
		{
/*			try
			{*/
				for each (var menuComponent:IProcessAreaNavigationMenu in processAreaNavigationMenuRegister) 
				{
					menuComponent.loadMenu(menuData);
				}			
/*			}
			catch (error:Error)
			{
				LOGGER.error("Error: loadApplicationMenuData processing failed. {0}", error.message);
			}*/
		}
	}
}