import flash.events.Event;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;
import mx.events.CloseEvent;

import mx.printing.FlexPrintJob;


public var arreglo_pretomas_verifica:ArrayCollection;
public var codigo_pretoma_verifica:String



private function tw_pretoma_verifica_creationComplete():void{
	
	lbl_codigo_pretoma_verifica.text = codigo_pretoma_verifica 
	dg_pretoma_verifica.dataProvider = arreglo_pretomas_verifica
	
}


private function result_cambia_estados_en_pretoma(event:Event):void{

	  	this.parentApplication.mod.getChildAt(0).tw_pretomas.enabled = false;
		btn_imprime.enabled = true  
		btn_aceptar.enabled = false
		
		var pj:FlexPrintJob = new FlexPrintJob();
        if (pj.start() != true) return;
        pj.addObject(vb_pretomas);
		pj.send();
//		delete pj;
		mx.controls.Alert.show("Pretoma realizada exitosamente, ahora puede imprimir comprobante" , "EXITO");

}


private function btn_aceptar_click():void {
	
	
	mx.controls.Alert.show("Esta seguro que desea aceptar la pretoma?" , "PREGUNTA" , mx.controls.Alert.OK|mx.controls.Alert.CANCEL, this, this.Manejador_Alerta, null, Alert.OK);

	
}



private function Manejador_Alerta(event:CloseEvent):void{
      if (event.detail == mx.controls.Alert.OK) {
      var i:Number;
	  		var arreglo100:ArrayCollection = new ArrayCollection;
			
			for(i = 0; i < dg_pretoma_verifica.dataProvider.length ; i++ )
			{
			var o_dos_campos:obj_dos_campos = new obj_dos_campos;
			o_dos_campos.data = dg_pretoma_verifica.dataProvider.getItemAt(i).data;
			o_dos_campos.label = '';
			arreglo100.addItem(o_dos_campos);		
			}
			
			ro_pretoma_aceptadas.cambia_estados_en_pretoma(Number(lbl_codigo_pretoma_verifica.text), arreglo100)
			
			
	  
		
      }else{
            return;
      }
}


private function btn_cerrar_click():void{
	

	PopUpManager.removePopUp(this)

}


private function btn_imprime_click():void{

 var pj : FlexPrintJob = new FlexPrintJob();
            if (pj.start() != true) return;
            pj.addObject(vb_pretomas);
			pj.send();
//            delete pj;

}
						
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
