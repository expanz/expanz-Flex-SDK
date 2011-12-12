package com.expanz.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AppFrameworkModel extends EventDispatcher
	{
		public function AppFrameworkModel(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}