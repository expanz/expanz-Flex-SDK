package com.expanz.controls.halo
{
	import mx.containers.ViewStack;
	import mx.controls.Alert;

	public class Wizard extends ViewStack
	{
		protected var started:Boolean;
		public function Wizard()
		{
			super();
			this.creationPolicy="all";
		} 
		public function start():void {started=true;}
		public function prevPage():void
		{
			if(started && selectedIndex>0) selectedIndex--;
		}
		
		public function nextPage():void
		{
			if(started && selectedIndex<(numChildren-1)) selectedIndex++;
		}
	}
}