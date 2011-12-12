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

package com.expanz.vo.common
{
	import com.expanz.constants.UserType;
	
	import mx.utils.URLUtil;

	/**
	 * The SystemPreferencesVO class is a Value Object class for storing data about the 
	 * Expanz Server this ThinRIA connects too.
	 * 
	 * @author EXPANZ	 
	 */
	[Bindable]
	public class SystemPreferencesVO
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 *  
		 * @private
		 */
		public function SystemPreferencesVO()
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Members
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The portal address this ApplicationEx will connect too.
		 */
		public var portalAddress:String;

		/**
		 * TODO: Document me. What am I?
		 */
		public var fixedSite:String;
		
		/**
		 * TODO: Document me. What am I?
		 */
		public var site:String;
		
		/**
		 * TODO: Document me. What am I?
		 */
		public var userType:String = UserType.PRIMARY;

		/**
	     *  Returns the server name from the portal URL.
		 * 
	     *  <pre>
	     *  portalHost("https://www.expanz.com/ajax/esaservice.asmx") returns "expanz.com"
	     *  </pre>
		 */
		public function get portalHost():String
		{
			return URLUtil.getServerName(portalAddress);
		}

		/**
	     *  Returns the protocol section of the specified portal URL.
	     *  
	     *  The following examples show what is returned based on different URLs:
	     *  
	     *  <pre>
	     *  portalProtocol("https://www.expanz.com/ajax/esaservice.asmx") returns "https"
	     *  portalProtocol("http://www.expanz.com/ajax/esaservice.asmx") returns "http"
	     *  </pre>
		 */
		public function get portalProtocol():String
		{
			return URLUtil.getProtocol(portalAddress);
		}

	}
}