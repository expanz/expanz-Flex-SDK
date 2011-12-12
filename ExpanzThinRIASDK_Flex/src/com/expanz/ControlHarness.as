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
	import com.expanz.interfaces.IActivityContainer;
	import com.expanz.interfaces.IDataControl;
	import com.expanz.interfaces.IMessagePanel;
	import com.expanz.interfaces.IServerBoundControl;
	
	import flash.display.DisplayObjectContainer;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import spark.components.Application;

	/**
	 * Composition class for each expanz custom control, supplies the framework integration such as
	 * - traversing up the display list and attaching to the first parent expanz Activity Container found.
	 * - sending expanz XML messages to the expanz app server
	 * 
	 * @author expanz
	 * 
	 */
	public class ControlHarness extends AbstractHarnessBase
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * For the creating control passed in will traverse up the display list 
		 * registering the Controls implementation type against the Activity Harness
		 */
		public function ControlHarness(control:UIComponent)
		{
			var parent:DisplayObjectContainer = control.parent;
			
			_parentActivityContainer = findParentActivityContainer(parent);
			
			if (parentActivityContainer != null)
			{
				//Check the controls Interface implementations and register into the managed Dictionary.
				//It is likely for controls to implement more than one interface
				
				//Is serverbound - manages the controls visibility from the server 
				if (control is IServerBoundControl)
				{
					parentActivityContainer.registerControl(control as IServerBoundControl);
				}				
				
				//The control renders DataPublications from the server
				if (control is IDataControl)
				{
					parentActivityContainer.registerDataControl(control as IDataControl);
				}
				
				//The control renders Messages from the server
				if (control is IMessagePanel)
				{
					parentActivityContainer.MessagePanel = (control as IMessagePanel);
				}
			}
			else
			{
				if (control is IMessagePanel)
					//There was no activity parent and it is an IMessagePanel so register it as the top level
					//MessagePanel Control
				{
					ExpanzThinRIA.getInstance().homeMessagePanel = (control as IMessagePanel);
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		private var _parentActivityContainer:IActivityContainer;
		
		/**
		 * Reference to this controls parent Activity Container.
		 */
		public function get parentActivityContainer():IActivityContainer
		{
			return _parentActivityContainer;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Static utility method to find the controls IActivityContainer
		 */
		public static function findParentActivityContainer(parent:DisplayObjectContainer):IActivityContainer
		{
			var parentActivityContainer:IActivityContainer;
			
			while (parentActivityContainer == null && parent != null)
			{
				if (parent is IActivityContainer)
				{
					parentActivityContainer = parent as IActivityContainer;
				}
				else
				{
					parent = parent.parent;
				}
			}
			return parentActivityContainer;
		}
		
		public function sendXml(xml:XML):void
		{
			parentActivityContainer.Exec(xml);
		}

		public function sendXmlList(xml:ArrayCollection):void
		{
			parentActivityContainer.ExecList(xml);
		}

		public function get DeltaElement():XML
		{
			parentActivityContainer.AppHost.request.appendChild(<Delta/>);
			return parentActivityContainer.AppHost.request.child("Delta")[parentActivityContainer.AppHost.request.child("Delta").length() - 1];
		}
		
		public function get DataPublicationRefreshElement():XML
		{
			parentActivityContainer.AppHost.request.appendChild(<DataPublication/>);
			return parentActivityContainer.AppHost.request.child("DataPublication")[parentActivityContainer.AppHost.request.child("DataPublication").length() - 1];
		}

		public function get MethodElement():XML
		{
			parentActivityContainer.AppHost.request.appendChild(<Method/>);
			return parentActivityContainer.AppHost.request.child("Method")[parentActivityContainer.AppHost.request.child("Method").length() - 1];
		}

		public function getContextMenuRequest(id:String, type:String, contextObject:String):ArrayCollection
		{
			var nodes:ArrayCollection = new ArrayCollection();
			parentActivityContainer.AppHost.request.appendChild(<Context/>);
			var context:XML = parentActivityContainer.AppHost.request.child("Context")[parentActivityContainer.AppHost.request.child("Context").length() - 1];
			context.@["id"] = id;
			context.@["Type"] = type;
			setModelObjectContext(context, contextObject);
			nodes.addItem(context);
			parentActivityContainer.AppHost.request.appendChild(<ContextMenu/>);
			var menu:XML = parentActivityContainer.AppHost.request.child("ContextMenu")[parentActivityContainer.AppHost.request.child("ContextMenu").length() - 1];
			setModelObjectContext(menu, contextObject);
			nodes.addItem(menu);
			return nodes;
		}

		public function getDoubleClickRequest(id:String, type:String, contextObject:String):ArrayCollection
		{
			var nodes:ArrayCollection = new ArrayCollection();
			parentActivityContainer.AppHost.request.appendChild(<Context/>);
			var context:XML = parentActivityContainer.AppHost.request.child("Context")[parentActivityContainer.AppHost.request.child("Context").length() - 1];
			context.@["id"] = id;
			context.@["Type"] = type;
			setModelObjectContext(context, contextObject);
			nodes.addItem(context);
			parentActivityContainer.AppHost.request.appendChild(<MenuAction/>);
			var menu:XML = parentActivityContainer.AppHost.request.child("MenuAction")[parentActivityContainer.AppHost.request.child("MenuAction").length() - 1];
			menu.@["defaultAction"] = "true";
			setModelObjectContext(menu, contextObject);
			nodes.addItem(menu);
			return nodes;
		}

		public function MenuActionElement(action:String, contextObject:String):XML
		{
			var menuAction:XML = <MenuAction action={action}/>;	
			
			if (contextObject != null)
				menuAction.@["contextObject"] = contextObject;
			
			parentActivityContainer.AppHost.request.appendChild(menuAction);
			
			return menuAction;
		}

		//--------------------------------------------------------------------------
		//
		//  Private Methods
		//
		//--------------------------------------------------------------------------
		
		private function setModelObjectContext(xml:XML, context:String):void
		{
			var c:String;

			if (context != null && context.length > 0)
				c = context;

			if (c == null && parentActivityContainer.FixedContext != null)
				c = parentActivityContainer.FixedContext;

			if (c != null)
				xml.@["contextObject"] = c;
		}
	}
}