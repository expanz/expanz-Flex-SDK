package com.expanz.controls.halo.dataGridClasses.renderers
{
    import com.expanz.controls.halo.DataGridEx;
    import com.expanz.controls.halo.dataGridClasses.DataGridColumnEx;

    import mx.containers.Canvas;
    import mx.controls.TextInput;
    import mx.controls.listClasses.BaseListData;
    import mx.controls.listClasses.IDropInListItemRenderer;
    import mx.controls.listClasses.IListItemRenderer;
    import mx.core.IDataRenderer;
    import mx.core.ScrollPolicy;
    import mx.core.UIComponent;

    public class ItemEditor extends Canvas implements IListItemRenderer, IDropInListItemRenderer
    {

        private var editor:UIComponent;

        public function ItemEditor()
        {
            super();
            focusEnabled = false;
            horizontalScrollPolicy = ScrollPolicy.OFF;
            verticalScrollPolicy = ScrollPolicy.OFF;
        }

        public function get listData():BaseListData
        {
            return editor ? IDropInListItemRenderer(editor).listData : null;
        }

        public function set listData(value:BaseListData):void
        {
            var dataGridCols:Array = DataGridEx(value.owner).columns;
            var col:DataGridColumnEx = dataGridCols[value.columnIndex];

            if (editor)
            {
                removeChild(editor);
                editor = null;
            }

            if (col.dataType == "string")
            {
                editor = new TextInput();
                TextInput(editor).percentHeight = 100;
                TextInput(editor).percentWidth = 100;
            }

            if (col.dataType == "bool")
            {
                editor = new CheckBoxRenderer();
                editor.setStyle("horizontalCenter", 0);
                editor.setStyle("verticalCenter", 0);
            }

            if (editor)
            {
                IDropInListItemRenderer(editor).listData = value;

                if (super.data)
                {
                    IDataRenderer(editor).data = super.data;
                }
                addChild(editor);
            }
        }

        public override function get data():Object
        {
            return editor ? IDataRenderer(editor).data : super.data;
        }

        public override function set data(value:Object):void
        {
            super.data = value;

            if (editor)
            {
                IDataRenderer(editor).data = value;
            }
        }

        public function get text():String
        {
            return editor ? editor["text"] : undefined;
        }

        public function get selected():uint
        {
            if (editor)
            {
                return uint(editor["selected"]);
            }
            return undefined;
        }
    }
}