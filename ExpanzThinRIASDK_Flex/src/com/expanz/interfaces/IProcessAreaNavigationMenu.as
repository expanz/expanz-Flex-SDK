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

package com.expanz.interfaces
{
	import com.expanz.vo.ActivityVO;

	/**
	 * Process Area application menu renderer component interface.
	 * 
	 *  
	 * @see com.expanz.controls.ProcessMapNavigationMenuList
	 * @see com.expanz.skins.ProcessMapNavigationMenuListSkin
	 * 
	 * @author expanz
	 * 
	 */
	public interface IProcessAreaNavigationMenu
	{
				/**
		 * Called when the system has downloaded the menu and wants the Implmenting component to render the menu 
		 * @param menuXML
		 * 
		 */
		function loadMenu(menuXML:XML):void;

		
		/**
		 * A protected function to implement for setting the current menu item the user has selected 
		 * @param dp
		 * 
		 */
		function setMenu(dp:ActivityVO):void;

	}
}