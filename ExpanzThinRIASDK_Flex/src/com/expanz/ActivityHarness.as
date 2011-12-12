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

package com.expanz
{
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.controls.halo.Picklist;
	import com.expanz.forms.ClientMessageWindow;
	import com.expanz.interfaces.IActivityContainer;
	import com.expanz.interfaces.IContextMenuPublisher;
	import com.expanz.interfaces.ICustomContentPublisher;
	import com.expanz.interfaces.ICustomSchemaPublisher;
	import com.expanz.interfaces.IDataControl;
	import com.expanz.interfaces.IEditableControl;
	import com.expanz.interfaces.IFieldErrorMessage;
	import com.expanz.interfaces.IGraphControl;
	import com.expanz.interfaces.IMediaControl;
	import com.expanz.interfaces.IMessagePanel;
	import com.expanz.interfaces.IServerBoundControl;
	import com.expanz.interfaces.IServerBoundControlContainer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.IFlexDisplayObject;
	import mx.managers.IFocusManagerComponent;
	import mx.managers.PopUpManager;
	
	import spark.components.TextInput;

	/**
	 * 
	 * @author expanz
	 * 
	 */
	public class ActivityHarness extends AbstractHarnessBase
	{
		private var schemaPublished:Boolean;
		internal var isActivityOwner:Boolean;
		private var appHost:ExpanzThinRIA;

		public function get AppHost():ExpanzThinRIA
		{
			return appHost;
		}

		public function set AppHost(value:ExpanzThinRIA):void
		{
			appHost = value;
		}
		public var Schema:XML;
		private var activityName:String;

		public function set ActivityName(value:String):void
		{
			activityName = value;
		}

		public function get ActivityName():String
		{
			return activityName;
		}
		private var activityStyle:String;

		public function set ActivityStyle(value:String):void
		{
			activityStyle = value;
		}

		public function get ActivityStyle():String
		{
			if (activityStyle == null)
				return "";
			return activityStyle;
		}
		private var activityStamp:String;
		private var container:IActivityContainer;
		private var myControls:Dictionary;

		private function get Controls():Dictionary
		{
			if (myControls == null)
				myControls = new Dictionary();
			return myControls;
		}
		private var myDataControls:Dictionary;

		private function get DataControls():Dictionary
		{
			if (myDataControls == null)
				myDataControls = new Dictionary();
			return myDataControls;
		}
		private var myCustomSchemaControls:ArrayCollection;

		public function get CustomSchemaControls():ArrayCollection
		{
			if (myCustomSchemaControls == null)
				myCustomSchemaControls = new ArrayCollection();
			return myCustomSchemaControls;
		}
		private var publishing:Boolean;

		public function get Publishing():Boolean
		{
			return publishing;
		}
		
		public function get MessagePanelControls():Array
		{
			if (myMessagePanelControls == null)
				myMessagePanelControls = new Array();
			return myMessagePanelControls;
		}
		private var myMessagePanelControls:Array;

		public function ActivityHarness(container:IActivityContainer)
		{
			super();
			this.container = container;
			AppHost = ExpanzThinRIA.getInstance();
		}
		private var myWindowTitle:String;
		private var myWindowTitleField:String;
		private var myWindowTitleFieldValue:String;

		public function get WindowTitle():String
		{
			if (myWindowTitleFieldValue != null && myWindowTitleFieldValue.length > 0)
			{
				var det:String = myWindowTitleFieldValue;

				if (det.length > 32)
					det = det.substr(0, 32) + "...";
				return myWindowTitle + " - " + det;
			}
			else
			{
				return myWindowTitle;
			}
		}
		private var myWindowHintField:String;
		private var myWindowHintFieldValue:String;
		private var myPersistentId:int;

		public function get PersistentId():int
		{
			return myPersistentId;
		}
		private var myFixedContext:String;

		public function get FixedContext():String
		{
			return myFixedContext;
		}

		public function initialise(xml:XML):void
		{
			if (ActivityName != null && ActivityName.length > 0)
			{
				createServerActivity(xml);
			}
		}

		public function get IsInitialised():Boolean
		{
			return activityStamp != null;
		}
		private var myDuplicateIndex:int;

		public function get DuplicateIndex():int
		{
			return myDuplicateIndex;
		}

		public function copyFrom(ah:ActivityHarness):void
		{
			AppHost = ah.AppHost;
			activityStamp = ah.ActivityStamp;
			isActivityOwner = ah.isActivityOwner;

			if (ah.FixedContext != null)
				this.myFixedContext = ah.FixedContext;
			AppHost.getSchema(this);
			Schema = new XML(AppHost.response.toString());
			var act:XML = Schema.children()[0];
			myWindowTitle = act.@["title"];

			if (myWindowTitle.length > 0)
				container.resetWindowTitle(this);
			myWindowTitleField = act.@titleField;
			myWindowHintField = act.@hintField;
			publishResponse(act);

			if (myCustomSchemaControls != null)
			{
				for (var i:int = 0; i < myCustomSchemaControls.length; i++)
				{
					var control:ICustomSchemaPublisher = myCustomSchemaControls.getItemAt(i) as ICustomSchemaPublisher;
					control.customPublishSchema(Schema, FixedContext);
				}
			}

			this.myDuplicateIndex = AppHost.registerActivityCopy(this.container);
		}

		public function createServerActivity(xml:XML):void
		{
			var InitialKey:int = 0;

			if (xml != null && xml.@[MessageSchemaAttributes.Key].toString().length > 0)
			{				
				InitialKey = parseInt(xml.@[MessageSchemaAttributes.Key]);
			}
			AppHost.requestActivity(this.container, ActivityName, ActivityStyle, InitialKey);
		}

		public function appendDataPublicationsToActivityRequest():void
		{
			for (var id:String in DataControls)
			{
				var control:IDataControl = DataControls[id] as IDataControl;
				AppHost.request.CreateActivity.appendChild(<DataPublication useThumbNailImages={true}/>);
				var DP:XML = AppHost.request.CreateActivity.DataPublication[AppHost.request.CreateActivity.DataPublication.length() - 1];
				DP.@[MessageSchemaAttributes.IDAttrib] = control.DataId;

				if (control.PopulateMethod == null && control.QueryID != null)
				{
					DP.@query = control.QueryID;
				}
				
				if (control.PopulateMethod != null)
				{
					DP.@populateMethod = control.PopulateMethod;
				}

				if (control.ModelObject != null)
				{
					DP.@contextObject = control.ModelObject;
				}

				if (control.AutoPopulate != null)
				{
					DP.@autoPopulate = control.AutoPopulate;
				}

				if (control.Type != null)
				{
					DP.@Type = control.Type;
				}
				DP = control.fillServerRegistrationXml(DP);
					//				request.appendChild(DP);				
			}
			
			//Handle IMediaControl in teh same way, will need to refactor when implementing optimisation
			for (var mid:String in Controls)
			{
				var mediaControl:IMediaControl = Controls[mid] as IMediaControl;
				if(mediaControl)
				{
					AppHost.request.CreateActivity.appendChild(<Field id={mid} Publish={mediaControl.publishType}/>);				
				}
			}	
		}

		public function publishSchema(xml:XML):void
		{
			isActivityOwner = true;
			Schema = xml;
			activityStamp = Schema.@[MessageSchemaAttributes.ActivityHandle];

			myWindowTitle = Schema.@title;

			if (myWindowTitle.length > 0)
				container.resetWindowTitle(this);
			myWindowTitleField = Schema.@titleField;
			myWindowHintField = Schema.@hintField;

			if (Schema.hasOwnProperty("@" + MessageSchemaAttributes.FixedContext))
			{
				myFixedContext = Schema.@[MessageSchemaAttributes.FixedContext];
			}

			publishResponse(Schema);

			if (myCustomSchemaControls != null)
			{
				for (var i:int = 0; i < myCustomSchemaControls.length; i++)
				{
					var control:ICustomSchemaPublisher = myCustomSchemaControls.getItemAt(i) as ICustomSchemaPublisher;
					control.customPublishSchema(Schema, FixedContext);
				}
				/* example only
				   for (var id:String in Controls) {
				   var control2:IServerBoundControl = Controls[id] as IServerBoundControl;
				 } */
				
				
			}
			schemaPublished = true;
		}

		public function get ActivityStamp():String
		{
			return activityStamp;
		}

		public function get ActivityStampEx():String
		{
			if (myDuplicateIndex > 0)
				return activityStamp + "/" + myDuplicateIndex.toString();
			else
				return ActivityStamp;
		}

		public function registerControl(control:IServerBoundControl):void
		{
			var id:String = control.fieldId;

			if (schemaPublished)
			{
				mx.controls.Alert.show("Control registration after schema publication:" + id, "Timing Problem");
			}

			//TODO: allow multiple controls
			if (Controls[id] == null)
			{
				Controls[id] = control;
			}
			else
			{	
				//There are more than one control bound to the same field so make it an array of them
				var a:Array = new Array();
				a.push(control);
				a.push(Controls[id]);
				Controls[id] = a;
			}
		}

		public function registerDataControl(control:IDataControl):void
		{
			var id:String = control.DataId;

			if (schemaPublished)
			{
				mx.controls.Alert.show("Data Control registration after schema publication:" + id, "Timing Problem");
			}

			if (DataControls[id] == null)
			{
				DataControls[id] = control;
			}
		}
		
		public function registerMessageControl(control:IMessagePanel):void
		{
			MessagePanelControls.push(control);
		}

		public function registerCustomSchemaPublisher(control:ICustomSchemaPublisher):void
		{
			CustomSchemaControls.addItem(control);
		}
		private var myGraphControls:Dictionary;

		internal function get GraphControls():Dictionary
		{
			if (myGraphControls == null)
				myGraphControls = new Dictionary();
			return myGraphControls;
		}

		public function registerGraphControl(control:IGraphControl):void
		{
			GraphControls[control.GraphId] = control;
		}
		private var myControlContainers:Dictionary;

		internal function get ControlContainers():Dictionary
		{
			if (myControlContainers == null)
				myControlContainers = new Dictionary();
			return myControlContainers;
		}

		public function registerControlContainer(control:IServerBoundControlContainer):void
		{
			ControlContainers[control.fieldId] = control;
		}
		private var myCustomControls:Dictionary;

		internal function get CustomControls():Dictionary
		{
			if (myCustomControls == null)
				myCustomControls = new Dictionary();
			return myCustomControls;
		}

		public function registerCustomControl(control:ICustomContentPublisher):void
		{
			CustomControls[control.ContentId] = control;
		}

		public function Exec(xml:XML):void
		{
			clearMessages();
			AppHost.request = <ESA><Activity/></ESA>;
			var act:XML = AppHost.request.Activity[0];
			act.@[MessageSchemaAttributes.ActivityHandle] = ActivityStamp;
			act.appendChild(xml);
			AppHost.submitRequestToServerPortal();
		}

		public function ExecList(xmlList:ArrayCollection):void
		{
			clearMessages();
			AppHost.request = <ESA><Activity/></ESA>;
			var act:XML = AppHost.request.Activity[0];
			act.@[MessageSchemaAttributes.ActivityHandle] = ActivityStamp;

			for (var i:int = 0; i < xmlList.length; i++)
			{
				var xml:XML = xmlList.getItemAt(i) as XML;
				act.appendChild(xml);
			}
			AppHost.submitRequestToServerPortal();
		}

		public function publishResponse(xml:XML):void
		{
			publishing = true;

			if (xml.hasOwnProperty("@" + MessageSchemaAttributes.ActivityPersistentId))
			{
				myPersistentId = parseInt(xml.@[MessageSchemaAttributes.ActivityPersistentId]);
			}


			for each (var child:XML in xml.children())
			{
				switch (child.localName())
				{
					case "Data":
						var dataId:String = child.@[MessageSchemaAttributes.IDAttrib];
						
						if (dataId == MessageSchemaAttributes.Picklist)
						{
							var picklist:Picklist = new com.expanz.controls.halo.Picklist();
							//picklist.label = "Select " + child.@contextObject;
							picklist.data = child;
							picklist.harness = this;
							
							PopUpManager.addPopUp(picklist, container as DisplayObject, true);
							PopUpManager.centerPopUp(picklist);
						}
						else
						{
							var process:Boolean = true;
							
							if (FixedContext != null)
							{
								var len:int = FixedContext.length;
								
								if (dataId.length > len && dataId.substr(0, len) == FixedContext)
								{
									dataId = dataId.substr(len);
								}
							}
							
							if (process && DataControls[dataId] != null)
							{
								var dc:IDataControl = DataControls[dataId] as IDataControl;
								dc.publishData(child);
							}
						}
						break;
					case "Field":
						publishXmlToChild(child);
						break;
					case "Messages":
						for each (var msg:XML in child.children())
						{
							publishMessage(msg);
						}
						break;
					case "ModelObject":
						var dirty:Boolean = MessageSchemaAttributes.boolValue(child.@[MessageSchemaAttributes.Dirty]);
						var mo:String = child.@[MessageSchemaAttributes.IDAttrib];
						container.publishDirtyChange(mo, dirty);
						break;
					case "ContextMenu":
						if (ContextMenuPublisher == null)
						{
							mx.controls.Alert.show("No publisher for context menu");
						}
						else
							ContextMenuPublisher.publishContextMenu(child);
						break;
					case "UIMessage":						
						processUIMessages(child);
						break;
					case "closeWindow":
						container.close();
						break;
					default:
						trace("OTHER " + child.localName());
				}
			}
			
			dispatchEvent(new Event("publishingComplete"));
			
			publishing = false;
			ContextMenuPublisher = null;
		}

		/**
		 * 
		 * @param uiMessage
		 * 
		 */
		protected function processUIMessages(uiMessage:XML):void
		{
			var popup:ClientMessageWindow = new ClientMessageWindow();
			popup.publishXml(uiMessage);
			popup.activityHarness = this;
			PopUpManager.addPopUp(popup as IFlexDisplayObject, this.container as DisplayObject, true);
			PopUpManager.centerPopUp(popup);
			
		}
		
		private function publishMessage(msg:XML):void
		{
			//Show in Message Panel if it exists
			if (container.MessagePanel != null)
			{
				container.MessagePanel.addMessage(msg);
			}
			else
			{
				AppHost.publishMessage(msg);
			}
			
			//Show Validation on control if possible
			var fieldID:String = msg.@source;
			var control:IFieldErrorMessage;
						
			if (Controls[fieldID] is Array)
			{
				//There may be multiple fields with the same fieldID in this activity 
				var a:Array = Controls[fieldID];
				for (var i:int = 0; i < a.length; i++) 
				{						 
					control = a[i] as IFieldErrorMessage;	
					if (control)
						control.showError(msg);
				}					
			}
			else
			{	
				//There is only one field activity with this fieldID
				control = Controls[fieldID] as IFieldErrorMessage;
				if (control)
					control.showError(msg);
			}
			
			//Set the focus to the field
			if(control)
			{
				if (msg.hasOwnProperty("focusField"))
				{
					//Server may indicate which field to set the focus too
					var otherControl:IServerBoundControl = Controls[msg.@focusField];
					if(otherControl)
						(otherControl as IFocusManagerComponent).setFocus();
				}
				else
				{
					//If not then just setFocus to the field in question
					(control as IFocusManagerComponent).setFocus();
					(control as TextInput).selectAll();
				}			
			}
		}

		public function clearMessages():void
		{
			if (container.MessagePanel != null)
				container.MessagePanel.clear();
		}

		private function publishXmlToChild(xml:XML):void
		{
			var process:Boolean = true;
			var processed:Boolean = false;
			var titleField:Boolean = false;
			var hintField:Boolean = false;
			var id:String = xml.@[MessageSchemaAttributes.IDAttrib];


			if (myFixedContext != null)
			{
				var len:int = myFixedContext.length;

				if (id.length >= len && id.substr(0, len) == myFixedContext)
				{
					if (myWindowTitleField != null && myWindowTitleField.length > 0 && myWindowTitleField == id)
					{
						titleField = true;
					}
					id = id.substr(len + 1);
				}
				else
				{
					if (id.indexOf(".") < 0)
						process = false;

					if (myWindowTitleField != null && myWindowTitleField.length > 8 && myWindowTitleField.substr(0, 8) == "$Parent.")
					{
						if (id == myWindowTitleField.substr(8))
							titleField = true;
					}
				}
			}

			if (myWindowTitleField != null && myWindowTitleField.length > 0 && myWindowTitleField == id)
			{
				titleField = true;
			}

			if (myWindowHintField != null && myWindowHintField.length > 0 && myWindowHintField == id)
			{
				hintField = true;
			}

			//TODO: FIX UNDERSCORING INSIDE ELEMENTS, not here
			if (process && Controls[id] != null)
			{
				if (Controls[id] is Array)
				{
					var a:Array = Controls[id];
					for (var i:int = 0; i < a.length; i++) 
					{						
						var c:IServerBoundControl = a[i] as IServerBoundControl;
						publishToControl(xml, c, false, false);
					}					
				}
				else
				{					
					var control:IServerBoundControl = Controls[id] as IServerBoundControl;
					publishToControl(xml, control, false, false);				
				}
				processed = true;
			}

			//check for registered container
			if (!processed)
			{
				if (titleField)
				{
					var textVal:String = xml.@[MessageSchemaAttributes.Value];

					if (textVal.length > 0)
						myWindowTitleFieldValue = textVal;
					else
						myWindowTitleFieldValue = "New";
				}

				if (id.indexOf(".") > 0)
				{
					var p:int = id.indexOf(".");
					var prefix:String = id.substr(0, p);

					if (ControlContainers[prefix] != null)
					{
						var cont:IServerBoundControlContainer = ControlContainers[prefix] as IServerBoundControlContainer;
						cont.publishXml(xml);
						processed = true;
					}
				}

				if (!processed && xml.hasOwnProperty("@" + MessageSchemaAttributes.Label))
				{
					//no control, but a label for it
					var label:String = xml.@[MessageSchemaAttributes.Label];
					//check for a field with this id + _label
					var l:String = id + "_label";
					/* fixme
					   object o = myVisualContainer.FindName(l);
					   if (o != null)
					   {
					   if (o is Label)
					   {
					   ((Label)o).Content = label;
					   }
					 } */
				}
			}

			if (titleField)
				container.resetWindowTitle(this);
		}

		private function publishToControl(xml:XML, control:IServerBoundControl, titleField:Boolean, hintField:Boolean):void
		{
			if (xml.hasOwnProperty("@hidden"))
			{
				control.setControlVisible(MessageSchemaAttributes.boolValue(xml.@["hidden"]));
			}

			
			if (control is IEditableControl)
			{
				var ec:IEditableControl = control as IEditableControl;
				//always give control a chance to publish first
				ec.publishXml(xml);

				//check for label publish
				if (xml.hasOwnProperty("@" + MessageSchemaAttributes.Label))
				{
					var label:String = xml.@[MessageSchemaAttributes.Label];
					ec.setLabel(label);
				}

				if (xml.hasOwnProperty("@" + MessageSchemaAttributes.Hint))
				{
					ec.setHint(xml.@[MessageSchemaAttributes.Hint]);
				}

				if (xml.hasOwnProperty("@" + MessageSchemaAttributes.Null) && MessageSchemaAttributes.boolValue(xml.@[MessageSchemaAttributes.Null]))
				{
					ec.setNull();

					if (titleField)
						this.myWindowTitleFieldValue = "New";
				}

				var co:Object = control as Object; //todo: Multiple control support

				if (co.hasOwnProperty("FieldLabel") && co.FieldLabel != null && co.FieldLabel.length > 0)
				{ //todo: use interfaces
					ec.setValue(xml[co.FieldLabel]); //this gives us the ability to define an ESA analogy to Flex labelField
				}
				else if (xml.hasOwnProperty("@" + MessageSchemaAttributes.Value))
				{
					var value:String = xml.@[MessageSchemaAttributes.Value];

					if (value == MessageSchemaAttributes.LongData)
						value = xml.toString();
					ec.setValue(value);

					if (titleField)
					{
						if (value.length > 0)
							myWindowTitleFieldValue = value;
						else
							myWindowTitleFieldValue = "New";
					}

					if (hintField)
					{
						if (value.length > 0)
							myWindowHintFieldValue = value;
						else
							myWindowHintFieldValue = "[?]";
					}
				}

				if (xml.hasOwnProperty("@" + MessageSchemaAttributes.Disabled))
				{
					ec.setEditable(!MessageSchemaAttributes.boolValue(xml.@[MessageSchemaAttributes.Disabled]));
				}
				
				if (xml.hasOwnProperty("@" + MessageSchemaAttributes.URL))
				{
					ec.setValue(xml.@[MessageSchemaAttributes.URL]);
				}
			}
		}
		private static var contextMenuPublisher:IContextMenuPublisher;

		public static function set ContextMenuPublisher(value:IContextMenuPublisher):void
		{
			contextMenuPublisher = value;
		}

		public static function get ContextMenuPublisher():IContextMenuPublisher
		{
			return contextMenuPublisher;
		}
		
		/*public function sendXml(sendList:XMLList):void 
		{
			var sendElt:XML = new XML();
		
			sendElt = GlobalRequest.CreateElement(MyAlternateActivity);
			
			
			resultDoc = <ESA><Activity activityHandle={activityStamp}>{sender.request.toXMLString()}<Activity></ESA>;
			appHost.
			apphost.submitRequestToServerPortal();
		}*/
		/*public sendXml(sendList:XMLList)void 
		{
		var sendElt:XML = new XML();
		if (MyAlternateActivity == null || MyAlternateActivity.Length==0)
		{
		sendElt = GlobalRequest.CreateElement(Common.ActivityNode);
		sendElt.SetAttribute(Common.ActivityHandle, this.MyActivityHandle);
		}
		else
		sendElt = GlobalRequest.CreateElement(MyAlternateActivity);
		
		try
		{
		IEnumerator<XmlElement> myPreSend = preSendElts.GetEnumerator();
		while (myPreSend.MoveNext())
		{
		XmlElement preSend = myPreSend.Current;
		if (preSend.OwnerDocument == GlobalRequest)
		sendElt.AppendChild(preSend);
		else
		sendElt.AppendChild(GlobalRequest.ImportNode(preSend, true));
		}
		preSendElts.Clear();
		}
		catch (Exception e) { AppHomeBase.debugException(e); }
		
		for (int i = 0; i < sendList.GetLength(0); i++)
		{
		if (sendList[i].OwnerDocument == GlobalRequest)
		sendElt.AppendChild(sendList[i]);
		else
		sendElt.AppendChild(GlobalRequest.ImportNode(sendList[i], true));
		}
		sendXmlArray(new XmlElement[] {sendElt});
		}*/
	}
}