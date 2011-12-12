package com.expanz.controls.halo
{
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.controls.Button;

	public class TabButtonEx extends Button
	{
		public function TabButtonEx()
		{
			super();
			var cm:ContextMenu=new ContextMenu();
			var mi:ContextMenuItem =new ContextMenuItem("test");
			//mi.label="test"; 
			cm.addItem(mi);
			this.contextMenu=cm;
		}
		
	}
}