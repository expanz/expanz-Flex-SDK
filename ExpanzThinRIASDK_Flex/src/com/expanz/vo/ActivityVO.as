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

package com.expanz.vo
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	/**
	 * Activity Value Object for typed access to the expanz Activitie in a Process Map.
	 * 
	 * Dynamic access allow the custom application developer to attach new properties at runtime without having to subclass
	 * 
	 * 
	 * @author expanz
	 * 
	 */
	public dynamic class ActivityVO
	{
		/**
		 * Title label of the Activity 
		 */
		public var title:String;
		
		/**
		 * Local image resource reference representing the Activity
		 */
		public var image:Class;
		
		/**
		 * The Style for the Activty 
		 * @see http://expanz.com/docs/activity_style.html
		 */
		public var style:String;
		
		/**
		 * Activity reference name decalred in metadata, not to be used as the label
		 */
		public var name:String;
		
		/**
		 * is a ProcessArea
		 */
		public var isCategory:Boolean = false; 
		
		/**
		 * Child Process Areas or Activities
		 */
		public var children:ArrayCollection;

		/**
		 * 
		 */
		public var enabled:Boolean = true;

		
		/**
		 * Used for Flex Databinding as label property is the default property for 
		 * displaying labels on itemrenderers  
		 */		
		public function get label():String
		{
			return title;
		}
		
		/**
		 * Add children menus 
		 */
		public function addChild(value:Object):void
		{
			if(!children)
				children = new ArrayCollection();
			
			children.addItem(value);
		}
	}
}