// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

[Bindable]
private var valor_arancel:String;
[Bindable]
private var arreglo_pagadores:ArrayCollection;

public var titulo_carrera:String;
public var insc_idn:String;
public var pro_mal_idn:String;
public var tip_prod_idn:String;
public var eje_adm_idn:String;
public var ent_reg_idn:String;
public var ent_nombre:String;
public var fecha_inicio_clases:String;
public var indice:int;

//*******************************************************************************************************
private function inicio():void
{
	buscar_malla();
}
//******************************************************************************************************
private function buscar_malla():void
{
	this.ro_ver_inscripcion.busca_promocion_malla(pro_mal_idn);	
	this.ro_ver_inscripcion.busca_parametro_jornada(insc_idn, ent_reg_idn, pro_mal_idn);
}
//******************************************************************************************************
private function buscar_pagadores():void
{
	this.ro_ver_inscripcion.busca_pagadores(pro_mal_idn, insc_idn);	
}
//***********************************************************************************************************
private function result_busca_parametro_jornada(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
	
	}
	else
	{
		this.cmb_tipo_jornada.dataProvider = event.result;	
	}
}
//***********************************************************************************************************
private function result_busca_pagadores(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontraron pagadores","Alerta");
	else
	{
		var arreglo:ArrayCollection = new ArrayCollection;
		var i:int;
		var o_nueve_campos:obj_nueve_campos;
		
		for (i = 0; i < event.result.length; i++){
			o_nueve_campos = new obj_nueve_campos;
			
			o_nueve_campos.campo_uno = event.result[i].campo_uno;
			o_nueve_campos.campo_dos = event.result[i].campo_dos;
			o_nueve_campos.campo_tres = event.result[i].campo_tres;
			o_nueve_campos.campo_cuatro = event.result[i].campo_cuatro;
			o_nueve_campos.campo_cinco = event.result[i].campo_cinco;
			o_nueve_campos.campo_seis = event.result[i].campo_seis;
			o_nueve_campos.campo_siete = event.result[i].campo_siete;
			o_nueve_campos.campo_ocho = event.result[i].campo_ocho;
			o_nueve_campos.campo_nueve = event.result[i].campo_nueve;
			arreglo.addItem(o_nueve_campos)
		}
		
		
		this.tab_ingreso.selectedIndex = 1;
		valor_arancel = arreglo[0].campo_nueve;
		arreglo_pagadores = arreglo;
	//	this.tab_ingreso.selectedIndex = 0;
	//	mx.controls.Alert.show(event.result[0].campo_nueve);
	//	this.rp_pagadores.dataProvider = arreglo;
	}
}
//***********************************************************************************************************
private function result_busca_promocion_malla(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontró la promoción de la malla","Alerta");
	else
	{
		this.lbl_fecha_inicio_clases.text = fecha_inicio_clases;
		
		var o_dos_campos:obj_dos_campos = new obj_dos_campos;
		o_dos_campos.data = event.result[0].campo_uno;
		o_dos_campos.label = event.result[0].campo_dos;
		cmb_carrera.dataProvider = o_dos_campos;
		cmb_carrera.selectedIndex = 0;
		
		var o_cinco_campos:obj_cinco_campos = new obj_cinco_campos;
		o_cinco_campos.campo_uno = event.result[0].campo_tres;
		o_cinco_campos.campo_dos = event.result[0].campo_cuatro;
		o_cinco_campos.campo_tres = event.result[0].campo_cinco;
		o_cinco_campos.campo_cuatro = event.result[0].campo_seis;
		o_cinco_campos.campo_cinco = event.result[0].campo_doce;
		dg_mallas.dataProvider = o_cinco_campos;
		dg_mallas.selectedIndex = 0;
		
		this.titulo_carrera = event.result[0].campo_dos;
		
		this.parentApplication.cambiar_titulo_producto(event.result[0].campo_dos, this.indice);
		
		o_dos_campos = new obj_dos_campos;
		o_dos_campos.data = event.result[0].campo_diez;
		o_dos_campos.label = event.result[0].campo_seis;
		this.cmb_tipo_producto.dataProvider.addItem(o_dos_campos);
		
		o_dos_campos = new obj_dos_campos;
		o_dos_campos.data = ent_reg_idn;
		o_dos_campos.label = ent_nombre;
		this.cmb_alumno_asociado.dataProvider.addItem(o_dos_campos);
		
		this.tip_prod_idn = event.result[0].campo_diez;
		this.eje_adm_idn = event.result[0].campo_once;
		
		var o_tres_campos:obj_tres_campos = new obj_tres_campos;
		o_tres_campos.campo_uno = event.result[0].campo_ocho;
		o_tres_campos.campo_dos = event.result[0].campo_nueve;
		o_tres_campos.campo_tres = pro_mal_idn;
		cmb_promociones.dataProvider.addItem(o_tres_campos);
		cmb_promociones.selectedIndex = 1;
		buscar_pagadores();

	}
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

//***********************************************************************************************************
private function establecer_producto():void
{
///	ro_ingreso_inscripcion.muestra_promocion_malla(mod_cam_idn, this.cmb_carrera.selectedItem.data, this.dg_mallas.selectedItem.campo_cinco, this.cmb_promociones.selectedItem.campo_uno);
}
//******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}

