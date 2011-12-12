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

package com.expanz.controls
{	
	import com.expanz.ExpanzThinRIA;
	import com.expanz.events.ItemEvent;
	import com.expanz.interfaces.IProcessAreaNavigationMenu;
	import com.expanz.utils.ProcessAreaNavigationMenuHelper;
	import com.expanz.vo.ActivityVO;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	
	import spark.components.List;
	import spark.events.IndexChangeEvent;
			
	/**
	 * List renderer of the expanz Process Map. The expanz process map is basically a menu of your 
	 * Process Areas and Activities.
	 * <br/><br/>
	 * To use simply drop the list where you want to display your menu and create your custom skin. 
	 * You can render the menu using any layout you choose.
	 * <br/><br/>
	 * Upon successful Authentication this components data provider will be set with the menu data. 
	 * You do not need to program anything it is automatically wired up to the expanz framework. 
	 * <br/><br/>
	 * @usage <ProcessMapNavigationMenuList skinClass="com.myproject.skins.ProcessMapNavigationMenuListSkin" />
	 * 
	 * @see com.expanz.skins.ProcessMapNavigationMenuListSkin
	 * @see http://expanz.com/docs/activity_aka_business_process_.html
	 * 
	 * @author expanz
	 */
	public class ProcessMapNavigationMenuList extends List implements IProcessAreaNavigationMenu
	{
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------	
		
		[Bindable]
		private var menuRoot:ActivityVO;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ProcessMapNavigationMenuList()
		{
			super();
			ExpanzThinRIA.getInstance().registerProcessAreaNavigationMenu(this);
			addEventListener(IndexChangeEvent.CHANGE, menuItemClick, false, 0, true);
		}
		
		//--------------------------------------------------------------------------
		//  IProcessAreaNavigationMenu
		//--------------------------------------------------------------------------
		
		public function loadMenu(menuXML:XML):void
		{
			menuRoot = new ActivityVO();
			menuRoot.title = "Home";	
			menuRoot.children = new ArrayCollection();
			ProcessAreaNavigationMenuHelper.processMenu(menuRoot.children, menuXML)
			
			setMenu(menuRoot);	
		}
		
		public function setMenu(dp:ActivityVO):void
		{
			if (this.dataProvider == dp.children)
			{
				return;
			}
			
			this.dataProvider = dp.children;
			
			//breadcrumbs
			
			var currentCrumbs:Array = findPathToSeed([ menuRoot ], dp);
			
			//breadcrumbs.removeAllChildren();
			
			for each (var a:ActivityVO in currentCrumbs)
			{
				var b:Button = new Button();
				b.styleName = "breadcrumb";
				b.label = a.title
				b.data = a;
				b.addEventListener(MouseEvent.CLICK,
					function(e:MouseEvent):void{
						setMenu(e.currentTarget.data);
					});
				//breadcrumbs.addChild(b);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------		
		
		private function findPathToSeed(initialPath:Array, seed:ActivityVO):Array
		{
			if (initialPath[initialPath.length - 1] == seed)
			{
				return initialPath; //return "Home" if we are in home (we are adding seed at the end of path if found)
			}
			
			
			for each (var child:ActivityVO in initialPath[initialPath.length - 1].children)
			{
				if (child == seed)
				{
					initialPath.push(child); //(we are adding seed at the end of path if found)
					return initialPath;
				}
				else if (child.children != null && child.children.length)
				{
					//copy array
					var newPath:Array = new Array();
					
					for each (var a:ActivityVO in initialPath)
					{
						newPath.push(a);
					}
					newPath.push(child);
					var path:Array = findPathToSeed(newPath, seed);
					
					if (path != null)
					{
						return path;
					}
				}
			}
			return null;
		}
		
		
		private function menuItemClick(event:IndexChangeEvent):void
		{
			//var a:ActivityVO = event.target.itemRenderer.data as ActivityVO;
			var a:ActivityVO = this.selectedItem as ActivityVO;
			
			if (a == null)
			{
				trace("Error: unexpected data type");
				return;
			}
			
			if (a.isCategory == false)
			{
				//do item stuff
				dispatchEvent(new ItemEvent(ItemEvent.ACTIVITY_SELECTED, a, true));
			}
			else if (a.children.length)
			{
				setMenu(a);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
		
	}
}