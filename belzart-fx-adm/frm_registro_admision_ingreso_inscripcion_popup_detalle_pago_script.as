// ActionScript file
import libreria.*;

import mx.core.Application;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

//******************************************************************************************************
private var porcentaje_pago:String;
private var direccion_pago:String;
private var forma_pago:String;
private var medio_pago:String;
private var tipo_pago:String;
//******************************************************************************************************
private function inicio():void
{
	

}
//******************************************************************************************************
private function btn_aceptar_click():void
{
	PopUpManager.removePopUp(this);	
}