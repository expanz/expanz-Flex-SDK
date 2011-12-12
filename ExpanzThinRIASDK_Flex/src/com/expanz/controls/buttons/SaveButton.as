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
	[IconFile("SaveButton.png")]
	/**
	 * Call the Save method on the Server Model Object
	 * 
	 * @author 	expanz
	 * @date	7/2010
	 */
	public class SaveButton extends ButtonEx
	{
		public function SaveButton()
		{
			super();
			MethodName = "Save";
			label = "Save";
		}
	}
}