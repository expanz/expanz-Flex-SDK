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
//  Properties
//
//--------------------------------------------------------------------------

private var _fieldId:String; 

[Inspectable(category="Expanz")]
/**
 * @inheritDoc
 */
public function get fieldId():String
{
	if(_fieldId)
		return _fieldId;
	if(this.id)
		return this.id;
	return "";
}

[Inspectable(category="Expanz")]
public function set fieldId(value:String):void
{
	_fieldId = value;
}

//--------------------------------------------------------------------------
//
//  Methods
//
//--------------------------------------------------------------------------

/**
 * @inheritDoc
 */
public function setControlVisible(visible:Boolean):void
{
	this.visible=visible;
}