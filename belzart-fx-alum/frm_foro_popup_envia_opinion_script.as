import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;
public var foro:String;
private var tc_idn:String;

//***********************************************************************************************************
private function inicio():void
{
	tc_idn = this.parentApplication.tc_idn;
}
//***********************************************************************************************************
private function btn_cerrar_click():void
{
	PopUpManager.removePopUp(this);
}
//***********************************************************************************************************
private function click_btn_envia():void
{
	if(txt_texto.text != ""){

	ro_foro_alumno2.foro_inserta_opinion(Number(foro), txt_texto.text, tc_idn);
	mx.controls.Alert.show("Presione el botón Actualizar para ver su mensaje","Información");
	}
	else
	{
		mx.controls.Alert.show("Ingrese una opinión","Ayuda");
	}
	
}
//***********************************************************************************************************
private function result_foro_inserta_opinion(event:Event):void
{
	PopUpManager.removePopUp(this)
}

private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
