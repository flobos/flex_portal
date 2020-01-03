// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
private var funcionario:String;
private var eje_idn:String;
//*******************************************************************************************************
private function inicio():void
{
	eje_idn = this.parentApplication.eje_idn;
	funcionario = this.parentApplication.txt_fun_codigo.text;
	
	if (this.parentApplication.chk_eje_tutor.selected == true)
	{
		ro_ingreso_conferencia.busca_ejecuciones_academicas(eje_idn);
	}
	else
	{
		ro_ingreso_conferencia.busca_ejecuciones_academicas_tutor(eje_idn, funcionario);	
	}
	
}

//*******************************************************************************************************
private function btn_seleccionar_click():void
{
	if (rp_ejecuciones_academicas.dataProvider.length > 0){
		for(x = 0; x < rp_ejecuciones_academicas.dataProvider.length; x++)
		{
			if (chk_ok_sel[x].selected==true)
			{
				var o_cuatro_campos:obj_cuatro_campos = new obj_cuatro_campos;
				o_cuatro_campos.campo_uno = lbl_codigo_ramo[x].text;
				o_cuatro_campos.campo_dos = lbl_ramo[x].text;
				o_cuatro_campos.campo_tres = lbl_jornada[x].text;
				o_cuatro_campos.campo_cuatro = lbl_seccion[x].text;
				this.parentApplication.dg_ejecuciones_academicas.dataProvider.addItem(o_cuatro_campos);
			}
		}
		btn_cancelar_click();
	}
}
//***********************************************************************************************************
private function result_busca_ejecuciones_academicas(event:ResultEvent):void
{
	if (event.result.length <1)
	{
		this.rp_ejecuciones_academicas.dataProvider = null;
	}
	else
	{
		this.rp_ejecuciones_academicas.dataProvider = event.result;
		eliminar_seleccionadas();
	}
}
//******************************************************************************************************
private function eliminar_seleccionadas():void
{
	if(this.parentApplication.dg_ejecuciones_academicas.dataProvider.length > 0)
	{
		var i:int;
		var j:int;
		for (i = 0; i < parentApplication.dg_ejecuciones_academicas.dataProvider.length ;i++)
		{
			j=0;
			for (j = 0; j < rp_ejecuciones_academicas.dataProvider.length; j++)
			{
				if (parentApplication.dg_ejecuciones_academicas.dataProvider[i].campo_uno == rp_ejecuciones_academicas.dataProvider[j].campo_uno)
				{
					rp_ejecuciones_academicas.dataProvider.removeItemAt(j);
				}
			}
		}
	}
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}

//*******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}
