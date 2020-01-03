import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.*;
import mx.rpc.events.*;
import mx.utils.*;


//***********************************************************************************************************
private function inicio():void
{
	
	var eje_aca:String;
	eje_aca= String(String(this.parentApplication.eje_aca_idn));
	ro_ficha_tutor.ro_carga_nombre_tutor(eje_aca);
	ro_ficha_tutor.ro_carga_datos_tutor(eje_aca);

}
//***********************************************************************************************************
private function devuelve_datos_carga_nombre_tutor(event:ResultEvent):void
{

	lbl_nombre.text = event.result[0].campo_uno;

}



//***********************************************************************************************************
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show("error");

}


//***********************************************************************************************************
private function devuelve_datos_carga_datos_tutor(event:ResultEvent):void
{
	var i:Number;

	var arreglo:Object;
	arreglo = event.result;
	if (arreglo.length > 0){
		lbl_horario.text = arreglo[0].campo_seis;
		var arreglo_titulo:ArrayCollection = new ArrayCollection;
		var arreglo_perfec:ArrayCollection = new ArrayCollection;
		var y:Number;
		var z:Number;
		y=0;
		z=0;
	
		var obj1:Object=new Object;
	    var obj2:Object=new Object;	
	
		for(  i = 0; i < arreglo.length; i++ )
		{
			if (arreglo[i].campo_cuatro == '100')
			{
				obj1.titulo = String(arreglo[i].campo_dos)
				obj1.uni = String(arreglo[i].campo_tres)
				
				arreglo_titulo.addItem(obj1);
				y++;
			}
			else
			{
				var obj2:Object=new Object;	
				obj2.perfeccionamiento = String(arreglo[i].campo_dos)
				obj2.uni = String(arreglo[i].campo_tres)
	
				arreglo_perfec.addItem(obj2);
				
				z++;
			}
			
		}
		titulo_prof.dataProvider = arreglo_titulo;
		universidad.dataProvider = arreglo_titulo;
		titulo_perf.dataProvider = arreglo_perfec; 
		uni_perf.dataProvider = arreglo_perfec;
	}
	else {
		mx.controls.Alert.show("El tutor "+lbl_nombre.text +" no registra datos asociados","Información");
	}


}