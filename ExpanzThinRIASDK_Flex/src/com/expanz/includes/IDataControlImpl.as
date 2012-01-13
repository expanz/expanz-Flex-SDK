import com.expanz.ControlHarness;

// ActionScript include file

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


/*--------------------------------------------------------------------------

Shared Implementation code of the Interface. 

Due to the lack of multi-inheritence support in AS3 and most modern OO languages, 
we are psudeo inheriting this Interfaces code via and Actionscript include.

Any changes to these files will have sweeping affects across the framework applications.

--------------------------------------------------------------------------*/


//--------------------------------------------------------------------------
//
//  Public Properties
//
//--------------------------------------------------------------------------

//----------------------------------
//  DataId
//----------------------------------
/**
 * @inheritDoc
 */
public function get DataId():String
{
	return this.id;
}

//----------------------------------
//  QueryID
//----------------------------------

[Inspectable(category="expanz")]
/**
 * @inheritDoc
 */
public function get QueryID():String
{
	return queryId;
}
public function set QueryID(value:String):void
{
	queryId=value;
}
private var queryId:String;


//----------------------------------
//  PopulateMethod
//----------------------------------
[Inspectable(category="expanz")]
/**
 * @inheritDoc
 */
public function get PopulateMethod():String
{
	return populateMethod;
}
public function set PopulateMethod(value:String):void
{
	populateMethod=value;
}
private var populateMethod:String;


//----------------------------------
//  ModelObject
//----------------------------------
[Inspectable(category="expanz")]
/**
 * @inheritDoc
 */
public function get ModelObject():String
{
	return modelObject;
}
public function set ModelObject(value:String):void
{
	modelObject=value;
}
private var modelObject:String;


//----------------------------------
//  AutoPopulate
//----------------------------------
[Inspectable(category="expanz",enumeration="0, 1, once", defaultValue="")]	
/**
 * @inheritDoc
 */
public function get AutoPopulate():String
{
	return autoPopulate;
}
public function set AutoPopulate(value:String):void
{
	autoPopulate=value;
}
private var autoPopulate:String;


//----------------------------------
//  Type
//----------------------------------
/**
 * @inheritDoc
 */
public function get Type():String
{
	return type;
}
public function set Type(value:String):void
{
	type=value;
}
private var type:String;


//--------------------------------------------------------------------------
//
//  Public Methods
//
//--------------------------------------------------------------------------	

/**
 * @inheritDoc
 */
public function fillServerRegistrationXml(dp:XML):XML
{
	return dp;
}

