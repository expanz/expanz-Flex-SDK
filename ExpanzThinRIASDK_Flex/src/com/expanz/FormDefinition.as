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
	
	/**
	 * Definition of a form that maps to an Activity. Creating from the FormMappings
	 * 
	 * @author expanz
	 * 
	 */
public class FormDefinition
	{
		private var useDef:Boolean;
				
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function FormDefinition(activityName:String, activityStyle:String, useDefaults:Boolean)
		{
			super();
			this.activityName=activityName;
			this.activityStyle=activityStyle;
			this.useDef = useDefaults;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var activityName:String; 
		public var activityStyle:String;
		
		//----------------------------------
		//  Id
		//----------------------------------
		
		/**
		 * Id of the Form Definition
		 */
		public function get Id():String{return activityName + activityStyle}
		//public function get Id():String{return _Id;}
		//public function set Id(value:String):void {	_Id=value; }
		//private var _Id:String;

		//----------------------------------
		//  defaultActivity
		//----------------------------------
		
		/**
		 * Is the default Activity to load
		 */
		public function get defaultActivity():Boolean{return _defaultActivity;}
		public function set defaultActivity(value:Boolean):void{_defaultActivity = value;}
		private var _defaultActivity:Boolean;
		
		
		//----------------------------------
		//  Form
		//----------------------------------
		
		/**
		 * Id of the Form Definition
		 */
		public function get Form():String
		{
			if(form==null && useDef)
			{
				form="forms."+nameFromActivityStyle(Id);
			}
			return form;
		}
		public function set Form(value:String):void { form=value; }
		private var form:String;
		
		//----------------------------------
		//  TabItem
		//----------------------------------
		
		/**
		 * Id of the Form Definition
		 */
		public function get TabItem():String
		{
			if(tabItem==null && useDef)
			{
				tabItem="tabs."+nameFromActivityStyle(Id);
			}
			return tabItem;
		}
		public function set TabItem(value:String):void { tabItem=value; }		
		private var tabItem:String;
		
		//--------------------------------------------------------------------------
		//
		//  Static Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  
		 */
		public static function nameFromActivityStyle(actStyle:String):String
		{
			var p:int = actStyle.lastIndexOf(".");
			if(p>0) actStyle=actStyle.substr(p+1);
			p=actStyle.indexOf("(");
			if(p>0) actStyle=actStyle.substr(0,p);
			return actStyle;
		}		

		/**
		 * Helper method to create a new FormDefinition
		 * @param activityName
		 * @param activityStyle
		 * @param form
		 * @param defaultActivity
		 * @param tabItem
		 * @return 
		 * 
		 */
		public static function createFormDefinition(activityName:String, activityStyle:String, form:String, defaultActivity:Boolean, tabItem:String):FormDefinition
		{
			var useDefaults:Boolean = !(form || tabItem);			
			var fd:FormDefinition = new FormDefinition(activityName, activityStyle, useDefaults);
			
			fd.Form = form;
			fd.TabItem = tabItem;
			fd.defaultActivity = defaultActivity;
			return fd;
		}	
	}
}