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
//  Imports
//
//--------------------------------------------------------------------------

import com.expanz.ActivityHarness;
import com.expanz.ExpanzThinRIA;
import com.expanz.controls.buttons.ButtonEx;
import com.expanz.interfaces.ICustomContentPublisher;
import com.expanz.interfaces.ICustomSchemaPublisher;
import com.expanz.interfaces.IDataControl;
import com.expanz.interfaces.IGraphControl;
import com.expanz.interfaces.IMessagePanel;
import com.expanz.interfaces.IServerBoundControl;
import com.expanz.interfaces.IServerBoundControlContainer;

import flash.display.DisplayObject;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.containers.ViewStack;
import mx.core.Container;
import mx.events.FlexEvent;

private var appHost:ExpanzThinRIA;
private var createXML:XML;
private var harness:ActivityHarness;
private var myDirtyButtons:Dictionary;
private var wantFixedWindowTitle:Boolean;

//--------------------------------------------------------------------------
//
//  Public Properties
//
//--------------------------------------------------------------------------

//----------------------------------
//  AppHost
//----------------------------------

/**
 * @inheritDoc
 */
public function get AppHost():ExpanzThinRIA
{
	return ExpanzThinRIA.getInstance();
}

//----------------------------------
//  defferedActivation
//----------------------------------
[Inspectable(category="Expanz")]
/**
 * Set to true to defer server activity creation but you want the UI component created on the display list
 * A deffered Activity must be initialised manually calling activate();
 */
public var defferedActivation:Boolean;

//----------------------------------
//  IsDynamic
//----------------------------------
/**
 * TODO:DOC
 */
public var IsDynamic:Boolean;

//----------------------------------
//  imageIconURL
//----------------------------------
[Inspectable(category="Expanz")]
[Bindable]
/**
 * Icon Image URL for the activity
 */
public var imageIconURL:String;


//----------------------------------
//  ActivityName
//----------------------------------

[Inspectable(category="Expanz")]
/**
 * @inheritDoc
 */
public function get ActivityName():String
{
	return harness.ActivityName;
}

public function set ActivityName(value:String):void
{
	harness.ActivityName = value;
}

//----------------------------------
//  ActivityStyle
//----------------------------------
[Inspectable(category="Expanz", enumeration="Browse")]
/**
 * @inheritDoc
 */
public function get ActivityStyle():String
{
	return harness.ActivityStyle;
}
public function set ActivityStyle(value:String):void
{
	harness.ActivityStyle = value;
}

//----------------------------------
//  ActivityStamp
//----------------------------------
/**
 * @inheritDoc
 */
public function get ActivityStamp():String
{
	return harness.ActivityStamp;
}

//----------------------------------
//  ActivityStampEx
//----------------------------------
/**
 * @inheritDoc
 */
public function get ActivityStampEx():String
{
	return harness.ActivityStampEx;
}

//----------------------------------
//  DuplicateIndex
//----------------------------------
/**
 * @inheritDoc
 */
public function get DuplicateIndex():int
{
	return harness.DuplicateIndex;
}

//----------------------------------
//  FixedContext
//----------------------------------
/**
 * @inheritDoc
 */
public function get FixedContext():String
{
	return harness.FixedContext;
}

//----------------------------------
//  IsInitialised
//----------------------------------
/**
 * @inheritDoc
 */
public function get IsInitialised():Boolean
{
	return harness.IsInitialised;
}

//----------------------------------
//  MessagePanel
//----------------------------------
/**
 * @inheritDoc
 */
public function get MessagePanel():IMessagePanel
{
	return _messagePanel;
}

public function set MessagePanel(value:IMessagePanel):void
{
	_messagePanel = value;
}
private var _messagePanel:IMessagePanel;

//----------------------------------
//  PersistentKey
//----------------------------------
/**
 * @inheritDoc
 */
public function get PersistentKey():int
{
	return harness.PersistentId;
}

//----------------------------------
//  Publishing
//----------------------------------
/**
 * @inheritDoc
 */
public function get Publishing():Boolean
{
	return harness.Publishing;
}

//----------------------------------
//  WantFixedWindowTitle
//----------------------------------
public function set WantFixedWindowTitle(value:Boolean):void
{
	wantFixedWindowTitle = value;
}


//----------------------------------
//  SingleViewMode
//----------------------------------
/**
 * @inheritDoc
 */
public function get SingleViewMode():Boolean
{
	return _SingleViewMode;
}

public function set SingleViewMode(value:Boolean):void
{
	_SingleViewMode = value;
}
private var _SingleViewMode:Boolean=false;



//--------------------------------------------------------------------------
//
//  Public Methods
//
//--------------------------------------------------------------------------


/**
 * @inheritDoc
 */
public function initHarness():void
{	
	if(!harness)
		harness = new ActivityHarness(this);
}

/**
 * @inheritDoc
 */
public function Exec(xml:XML):void
{
	harness.Exec(xml);
}

/**
 * @inheritDoc
 */
public function ExecList(nodes:ArrayCollection):void
{
	harness.ExecList(nodes);
}

/**
 * @inheritDoc
 */
public function appendDataPublicationsToActivityRequest():void
{
	harness.appendDataPublicationsToActivityRequest();
}

/**
 * @inheritDoc
 */
public function close():void
{
	if (parent && parent is ViewStack)
	{
		parent.removeChild(this);
	}
	AppHost.activityWindowClosing(this);
}

/**
 * @inheritDoc
 */
virtual public function closeOnLogout():void
{
	harness = null;
}

/**
 * @inheritDoc
 */
public function findChildByName(name:String):DisplayObject
{
	return getChildByName(name);
}

/**
 * @inheritDoc
 */
public function focus(setState:String = null):void
{
	if (setState != null)
	{ //we accept emptystring
		currentState = setState;
	}
	
	if (this.parent && this.parent is ViewStack)	
	{
		//set me as the current tab	
		(this.parent as Object).selectedChild = this;	
	} 	
}

/**
 * @inheritDoc
 */
public function initialise(xml:XML):void
{
	if(xml)
	{
		createXML = xml;
		imageIconURL = xml.@image;	
	}
}

/**
 * @inheritDoc
 */
public function initialiseCopy(H:ActivityHarness):void
{
	harness.copyFrom(H);
	ExpanzThinRIA.CreatingContainer = null;
	//		if (NavigationPanel != null) harness.NavigationPanel = NavigationPanel;
}

/**
 * @inheritDoc
 */
public function publishDirtyChange(modelObject:String, dirty:Boolean):void
{
	if (DirtyButtons[modelObject] != null)
	{
		var b:ButtonEx = DirtyButtons[modelObject] as ButtonEx;
		b.setDirtyState(dirty);
	}
}

/**
 * @inheritDoc
 */
public function publishResponse(xml:XML):void
{
	harness.publishResponse(xml);
}

/**
 * @inheritDoc
 */
public function publishSchema(xml:XML):void
{
	harness.publishSchema(xml);
}

/**
 * @inheritDoc
 */
public function registerControl(control:IServerBoundControl):void
{
	harness.registerControl(control);
}

/**
 * @inheritDoc
 */
public function registerControlContainer(control:IServerBoundControlContainer):void
{
	harness.registerControlContainer(control);
}

/**
 * @inheritDoc
 */
public function registerCustomControl(control:ICustomContentPublisher):void
{
	harness.registerCustomControl(control);
}

/**
 * @inheritDoc
 */
public function registerCustomSchemaPublisher(control:ICustomSchemaPublisher):void
{
	harness.registerCustomSchemaPublisher(control)
}

/**
 * @inheritDoc
 */
public function registerDataControl(control:IDataControl):void
{
	harness.registerDataControl(control);
}

/**
 * @inheritDoc
 */
public function registerMessageControl(control:IMessagePanel):void
{
	harness.registerMessageControl(control);
}

/**
 * @inheritDoc
 */
public function registerDirtyButton(b:ButtonEx):void
{
	DirtyButtons[b.ModelObject] = b;
}

/**
 * @inheritDoc
 */
public function registerGraphControl(control:IGraphControl):void
{
	harness.registerGraphControl(control);
}

/**
 * @inheritDoc
 */
public function resetWindowTitle(H:ActivityHarness):void
{
	if (!this.wantFixedWindowTitle && this is mx.core.Container)//Updates halo Canvas and Tab Nav
		(this as mx.core.Container).label = H.WindowTitle;
	
	//TODO: Add support for spark containers
}

/**
 * @inheritDoc
 */
internal function get DirtyButtons():Dictionary
{
	if (myDirtyButtons == null)
		myDirtyButtons = new Dictionary();
	return myDirtyButtons;
}


public function activate():void 
{				
	if (ExpanzThinRIA.getInstance()!=null)
	{
		harness.initialise(createXML);
	}
}

//--------------------------------------------------------------------------
//
//  Private Methods
//
//--------------------------------------------------------------------------

/**
 * Called by the classes constructor. Centralises repeated constructor code and compiles it.
 */
private function init():void
{
	this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
	this.addEventListener(FlexEvent.PREINITIALIZE, onPreInitialize);
}

private function onPreInitialize(e:FlexEvent):void
{
	initHarness();
}

/**
 * The Activity view component must be created before having a valid session.
 * You can activate the activty after logging in successfully by calling .activate() 
 */
private function onCreationComplete(e:FlexEvent):void
{
	if(!defferedActivation){
		activate();
	}
}