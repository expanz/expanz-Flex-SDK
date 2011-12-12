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

package com.expanz.model
{
	import com.expanz.events.SystemPreferencesEvent;
	import com.expanz.vo.common.SystemPreferencesVO;
	
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	
	/**
	 * Stores the System Preference for this application.
	 * They're stored using local shared objects, so beware preferences are no roaming
	 * Set them on one machine and you wont see them at the next machine.
	 * 
	 * 
	 * @author expanz
	 * 
	 */
	public class SystemPreferences extends EventDispatcher
	{
		
		private static const LOCAL_SHARED_OBJECT_NAME:String = "esaSystemPreferences";
		
		private var _defaultSystemPreferences:SystemPreferencesVO;
		private var _systemPreferences:SystemPreferencesVO;
		
		private var sharedObject:SharedObject;
		
		public function SystemPreferences(defaultSystemPreferences:SystemPreferencesVO, useStoredPrefs:Boolean)
		{
			super();
			
			this.defaultSystemPreferences = defaultSystemPreferences;
			
			sharedObject = SharedObject.getLocal(LOCAL_SHARED_OBJECT_NAME);
			
			if (useStoredPrefs && sharedObject && sharedObject.data.systemPreferences)
			{				
				_systemPreferences = restoreVOFromSO(sharedObject.data.systemPreferences);
			}
			else
			{
				_systemPreferences = new SystemPreferencesVO();
				resetDefaultPreferences(true);
			}
		}
		
		public function set defaultSystemPreferences(value:SystemPreferencesVO):void
		{
			_defaultSystemPreferences = value;
		}
		
		public function get systemPreferences():SystemPreferencesVO
		{
			return _systemPreferences;
		}
		
		public function savePreferences(systemPreferences:SystemPreferencesVO = null):void
		{
			if (systemPreferences)
			{
				_systemPreferences.portalAddress = systemPreferences.portalAddress;
				_systemPreferences.fixedSite = systemPreferences.fixedSite;
				_systemPreferences.site = systemPreferences.site;
				_systemPreferences.userType = systemPreferences.userType;
			}
			
			sharedObject.data.systemPreferences = _systemPreferences;
			sharedObject.flush();
			
			// TODO: watch _systemPreferences as well 
			dispatchEvent(new SystemPreferencesEvent(SystemPreferencesEvent.SYSTEM_PREFERENCES_CHANGED));
		}
		
		public function resetDefaultPreferences(force:Boolean = false):void
		{
			if (force || !sharedObject.data.systemPreferences)
			{
				savePreferences(_defaultSystemPreferences);
			}
		}
		
		private function restoreVOFromSO(o:Object):SystemPreferencesVO
		{
			var spVO:SystemPreferencesVO = new SystemPreferencesVO();
			spVO.fixedSite = o.fixedSite;
			spVO.portalAddress = o.portalAddress;
			spVO.site = o.site;
			spVO.userType = o.userType;			
			return spVO; 
		}
	}
}