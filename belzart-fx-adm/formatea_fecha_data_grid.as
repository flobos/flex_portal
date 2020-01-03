package
{ 
import mx.controls.Label;

class formatea_fecha_data_grid extends Label
{
	var theDate:Date;
	var getDataLabel:Function;
	static var dateFmt:String;//DateFormatter;
	
	function init()
	{
		
		if( dateFmt == undefined ) {
			dateFmt = new String();//DateFormatter();
			//dateFmt = "MM/DD/YYYY";
		}
		
		theDate = new Date();
		
		init();
	}
	
	function setValue(str:String, item:Object, sel:Boolean)
	{
		if( item != undefined ) {
			var pdate:String = item[getDataLabel()];
		
		
		var final:String;
		//var objeto = new String(pdate); 
		trace(pdate.length); 
		
		
		final =( pdate.charAt(pdate.length-13)+ pdate.charAt(pdate.length-12)+"-"+pdate.charAt(pdate.length-16)+ pdate.charAt(pdate.length-15)+"-"+ pdate.charAt(pdate.length-21)+ pdate.charAt(pdate.length-20)+ pdate.charAt(pdate.length-19)+ pdate.charAt(pdate.length-18) )
		
						
						
						
			//theDate.toString(pdate);
			this.text = (final);
		}
		else {
			this.text = "";
		}
	}
	
//	function size()
//	{
//		this.setSize(layoutWidth,layoutHeight);
//	}
}
}