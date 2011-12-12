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
	[IconFile("DeleteButton.png")]
	
	/**
	 * Call the Delete method on the Server Model Object
	 * 
	 * @author 	expanz
	 * @date	7/2010
	 */
	public class DeleteButton extends ButtonEx
	{
		public function DeleteButton()
		{
			super();
			MethodName = "Delete";
			label = "Delete";
		}
	}
}