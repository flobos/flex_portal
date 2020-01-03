// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import flash.events.Event;


public var producto_establecido:Boolean = false;
[Bindable]
public var producto_modificable:Boolean = true;

public var pro_mal_idn:String;
public var porcentaje_pago_popup:String;
public var direccion_pago_popup:String;
public var forma_pago_popup:String;
public var medio_pago_popup:String;
public var tipo_pago_popup:String;
public var total_pagadores:int = 0;
private var mod_cam_idn:String;
public var tip_prod_idn:String;
public var eje_adm_idn:String;
public var titulo_carrera:String;
[Bindable]
public var alumnos_toma_curso:ArrayCollection;
[Bindable]
public var pagadores:ArrayCollection;
//*******************************************************************************************************
private function inicio():void
{	
//	this.rp_pagadores.enabled = true;
//	mod_cam_idn = '156';
	mod_cam_idn = this.parentApplication.mod_cam_idn;
//	ro_ingreso_inscripcion.muestra_carreras(mod_cam_idn);
	ro_ingreso_inscripcion.muestra_promociones(mod_cam_idn);
	ro_ingreso_inscripcion.muestra_tipo_carrera(mod_cam_idn);
	ro_ingreso_inscripcion.muestra_tipo_admision();
	ro_ingreso_inscripcion.muestra_jornada();
}
//*******************************************************************************************************
private function tipo_producto_change():void
{
	if (this.cmb_tipo_producto.selectedIndex >0)
	{
		quitar_carrera();
		this.cmb_carrera.dataProvider = null;
//		ro_ingreso_inscripcion.muestra_carreras_tipo(mod_cam_idn, this.cmb_tipo_producto.selectedItem.data);
		ro_ingreso_inscripcion.muestra_promociones_tipo(mod_cam_idn, this.cmb_tipo_producto.selectedItem.data);
	}
}
//******************************************************************************************************
private function popup_agrega_pagador():void
{
	if (this.lbl_valor_arancel.text !="")
	{
		var buscar:frm_registro_admision_ingreso_inscripcion_popup_tipo_pago = frm_registro_admision_ingreso_inscripcion_popup_tipo_pago(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_inscripcion_popup_tipo_pago , true));
		buscar.valor_arancel = int(this.lbl_valor_arancel.text);
		buscar.max_valor = max_valor();
		buscar.pagador_nombre = this.cmb_pagador_asociado.selectedItem.label;
		buscar.pagador_id = this.cmb_pagador_asociado.selectedItem.data;
		mx.managers.PopUpManager.centerPopUp(buscar);
	}
	else
	{
		mx.controls.Alert.show("Debe existir un Arancel a Pagar","Alerta");
	}
}
//******************************************************************************************************
public function max_valor():int
{
	var i:int = 0;
	var suma:int = 0;
	var maximo:int;
	if (this.rp_pagadores.dataProvider != null && this.rp_pagadores.dataProvider.length > 0)
	{
		for (i= 0 ; i < rp_pagadores.dataProvider.length > 0; i++)
		{
			suma = suma + int(lbl_total_pagar[i].text);
		}	
	}
	maximo =int(this.lbl_valor_arancel.text) - suma; 
	return maximo;
}
//******************************************************************************************************
public function verificar_pagos():void
{
	var i:int = 0;
	var suma:int = 0;
	if (this.rp_pagadores.dataProvider != null && this.rp_pagadores.dataProvider.length > 0)
	{
		for (i= 0 ; i < rp_pagadores.dataProvider.length > 0; i++)
		{
			suma = suma + int(lbl_total_pagar[i].text);
		}	
	}
	
	if (suma == int(this.lbl_valor_arancel.text))
	{
		this.txt_agregue_pagadores.visible = false;
		this.btn_agrega_pagador.enabled = false;
		this.btn_verificar_pagos.enabled = false;
		this.rp_pagadores.enabled = false;
		this.cmb_pagador_asociado.enabled = false;
		this.cnv_requisitos.enabled = true;
		this.tab_ingreso.selectedIndex = 2;
		this.ro_ingreso_inscripcion.muestra_requisitos(this.cmb_carrera.selectedItem.data);
		this.ro_ingreso_inscripcion.muestra_requisitos_asignados(this.cmb_alumno_asociado.selectedItem.data);
		this.ro_ingreso_inscripcion.muestra_requisitos_renovar(this.cmb_alumno_asociado.selectedItem.data);
		producto_modificable = false;
	}
	else
	{
		mx.controls.Alert.show("Debe asignar el total del Arancel a Pagar", "Alerta");
		this.txt_agregue_pagadores.visible = true;
		this.btn_agrega_pagador.enabled = true;
		this.btn_verificar_pagos.enabled = true;
	}
}
//******************************************************************************************************
public function verificar_requisitos():void
{
	var i:int = 0;
	var verif:int = 1;
	if (this.rp_requisitos.dataProvider != null && this.rp_requisitos.dataProvider.length > 0)
	{
		for (i= 0 ; i < rp_requisitos.dataProvider.length > 0; i++)
		{
			if (chk_id_requisito[i].selected == false && lbl_pri_idn_requisito[i].text == "102")
			{
				verif = 0;
			}
		}	
	}
	if (this.rp_requisitos_alumno.dataProvider != null && this.rp_requisitos_alumno.dataProvider.length > 0)
	{
		for (i= 0 ; i < rp_requisitos_alumno.dataProvider.length > 0; i++)
		{
			if (chk_id_requisito_alum[i].selected == false && lbl_pri_idn[i].text == "102")
			{
				verif = 0;
			}
		}	
	}
	
	if (verif == 1)
	{
		validar_requisito();
		this.tab_ingreso.selectedIndex = 3;
		this.rp_requisitos.enabled = false;
		this.rp_requisitos_alumno.enabled = false;
		this.rp_requisitos_renovar.enabled = false;
		this.cnv_mat_apoyo.enabled = true;
		ro_ingreso_inscripcion.muestra_material_apoyo(pro_mal_idn);
		
		if (this.rp_requisitos_alumno.dataProvider != null && this.rp_requisitos_alumno.dataProvider.length > 0)
		{
			for (i= 0 ; i < rp_requisitos_alumno.dataProvider.length > 0; i++)
			{
				chk_id_requisito_alum[i].enabled = false;
			}	
		}
		
		if (this.rp_requisitos.dataProvider != null && this.rp_requisitos.dataProvider.length > 0)
		{
			for (i= 0 ; i < rp_requisitos.dataProvider.length > 0; i++)
			{
				chk_id_requisito[i].enabled = false;
			}	
		}
		this.btn_verificar_requisitos.enabled = false;
	}
	else
	{
		mx.controls.Alert.show("Existen requisitos faltantes","Alerta");
	}
}
//******************************************************************************************************
private function validar_requisito():void{
	var i:int;
	
	if (this.rp_requisitos_alumno.dataProvider != null && this.rp_requisitos_alumno.dataProvider.length > 0)
	{
		for (i= 0 ; i < rp_requisitos_alumno.dataProvider.length > 0; i++)
		{
			if (chk_id_requisito_alum[i].selected == true)
			{
				ro_ingreso_inscripcion.validar_requisito(chk_id_requisito_alum[i].label);	
			}
		}	
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
//******************************************************************************************************

private function result_validar_requisito(event:ResultEvent):void {
	
} 
//*******************************************************************************************************
private function cmb_carrera_change():void
{
//	quitar_carrera();
	if (this.cmb_carrera.selectedIndex > 0)
	{
		ro_ingreso_inscripcion.muestra_mallas(mod_cam_idn, this.cmb_carrera.selectedItem.campo_uno, this.cmb_promociones.selectedItem.data);
	//	ro_ingreso_inscripcion.muestra_promociones(mod_cam_idn, this.cmb_carrera.selectedItem.data);
	}	
}

private function cmb_promociones_change():void
{
		quitar_carrera();
	if (this.cmb_promociones.selectedIndex > 0)
	{
	//	ro_ingreso_inscripcion.muestra_mallas(mod_cam_idn, this.cmb_carrera.selectedItem.data, this.cmb_promociones.selectedItem.campo_uno);
		ro_ingreso_inscripcion.muestra_carreras(mod_cam_idn, this.cmb_promociones.selectedItem.data);
		
		this.txt_sel_carrera.visible = true;
		this.txt_sel_promocion.visible = false;
	}
}

//*******************************************************************************************************
private function quitar_carrera():void
{
	this.dg_mallas.dataProvider = null;
	this.cmb_carrera.dataProvider = null;
}

//*******************************************************************************************************
private function btn_elimina_selec_click(evento:Event):void
{
	var item:Object=evento.currentTarget.getRepeaterItem();
	var obj:Object = rp_pagadores.dataProvider;
	var i:int;
	var x:int;
	for(i = 0; i < rp_pagadores.dataProvider.length; i++) 
	{
		if (item.campo_uno==obj[i].campo_uno && item.campo_cinco == obj[i].campo_cinco && item.campo_siete==obj[i].campo_siete && item.campo_nueve==obj[i].campo_nueve)
		{
			x= i;
		}
	}
	this.rp_pagadores.dataProvider.removeItemAt(x);
//	this.parentApplication.actualizar_resumen();
}

//***********************************************************************************************************

private function popup_agrega_material():void
{
	var buscar:frm_registro_admision_ingreso_inscripcion_popup_agrega_material = frm_registro_admision_ingreso_inscripcion_popup_agrega_material(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_inscripcion_popup_agrega_material , true));
	mx.managers.PopUpManager.centerPopUp(buscar)
}

//******************************************************************************************************
private function btn_quitar_material_click():void
{
	this.dg_material_apoyo.dataProvider.removeItemAt(dg_material_apoyo.selectedIndex);
}
//******************************************************************************************************
private function btn_buscar_malla_click():void
{
	if (lbl_buscar_pro_mal.text != "")
	{
		this.ro_ingreso_inscripcion.busca_promocion_malla(mod_cam_idn, this.lbl_buscar_pro_mal.text );	
	}
	else
	{
		mx.controls.Alert.show("Debe ingresar un código de malla","Alerta");
	}
}

//***********************************************************************************************************
private function result_busca_promocion_malla(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontró la promoción de la malla","Alerta");
	else
	{
		var o_dos_campos:obj_dos_campos = new obj_dos_campos;
		o_dos_campos.data = event.result[0].campo_uno;
		o_dos_campos.label = event.result[0].campo_dos;
		cmb_carrera.dataProvider = o_dos_campos;
		cmb_carrera.selectedIndex = 0;
		
		this.titulo_carrera = event.result[0].campo_dos;
		
		var o_cinco_campos:obj_cinco_campos = new obj_cinco_campos;
		o_cinco_campos.campo_uno = event.result[0].campo_tres;
		o_cinco_campos.campo_dos = event.result[0].campo_cuatro;
		o_cinco_campos.campo_tres = event.result[0].campo_cinco;
		o_cinco_campos.campo_cuatro = event.result[0].campo_seis;
		o_cinco_campos.campo_cinco = event.result[0].campo_siete;
		dg_mallas.dataProvider = o_cinco_campos;
		dg_mallas.selectedIndex = 0;
		
		var o_tres_campos:obj_tres_campos = new obj_tres_campos;
		o_tres_campos.campo_uno = '0';
		o_tres_campos.campo_dos = '-- Seleccione Promoción --';
		cmb_promociones.dataProvider = o_tres_campos;
		
		o_tres_campos = new obj_tres_campos;
		o_tres_campos.campo_uno = event.result[0].campo_ocho;
		o_tres_campos.campo_dos = event.result[0].campo_nueve;
		o_tres_campos.campo_tres = lbl_buscar_pro_mal.text;
		cmb_promociones.dataProvider.addItem(o_tres_campos);
		cmb_promociones.selectedIndex = 1;
		
	}
}
//***********************************************************************************************************
private function result_muestra_tipo_carrera(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontraron tipos de producto","Alerta");
	else
	{
		this.cmb_tipo_producto.dataProvider = event.result;
	}
}
//***********************************************************************************************************
private function result_muestra_jornada(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontraron tipos de jornada","Alerta");
	else
	{
		this.cmb_jornada.dataProvider = event.result;
	}
}
//***********************************************************************************************************
private function result_muestra_tipo_admision(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontraron tipos de admisión","Alerta");
	else
	{
		this.cmb_tipo_admision.dataProvider = event.result;
	}
}
//***********************************************************************************************************
private function result_muestra_mallas(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontraron mallas asociadas","Alerta");
	else
	{
		this.dg_mallas.dataProvider = event.result;
		this.txt_sel_malla.visible = true;
		this.txt_sel_carrera.visible = false;
	}
}
//***********************************************************************************************************
private function result_muestra_promociones(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontraron promociones asociadas","Alerta");
	else
	{
		this.cmb_promociones.dataProvider = event.result;
		
//		this.txt_sel_carrera.visible = true;
//		this.txt_sel_promocion.visible = false;
		
		
	}
}
//***********************************************************************************************************
private function result_muestra_promocion_malla(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontro la Promoción de la Malla","Alerta");
	else
	{
		pro_mal_idn = event.result[0].campo_uno;	
		this.cmb_alumno_asociado.enabled = false;
		this.tip_prod_idn = this.dg_mallas.selectedItem.campo_seis;
		this.eje_adm_idn = this.dg_mallas.selectedItem.campo_siete;
		this.dg_mallas.enabled = false;
		this.cmb_promociones.enabled = false;
		this.cmb_jornada.enabled = false;
		this.cmb_carrera.enabled = false;
		this.btn_establecer_producto.enabled = false;
		this.cnv_pagos_matriculas.enabled = true;
		this.tab_ingreso.selectedIndex = 1;
		this.txt_sel_promocion.visible = false;
		this.parentApplication.cambiar_titulo_producto(this.dg_mallas.selectedItem.campo_dos);
		this.titulo_carrera = this.dg_mallas.selectedItem.campo_dos;
		this.cmb_tipo_producto.enabled = false;
		this.lbl_fecha_inicio_clases.enabled = false;
		this.lbl_buscar_pro_mal.enabled = false;
		this.btn_buscar_malla.enabled = false;
		this.txt_sel_fecha.visible = false;
	}
}
//***********************************************************************************************************
private function dg_mallas_click():void
{
	if (this.dg_mallas.selectedItem != null){
		this.txt_sel_malla.visible = false;
		this.txt_sel_fecha.visible = true;
	}
}
//***********************************************************************************************************
private function btn_establecer_seleccion():void
{
	if (this.cmb_promociones.dataProvider != null && this.cmb_jornada.selectedIndex > 0 && this.dg_mallas.selectedItem != null && this.cmb_promociones.selectedIndex > 0 && this.lbl_fecha_inicio_clases.text != "")
	{
		establecer_producto();
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar una carrera, malla, promoción, fecha de inicio de clases y tipo de jornada","Alerta");
	}
	
}
//***********************************************************************************************************
private function establecer_producto():void
{
	ro_ingreso_inscripcion.muestra_promocion_malla(mod_cam_idn, this.cmb_carrera.selectedItem.campo_uno, this.dg_mallas.selectedItem.campo_cinco, this.cmb_promociones.selectedItem.data);
}
private function confirmar_producto():void
{
	this.total_pagadores = this.rp_pagadores.dataProvider.length;
	this.btn_agregar_material.enabled = false;
	this.btn_quitar_material.enabled = false;
	this.btn_confirmar_producto.enabled = false;
	this.producto_establecido = true;
	this.producto_modificable = false;
	this.tab_ingreso.selectedIndex = 0;
}
//***********************************************************************************************************
private function cargar_arancel():void
{
	if (this.tab_ingreso.selectedIndex == 1 && this.cnv_requisitos.enabled == false && this.cmb_carrera.enabled ==false && this.lbl_valor_arancel.text == "")
	{
		ro_ingreso_inscripcion.muestra_aranceles_malla(this.pro_mal_idn);
	}
}
//***********************************************************************************************************
private function result_muestra_aranceles_malla(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontraron aranceles","Alerta");
	else
	{
		
		var arreglo:ArrayCollection = new ArrayCollection;
		var i:int;
		var o_tres_campos:obj_tres_campos;
		
		for (i = 0; i < event.result.length; i++){
			o_tres_campos = new obj_tres_campos;
			
			o_tres_campos.campo_uno = event.result[i].campo_uno;
			o_tres_campos.campo_dos = event.result[i].campo_dos;
			o_tres_campos.campo_tres = event.result[i].campo_tres;
			arreglo.addItem(o_tres_campos)
		}
		
		
		var popup:frm_registro_admision_ingreso_inscripcion_popup_arancel = frm_registro_admision_ingreso_inscripcion_popup_arancel(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_inscripcion_popup_arancel , true));
		popup.aranceles = arreglo;
		mx.managers.PopUpManager.centerPopUp(popup);
		
	}
}
//***********************************************************************************************************
private function result_muestra_carreras(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontraron carreras","Alerta");
	else
	{
		this.cmb_carrera.dataProvider = event.result;
	}
}
//******************************************************************************************************



//***********************************************************************************************************
private function result_muestra_arancel(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No existen Arancel asociado a esta Malla","Alerta");
	else
	{
		this.lbl_valor_arancel.text = event.result[0].campo_uno;
		this.parentApplication.actualizar_resumen();
	}
}
//***********************************************************************************************************
private function result_muestra_requisitos(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No existen Requisitos asociados a esta Malla","Alerta");
	else
	{
		this.rp_requisitos.dataProvider = event.result;
		
	}
	this.tab_ingreso.selectedIndex = 2;

}
//***********************************************************************************************************
private function result_muestra_requisitos_asignados(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No existen Requisitos asociados a esta persona","Alerta");
	else
	{
		this.rp_requisitos_alumno.dataProvider = event.result;
		
	}
	this.tab_ingreso.selectedIndex = 2;
	
}
//***********************************************************************************************************
private function result_muestra_requisitos_renovar(event:ResultEvent):void
{
	if (event.result.length <1 )
	{}
	else
	{
		this.rp_requisitos_renovar.dataProvider = event.result;
		
	}
	this.tab_ingreso.selectedIndex = 2;
	
}
//***********************************************************************************************************
private function result_muestra_material_apoyo(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("No existe Material de Apoyo para este Material","Alerta");
	else
	{
		this.dg_material_apoyo.dataProvider = event.result;
		
	}
}
//***********************************************************************************************************
private function btn_editar_malla_click():void
{
}
//******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}

//***********************************************************************************************************
private function fecha_string(fec_ano:String, fec_mes:String, fec_dia:String, fec_dia_semana:String):String
{
	var fecha:String;
	switch(fec_dia_semana){
		case '1' :
			fecha = "Lunes ";
			break;
		case '2' :
			fecha = "Martes ";
			break;
		case '3' :
			fecha = "Miércoles ";
			break;
		case '4' :
			fecha = "Jueves ";
			break;
		case '5' :
			fecha = "Viernes ";
			break;
		case '6' :
			fecha = "Sábado ";
			break;
		case '7' :
			fecha = "Domingo ";
			break;
	}
	if (fecha == null)
	{
		fecha = "";
	}
	fecha = fecha + fec_dia
	
	switch(fec_mes){
		case '0' :
			fecha = fecha + " de Enero de " + fec_ano;
			break;
		case '1' :
			fecha = fecha + " de Febrero de " + fec_ano;
			break;
		case '2' :
			fecha = fecha + " de Marzo de " + fec_ano;
			break;
		case '3' :
			fecha = fecha + " de Abril de " + fec_ano;
			break;
		case '4' :
			fecha = fecha + " de Mayo de " + fec_ano;
			break;
		case '5' :
			fecha = fecha + " de Junio de " + fec_ano;
			break;
		case '6' :
			fecha = fecha + " de Julio de " + fec_ano;
			break;
		case '7' :
			fecha = fecha + " de Agosto de " + fec_ano;
			break;
		case '8' :
			fecha = fecha + " de Septiembre de " + fec_ano;
			break;
		case '9' :
			fecha = fecha + " de Octubre de " + fec_ano;
			break;
		case '10' :
			fecha = fecha + " de Noviembre de " + fec_ano;
			break;		
		case '11' :
			fecha = fecha + " de Diciembre de " + fec_ano;
			break;
	}
	
	return fecha;
}