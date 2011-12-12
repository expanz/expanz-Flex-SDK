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

package com.expanz.activitycontainers
{
	import com.expanz.interfaces.IActivityContainer;
	
	import spark.components.Group;
	
	[IconFile("Group.png")]
	/**
	 * Group expanz Activity Container
	 * 
	 * @author expanz
	 * 
	 */
	public class GroupEx extends Group implements IActivityContainer
	{
		include "../includes/IActivityContainerImpl.as";
		
		public function GroupEx()
		{
			super();
			init();
		}
	}
}