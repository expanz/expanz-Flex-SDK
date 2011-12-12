package com.expanz.controls.halo.dataGridClasses.renderers
{
	import com.expanz.controls.halo.DataGridEx;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;

	import mx.controls.CheckBox;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.events.FocusRequestDirection;

	public class CheckBoxRenderer extends CheckBox
	{
		public function CheckBoxRenderer()
		{
			super();

			//focusEnabled = false;
			addEventListener(Event.CHANGE, changeHandler);
		}

		public override function set data(value:Object):void
		{
			super.data = value;

			var newSelected:* = data[DataGridListData(listData).dataField];

			selected = Boolean(Number(newSelected));
		}

		public function get isSelected():uint
		{
			return uint(selected);
		}

		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);

			if (listData is DataGridListData)
			{
				var n:int = numChildren;

				for (var i:int = 0; i < n; i++)
				{
					var c:DisplayObject = getChildAt(i);

					if (!(c is TextField))
					{
						c.x = (w - c.width) / 2;
						c.y = 0;
					}
				}
			}
		}

		private function changeHandler(event:Event):void
		{
			//trace("checkbox changing");
			DataGridEx(owner).sendDelta(listData.columnIndex, String(isSelected), data.@id, data.@Type);
		}

	}
}