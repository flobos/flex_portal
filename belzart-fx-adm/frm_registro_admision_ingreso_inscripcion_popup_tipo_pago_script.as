// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

public var valor_arancel:int;
public var max_valor:int;
public var pagadores:ArrayCollection = new ArrayCollection;
public var pagador_nombre:String;
public var pagador_id:String;
//******************************************************************************************************
private function inicio():void
{
	propuesta_fecha_inicio_pago();	
	txt_max.text = txt_max.text + String(max_valor);
	ro_ingreso_inscripcion.muestra_financiamiento();
	ro_ingreso_inscripcion.muestra_medio_cobro();
}
//******************************************************************************************************
private function propuesta_fecha_inicio_pago():void
{
	var current:Date = new Date();
	var dia:String;
	var mes:String;
	var año:String;
	dia = (this.ns_dia_vencimiento.value).toString();
	mes = (current.getMonth() + 2).toString();
	año = current.getFullYear().toString();
	
	
	if (mes == "13")
	{
		mes = "1";
		año = (current.getFullYear() + 1).toString();
	}
	
	
	if (int(dia) < 10)
	{
		dia = "0" + dia;
	}
	
	if (int(mes) < 9)
	{
		mes = "0" + mes;
	}
	
	
	
	
	var strFecha:String;
	strFecha = dia + "-" + mes + "-" +año
	this.lbl_fecha_inicio_pago.text = strFecha;
}
//******************************************************************************************************
private function result_muestra_financiamiento(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("Error en Base de Datos. No existe Medio de Financiamiento","Alerta");
	else
	{
		this.cmb_financiamiento.dataProvider = event.result;
	}
}
//******************************************************************************************************
private function result_muestra_medio_cobro(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("Error en Base de Datos. No existe Medio de Cobro","Alerta");
	else
	{
		this.cmb_medio_cobro.dataProvider = event.result;
	}
}

//******************************************************************************************************
private function cambio_valor_a_pagar():void
{
	if(this.lbl_valor_a_pagar.text != "")
	{
		txt_valor_cuota.text = (int(lbl_valor_a_pagar.text)/int(this.ns_num_cuotas.value)).toString();
		lbl_porcentaje_a_pagar.text = ((int(lbl_valor_a_pagar.text)*100/int(valor_arancel))).toString();
	}
	else
	{
		this.lbl_porcentaje_a_pagar.text = "";
	}
}

//******************************************************************************************************
private function cambio_cuotas():void
{
	if (this.lbl_valor_a_pagar.text != "")
	{
		txt_valor_cuota.text = (int(lbl_valor_a_pagar.text)/int(this.ns_num_cuotas.value)).toString();
	}
}



//******************************************************************************************************
private function cambio_porcentaje():void
{
	if (this.lbl_porcentaje_a_pagar.text != "")
	{
		if (int(lbl_porcentaje_a_pagar.text) > 100)
		{
			mx.controls.Alert.show("El porcentaje no puede ser mayor a 100", "Alerta");
			lbl_porcentaje_a_pagar.text = "0";
			lbl_valor_a_pagar.text = "0";
			txt_valor_cuota.text = "0";
		}
		else
		{
				lbl_valor_a_pagar.text = ((int(valor_arancel)*int(lbl_porcentaje_a_pagar.text))/100).toString();
				txt_valor_cuota.text = (int(lbl_valor_a_pagar.text)/int(this.ns_num_cuotas.value)).toString();
		}
	}
	else
	{
		this.lbl_porcentaje_a_pagar.text = "0";
		cambio_porcentaje();
	}
	
}
//******************************************************************************************************
private function dia_vencimiento_change():void
{
	propuesta_fecha_inicio_pago();
}
//******************************************************************************************************
private function btn_aceptar_click():void
{
	if (this.lbl_valor_a_pagar.text != "" && int(lbl_valor_a_pagar.text) <= max_valor)
	{
		if (ns_num_cuotas.value.toString() != "" && lbl_fecha_inicio_pago.text != "" && ns_dia_vencimiento.value.toString() != "")
		{
			if (this.cmb_financiamiento.selectedIndex > 0){
				if (this.cmb_medio_cobro.selectedIndex > 0){
					var arreglo:ArrayCollection = new ArrayCollection;
					var o_once_campos:obj_once_campos = new obj_once_campos;
					var malla_seleccionada:int = new int;
					var i:int;
					var formulario:Array;
					formulario = this.parentApplication.tn_productos.getChildren();
					malla_seleccionada = this.parentApplication.tn_productos.selectedIndex;
					
						
						
					o_once_campos.campo_uno = pagador_id;
					o_once_campos.campo_dos = pagador_nombre;
					o_once_campos.campo_tres = this.lbl_porcentaje_a_pagar.text;
					o_once_campos.campo_cuatro = this.lbl_valor_a_pagar.text; 
					o_once_campos.campo_cinco = this.cmb_financiamiento.selectedItem.data;
					o_once_campos.campo_seis = this.cmb_financiamiento.selectedLabel;
					o_once_campos.campo_siete = this.cmb_medio_cobro.selectedItem.data;
					o_once_campos.campo_ocho = this.cmb_medio_cobro.selectedLabel;
					o_once_campos.campo_nueve = this.ns_num_cuotas.value.toString();
					o_once_campos.campo_diez = this.lbl_fecha_inicio_pago.text;
					o_once_campos.campo_once = this.ns_dia_vencimiento.value.toString();
					
						
						if (formulario[malla_seleccionada].rp_pagadores.dataProvider != null) {
							arreglo = formulario[malla_seleccionada].rp_pagadores.dataProvider;
						}
						
						arreglo.addItem(o_once_campos);
						formulario[malla_seleccionada].rp_pagadores.dataProvider = arreglo;
				//		this.parentApplication.actualizar_resumen();
						
						PopUpManager.removePopUp(this);	
				}	
				else
				{
					mx.controls.Alert.show("Debe seleccionar un Medio de Cobro","Alerta");
				}
			}
			else
			{
				mx.controls.Alert.show("Debe seleccionar un Financiamiento","Alerta");
			}
		}
		else
		{
			mx.controls.Alert.show("Debe indicar el N° de cuotas, fecha de inicio de pago y dia de vencimiento","Alerta");
		}
		
	}
	else
	{
		mx.controls.Alert.show("Debe indicar un valor o un porcentaje de Arancel a pagar válido","Alerta");
	}
	
}

//******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
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