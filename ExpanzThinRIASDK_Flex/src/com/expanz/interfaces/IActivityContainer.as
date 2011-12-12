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

package com.expanz.interfaces
{

	import com.expanz.ActivityHarness;
	import com.expanz.ExpanzThinRIA;
	import com.expanz.controls.buttons.ButtonEx;
	
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;

	/**
	 * 
	 * @author expanz
	 * 
	 */
	public interface IActivityContainer
	{
		function get AppHost():ExpanzThinRIA;
		
		function get IsInitialised():Boolean;
		/**
		 * Activity Name for this view 
		 */
		function get ActivityName():String;
		function set ActivityName(value:String):void;
		/**
		 * Activity Style for this view 
		 */
		function get ActivityStyle():String;
		function set ActivityStyle(value:String):void;
		
		function get ActivityStamp():String;
		function get ActivityStampEx():String;
		function get DuplicateIndex():int;
		function get FixedContext():String;
		function get PersistentKey():int;
		function get Publishing():Boolean;
		
		/**
		 * The Messsage Panel Control for this Activity Container View
		 * @see com.expanz.controls.MessagePanel 
		 */
		function get MessagePanel():IMessagePanel;		
		function set MessagePanel(c:IMessagePanel):void;	
		/**
		 * When true, only one instance of this Activity can exist 
		 */
		function get SingleViewMode():Boolean;
		
		function initialise(xml:XML):void;
		/**
		 * Initialise the ActivityHarness.
		 * Cannot be done the the contructor as it kills the Design View mode
		 */
		function initHarness():void;
		function initialiseCopy(H:ActivityHarness):void;
		function findChildByName(name:String):DisplayObject;
		function registerControl(control:IServerBoundControl):void;
		function registerControlContainer(control:IServerBoundControlContainer):void;
		function registerDataControl(control:IDataControl):void;
		function registerGraphControl(control:IGraphControl):void;
		function registerCustomControl(control:ICustomContentPublisher):void;
		function registerCustomSchemaPublisher(control:ICustomSchemaPublisher):void;
		function registerDirtyButton(b:ButtonEx):void;
		function registerMessageControl(control:IMessagePanel):void;
		function Exec(DeltaXml:XML):void;
		function ExecList(nodes:ArrayCollection):void;
		function appendDataPublicationsToActivityRequest():void;
		function publishSchema(xml:XML):void;
		function publishResponse(xml:XML):void;
		function publishDirtyChange(modelObject:String, dirty:Boolean):void;
		function resetWindowTitle(H:ActivityHarness):void;
		function close():void;
		//	void popupHelp(string context);
		//	void launchHelp(string context);
		function closeOnLogout():void;
		function focus(setState:String = null):void;
		//function get NotifyOnClose( { get; set; }
	}
}