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
	public interface IServerMethodCaller
	{
		/**
		 * The Server MethodName to call
		 */
		function get MethodName():String;
				
		/**
		 * If the partent Activity Container is not the Model Object to call 
		 * the methods on Set the Model Object here you want to call methods on.
		 * 
		 * i.e If the ERP.Sales Order has children MO's like Customer and Lines
		 */
		function get ModelObject():String;
		
		/**
		 * To refer to the different Model Object within the activity 
		 * from which this method is refering to.
		 * 
		 * TODO: Confirm what this is for?
		 */
		function get ReferenceObject():String;
				
		/**
		 * Set to launch/create a server activity 
		 */
		function get Activity():String;
				
		/**
		 * Activity Style is set my the server
		 * i.e. ERP.SalesOrder style could be
		 * Consultant or Employee, depending on whos looking at it
		 */
		function get ActivityStyle():String;

	}
}