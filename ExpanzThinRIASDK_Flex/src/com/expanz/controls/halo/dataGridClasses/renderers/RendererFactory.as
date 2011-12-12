package com.expanz.controls.halo.dataGridClasses.renderers
{
    import mx.controls.TextInput;

    public class RendererFactory
    {

        public static function getItemEditor(type:String):Class
        {
            var editor:Class;

            switch (type)
            {

                case "bool":
                    editor = CheckBoxRenderer;
                    break;
                case "string":
                default:
                    editor = TextInput;
            }

            return editor;
        }

    }
}