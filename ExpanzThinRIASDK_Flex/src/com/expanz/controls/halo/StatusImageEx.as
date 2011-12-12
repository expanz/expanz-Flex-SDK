package com.expanz.controls.halo
{
	[IconFile("Image.png")]
	
	
	/**
	 * Used to display images/icons for field values status's
	 * @author expanz
	 * 
	 */
	public class StatusImageEx extends ImageEx
	{
		/**
		 * Set to true to hide the image when the value is false otherwise the default is to show the image but disabled 
		 */
		public var showWhenDisabled:Boolean;
		
		public function StatusImageEx()
		{
			super();
			visible = showWhenDisabled;
			enabled = false;
		}
		

		public override function setNull():void
		{
			setVisibilityValue(false);
		}

		public override function setValue(text:String):void
		{
			//override and ignore as we dont want to change the source property
		}

		public override function publishXml(xml:XML):void
		{
			if (xml.hasOwnProperty("@value") && xml.hasOwnProperty("@datatype") && xml.@datatype.toString() == "bool" && xml.@value != "")
			{
				var value:Boolean = Boolean(parseInt(xml.@value.toString()));
				setVisibilityValue(value);	 
			}
		}

		private function setVisibilityValue(value:Boolean):void
		{
			if (!showWhenDisabled && value == false){
				visible = false;
				this.alpha = .30;
			}else{
				visible = true;
				this.alpha = 1;
			}
			
		}


	}
}