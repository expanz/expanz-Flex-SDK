package com.expanz.controls.gridClasses
{
    import com.expanz.controls.halo.dataGridClasses.renderers.RendererFactory;
    
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.core.ClassFactory;
    import mx.utils.ObjectUtil;
    
    import spark.components.gridClasses.GridColumn;
    import spark.globalization.SortingCollator;

    public class GridColumnEx extends GridColumn
    {
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

        public function GridColumnEx(columnName:String = null)
        {
            super(columnName);
			super.sortCompareFunction = numeric_sortCompareFunc;
        }

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		// Create an instance of the SortingCollator.
		private var collator:SortingCollator = new SortingCollator();
		
        private var _column:XML;

        private var _dataType:String = "string";
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		public override function set dataField(value:String):void
		{
			super.dataField = value;
		}

		public function get column():XML
		{
			return _column;
		}

		public function set column(value:XML):void
		{
			_column = value;
		}

        public function get dataType():String
        {
            return _dataType;
        }

        public function set dataType(value:String):void
        {
            _dataType = value;
            updateRenderer();
        }

        public function setEditable(value:Boolean):void
        {
            editable = value;
            updateRenderer();
        }

        private function updateRenderer():void
        {
			//UPDATE TO BE COMPATIBLE WITH SPARK
			/*
			if (editable && dataType)
            {
                switch (dataType)
                {
                    case "bool":
                        editorDataField = "isSelected";
                        break;
                    case "string":
                    default:
                        editorDataField = "text";
                }

                itemRenderer = new ClassFactory(RendererFactory.getItemEditor(dataType));
                
				
				rendererIsEditor = true; 
            }
			*/
        }
		
		/**
		 *	Handle 3 sort cases
		 *  1. No Sort value Supplied then do a text sort
		 *  2. Sort Value supplied do a number sort
		 *  3. Date value supplied, convert to date then Number and sort
		 *  
		 * @param itemA
		 * @param itemB
		 * @return 
		 * 
		 */
		private function numeric_sortCompareFunc(itemA:Object, itemB:Object, col:GridColumn):int 
		{			
			var returnValue:int;
			
			var compareValueA:Number;
			var compareValueB:Number;
				
			//check the values are dates
			var dateA:Date = createDateObject(itemA[dataField].@sortValue); 
			var dateB:Date = createDateObject(itemB[dataField].@sortValue);
		
			if(!isNaN(dateA.time) && !isNaN(dateB.time))
			{
				//Date Comparison			
				compareValueA = dateA.valueOf();
				compareValueB = dateB.valueOf();
				returnValue = ObjectUtil.numericCompare(compareValueA, compareValueB);
			}
			else
			{
				//Numeric Comparison by sortField Supplied
				if (itemA[dataField].@sortValue.toString() != "" && itemB[dataField].@sortValue.toString() != "")
				{
					compareValueA = itemA[dataField].@sortValue;
					compareValueB = itemB[dataField].@sortValue;
					returnValue = ObjectUtil.numericCompare(compareValueA, compareValueB);
				}
				else
				{		
					//String Comparison on the data values
					returnValue = collator.compare(itemA[dataField][0], itemB[dataField][0]);
				}
			}
			return returnValue
		}
		
		private function createDateObject(value:String):Date
		{
			var dateString:String = value.replace(" 00:00:00Z","");
			var dateParts:Array = dateString.split("-");
			
			return new Date(dateParts[0], dateParts[1], dateParts[2]);
		}
    }
}