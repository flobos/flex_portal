import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;


public var trabajo:String

private function carga():void{

ro_respuestas.muestra_preguntas_objetivas(trabajo)

}


private function click_btn_cerrar():void{
	
	PopUpManager.removePopUp(this)

}


private function result_muestra_preguntas_objetivas(event:ResultEvent):void{
	var i:Number
	rpt_preguntas.dataProvider =  event.result;
	
	var arreglo_preguntas:Object;
	arreglo_preguntas = rpt_preguntas.dataProvider

	for(i = 0; i < arreglo_preguntas.length ; i++)
	{
		ro_respuestas.muestra_preguntas_respuestas(Number(librerias.f_trim(lbl_codigo[i].text)))
	}
	

}



private function result_muestra_preguntas_respuestas(event:ResultEvent):void{
	

var codigo:String	
var arreglo2:Object;
var x:Number
var arreglo_preguntas1:Object;
arreglo_preguntas1 = rpt_preguntas.dataProvider
arreglo2 = event.result; 
codigo = arreglo2[0].campo_cuatro


for(x = 0; x < arreglo_preguntas1.length ; x++)
	{
  		if (lbl_codigo[x].text == codigo){
			
		rpt_respuestas[x].dataProvider = event.result
					
		}
	}


}
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
