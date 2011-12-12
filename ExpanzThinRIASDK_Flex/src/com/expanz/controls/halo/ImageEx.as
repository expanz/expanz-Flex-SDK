package com.expanz.controls.halo
{
	import com.expanz.ControlHarness;
	import com.expanz.interfaces.IEditableControl;
	import com.expanz.interfaces.IServerBoundControl;
	import com.expanz.utils.Util;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.events.FlexEvent;
	import mx.utils.Base64Decoder;

	[IconFile("Image.png")]
	
	public class ImageEx extends Image implements IServerBoundControl, IEditableControl
	{

		private var harness:ControlHarness;
		private var pdfLabel:Label;
		private var PDF:String;
		
		public function ImageEx()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}

		private function creationCompleteHandler(event:FlexEvent):void
		{
			harness = new ControlHarness(this);
		}
		
		private function onDoubleClick(event:MouseEvent):void
		{
			if(PDF!=null)
			{
				navigateToURL(new URLRequest(PDF),"_blank");
			}
		}

		//------------------------------------------------------
		// IServerBoundControl Interface Implementation
		//------------------------------------------------------
		
		include "../../includes/IServerBoundControlImpl.as";	

		public function get DeltaXml():XML
		{
			return null;
		}

		public function setEditable(editable:Boolean):void
		{
		}

		public function setNull():void
		{
			source = null;
		}

		public function setValue(text:String):void
		{
			source = text;
		}

		public function setLabel(label:String):void
		{
		}

		public function setHint(hint:String):void
		{
			toolTip = hint;
		}

		public function publishXml(xml:XML):void
		{
			if (xml.hasOwnProperty("@encoding") && xml.@encoding == "BASE64")
			{
				var base64Decoder:Base64Decoder = new Base64Decoder();
				base64Decoder.decode(xml.toString());
				source = base64Decoder.toByteArray();
			}
			else if (xml.hasOwnProperty("@url") && xml.@url != "")
			{
				var url:String = xml.@url.toString();
				if(url.toUpperCase().indexOf(".PDF")>0)
				{
					PDF=harness.parentActivityContainer.AppHost.fileURLPrefix + url;
					pdfLabel=new Label();
					pdfLabel.width=this.width;
					pdfLabel.text="Click here to view PDF";
					pdfLabel.addEventListener(MouseEvent.CLICK, onDoubleClick);
					this.visible=false;
					this.parent.addChild(pdfLabel);
				}
				else
				{
					if(pdfLabel!=null)
					{
						this.visible =true;
						pdfLabel.parent.removeChild(pdfLabel);
						pdfLabel=null;
					}
					if(url.toUpperCase().indexOf(".TIF")>=0)
					{
						url = url.substr(0,url.lastIndexOf("."))+".jpeg";
					}
					source = harness.parentActivityContainer.AppHost.fileURLPrefix + url;
					this.toolTip=source.toString();
				}
			}
		}


	}
}