// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

public var func_mod_fun_idn:String;
public var eje_idn:String;
private var conf_idn:String;
//*******************************************************************************************************
private function inicio():void
{
	limpiar_pantalla();
	
	var par_func_mod_fun_idn:String = Application.application.parameters.par_func_mod_fun_idn;
	ro_desencripta.desencriptar_func_mod_fun_idn("Iplacex", par_func_mod_fun_idn);
	
	ro_ingreso_conferencia.muestra_tipo_conferencia();

}
//******************************************************************************************************
private function popup_agregar_ejecucion_academica():void
{
	var popup:frm_conferencias_ingreso_conferencia_popup_agrega_ejecucion = frm_conferencias_ingreso_conferencia_popup_agrega_ejecucion(PopUpManager.createPopUp( this, frm_conferencias_ingreso_conferencia_popup_agrega_ejecucion , true));
	mx.managers.PopUpManager.centerPopUp(popup);
	
}
//******************************************************************************************************
private function popup_agregar_funcionario():void
{
	var popup:frm_conferencias_ingreso_conferencia_popup_agrega_funcionario = frm_conferencias_ingreso_conferencia_popup_agrega_funcionario(PopUpManager.createPopUp( this, frm_conferencias_ingreso_conferencia_popup_agrega_funcionario , true));
	mx.managers.PopUpManager.centerPopUp(popup);
	
}
//*****************************************************
private function result_desencriptar_func_mod_fun_idn(event:ResultEvent):void{
	var arreglo1:Object;
	
	arreglo1 = event.result; 
	func_mod_fun_idn=arreglo1[0].campo_uno
}
//***********************************************************************************************************
private function btn_guardar_click():void
{
	if (this.lbl_nombre_conferencia.text != "")
	{
		if (this.cmb_tipo_conferencia.selectedIndex > 0)
		{
			if (this.lbl_fecha_inicio.text != "")
			{
				if (this.ns_duracion.value > 0)
				{
					if (this.txt_fun_codigo.text != "")
					{
						if (this.dg_ejecuciones_academicas.dataProvider.length > 0)
						{
							ro_ingreso_conferencia.agrega_conferencia(lbl_nombre_conferencia.text,
																		cmb_tipo_conferencia.selectedIndex.toString(),
																		ns_max_integrantes.value.toString(),
																		prepara_fecha(),
																		ns_duracion.value.toString());
							
						}
						else
						{
							mx.controls.Alert.show("Debe agregar Ejecuciones Académicas","Alerta");
						}
					}
					else
					{
						mx.controls.Alert.show("Debe agregar un Encargado de la Conferencia","Alerta");
					}
				}
				else
				{
					mx.controls.Alert.show("Debe indicar la duración de la Conferencia","Alerta");
				}
			}
			else
			{
				mx.controls.Alert.show("Debe indicar una fecha de inicio de la Conferencia","Alerta");
			}
		}
		else
		{
			mx.controls.Alert.show("Debe seleccionar un tipo de Conferencia","Alerta");
		}
	}
	else
	{
		mx.controls.Alert.show("Debe indicar un Título para la Conferencia","Alerta");
	}
}
//***********************************************************************************************************
private function prepara_fecha():String
{
	var fecha_inicio:String;
	var hora_inicio:String;
	var min_inicio:String;
	
	if (this.ns_hora_inicio.value < 10)
	{
		hora_inicio = '0'+this.ns_hora_inicio.value.toString();
	}
	else
	{
		hora_inicio = this.ns_hora_inicio.value.toString();
	}
	if (this.ns_min_inicio.value < 10)
	{
		min_inicio = '0'+this.ns_min_inicio.value.toString();
	}
	else
	{
		min_inicio = this.ns_min_inicio.value.toString();
	}
	
	fecha_inicio = this.lbl_fecha_inicio.text + ' ' + hora_inicio + ':'+min_inicio + ':00';
	
	return fecha_inicio;
}
//***********************************************************************************************************
private function cmb_ejecuciones_change():void
{
	if (this.cmb_ejecuciones.selectedIndex > 0)
	{
		eje_idn = cmb_ejecuciones.selectedItem.data;
		this.btn_agrega_eje_academica.enabled = true;
		
	}
	else
	{
		eje_idn = "";
		this.btn_agrega_eje_academica.enabled = false;
	}
	var arreglo_eje_aca:ArrayCollection = new ArrayCollection;
	this.dg_ejecuciones_academicas.dataProvider = arreglo_eje_aca;
}

//***********************************************************************************************************
private function result_agrega_conferencia(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("Ha ocurrido un error al ingresar la conferencia","ERROR");
	}
	else
	{
		conf_idn = event.result[0].campo_uno;
		ro_ingreso_conferencia.guarda_conferencia_funcionarios(this.txt_fun_codigo.text, conf_idn);
	}
}
//***********************************************************************************************************
private function result_guarda_conferencia_funcionarios(event:ResultEvent):void
{
	ro_ingreso_conferencia.guarda_conferencia_ejecuciones(this.dg_ejecuciones_academicas.dataProvider, conf_idn);
}

//***********************************************************************************************************
private function result_guarda_conferencia_ejecuciones(event:ResultEvent):void
{
	mx.controls.Alert.show("Conferencia guardada exitosamente","Alerta");
	limpiar_pantalla();
}
//***********************************************************************************************************
private function btn_quitar_eje_click():void
{
	dg_ejecuciones_academicas.dataProvider.removeItemAt(dg_ejecuciones_academicas.selectedIndex);
}


//***********************************************************************************************************
private function btn_quitar_fun_click():void
{
	this.txt_fun_codigo.text = "";
	this.txt_fun_funcion.text = "";
	this.txt_fun_nombre.text = "";
	this.txt_fun_rut.text = "";
	this.btn_agrega_funcionario.enabled = true;
	this.btn_quitar_funcionario.enabled = false;
	this.cmb_ejecuciones.dataProvider = null;
	this.cmb_ejecuciones.enabled = false;
	this.chk_eje_tutor.enabled = false;
	this.dg_ejecuciones_academicas.dataProvider = null;
	this.chk_eje_tutor.selected = false;
}
//***********************************************************************************************************
private function result_muestra_tipo_conferencia(event:ResultEvent):void
{
	cmb_tipo_conferencia.dataProvider = event.result;
}
//***********************************************************************************************************
private function result_muestra_ejecuciones(event:ResultEvent):void
{
	this.cmb_ejecuciones.dataProvider = event.result;
}
//***********************************************************************************************************
private function result_muestra_ejecuciones_tutor(event:ResultEvent):void
{
	this.cmb_ejecuciones.dataProvider = event.result;
	this.cmb_ejecuciones.enabled = true;
	this.chk_eje_tutor.enabled = true;
}
//***********************************************************************************************************
private function chk_eje_tutor_change():void
{
	if (this.txt_fun_codigo.text != "")
	{
		if (this.chk_eje_tutor.selected == false)
		{
			this.ro_ingreso_conferencia.muestra_ejecuciones_tutor(this.txt_fun_codigo.text);
		}
		else
		{
			this.ro_ingreso_conferencia.muestra_ejecuciones();
		}
	}
	
}


//******************************************************************************************************
private function limpiar_pantalla():void
{
	var arreglo_eje_aca:ArrayCollection = new ArrayCollection;
	var arreglo_func:ArrayCollection = new ArrayCollection;
	this.dg_ejecuciones_academicas.dataProvider = arreglo_eje_aca;
	this.txt_fun_codigo.text = "";
	this.txt_fun_funcion.text = "";
	this.txt_fun_nombre.text = "";
	this.txt_fun_rut.text = "";
	this.btn_agrega_eje_academica.enabled = false;
	this.lbl_nombre_conferencia.text = "";
	this.cmb_ejecuciones.dataProvider = null;
	this.cmb_ejecuciones.enabled = false;
	this.chk_eje_tutor.selected = false;
	this.chk_eje_tutor.enabled = false;
	this.cmb_tipo_conferencia.selectedIndex = 0;
	this.lbl_fecha_inicio.text = "";
	this.ns_hora_inicio.value = 0;
	this.ns_min_inicio.value = 0;
	this.ns_max_integrantes.value = 0;
	this.ns_min_inicio.value = 0;
	this.ns_duracion.value = 60;
//	ro_ingreso_conferencia.muestra_ejecuciones();
}

//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}

//******************************************************************************************************

private function formatea_fecha(date:Date):String {
	return dfconv.format(date);
} 