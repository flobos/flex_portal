import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

// ActionScript Document
public var trab_idn:String
public var promedio:String

private function carga():void
{
	//lbl_not_idn.text = "920103";
	ro_notas.ro_obtiene_correccion_pruebas(trab_idn);
}


private function result_ro_obtiene_correccion_pruebas(event:ResultEvent):void
{
	var arreglo:Object;
	arreglo = event.result;
	var i:Number;
	var arreglo_puntaje_total:ArrayCollection = new ArrayCollection;
	var y:Number;

	
	y=0;
	//largo_preguntas = arreglo.length

	for(i = 0; i < arreglo.length; i++ )
	{
			var o_cuatro_campos:obj_cuatro_campos = new obj_cuatro_campos;
			o_cuatro_campos.campo_uno = arreglo[i].campo_uno;//pregunta
			o_cuatro_campos.campo_dos = arreglo[i].campo_dos; //puntaje_total
			o_cuatro_campos.campo_tres = arreglo[i].campo_tres; //puntaje_obtenido
			o_cuatro_campos.campo_cuatro = arreglo[i].campo_cuatro; //observacion
			arreglo_puntaje_total.addItem(o_cuatro_campos);	
//			arreglo_puntaje_total.addItemAt(y, { ,, puntaje_obtenido: String(arreglo[i].campo_tres), observacion: String(arreglo[i].campo_cuatro)});
			y++;
	}
	rp_correccion.dataProvider = arreglo_puntaje_total;
	lbl_promedio_t.text = promedio;
	
}

private function salir():void {
	PopUpManager.removePopUp(this)
}
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
