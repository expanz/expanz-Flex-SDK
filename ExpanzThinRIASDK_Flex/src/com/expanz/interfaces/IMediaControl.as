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
	/**
	 * The expanz control or custom will render some type of media such as image 
	 * or movie or file.   
	 * 
	 * This interface specify how the App server should send return the media 
	 * and in what format.
	 * 
	 * @author expanz
	 * 
	 */
	public interface IMediaControl
	{
		/**
		 * Specify how the media resource should be published to the control.
		 * This may differ per client. E.g. winforms must have a BLOB however
		 * Silverlight client may prefer URL to the media resource
		 *  
		 * Options
		 * - URL: Returns the URL to the resource to load
		 * - BLOB: Returns the ByteArray of the resource 
		 */
		function get publishType():String;
	}
}