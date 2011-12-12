package com.expanz.forms
{
	import com.expanz.ExpanzThinRIA;
	import com.expanz.events.SessionEvent;
	import com.expanz.events.SystemPreferencesEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.ComboBox;
	import mx.controls.LinkButton;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.SkinnableContainer;
	import spark.components.TextInput;
	
	//--------------------------------------
	//  SkinStates
	//--------------------------------------
	
	/**
	 *  The form is enabled and showing all parts.
	 *  
	 */
	[SkinState("normal")]
	
	/**
	 * The form does not require site selection so remove the 
	 * site selection skin part from the form 
	 *  
	 */
	[SkinState("noSiteSelection")]
	
	/**
	 * Hide the username and password and let the user access the system as a guest
	 */
	[SkinState("guestNoSiteSelection")]	
	
	/**
	 * expanz custom skinnable login component
	 * 
	 * @usage <forms:LoginFormEx heading="Welcome " /> 
	 * 
	 * @author expanz
	 * 
	 */
	public class LoginFormEx extends SkinnableContainer
	{
		[Bindable]
		private var appHost:ExpanzThinRIA = ExpanzThinRIA.getInstance();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function LoginFormEx()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler, false, 0, true);						
			appHost.addEventListener(SessionEvent.USER_LOGGING_OFF, onLoggingOff, false, 0, true);
			appHost.addEventListener(SessionEvent.SESSION_CREATED, onSessionCreated, false, 0, true);
			appHost.addEventListener(SessionEvent.AUTHENTICATION_FAILED, onAuthenticationFailed, false, 0, true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------			
		/**
		 *  The skin part that defines the Username TextInput. 
		 */
		[SkinPart (required="true")]
		public var username:TextInput;
		
		/**
		 *  The skin part that defines the Password TextInput. 
		 */
		[SkinPart (required="true")]
		public var password:TextInput;
		
		/**
		 *  The skin part that defines the Login Button. 
		 */
		[SkinPart (required="true")]
		public var loginButton:Button;
		
		/**
		 *  The optional skin part that defines the Site Selection List.
		 */
		[SkinPart (required="false")]
		public var siteSelectionList:ComboBox;
		
		/**
		 *  The optional skin part that defines the Site Settings Button for 
		 *  launching the Settings dialog window.
		 */
		[SkinPart (required="false")]
		public var settingsButton:LinkButton;
		
		/**
		 *  For guests / anyone logging in or registered system users 		 
		 */
		[SkinPart (required="false")]
		public var guestCheckBox:CheckBox;

		//--------------------------------------------------------------------------
		//
		//  Public Properties
		//
		//--------------------------------------------------------------------------
				
		private var _heading:String = "";	

		[Inspectable(category="Expanz")]
		[Bindable]
		/**
		 * The heading title text of the login form to be displayed. 
		 */
		public function get heading():String
		{
			return _heading;
		}

		public function set heading(value:String):void
		{
			_heading = value;
		}
		
		private var _clearUserNameOnLogout:Boolean=false;

		[Inspectable(category="Expanz")]
		/**
		 * Set to true to clear out the username text input when the use logs out.
		 * Default is false and will leave the username in the username field
		 */
		public function get clearUserNameOnLogout():Boolean
		{
			return _clearUserNameOnLogout;
		}

		public function set clearUserNameOnLogout(value:Boolean):void
		{
			_clearUserNameOnLogout = value;
		}

		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Clears the password from the text input.
		 */
		public function clearPassword():void
		{
			if(password)
				password.text="";
		}
		
		
		/**
		 * Requests the list of available sites form the app server.   
		 * For more info about sites @see http://expanz.com/docs/site_manager.html
		 */
		public function requestSites():void
		{
			//username.setFocus();
			
			if (currentState != 'noSiteSelection')
			{
				appHost.listAvailableSites(onRequestSitesResult);
			}
			
		}
		
		internal function onRequestSitesResult(e:Object=null):void
		{
			if(!siteSelectionList)
				return;
			
			var xml:XML=new XML(e.ListAvailableSitesResult);
			siteSelectionList.dataProvider=xml.AppSites.children();
			
			for each (var site:XML in siteSelectionList.dataProvider)
			{
				if (site.@id == appHost.systemPreferences.systemPreferences.site)
				{
					siteSelectionList.selectedItem=site;
				}
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			requestSites();
			appHost.addEventListener(SystemPreferencesEvent.SYSTEM_PREFERENCES_CHANGED, systemPreferencesChangedHandler);
		}
		
		private function onAuthenticationFailed(event:SessionEvent):void
		{
			if(loginButton)
				loginButton.enabled = true;	
		}
		
		private function onLoggingOff(event:SessionEvent):void
		{
			if(clearUserNameOnLogout)
			{
				if(username)
					username.text = "";
			}				
			
			clearPassword();
		}
		
		// TODO: this should be based on a a change of the site list not the syspref change.
		private function systemPreferencesChangedHandler(event:SystemPreferencesEvent):void
		{
			requestSites();
		}
		
		private function settingsButton_clickHandler(event:MouseEvent):void
		{
			var settings:SystemPreferencesForm=PopUpManager.createPopUp(DisplayObject(FlexGlobals.topLevelApplication), SystemPreferencesForm, true) as SystemPreferencesForm;
			settings.systemPreferences=appHost.systemPreferences.systemPreferences;
			
			PopUpManager.centerPopUp(settings);
		}
		
		private function tryLogin(event:Event):void
		{
			//TODO: Disable login button and listen to login response
			//loginButton.enabled=false;
			
			var site:String=appHost.systemPreferences.systemPreferences.fixedSite; // default
			
			if (!(site && site.length > 0 && siteSelectionList))
			{
				if (siteSelectionList.selectedItem != null)
				{ //if selected
					site=siteSelectionList.selectedItem.@id;
				}
				else if (siteSelectionList.text.length > 0)
				{ //if user entered
					site=siteSelectionList.text;
				}
			}
			
			appHost.systemPreferences.systemPreferences.site=site;
			
			if(currentState == "guestNoSiteSelection")
			{
				appHost.login("", "", site);				
			}
			else
			{
				appHost.login(username.text, password.text, site);
			}
			
			loginButton.enabled = false;
			
		}

		private function onSessionCreated(event:SessionEvent):void
		{
			if(loginButton)
				loginButton.enabled = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == loginButton)
			{
				loginButton.addEventListener(MouseEvent.CLICK, tryLogin);				
				loginButton.addEventListener(FlexEvent.ENTER, tryLogin);				
			}			
			else if (instance == password)
			{
				password.addEventListener(FlexEvent.ENTER, tryLogin);				
			}
			else if (instance == settingsButton)
			{
				settingsButton.addEventListener(MouseEvent.CLICK, settingsButton_clickHandler);				
			}
			else if (instance == guestCheckBox)
			{
				guestCheckBox.addEventListener(MouseEvent.CLICK, guestCheckBox_clickHandler);				
			}
		}

		private var formerUserType:String;
		private function guestCheckBox_clickHandler(event:MouseEvent):void
		{
			if(currentState == "noSiteSelection")
			{
				currentState == "guestNoSiteSelection";
				formerUserType = appHost.userType;
				appHost.userType = "guest"; 
			}
			else
			{
				currentState == "noSiteSelection";
				appHost.userType = formerUserType;
			}
		}
		
		/**
		 *  @private
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == loginButton)
			{
				loginButton.removeEventListener(MouseEvent.CLICK, tryLogin);
				loginButton.removeEventListener(FlexEvent.ENTER, tryLogin);
			}			
			else if (instance == password)
			{
				password.removeEventListener(FlexEvent.ENTER, tryLogin);				
			}
			else if (instance == settingsButton)
			{
				settingsButton.removeEventListener(MouseEvent.CLICK, settingsButton_clickHandler);				
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			if (appHost.preferredSite != "")
				return "noSiteSelection";
			
			if (!enabled)
				return "disabled";
			
			return "up";
		}
	}
}