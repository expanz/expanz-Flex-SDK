/**
 * ServerVariable is a very light non-visual component that can be declared in MXML. It will register itself
 * with a parent activity. It acts as a data source for custom, non-ex (expanz) data components.
 * 
 * TextInputEx can perform the same function but is much heavier
 **/
package com.expanz.controls.halo
{
	import com.expanz.utils.Util;
	import com.expanz.interfaces.IActivityContainer;
	import com.expanz.interfaces.IEditableControl;
	import com.expanz.interfaces.IServerBoundControl;
	
	import mx.core.IMXMLObject;
	

	public class ServerVariable implements IMXMLObject, IEditableControl, IServerBoundControl
	{
		[Bindable]
		public var value:String;
		[Bindable]
		public var toolTip:String;
		[Bindable]
		public var text:String; //optional

		

		public var id:String;
		
		public function ServerVariable()
		{
		}
		//IMXMLObject
		public function initialized(document:Object, id:String):void
		{
			this.id = id;
			var parentContainer:IActivityContainer = document as IActivityContainer;
			
			if(parentContainer!=null)
			{
				parentContainer.registerControl(this);
			} else {
				throw new Error("ServerVariable must be declared in document of type IActivityContainer");
			}
		}

		
		public function get DeltaXml():XML
		{
			return null; //TODO if needed
		}
		
		public function setEditable(editable:Boolean):void
		{
		}
		
		public function setNull():void
		{
			this.value="";
		}
		
		public function setValue(text:String):void
		{
			this.value=text;
		}
		
		public function setLabel(label:String):void
		{
		}
		
		public function setHint(hint:String):void
		{
			this.toolTip=hint;
		}
		
		public function publishXml(xml:XML):void
		{
			//process some extra optional fields if they are in xml
			if (xml.hasOwnProperty("@text")) {
				this.text = xml.@text;
			}
		}
		
		//------------------------------------------------------
		// IServerBoundControl Interface Implementation
		//------------------------------------------------------
		
		public function get fieldId():String
		{
			return Util.underscoresToDots(this.id);
		}

		public function setControlVisible(visible:Boolean):void
		{
		}
		
	}
}