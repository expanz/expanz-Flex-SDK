package com.expanz.controls.halo
{
	public class ListItemEx
	{
		private var id:String;
		private var text:String;
		private var type:String;
		public function get Id():String
		{
			return id;
		}
		public function get label():String
		{
			return text;
		}
		public function get Type():String
		{
			return type;
		}
		public function set Type(value:String):void
		{
			type=value;
		}
		public function ListItemEx(id:String,text:String)
		{
			super();
			this.id=id;
			this.text=text;
		}

	}
}