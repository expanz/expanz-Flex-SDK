package com.expanz.controls.halo.dataGridClasses
{
	import mx.controls.dataGridClasses.DataGridColumn;

	public class GridColumnEx extends DataGridColumn
	{
		public function GridColumnEx(columnName:String=null)
		{
			super(columnName);
		}
		private var cellid:String;
		public function get CellId():String {return cellid;}
		public function set CellId(value:String):void
		{
			cellid=value;
			this.dataField = "Cell"+cellid;
		}
	}
}