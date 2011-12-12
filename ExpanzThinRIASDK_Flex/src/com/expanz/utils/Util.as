package com.expanz.utils
{
	import mx.collections.ArrayCollection;

	/**
	 * expanz Framework utility class with static helper methods 
	 * 
	 * @author expanz
	 * 
	 */
	public class Util
	{
		public static function replaceAll(onString:String, replaceWhat:String, replaceWith:String ):String {
			if(onString == null)
				return "";
			
			while ( onString != onString.replace(replaceWhat, replaceWith)) {
				onString = onString.replace(replaceWhat, replaceWith);
			}		
			return onString;	
		}
		
		public static function underscoresToDots(onString:String):String {
			return replaceAll(onString, "_", ".");
		}
		
		public static function dotsToUnderscores(onString:String):String {
			return replaceAll(onString, ".", "_");
		}
		
		/**
		 * Trim . from the fieldNames for field databinding references
		 */
		public static function formatColumnName(field:String):String
		{
			return field.replace(".","");
		}
		
		
		/**
		 * ESA XML payload is not databindable as it is delivered and must be transformed
		 *  
		 * @param data the XML from the servers Data Publication
		 * @param modelObject reference
		 * @return XMLList or <Row/> Elements
		 * 
		 */
		public static function transformXMLToDataBindableXML(data:XML, modelObject:String=""):XMLList
		{
			var transformedXML:XML = <Rows />;
			var colCount:int = data.Columns.children().length();
			
			for each (var row:XML in data.Rows.children()) {
				var newRow:XML = <Row Type={row.@Type} id={row.@id} ModelObject={modelObject}/>;
							
				for (var i:int = 0; i < colCount; i++)
				{			
					var colData:XMLList = row.child(i);
					var colDef:XMLList = data.Columns.child(i);
					var colNameFormatted:String = formatColumnName(colDef.@field)
					newRow.appendChild(
						<{colNameFormatted} label={colDef.@label} value={colData.toString()} datatype={colDef.@datatype} width={colDef.@width} sortValue={colData.@sortValue}>
						{colData.toString()}
						</{colNameFormatted}>
					);
				}
				
				transformedXML.appendChild(newRow);
			}
			return transformedXML.Row;
		}						
		
		/**
		 * Transforms ESA XML to Objects for databinding
		 * 
		 * ESA XML payload is not databindable as it is delivered and must be transformed.
		 * 
		 * @param data
		 * @param modelObject
		 * @return 
		 * 
		 */		
		public static function transformXMLToDataBindableObjects(dataPublication:XML, modelObject:String=""):ArrayCollection 
		{
			var transformedData:ArrayCollection = new ArrayCollection();
			
			for each (var row:XML in dataPublication.Rows.children()) 
			{
				var newRow:Object = new Object();
				newRow["Type"] = row.@Type.toString();
				newRow["id"] = row.@id.toString();
				newRow["ModelObject"] = modelObject;
				newRow["displayStyle"] = "";
				
				//column data cells
				for each (var col:XML in dataPublication.Columns.children()) 
				{
					newRow[formatColumnName(col.@field)] = row.child(col.@id - 1).toString(); 
				}
				transformedData.addItem(newRow);
			}
			return transformedData;	
		}
	}
}
