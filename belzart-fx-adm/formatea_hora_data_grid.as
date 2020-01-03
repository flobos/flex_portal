
import mx.controls.Label;


class formatea_hora_data_grid extends Label
{
	var theDate:Date;
	var getDataLabel:Function;
	static var dateFmt:String;//DateFormatter;
	
	function init() : Void
	{
		
		if( dateFmt == undefined ) {
			dateFmt = new String();//DateFormatter();
			//dateFmt = "MM/DD/YYYY";
		}
		
		theDate = new Date();
		
		super.init();
	}
	
	function setValue(str:String, item:Object, sel:Boolean)
	{
		if( item != undefined ) {
			var pdate:String = item[getDataLabel()];
		
		
		var final2:String;
		//var objeto = new String(pdate); 
		trace(pdate.length); 
		final2=(pdate.charAt(pdate.length-10)+ pdate.charAt(pdate.length-9)+pdate.charAt(pdate.length-8)+ pdate.charAt(pdate.length-7)+pdate.charAt(pdate.length-6) )
		
						
						
						
			//theDate.toString(pdate);
			this.text = (final2);
		}
		else {
			this.text = "";
		}
	}
	
	function size() : Void
	{
		this.setSize(layoutWidth,layoutHeight);
	}
}