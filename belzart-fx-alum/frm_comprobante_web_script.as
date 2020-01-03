import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

public var archivo:String;
public var trabajo:String;

public var tipo_prueba:String;
public var alumno:String;
public var ramo:String;
public var carrera:String;
public var codigo_prueba:String;


private function carga():void
{	
	ro_grupos.ro_llena_grilla_comprobante(this.parentApplication.trabajo)
}
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
private function devuelve_consulta_grilla_comprobante(event:ResultEvent):void
{
	if( event.result.length > 0){
		lbl_archivo.text = this.parentApplication.archivo;
		lbl_trabajo.text= this.parentApplication.trabajo;
		lbl_tipo_prueba_n.text = this.parentApplication.tipo_prueba;
		lbl_encargado.text = this.parentApplication.encargado;
		lbl_ramo.text = this.parentApplication.cur_nombre;
		lbl_carrera.text = this.parentApplication.mal_nombre;
		dt_integrantes.dataProvider = event.result;	
	}
	else
	{
		mx.controls.Alert.show("Han ocurrido errores al enviar la prueba.\nPor favor intente nuevamente.","Alerta");
		salir();
	}
	
	

}
private function salir():void
{
	PopUpManager.removePopUp(this)
	
}
private function doPrint():void {
            var pj : PrintJob = new PrintJob();
            if (pj.start() != true) return;
            pj.addPage(Canvas_print);
			pj.send();
   }
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
