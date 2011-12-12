package com.expanz.activitycontainers
{
	import com.expanz.*;
	import com.expanz.controls.buttons.ButtonEx;
	import com.expanz.interfaces.*;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import com.expanz.activitycontainers.windowExClasses.ResizableTitleWindow;

	[IconFile("TitleWindow.png")]
	/**
	 * TODO: refactor to use include
	 * 
	 * @author expanz
	 * 
	 */
	public class WindowEx extends ResizableTitleWindow implements IActivityContainer
	{
		private var harness:ActivityHarness;
		private var appHost:ExpanzThinRIA;
		private var createXML:XML;		
		private var _messagePanel:IMessagePanel;
		
		public var isModalWindow:Boolean=true;
		
		/**
		 * when true only one instance of this activity can exist 
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

		
		public function get AppHost():ExpanzThinRIA
		{
			return appHost;
		}
		
		public function set AppHost(value:ExpanzThinRIA):void
		{
			appHost = value;
		}
		
		public function set ActivityName(value:String):void
		{
			harness.ActivityName = value;
		}
		
		public function set ActivityStyle(value:String):void
		{
			harness.ActivityStyle = value;
		}
		
		public function WindowEx()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			harness = new ActivityHarness(this);
			//addEventListener(Event.CLOSING, onClose);
			addEventListener(CloseEvent.CLOSE, onClose);
			//layout = "absolute"; //Deprecated for Fx4
			//showCloseButton = true; //Deprecated to be hadled by Skin but perhaps needs to be included as an attribute
			
		}
		
		private function onCreationComplete(e:FlexEvent):void
		{
			harness.AppHost = this.AppHost;
			harness.initialise(createXML);
		}
		
		private function onClose(e:Event):void
		{
			close();
		}
		
		public function close():void
		{
			AppHost.activityWindowClosing(this);
			PopUpManager.removePopUp(this);
		}
		
		public function get ActivityStamp():String
		{
			return harness.ActivityStamp;
		}
		
		public function get ActivityStampEx():String
		{
			return harness.ActivityStampEx;
		}
		
		public function appendDataPublicationsToActivityRequest():void
		{
			harness.appendDataPublicationsToActivityRequest();
		}
		
		public function publishResponse(xml:XML):void
		{
			harness.publishResponse(xml);
		}
		
		public function publishSchema(xml:XML):void
		{
			harness.publishSchema(xml);
		}
		
		protected function publishMessages(msgs:XML):void
		{
			var msg:XML = msgs.firstChild;
			
			while (msg != null)
			{
				if (msg.localName == "Message")
				{
					var text:String = msg.firstChild.nodeValue;
					mx.controls.Alert.show(text);
				}
				msg = msg.nextSibling;
			}
		}
		
		public function get ActivityName():String
		{
			return harness.ActivityName;
		}
		
		public function get ActivityStyle():String
		{
			return harness.ActivityStyle;
		}
		
		public function initHarness():void
		{	
			if(!harness)
				harness = new ActivityHarness(this);
		}
		
		public function initialise(xml:XML):void
		{
			createXML = xml;
		}
		
		public function initialiseCopy(H:ActivityHarness):void
		{
			harness.copyFrom(H);
			ExpanzThinRIA.CreatingContainer = null;
			//		if (NavigationPanel != null) harness.NavigationPanel = NavigationPanel;
		}
		
		public function get IsInitialised():Boolean
		{
			return harness.IsInitialised;
		}
		
		public function registerControl(control:IServerBoundControl):void
		{
			harness.registerControl(control);
		}
		
		public function registerDataControl(control:IDataControl):void
		{
			harness.registerDataControl(control);
		}
		
		public function registerControlContainer(control:IServerBoundControlContainer):void
		{
			harness.registerControlContainer(control);
		}
		
		public function registerCustomControl(control:ICustomContentPublisher):void
		{
			harness.registerCustomControl(control);
		}
		
		public function registerGraphControl(control:IGraphControl):void
		{
			harness.registerGraphControl(control);
		}
		
		public function registerCustomSchemaPublisher(control:ICustomSchemaPublisher):void
		{
			harness.registerCustomSchemaPublisher(control);
		}
		
		public function registerMessageControl(control:IMessagePanel):void
		{
			harness.registerMessageControl(control);
		}
		
		public function Exec(xml:XML):void
		{
			harness.Exec(xml);
		}
		
		public function ExecList(nodes:ArrayCollection):void
		{
			harness.ExecList(nodes);
		}
		
		public function get Publishing():Boolean
		{
			return harness.Publishing;
		}
		
		public function get PersistentKey():int
		{
			return harness.PersistentId;
		}
		
		public function get FixedContext():String
		{
			return harness.FixedContext;
		}
		
		public function get DuplicateIndex():int
		{
			return harness.DuplicateIndex;
		}
		private var wantFixedWindowTitle:Boolean;
		
		public function set WantFixedWindowTitle(value:Boolean):void
		{
			wantFixedWindowTitle = value;
		}
		
		public function resetWindowTitle(H:ActivityHarness):void
		{
			if (!this.wantFixedWindowTitle)
				this.title = H.WindowTitle;
		}
		
		public function publishDirtyChange(modelObject:String, dirty:Boolean):void
		{
			if (DirtyButtons[modelObject] != null)
			{
				var b:ButtonEx = DirtyButtons[modelObject] as ButtonEx;
				b.setDirtyState(dirty);
			}
		}
		private var myDirtyButtons:Dictionary;
		
		internal function get DirtyButtons():Dictionary
		{
			if (myDirtyButtons == null)
				myDirtyButtons = new Dictionary();
			return myDirtyButtons;
		}
		
		public function registerDirtyButton(b:ButtonEx):void
		{
			DirtyButtons[b.ModelObject] = b;
		}
		
		public function get MessagePanel():IMessagePanel
		{
			return _messagePanel;
		}
		
		public function set MessagePanel(value:IMessagePanel):void
		{
			_messagePanel = value;
		}
		
		public function closeOnLogout():void
		{
			PopUpManager.removePopUp(this);
		}
		
		public function focus(setState:String = null):void
		{
		}
		
		public function findChildByName(name:String):DisplayObject
		{
			return getChildByName(name);
		}
		
	}
}