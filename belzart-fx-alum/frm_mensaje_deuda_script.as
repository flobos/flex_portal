import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

public var alu_idn:String;



private function frm_mensaje_deuda_load():void {
ro_mensaje_deuda.muestra_mensaje_deuda(alu_idn)
}





private function result_muestra_mensaje_deuda(event:ResultEvent):void
{
	var arreglo111:Object;
	arreglo111 = event.result;


	
	if  (arreglo111.length < 1)
	{
		//PopUpManager.removePopUp(this)  
		 parentApplication.flag_deuda.text = '0';
	}
	else
	{	
		parentApplication.flag_deuda.text = '1';
		
		dg_deuda.dataProvider = arreglo111
		
		var dia:Number
		var mes:Number
		var año:Number
		
		dia = Number(arreglo111[0].campo_cinco)
		mes = Number(arreglo111[0].campo_seis)
		año = Number(arreglo111[0].campo_siete)
		
		if (dia >= 5 && dia <= 14) {
			
		t_fecha.text = f_encuentra_remplaza(t_fecha.text, "DD", "15")
		t_fecha.text = f_encuentra_remplaza(t_fecha.text, "MM", String(mes))
		t_fecha.text = f_encuentra_remplaza(t_fecha.text, "AAAA", String(año))
	}
		
		if (dia >= 15 && dia <= 31 || dia >= 1 && dia <= 4) {
			
			var mes_mas_uno:Number
			mes_mas_uno = mes + 1
			
			t_fecha.text = f_encuentra_remplaza(t_fecha.text, "DD", "05")
			
			if (mes_mas_uno > 12){
				
			t_fecha.text = f_encuentra_remplaza(t_fecha.text, "MM", "01")
			t_fecha.text = f_encuentra_remplaza(t_fecha.text, "AAAA", String(año + 1))
			
			}else{
				
			t_fecha.text = f_encuentra_remplaza(t_fecha.text, "MM", String(mes_mas_uno))
			t_fecha.text = f_encuentra_remplaza(t_fecha.text, "AAAA", String(año))
			
			}
			
		
		
		
		
		}
		
		
		
		
	}
}




private function btn_leido_click():void{
	
 PopUpManager.removePopUp(this)  	
	
}


private function f_encuentra_remplaza(x:String, encontrar:String, remplazar:String):String
{
    if (x == "" || encontrar == "") return x;
    if (x.indexOf(encontrar) < 0) return x;
    var largo:Number = encontrar.length;
    var marca:Number = 0;
    var te_pille:Number = x.indexOf(encontrar,marca);
    var x2:String = "";
    while (te_pille > -1) {
        x2 += x.substring(marca,te_pille);
        x2 += remplazar;
        marca = te_pille + largo;
        te_pille = x.indexOf(encontrar,marca);
    }
    x2 += x.substring(marca);
    return x2;
}



private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
