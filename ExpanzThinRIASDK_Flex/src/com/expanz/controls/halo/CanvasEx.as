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
	import com.expanz.interfaces.IActivityTabStackPage;
	
	import mx.containers.Canvas;

	[IconFile("Canvas.png")]
	/**
	 * Canvas expanz Activity Container
	 * 
	 * If using Flex 4 SDK please use the spark containers 
	 * 
	 * @see com.expanz.activitycontainers.*
	 * 
	 * @author expanz
	 * 
	 */
	public class CanvasEx extends Canvas implements IActivityContainer, IActivityTabStackPage
	{
		include "../../includes/IActivityContainerImpl.as";
		
		public function CanvasEx()
		{
			super();
			init();		
		}
	}
}