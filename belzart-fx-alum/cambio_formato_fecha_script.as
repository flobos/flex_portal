package {
import mx.formatters.DateFormatter;
import mx.controls.Label;

/*
  si el formato tiene una base simple como la de un label se puede cambiar el contenido de este por el de un nuevo formato
 */

public class cambio_formato_fecha extends Label
{	
	var getDataLabel:Function;
	static var dateFmt:DateFormatter;
	
	function init() : void
	{
		
		if( dateFmt == undefined ) {
			dateFmt = new DateFormatter();
			dateFmt.formatString = "DD/MM/YYYY";
		}
		init();
	}
	
	function setValue(str:String, item:Object, sel:Boolean):void
	{
		if( item != undefined ) {
			
			this.text = dateFmt.format(item[getDataLabel()]);
		}
		else {
			this.text = "";
		}
	}
	
	function size() : void
	{
		this.setActualSize(layoutWidth,layoutHeight);
	}
}
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
}
