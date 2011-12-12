import com.expanz.ExpanzThinRIA;
import com.expanz.constants.MessageSchemaAttributes;

//----------------------------------
//  MethodName
//----------------------------------

[Inspectable(category="Expanz")]
/**
 * @inheritDoc
 */
public function get MethodName():String
{
	return _MethodName;
}

public function set MethodName(value:String):void
{
	_MethodName = value;
}

private var _MethodName:String;

//----------------------------------
//  ModelObject
//----------------------------------

[Inspectable(category="Expanz")]
/**
 * @inheritDoc
 */
public function get ModelObject():String
{
	return _ModelObject;
}

public function set ModelObject(value:String):void
{
	_ModelObject = value;
}

private var _ModelObject:String;

//----------------------------------
//  ReferenceObject
//----------------------------------

[Inspectable(category="Expanz")]
/**
 * @inheritDoc
 */
public function get ReferenceObject():String
{
	return _ReferenceObject;
}

public function set ReferenceObject(value:String):void
{
	_ReferenceObject = value;
}

private var _ReferenceObject:String;

//----------------------------------
//  Activity
//----------------------------------

[Inspectable(category="Expanz")]
/**
 * @inheritDoc
 */
public function get Activity():String
{
	return _Activity;
}

public function set Activity(value:String):void
{
	_Activity = value;
}

private var _Activity:String;

//----------------------------------
//  ActivityStyle
//----------------------------------

[Inspectable(category="Expanz")]
/**
 * @inheritDoc
 */
public function get ActivityStyle():String
{
	return _ActivityStyle;
}

public function set ActivityStyle(value:String):void
{
	_ActivityStyle = value;
}

private var _ActivityStyle:String="";

//--------------------------------------------------------------------------
//
//  Public Members
//
//--------------------------------------------------------------------------

/**
 * If the user has started editing this object. Then this method is called to
 * show the Object is dirty / has changes to persist commit.
 *  
 * @param dirty
 */
public function setDirtyState(dirty:Boolean):void
{
	var l:int = label.length - 1;
	if (dirty)
	{
		if (!this.label.substr(l,1)=="*") this.label += "*";
	}
	else
	{
		if (this.label.substr(l,1)=="*") this.label = this.label.substr(0,l);
	}
}
/**
 * Programatically callable 
 * 
 * @example buttonid.click(); 
 * 
 */
public function click():void
{
	var xml:XML;
	
	if (MethodName && MethodName.length > 0)
	{
		//Set the method name
		//xml = _harness.MethodElement;
		xml = <Method/>;
		xml.@[MessageSchemaAttributes.Name] = MethodName;
		
		//Set the contextObject
		if(ModelObject!=null && ModelObject.length>0)
		{
			xml.@["contextObject"]=ModelObject;
		}else if (ReferenceObject!=null && ReferenceObject.length>0)
		{
			xml.@["contextObject"]=ReferenceObject;
		}
		if (xml)
		{
			harness.sendXml(xml);
		}
	}
	else if (Activity && Activity.length > 0)
	{
		/*xml = <CreateActivity/>;
		xml.@name = Activity;
		xml.@style = ActivityStyle;*/
		
		ExpanzThinRIA.getInstance().createActivityWindowEx(Activity, ActivityStyle, null, null);
	}			
}

protected var harness:ControlHarness;

protected function creationCompleteHandler(event:FlexEvent):void
{
	harness = new ControlHarness(this);
}

private function init():void
{
	addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
}