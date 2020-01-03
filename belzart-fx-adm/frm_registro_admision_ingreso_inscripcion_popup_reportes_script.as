// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

public var url_frame:URLRequest;
public var arreglo_pag:ArrayCollection = new ArrayCollection;

public var mod_cam_idn:String;
public var insc_idn:String;
private var tip_prod_idn:String;
private var eje_adm_idn:String;
public var func_mod_fun_idn:String;
private function inicio():void
{
	this.dg_pagadores.dataProvider = arreglo_pag;
}

//******************************************************************************************************
private function btn_ver_informe_click():void
{
	if (this.cmb_reportes.selectedItem != null)
	{
	//	mx.controls.Alert.show("http://192.168.1.10/reportes_flex_net/"+this.cmb_reportes.selectedItem.data+"?insc_idn="+this.insc_idn+"&pag_idn="+this.dg_pagadores.selectedItem.campo_uno+"&alu_idn="+this.dg_pagadores.selectedItem.campo_dos+"&pro_mal_idn="+this.dg_pagadores.selectedItem.campo_tres+"&func_mod_fun_idn="+func_mod_fun_idn+"&ara_tot="+this.dg_pagadores.selectedItem.campo_cuatro+"&bec_tot="+this.dg_pagadores.selectedItem.campo_cinco+"&mat_tot="+this.dg_pagadores.selectedItem.campo_seis)
		url_frame = new URLRequest("http://192.168.1.10/reportes_flex_net/"+this.cmb_reportes.selectedItem.data+"?insc_idn="+this.insc_idn+"&pag_idn="+this.dg_pagadores.selectedItem.campo_uno+"&alu_idn="+this.dg_pagadores.selectedItem.campo_dos+"&pro_mal_idn="+this.dg_pagadores.selectedItem.campo_tres+"&func_mod_fun_idn="+func_mod_fun_idn+"&ara_tot="+this.dg_pagadores.selectedItem.campo_cuatro+"&bec_tot="+this.dg_pagadores.selectedItem.campo_cinco+"&mat_tot="+this.dg_pagadores.selectedItem.campo_seis);
		navigateToURL(url_frame, "_blank");
	}
}

//******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}
//***********************************************************************************************************
private function dg_pagadores_clickHandler(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	this.tip_prod_idn = this.dg_pagadores.selectedItem.campo_siete;
	this.eje_adm_idn = this.dg_pagadores.selectedItem.campo_ocho;
	this.ro_ingreso_inscripcion.muestra_reportes(mod_cam_idn, tip_prod_idn, eje_adm_idn); 
	
}
//***********************************************************************************************************
private function result_muestra_reportes(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontraron reportes","Alerta");
	else
	{
		this.cmb_reportes.dataProvider = event.result;
		
	}
}



//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}