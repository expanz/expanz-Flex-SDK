package com.expanz
{
	import mx.core.IMXMLObject;
	
	public class FormMappings implements IMXMLObject
	{
		public function FormMappings()
		{
		}
		
		public function initialized(document:Object, id:String):void
		{
		}
		
		[DefaultProperty]
		public var Activities:Array;
	}
}