package com.expanz.controls.halo
{
	import mx.collections.ArrayCollection;
	import mx.controls.ToggleButtonBar;
	import mx.events.ItemClickEvent;
	
	public class FilterControl extends ToggleButtonBar
	{
		public var optionsKey:String; 
		public var allOption:String;
				
		public function FilterControl():void
		{
			addEventListener(ItemClickEvent.ITEM_CLICK, onClick);
		}

		private var _dataSource:ArrayCollection;
		public function set dataSource(dp:Object):void {
			if (dp == _dataSource) {
				return;
			}
			if (!(dp is ArrayCollection)) {
				trace("Error: FilterControl.set dataSource: !(dp is ArrayCollection)");	
				return;
			}
			
			
			_dataSource = dp as ArrayCollection;
			
			//find options
			var options:Array = getOptions(_dataSource, optionsKey);

			if (allOption) {
				options.unshift(allOption);	
			}
			dataProvider = options;
			if (allOption) {
				selectedIndex = 0;	
			}
		}
		private var currentKey:String;
        private function onClick(event:ItemClickEvent):void {
        	if (event.label == allOption) {
        		_dataSource.filterFunction = null;
        	} else {
        		_dataSource.filterFunction = filter;
				currentKey = event.label;
        	}
        		_dataSource.refresh();
        }		
		
		public function filter(item:Object):Boolean {
			if (item[optionsKey]!=null && item[optionsKey] == currentKey) {
				return true;
			} else {
				return false;
			}
		}
		
		public function get dataSource():Object {
			return _dataSource;
		}
		
		private function getOptions(source:ArrayCollection, key:String):Array {
			var result:Array = new Array();
			if (key == null) {
				trace("Warning: FilterControl.getOptions: key==null");				
				return result;
			}
			var alreadyProcessed:Object = new Object();
			for each (var element:Object in source) {
				if (element[key]!=null && element[key] is String) {
					if (alreadyProcessed[element[key]] == null) {
						result.push(element[key]);
						alreadyProcessed[element[key]] = true;
					}
				}
			}
			return result;
		}
		


	}
}