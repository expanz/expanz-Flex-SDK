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
	// ActionScript file
	import com.expanz.Activity;
	import com.expanz.FormDefinition;
	import com.expanz.FormMappings;
	import com.expanz.activitycontainers.WindowEx;
	import com.expanz.constants.MessageSchemaAttributes;
	import com.expanz.controls.halo.CanvasEx;
	import com.expanz.events.ItemEvent;
	import com.expanz.events.SessionEvent;
	import com.expanz.events.SystemPreferencesEvent;
	import com.expanz.forms.ClientMessageWindow;
	import com.expanz.forms.LoginFormEx;
	import com.expanz.forms.TrafficDebugForm;
	import com.expanz.interfaces.IActivityContainer;
	import com.expanz.interfaces.IActivityTabStackPage;
	import com.expanz.interfaces.IMessagePanel;
	import com.expanz.interfaces.IProcessAreaNavigationMenu;
	import com.expanz.logging.LogUtil;
	import com.expanz.model.SystemPreferences;
	import com.expanz.utils.ProcessAreaNavigationMenuHelper;
	import com.expanz.vo.ActivityVO;
	import com.expanz.vo.common.SystemPreferencesVO;
	
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Form;
	import mx.containers.TabNavigator;
	import mx.containers.ViewStack;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.core.IMXMLObject;
	import mx.core.INavigatorContent;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.targets.TraceTarget;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.InvokeEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.mxml.WebService;

	//--------------------------------------------------------------------------
	//
	//  Metadata
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Dispatched when a session is created
	 */	
	[Event(name="sessionCreated",type="com.expanz.events.SessionEvent")]
	
	/**
	 * Dispatched when a session is destroyed. Dispatched after loggingOff to confirm the Session is destroyed on the server
	 */
	[Event(name="sessionDestroyed",type="com.expanz.events.SessionEvent")]
	
	/**
	 * Dispatched to indicate when a user logs off
	 */
	[Event(name="loggingOff",type="com.expanz.events.SessionEvent")]
	
	[DefaultProperty("formMappings")]
	
	[Bindable]
	/**
	 * All expanz thinRIAs in Flex must declare ExpanzThinRIA in the top level Application instance.
	 * 
	 * This class is the application harness that takes care of all the 
	 * - server communications 
	 * - activity creation
	 * 
	 * @usage <ExpanzThinRIA/>
	 * 
	 * @author Expanz
	 */
	public class ExpanzThinRIA extends EventDispatcher implements IMXMLObject 
	{	
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ExpanzThinRIA()
		{
			if (_instance){throw new Error("Singleton Class cannot be instantiated more than once")}else{_instance = this;}			
			init();
		}
		
		/**
		 * Called by the Constructor. simply here to compile the constructor code instead of interpreting it. 
		 */
		private function init():void
		{
			//Create webservice object and listeners
			//TODO: should be refactored into seperate class
			ESAPortal = new WebService();
			ESAPortal.showBusyCursor = true;
			ESAPortal.addEventListener(ResultEvent.RESULT, onResult);
			ESAPortal.addEventListener(FaultEvent.FAULT, onFault);
			ESAPortal.addEventListener(InvokeEvent.INVOKE, onInvoke);
			ESAPortal.addEventListener(LoadEvent.LOAD, onWSDLLoaded);
			
			ESAPortal.port = serviceBinding;
			ESAPortal.service = "ESAService";			
			
			//Attach global event Listeners
			FlexGlobals.topLevelApplication.addEventListener(SystemPreferencesEvent.SAVE_SYSTEM_PREFERENCES, saveSystemPreferencesHandler);
			FlexGlobals.topLevelApplication.addEventListener(SystemPreferencesEvent.RESET_DEFAULT_SYSTEM_PREFERENCES, resetDefaultSystemPreferencesHandler);
			
			//
			FlexGlobals.topLevelApplication.addEventListener(ItemEvent.ACTIVITY_SELECTED, createActivityItemEvent_Handler);
			
			FlexGlobals.topLevelApplication.addEventListener(FlexEvent.CREATION_COMPLETE, completeHandler);
			//Logging Targets
			Log.addTarget(_traceTarget);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private static var LOGGER:ILogger = LogUtil.getLogger(ExpanzThinRIA);
		private static var _instance:ExpanzThinRIA;
		
		private var _traceTarget:TraceTarget = new TraceTarget();
		private var _loginFormPopup:LoginFormEx;				
		private var _trafficDebugForm:TrafficDebugForm;
		private var prevActivity:String = "";
		private var prevStyle:String = "";		
		private var lastSuccess:Boolean;
		private var actWindow:IActivityContainer;
		private var myActivities:Dictionary = new Dictionary();
		private var dontAutoPublishResponse:Boolean;
		private var myDuplicateActivityCount:int;
		private var defaultActivity:FormDefinition;		
		private var nextMethod:Function;
		
		protected var defaultSystemPreferences:SystemPreferencesVO;		
		protected var ESAPortal:WebService;
		protected var myFormMappings:Dictionary;
		
		//--------------------------------------------------------------------------
		//
		//  Public Properties
		//
		//--------------------------------------------------------------------------		
		
		//----------------------------------
		//  serviceBinding
		//----------------------------------
		
		/**
		 * For the WCF Service end point of the expanz WebService proxy 
		 */
		public var serviceBinding:String = "BasicHttpBinding_IESAService";
		
		//----------------------------------
		//  versionNumber
		//----------------------------------
		/**
		 * Use for versioning your Flex Client.  
		 */
		public var versionNumber:String;
		
		//----------------------------------
		//  URL
		//----------------------------------
		/**
		 * The URL to the expanz Webservice proxy where your app server is hosted. 
		 * If your working locally it would be http://127.0.0.1:8080/esaservice.svc?WSDL
		 */
		public var URL:String;
		
		//----------------------------------
		//  preferredSite
		//----------------------------------
		/**
		 *  The default application site to access. If not set you should use the sites dropdown box to pick a site before logging in
		 */
		public var preferredSite:String;
		
		//----------------------------------
		//  userType
		//----------------------------------	
		//[Inspectable(enumeration="Primary, Alternate, Guest", defaultValue="Primary")]
		/**
		 * Either Primary (Default), Alternate, Guest values.
		 * Primary would be staff who have access to the system
		 * Alternate would be 3rd parties or other users with a login to particular parts of the system
		 */
		public function get userType():String
		{
			return _userType;
		}
		
		public function set userType(value:String):void
		{
			_userType = value;
		}		
		private var _userType:String = "Primary";				
		
		//----------------------------------
		//  processAreaMenuRegister
		//----------------------------------	
		[ArrayElementType("com.expanz.interfaces.IProcessAreaNavigationMenu")]
		/**
		 * Array of IProcessAreaNavigationMenu controls to render the applications Process Areas & Activites aka the app menu.
		 * 
		 * Called internally by IProcessAreaNavigationMenu components they will register themselves for subscribing to the menu data once 
		 * the application has loaded 
		 *    
		 */
		public function get processAreaMenuRegister():Array
		{
			return _processAreaMenuRegister;
		}
		
		/**
		 * @private
		 */
		public function set processAreaMenuRegister(value:Array):void
		{
			_processAreaMenuRegister = value;
		}
		private var _processAreaMenuRegister:Array = [];
		
		//----------------------------------
		//  IsLoggedIn
		//----------------------------------	
		public function get IsLoggedIn():Boolean
		{
			return sessionHandle != null;
		}		
		
		public function get LastSuccess():Boolean
		{
			return LastSuccess;
		}
		
		//----------------------------------
		//  mainTabs
		//----------------------------------	
		public var mainTabs:TabNavigator;
		
		
		//----------------------------------
		//  activitiesStack
		//----------------------------------	
		/**
		 * 
		 */
		public var activitiesStack:ViewStack; //instance can be (and used to be) a TabNavigator (or TabNavigatorEx)
		
		//----------------------------------
		//  titleText
		//----------------------------------	
		/**
		 * Application Title Text, set by the server
		 */
		public var titleText:String = "";
		
		//----------------------------------
		//  userName
		//----------------------------------	
		/**
		 * User name for the user logged in. Set by the server  
		 */
		public var userName:String = "";
		
		
		//----------------------------------
		//  formMappings
		//----------------------------------	
		private var _formMappings:Object;	

		
		/**
		 * Activity to View Mappings file. Use FormMappings MXML declaration which references 
		 * each view into the project for compilation. Using the XML file will mean you need to either 
		 * add each file to the compiler arguments manually using -includes myView myOtherView. or
		 * create references to them in AS3.
		 * 
		 */
		public function get formMappings():Object
		{
			return _formMappings;
		}

		/**
		 * @private
		 */
		public function set formMappings(value:Object):void
		{
			_formMappings = value;
		}

		
		//----------------------------------
		//  TODO: DOCUMENT Public Properties
		//----------------------------------
		
		public var loginState:String;
		public var loggedInState:String;		
		public var storePrefs:Boolean = false;		
		public var sessionHandle:String = "";		
		public var currentActivity:String = "";		
		public var currentStyle:String = "";				
		public var fileURLPrefix:String		
		public var systemPreferences:SystemPreferences;		
		public var request:XML;
		public var response:XML;		
		internal var releasingSession:Boolean;
		public static var CreatingContainer:IActivityContainer;	
		public var homeMessagePanel:IMessagePanel;		
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Singleton Accessor
		 */
		public static function getInstance():ExpanzThinRIA
		{
			if (!_instance) 
			{
				throw new Error("ExpanzThinRIA is not initialized in the top level application.");
			}
			return _instance;
		}
		
		
		/**
		 * 
		 * @param document
		 * @param id
		 * 
		 */
		public function initialized(document:Object, id:String):void
		{
			if(URL=='')
				throw new Error("You must set the ESA Server WSDL");
			
			if(preferredSite == null)
				throw new Error("You must set the ExpanzThinRIA.fixedSite property with a Expanz Appserver site name.");
			
			if(userType == null)
				throw new Error("You must set the ExpanzThinRIA.userType property with this RIA's user type. Primary or Alternate.");
			
			if(loginState == null || loginState == ""){
				_loginFormPopup = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, LoginFormEx, true) as LoginFormEx;
				PopUpManager.centerPopUp(_loginFormPopup);
			}
			
			//Create default SystemPreferencesVO
			defaultSystemPreferences = new SystemPreferencesVO();
			defaultSystemPreferences.userType = this.userType;
			defaultSystemPreferences.fixedSite = this.preferredSite;
			defaultSystemPreferences.portalAddress = ensureWSDLonURL(this.URL);
			
			systemPreferences = new SystemPreferences(defaultSystemPreferences, storePrefs);
			systemPreferences.addEventListener(SystemPreferencesEvent.SYSTEM_PREFERENCES_CHANGED, systemPreferencesChangedHandler);
			
			//Load the prefered ESA Portal URI
			ESAPortal.loadWSDL(systemPreferences.systemPreferences.portalAddress);
		}
		private function ensureWSDLonURL(URL:String):String
		{
			if(URL.substr(URL.length-5,5).toUpperCase() != "?WSDL")
			{
				return URL + "?WSDL";
			}
			else
			{
				return URL;
			}
		}
		
		/**
		 * 
		 * @param act
		 * @param style
		 * @param xml
		 * @param sourceHarness
		 * @param setState
		 * 
		 */
		public function createActivityWindowEx(act:String, style:String, xml:XML, sourceHarness:ActivityHarness, setState:String = null):void
		{
			var id:String = _makeFormKey(act, style);
			
			if (myFormMappings == null)
			{
				Alert.show("Form mappings not loaded", "Client config error");
				return;
			}
			
			if (myFormMappings[id] == null)
			{
				Alert.show("Developer Message:\nNo form mapping defined for Activity: " + act + ", Style: " + style + ". \n\nPlease check your form mappings XML that the Activity Name and Style map to a component and the component is being compiled into the application.", "Client form mapping configuration error");				
				return;
			}
			
			//check for an existing instance of this activity/style/row
			//if(xml!=null && xml.@[MessageSchemaConstants.Key].length)
			//			{
			
			try
			{
				//					var key:int = parseInt(xml.@[MessageSchemaConstants.Key]);
				for each (var inst:IActivityContainer in myActivities)
				{
					if (inst.ActivityName == act && inst.ActivityStyle == style && inst.SingleViewMode) // don't check for key;  && inst.PersistentKey==key
					{
						inst.focus(setState);
						return;
					}
				}
			}
			catch (e:Error)
			{
				
			}
			
			//			}
			var FD:FormDefinition = myFormMappings[id] as FormDefinition;
			var name:String = FD.TabItem;
			
			if (name == null)
				name = FD.Form;
			
			try
			{
				var form:Object = dynamicallyCreateForm(name);
			}catch(e:Error)
			{
				//Make logger support a Alert target for fatals
				
				mx.controls.Alert.show("Could not create " + name + " form for activity " + id + ". Check the form view for this Actvity is referenced and compiled in your project.");
				
				LOGGER.fatal("Could not create {0} form for activity {1}. Check it is referenced and compiled."
					, name
					, id);
				return;
			}
			
			if (!form is IActivityContainer)
			{
				mx.controls.Alert.show("Form " + name + " is not an IActivityContainer", "Invalid Form");
				return;
			}
			
			if (form is WindowEx)
			{
				var window:WindowEx = form as WindowEx;
				window.ActivityName = act;
				window.ActivityStyle = style;
				window.name = act + "_" + style;
				window.AppHost = this;
				window.initialise(xml);
				PopUpManager.addPopUp(window, (FlexGlobals.topLevelApplication as DisplayObject), window.isModalWindow);
				PopUpManager.centerPopUp(window);
			}
			else if (form is IActivityTabStackPage)
			{
				if (activitiesStack == null)
				{
					mx.controls.Alert.show(name + " is a tab page, but there is no home tab control", "Configuration Problem");
				}
				else
				{
					var ti:IActivityContainer = activitiesStack.getChildByName(act + "_" + style) as IActivityContainer;
					
					if (ti && ti.SingleViewMode)
					{
						activitiesStack.selectedChild = ti as INavigatorContent;
					}
					else
					{	
						ti = form as IActivityContainer;						
						ti.initHarness();
						ti.ActivityName = act;
						ti.ActivityStyle = style;
						(ti as DisplayObject).name = act + "_" + style;
						ti.initialise(xml);
						activitiesStack.addChild(ti as DisplayObject);
					}
					
					ti.focus(setState);
					//	           			activitiesStack.selectedChild = ti; //happens above but is too quick?
					currentActivity = act;
					currentStyle = style;
				}
			}
			else
			{
				mx.controls.Alert.show("Form " + name + " is neither a WindowEx nor an IActivityTabStackPage", "Unsupported IActivityContainer");
			}
			/*			}
			catch (e:Error)
			{
			mx.controls.Alert.show(e.message + "\nNo form found:" + name, "Form Creation Error");
			}*/
			//	var MM:ModuleManager = new ModuleManager();
		}
		
		public static function _makeFormKey(name:String, style:String):String
		{
			return name + style;
		}
		
		public function registerProcessAreaNavigationMenu(component:IProcessAreaNavigationMenu):void
		{
			processAreaMenuRegister.push(component);
		}
		
		//----------------------------------
		//  Preferences
		//----------------------------------	
		private function systemPreferencesChangedHandler(event:SystemPreferencesEvent):void
		{
			dispatchEvent(event);
		}
		
		private function saveSystemPreferencesHandler(event:SystemPreferencesEvent):void
		{
			systemPreferences.savePreferences(event.systemPreferences);
			
			ESAPortal.loadWSDL(systemPreferences.systemPreferences.portalAddress);
		}
		
		private function resetDefaultSystemPreferencesHandler(event:SystemPreferencesEvent):void
		{
			systemPreferences.resetDefaultPreferences(true);
			
			ESAPortal.loadWSDL(systemPreferences.systemPreferences.portalAddress);
		}		
		
		public function getSessionData(returnFunction:Function = null):void
		{
			request = <ESA><GetSessionData/></ESA>;
			nextMethod=returnFunction;
			Exec(request.toString(), onGetSessionDataComplete);
		}
		
		
		/**
		 * Processes the GetSessionData Response XML
		 * If you need anything from the Session Data do it here
		 * 
		 */
		public function onGetSessionDataComplete(result:Object):void
		{
			response = new XML(result.ExecResult);
			if (response.hasOwnProperty("@blobCacheURL"))
			{
				fileURLPrefix = response.@blobCacheURL;
			}
			
			if (response.hasOwnProperty("@userName"))
			{
				this.userName = response.@userName;
			}
			
			if (nextMethod!= null)
				nextMethod(result);
			
			var sessionEvent:SessionEvent = new SessionEvent(SessionEvent.SESSION_CREATED);
			sessionEvent.sessionData = response;
			dispatchEvent(sessionEvent);
			
			launchDefaultActivity();
		}
		
		protected function launchDefaultActivity():void
		{
			if(defaultActivity)
			{			
				createActivityWindowEx(defaultActivity.activityName, defaultActivity.activityStyle, null, null);
			}
		}
		
		public function listAvailableSites(returnFunction:Function = null):void
		{
			//<ListAvailableSites/>
			//			request = <ESA></ESA>;
			var token:AsyncToken = ESAPortal.ListAvailableSites();
			token.method = "ReturnResult";
			token.returnFunction = returnFunction;
		}
		
		public function login(user:String, password:String, site:String):void
		{
			var authenticationMode:String = userType;
			
			if (user == "" && password == "")
			{
				authenticationMode = "guest";
			}
			
			if (site=="" && this.preferredSite != "")
			{
				site = this.preferredSite;
			}	
			
			request = <ESA><CreateSession user={user} password={password} appSite={site} authenticationMode={authenticationMode}/></ESA>;
			request.CreateSession.@clientVersion = "Flex 1.0";
			request.CreateSession.@schemaVersion = "2.0";
			var xmlString:String = request.toString();
			var token:AsyncToken = ESAPortal.CreateSession(xmlString);
			token.method = "CreateSession";
			//			ESAPortal.showBusyCursor=true;
		}
		
		
		/**
		 * Log out the user from the application. Return to login screen and clean up session state.
		 *  
		 * @param isBadSession - set to true so the code does not call the server to ReleaseSession
		 * 
		 */
		public function logout(isBadSession:Boolean=false):void
		{						
			try
			{
				releasingSession = true;
				activitiesStack.removeAllChildren(); 
			}
			catch (ex:Error)
			{
				//swallow any errors, we're getting out!
			}
			finally
			{
				releasingSession = false;
				
				if (loginState!=''){
					//FIXME: Dont change the state directly on the app, must do via a UIComponent reference as 
					//it may not be the component that has the app view states
					FlexGlobals.topLevelApplication.currentState=loginState;
				}
			}
			
			//clean up session state
			titleText = "";
			userName = "";
			clearMessages();
			myActivities = new Dictionary();
			//TODO: AIR this.exit();
			
			//Call Server to release the session
			if(!isBadSession)
			{
				var token:AsyncToken = ESAPortal.ReleaseSession(sessionHandle);
				token.method = "ReleaseSession";
			}	
			
			dispatchEvent(new SessionEvent(SessionEvent.USER_LOGGING_OFF, true, true));
		}
		
		public function Exec(xml:String, returnFunction:Function = null):void
		{
			if(Log.isDebug())
				LOGGER.debug("service.Exec, xml:{0}", xml);
			
			request = new XML(xml);
			var token:AsyncToken = ESAPortal.Exec(xml, sessionHandle);
			token.method = "Exec";
			token.returnFunction = returnFunction;
		}
		
		public function ExecAnonymous(site:String, xml:String, returnFunction:Function = null):void
		{
			if(Log.isDebug())
				LOGGER.debug("service.ExecAnonymous, xml:{0}", xml);
			
			request = new XML(xml);
			var token:AsyncToken = ESAPortal.ExecAnonymous(site, xml, "");
			token.method = "ExecAnonymous";
			token.returnFunction = returnFunction;
		}
		
		public function requestActivity(W:IActivityContainer, activity:String, style:String, initialKey:int):void
		{
			request = <ESA><CreateActivity/></ESA>;
			request.CreateActivity.@[MessageSchemaAttributes.Name] = activity;
			
			if (style == null)
				style = "";
			request.CreateActivity.@[MessageSchemaAttributes.Style] = style;
			
			if (initialKey > 0)
			{
				request.CreateActivity.@initialKey = initialKey.toString();
			}
			W.appendDataPublicationsToActivityRequest();
			actWindow = W;
			SendRequestToServerPortal();
		}
		
		public function submitRequestToServerPortal():void
		{
			this.SendRequestToServerPortal();
		}
		
		private function SendRequestToServerPortal():void
		{
			//request.@sessionHandle = sessionHandle;
			Exec(request.toString());
		}
		
		private function onInvoke(event:InvokeEvent):void
		{
			clearMessages();
		}
		
		private function onResult(event:ResultEvent):void
		{
			LOGGER.info("Service result. Method:{0}, ", 
				event.token.method );
			
			if (event.result.hasOwnProperty('errors') && event.result.errors && event.result.errors.length > 0)
			{
				Alert.show(event.result.errors);
			}
			
			if (event.result.hasOwnProperty("@serverMessage"))
			{
				Alert.show(event.result..@serverMessage, "System Message");
			}
			
			if (event.token.method == "CreateSession")
			{
				sessionHandle = event.result.CreateSessionResult;
				
				if (sessionHandle.length == 0)
				{
					mx.controls.Alert.show(event.result.errorMessage);
					loginUnsuccessful();
				}
				else
				{
					loginSuccessful();
				}
			}
			else if (event.token.method == "ReleaseSession")
			{
				//Is there anything that needs to be done now?
				return;
			}
			else if (event.token.method == "Exec")
			{
				response = new XML(event.result.ExecResult);
				var responseChildren:XMLList = response.children();
				
				if (actWindow == null || responseChildren.length() == 0)
				{
					LOGGER.info("No Active Window, genericly processing response");
					processResponse();
				}
				else
				{	
					//actWindow.publishSchema(responseChildren[0]);//FIXME:bug right here, sometimes the data you need is in [1] or greater. Need to handle all children.
					
					for each (var element:XML in responseChildren) 
					{
						if(element.localName() == "Messages") //BUGFIX: had to put this here to get messages against Activities to render
						{
							publishMessage(element);
						}
						else
						{
							actWindow.publishSchema(element);
						}
					}					
					registerActivity(actWindow);
					actWindow = null;
				}
			}
			
			if (event.token.hasOwnProperty("returnFunction") && event.token.returnFunction != null)
			{
				event.token.returnFunction(event.result);
			}
			
		}
		
		
		/**
		 * Process the Response from the Exec server call 
		 */
		protected function processResponse():void
		{
			if(Log.isDebug())
				LOGGER.debug("Process the Response from the Exec server call");
			
			if (response.hasOwnProperty("@badSession") && response.@badSession == "1")
			{
				Alert.show("You have been logged out of this session. This is usually caused by timeout/expiry or successful login of the same user elsewhere.", "System Message");
				logout(true);
				return;
			}
			
			if (response.hasOwnProperty("@windowTitle"))
			{
				titleText = response.@windowTitle;
			}
			
			for each (var child:XML in response.children()) // could do this as if(response.hasOwnProperty("Activity"))
			{
				trace("Process " + child.localName());
				switch (child.localName())
				{
					case "Activity":
						var handle:String = child.@[MessageSchemaAttributes.ActivityHandle];
						if (handle.length > 0)
						{
							if (myActivities[handle] != null)
							{
								var publishWindow:IActivityContainer = myActivities[handle] as IActivityContainer;
								publishWindow.publishResponse(child);
							}
						}
						break;
					case "ActivityRequest":
						createActivityWindow(child);
						break;
					case "Menu":						
						if(processAreaMenuRegister.length > 0)
							ProcessAreaNavigationMenuHelper.loadApplicationMenuData(child, processAreaMenuRegister); 								
						break;
					
					case "Files":
						var fileURL:String = "";
						
						for each (var file:XML in child.children())
						{
							//HACK: Remove when TODO is done
							//TODO: Update WCF Service GetFile method support, currently only implemented in the .asmx 
							var downloadURL:String = ExpanzThinRIA.getInstance().systemPreferences.systemPreferences.portalAddress.replace("?wsdl", "/postssl");					
							
							//POST							
							var urlRequest:URLRequest;
							var variables:URLVariables = new URLVariables();
							var rhArray:Array = [new URLRequestHeader("Content-Type", "text/xml")];							
							
							if(file.hasOwnProperty("@field") && file.hasOwnProperty("@path"))
							{												
								var fileId:String = file.@field;
								
								//Create URLRequest
								downloadURL += "/GetBlob";
								urlRequest = new URLRequest(downloadURL);			
								urlRequest.requestHeaders = rhArray;
								
								//Set POST data   
								urlRequest.data = 	<GetBlob xmlns="http://www.expanz.com/ESAService">
														<sessionHandle>{ExpanzThinRIA.getInstance().sessionHandle}</sessionHandle>
														<activityHandle>{handle}</activityHandle>														
														<blobId>{fileId}</blobId>
														<isbyteArray>{false}</isbyteArray>
													</GetBlob>;
								
								//Download the file
								urlRequest.method = URLRequestMethod.POST;
								navigateToURL(urlRequest, "_blank");
								
								//clean up
								urlRequest = null;
							}
							else if(file.hasOwnProperty("@name"))
							{												
								var fileName:String = file.@name;
								
								//Create URLRequest
								downloadURL += "/GetFile";
								urlRequest = new URLRequest(downloadURL);		
								urlRequest.requestHeaders = rhArray;
								
								//Set POST data   
								urlRequest.data = 	<GetFile xmlns="http://www.expanz.com/ESAService">
														<sessionHandle>{ExpanzThinRIA.getInstance().sessionHandle}</sessionHandle>																											
														<fileName>{fileName}</fileName>
														<isbyteArray>{false}</isbyteArray>
													</GetFile>;
								
								//Download the file
								urlRequest.method = URLRequestMethod.POST;								
								navigateToURL(urlRequest, "_blank");
								
								//clean up
								urlRequest = null;
							}
							else
							{
								fileURL = fileURLPrefix + file.@path;
								navigateToURL(new URLRequest(fileURL), "_blank");
							}	
						}						
						break;
					case "UIPreferences":
						//TODO: Shortcuts
					case "SessionFields":
						//TODO: What is this?
						break
					case "Messages":
						//Show messages from the app server to the user 
						publishMessages(child.children());
						break;
					default:
				}
			}
		}
		
		protected function loginSuccessful():void
		{
			loadFormMappings();
			
			getSessionData();
			
			//FIXME: Dont change the state directly on the app
			if (loggedInState != '')
			{
				FlexGlobals.topLevelApplication.currentState = loggedInState;
			}
			else if (!_loginFormPopup is null)
			{
				PopUpManager.removePopUp(_loginFormPopup);
			}
		}

		protected function loginUnsuccessful():void
		{
			var sessionEvent:SessionEvent = new SessionEvent(SessionEvent.AUTHENTICATION_FAILED);
			dispatchEvent(sessionEvent);
		}
		
	
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		/**
		 * Class CreationComplete Event Handler 
		 */
		private function completeHandler(event:FlexEvent):void
		{
			addDebugMenu();
		}
		
		/**
		 * When a user clicks a menu item in a ProcessAreaMenu Renderer 
		 */
		private function createActivityItemEvent_Handler(event:ItemEvent):void
		{
			var activity:ActivityVO = event.item as ActivityVO;
			createActivityWindowEx(activity.name, activity.style, activity.original, null);
		}
		
		private function showXMLDebugWindow(event:ContextMenuEvent):void 
		{
			_trafficDebugForm = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, TrafficDebugForm, false, null, null) as TrafficDebugForm;
			PopUpManager.centerPopUp(_trafficDebugForm);
		}
		
		private function onFault(event:FaultEvent):void
		{
			//			ESAPortal.showBusyCursor=false;
			mx.controls.Alert.show(event.fault.faultString);
		}
		
		private function onWSDLLoaded(event:LoadEvent):void
		{
			LOGGER.info("WSDL Loaded");
		}
		
		
		
		public function registerActivity(activity:IActivityContainer):void
		{
			myActivities[activity.ActivityStamp] = activity;
		}
		
		
		
		internal function getSchema(H:ActivityHarness):void
		{
			request = <ESA><PublishSchema/></ESA>;
			
			request.PublishSchema.@[MessageSchemaAttributes.ActivityHandle] = H.ActivityStamp;
			H.appendDataPublicationsToActivityRequest();
			dontAutoPublishResponse = true;
			SendRequestToServerPortal();
			dontAutoPublishResponse = false;
		}
		
		
		public function registerActivityCopy(W:IActivityContainer):int
		{
			myDuplicateActivityCount++;
			myActivities[W.ActivityStamp + "/" + myDuplicateActivityCount.toString()] = W;
			return myDuplicateActivityCount;
		}
		
		public function activityWindowClosing(W:IActivityContainer):void
		{
			if (!releasingSession && W.IsInitialised && myActivities[W.ActivityStampEx] != null)
			{
				//tell server to close this activity
				request = <ESA><Close/></ESA>;
				request.Close.@[MessageSchemaAttributes.ActivityHandle] = W.ActivityStamp;
				delete myActivities[W.ActivityStampEx];
				//saveMessages = true; fixme
				SendRequestToServerPortal();
			}
		}
		
		
		protected function createActivityWindow(xml:XML):void
		{
			var act:String = xml.@[MessageSchemaAttributes.IDAttrib];
			var style:String = xml.@[MessageSchemaAttributes.Style];
			createActivityWindowEx(act, style, xml, null);
		}
		
		
		
		public function set HomeMessagePanel(value:IMessagePanel):void
		{
			homeMessagePanel = value;
		}
		
		internal function publishMessages(msgXMLList:XMLList):void
		{
			for each (var msg:XML in msgXMLList)
			{
				publishMessage(msg);
			}
		}
		
		internal function publishMessage(msg:XML):void
		{
			if (homeMessagePanel != null)
			{
				homeMessagePanel.addMessage(msg);
			}
			else
			{
				var text:String = msg.valueOf();
				var severity:String = msg.@[MessageSchemaAttributes.Type].toString().toUpperCase();
				
				//Alert.show(text, severity);
			}	
		}
		
		public function clearMessages():void
		{
			if (homeMessagePanel != null)
				homeMessagePanel.clear();
		}
		
		protected function loadFormMappings():void
		{
			var formDefinition:FormDefinition;
			
			LOGGER.info("Load FormMappings XML");
			myFormMappings = new Dictionary();
			
			if(formMappings is XML)
			{
				try
				{
					//				var mapFile:File=new File();
					//				var path:String = flash.filesystem.File.applicationDirectory.nativePath+ "\\assets\\formmapping.xml";
					//				mapFile.nativePath=path;
					//				var mapFileStream:FileStream = new FileStream();
					//				mapFileStream.open(mapFile,FileMode.READ);
					//				var mappings:XML = XML(mapFileStream.readUTFBytes(mapFileStream.bytesAvailable));
					
					for each (var aXML:XML in formMappings.activity)
					{
						/*
						var act:String = activity.@name;
						var style:String = activity.@style.length ? activity.@style : "";
						var form:String = activity.@form.length ? activity.@form : "";
						var defaultAct:String = activity.@default.length ? activity.@default : "";
						var tabItem:String = activity.@tabItem.length ? activity.@tabItem : "";
						var id:String = act + style;
						var useDef:Boolean = !(form.length > 0 || tabItem.length > 0);
						
						var fd:FormDefinition = new FormDefinition(id, useDef);
						
						*/
						
						formDefinition = FormDefinition.createFormDefinition
							(
								aXML.@name,
								aXML.@style,
								aXML.form,
								aXML.@default,
								aXML.@tabItem
							)
							
						myFormMappings[formDefinition.Id] = formDefinition;
						
						if (formDefinition.defaultActivity)
							defaultActivity = formDefinition;
					}
				}
				catch (e:Error)
				{
					mx.controls.Alert.show(e.message, "Load Form Mappings Error");
				}
			}
			else if (formMappings is Object)
			{
				for each (var ao:Activity in (formMappings as FormMappings).Activities)
				{			
					formDefinition = FormDefinition.createFormDefinition
						(
						ao.name,
						ao.style,
						flash.utils.getQualifiedClassName(ao.form),
						ao.defaultActivity,
						ao.tabItem
						)
						
					myFormMappings[formDefinition.Id] = formDefinition;
					
					if (formDefinition.defaultActivity)
						defaultActivity = formDefinition;					
				}
			}
		}
		
		protected virtual function dynamicallyCreateForm(name:String):Object
		{
			var ClassReference:Class = flash.utils.getDefinitionByName(name) as Class;
			var form:Object = new ClassReference();
			return form;
		}		
		
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		private function addDebugMenu():void 
		{
			//var customMenuItem0:ContextMenuItem = new ContextMenuItem("Flex SDK " + mx_internal::VERSION, false, false);
			var customMenuItem1:ContextMenuItem = new ContextMenuItem("Version " + this.versionNumber, false, false);
			var customMenuItem2:ContextMenuItem = new ContextMenuItem("Player " + Capabilities.version, false, false);
			var customMenuItem3:ContextMenuItem = new ContextMenuItem("Site " + this.preferredSite, false, false);
			var customMenuItem4:ContextMenuItem = new ContextMenuItem("Show XML");
			customMenuItem4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, showXMLDebugWindow);
			
			var contextMenuCustomItems:Array = FlexGlobals.topLevelApplication.contextMenu.customItems;
			
			contextMenuCustomItems.push(customMenuItem1);
			contextMenuCustomItems.push(customMenuItem2);
			contextMenuCustomItems.push(customMenuItem3);
			contextMenuCustomItems.push(customMenuItem4);
			
			//Hide default items
			FlexGlobals.topLevelApplication.contextMenu.hideBuiltInItems();
		}
	}
}