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

package com.expanz.constants
{
	/**
	 * 
	 * @author expanz
	 * 
	 */
	public class MessageSchemaAttributes
	{
		public static const PublishFieldMaxLength:String = "maxLength";
		public static const IDAttrib:String = "id";
		public static const Value:String = "value";
		public static const Encoding:String = "encoding";
		
		/**
		 * Sent as part of an Activity Request in a server response.
		 * Used to tell the System that needs to be seeded with 
		 * an instance.
		 *  
		 * (Translated to initialKey on the clients request) 
		 */
		public static const Key:String = "key";
		
		/**
		 * This attribute is passed to the server only when we are requesting 
		 * an Activity that needs to be seeded with an instance. 
		 */
		public static const InitialKey:String = "initialKey";
		public static const Name:String = "name";
		public static const Style:String = "style";
		public static const Type:String = "type";
		public static const ActivityHandle:String = "activityHandle";
		public static const Hint:String = "hint";
		public static const Label:String = "label";
		public static const Text:String = "text";
		public static const Null:String = "null";
		public static const Disabled:String = "disabled";
		public static const LongData:String = "$longData$";
		public static const ActivityPersistentId:String = "ActivityPersistentId";
		public static const Picklist:String = "picklist";
		public static const FixedContext:String = "fixedContext";
		public static const Dirty:String = "dirty";
		public static const URL:String = "url";
		
		public static function boolValue(val:String):Boolean
		{
			if(val==null || val.length==0) return false;
			val=val.toUpperCase();
			if(val=="1" || val=="TRUE" || val=="Y" || val=="YES" || val=="ON" || val=="1.00" || val=="enabled") return true;
			return false;
		}
		public static function boolString(val:Boolean):String
		{
			if(val) return "1"; else return "0";
		}
		public static function makeServerName(fieldId:String):String
		{
			return fieldId.replace("_",".");
		}
	}
}