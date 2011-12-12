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

package com.expanz.events
{
    import com.expanz.vo.common.SystemPreferencesVO;

    import flash.events.Event;

    public class SystemPreferencesEvent extends Event
    {
        public static const SAVE_SYSTEM_PREFERENCES:String = "saveSystemPreferences";
        public static const RESET_DEFAULT_SYSTEM_PREFERENCES:String = "resetDefaultSystemPreferences";

        public static const SYSTEM_PREFERENCES_CHANGED:String = "systemPreferencesChanged"

        private var _systemPreferences:SystemPreferencesVO;

        public function SystemPreferencesEvent(type:String, systemPreferences:SystemPreferencesVO = null, bubbles:Boolean = true, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);

            _systemPreferences = systemPreferences;
        }

        public function get systemPreferences():SystemPreferencesVO
        {
            return _systemPreferences;
        }

        public override function clone():Event
        {
            return new SystemPreferencesEvent(type, systemPreferences, bubbles, cancelable);
        }

    }
}