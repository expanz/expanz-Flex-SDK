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
	import com.expanz.interfaces.IActivityContainer;
	
	import mx.containers.Canvas;
	
	[IconFile("Canvas.png")]
	/**
	 * 
	 * @author expanz
	 * 
	 */
	public class ActivityTabPageEx extends Canvas implements IActivityContainer
	{
		include "../../includes/IActivityContainerImpl.as";						
		
		public function ActivityTabPageEx()
		{
			super();
			init();
		}		
	}
}