////////////////////////////////////////////////////////////////////////////////
//
//  expanz
//  Copyright 2008-2011 EXPANZ
//  All Rights Reserved.
//
//  NOTICE: expanz permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.expanz.constants
{

	/**
	 * UserTypes for expanzPlatform authentication.
	 * 
	 * @author expanz
	 * 
	 */
    public final class UserType
    {
		/**
		 * Use Primary Authentication when the role of the user loging in is a staff member
		 * FIXME: Describe these properly
		 */
        public static const PRIMARY:String = "primary";
		
		/**
		 * Use Alternate Authentication when a user is not the primary
		 * FIXME: Describe these properly 
		 */
        public static const ALTERNATE:String = "alternate";
    }
}