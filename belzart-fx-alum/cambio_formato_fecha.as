package {
import mx.formatters.DateFormatter;
import mx.controls.Label;

/*
  si el formato tiene una base simple como la de un label se puede cambiar el contenido de este por el de un nuevo formato
 */

public class cambio_formato_fecha extends Label
{	
	public  var getDataLabel:Function;
	public static var dateFmt:DateFormatter;
	
	public function init() : void
	{
		
		if( dateFmt == null ) {
			dateFmt = new DateFormatter();
			dateFmt.formatString = "DD/MM/YYYY";
		}
		init();
	}
	
	public function setValue(str:String, item:Object, sel:Boolean):void
	{
		if( item != null ) {
			
			this.text = dateFmt.format(item[getDataLabel()]);
		}
		else {
			this.text = "";
		}
	}
	
	public function size() : void
	{
	//	this.setActualSize(layout.width,layoutHeight);
	}
}
}