/**
 * Event used whenever something (represented by a value object instance) is 'selected'
 * by the user.
 * 
 **/
package com.expanz.events {
	
	import flash.events.Event;
	
	public class ItemEvent extends Event {

		static public const ACTIVITY_SELECTED : String = "activitySelected";


		public var item : Object;
		
		public function ItemEvent(type:String, item : Object = null, bubbles:Boolean = false) : void {				
			super(type, bubbles, false);
			this.item = item;
		}

		public override function clone() : Event {
			return new ItemEvent(type, item, bubbles);
		}		
		
	}
}