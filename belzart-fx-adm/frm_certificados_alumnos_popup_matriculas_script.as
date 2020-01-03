// ActionScript file


import flash.events.KeyboardEvent;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

public var resultado:ResultEvent;


//*******************************************************************************************************
private function inicio():void{
	
	dg_matricula.dataProvider=resultado.result;
	
}

//*******************************************************************************************************

private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}


//******************************************************************************************************

private function btn_seleccionar_click():void
{
	if (dg_matricula.selectedItem !=null)
	{
		this.parentApplication.asigna_matricula(dg_matricula.selectedItem.campo_uno, dg_matricula.selectedItem.campo_dos, dg_matricula.selectedItem.campo_tres, dg_matricula.selectedItem.campo_cuatro);
		this.parentApplication.cmb_certificados.enabled = true;
		PopUpManager.removePopUp(this);
	}
	else {
		mx.controls.Alert.show("Debe seleccionar una matrícula","Alerta");
	}
}
	
	
	
	
	