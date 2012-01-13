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
	 * Implement on any control that wishes to render the Data Publication Schema
	 * 
	 * Data Publications can be retrieved by 2 methods
	 * 1. Populdate Method
	 * 2. Query IDs.
	 * 
	 * Set one or the other not both to get data from teh App Server.
	 * 
	 * @author expanz
	 * @see http://developer.expanz.com/schemas/ep/2008/docs/CreateActivity_Response.html#Data
	 */
	public interface IDataControl
	{
		/**
		 * Must be implemented by each control as the way they render their data 
		 * is particular to the control / display rendering
		 * @param data DataPublication XML 
		 * 
		 * @see http://developer.expanz.com/schemas/ep/2008/docs/CreateActivity_Response.html#Data
		 */
		function publishData(data:XML):void;
		
		/**
		 * 
		 * @return 
		 * 
		 */
		function get DataId():String;
		
		/**
		 * ID of the Query declared in metadata in the App Server.
		 * Mutually exclusive to QueryID. You need only set one of these depending 
		 * on the data retrieval method
		 */
		function get QueryID():String;
				
		/**
		 * The method on the Model Object to call for the data
		 * Mutually exclusive to QueryID. You need only set one of these depending 
		 * on the data retrieval method 
		 */
		function get PopulateMethod():String;
		
		
		/**
		 * If this the root Model Object of the Activity does not contain the 
		 * Populate Method to call then set the ModelObject property to the 
		 * child ModelObject that contains the method to call for the datapublication
		 *   
		 */
		function get ModelObject():String;
		
		/**
		 * When set to True will retrive the data automatically on creation.
		 * When set to False will await to be sent the Datapublication from some 
		 * other event. e.g a Show Report screen may have some date range inputs then on 
		 * a "show report" button the DataPublication will be sent to the 
		 * IDataControl for rendering		 
		 */
		function get AutoPopulate():String;
		
		/**
		 * The Type of the ModelObject being rendered in this IDataControl 
		 */
		function get Type():String;
		
		/**
		 *  
		 */
		//function get QueryMode():String;
				
		/**
		 * TODO: DOCUMENT 
		 * @param dp
		 * @return 
		 * 
		 */
		function fillServerRegistrationXml(dp:XML):XML;
	}
}