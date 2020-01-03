// ActionScript file
import flash.events.KeyboardEvent;
import flash.net.URLRequest;
import flash.xml.XMLDocument;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.*;
import mx.graphics.ImageSnapshot;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import mx.utils.URLUtil;

private var num_cuotas:String;
private var abono:int;
private var total_asignado:Boolean = false;
private var monto_asignado:int = 0;
private var pro_mal_idn:String;
private var func_mod_fun_idn:String;
private var fun_rut:String;
private var num_boleta:String;
private var deuda_total:String;
private var pago_mes:String;
public var pago:frm_registro_admision_pagos_ingresar_pago;

//***********************************************************************************************************
private function inicio():void
{
	func_mod_fun_idn = Application.application.parameters.func_mod_fun_idn;
	fun_rut = Application.application.parameters.par_rut;

	//	this.func_mod_fun_idn = "46098" //temporal
	this.pro_mal_idn = "9988";//temporal
	
	lbl_rut.setFocus();
	this.ro_pagos.busca_medio_pago();

}



//***********************************************************************************************************
private function ver_desglose():void
{
	if (this.dg_operaciones.selectedItem != null)
	{
		var glosa:frm_registro_admision_pagos_desglose = frm_registro_admision_pagos_desglose(PopUpManager.createPopUp( this, frm_registro_admision_pagos_desglose , true));
		glosa.det_ope_idn = this.dg_operaciones.selectedItem.campo_uno;
		mx.managers.PopUpManager.centerPopUp(glosa);
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar una operación","Alerta");
	}
}

//***********************************************************************************************************
private function ingresar_pago():void
{
	if (this.dg_operaciones.dataProvider.length > 0)
	{
		
		var cargos_no_cuotas:int = 0;
		var i:int = 0;
		for (i= 0; i < this.dg_operaciones.dataProvider.length; i++)
		{
			if (this.dg_operaciones.dataProvider[i].campo_seis != '0' && this.dg_operaciones.dataProvider[i].campo_seis != '4')
			{
				cargos_no_cuotas = cargos_no_cuotas + int(this.dg_operaciones.dataProvider[i].campo_cuatro);
			}
		}
		
		
		pago = frm_registro_admision_pagos_ingresar_pago(PopUpManager.createPopUp( this, frm_registro_admision_pagos_ingresar_pago , true));
		pago.pago_mes = this.pago_mes;
		pago.nombre_item = this.dg_deudas.selectedItem.campo_dos;
		pago.deuda_total = this.deuda_total;
		pago.num_cuotas = this.num_cuotas;
		pago.total_abonos = String(int(this.lbl_total_abonos.text) - cargos_no_cuotas);
		pago.total_cobros = String(int(this.lbl_total_cobros.text) - cargos_no_cuotas); 
		pago.func_mod_fun_idn = this.func_mod_fun_idn;
		pago.fun_rut = this.fun_rut;
		pago.deu_idn = this.dg_deudas.selectedItem.campo_uno;
		mx.managers.PopUpManager.centerPopUp(pago);
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar una deuda","Alerta");
	}
}
//***********************************************************************************************************
public function limpiar_pantalla():void
{
	this.lbl_rut.editable = true;
	this.lbl_rut.setFocus();
	this.lbl_rut.text = "";
	this.rb_alumno.selected = true;
	this.btn_buscar.enabled = true;
	this.dg_deudas.dataProvider = null;
	this.dg_deudas.enabled = true;
	this.btn_seleccionar.enabled = true;
	this.dg_operaciones.dataProvider = null;
	this.dg_operaciones.enabled = true;
	this.lbl_total_abonos.text = "";
	this.lbl_total_cobros.text = "";
	
	num_cuotas = "";
	abono = 0;
	total_asignado = false;
	monto_asignado = 0;
	pro_mal_idn = "";
	num_boleta = "";
	
	
	
}

//***********************************************************************************************************

private function valida_rut(rut_temp:String):void{
	var dt:Number
	var dt2:String
	var resto:Number
	var i:Number
	var suma:Number
	var j:Number
	var is_ok:Number
	var us_rut:String 
	var largo:Number
	
	us_rut = rut_temp
	
	is_ok = 0
	
	if (lbl_rut.length == 12)
	{
		j = 2
		suma = 0
		largo = us_rut.length
		i = us_rut.length - 2
		
		
		while(i>0)
		{
			if (us_rut.substr(i-1, 1) != '.')
			{
				if (j > 7)
				{
					j = 2
				}
				suma = suma + Number(us_rut.substr(i-1, 1)) * j
				j = j + 1
			}
			
			i--
		}
		
		//mx.controls.Alert.show('Es suma ' + suma.toString() + '')
		
		resto = suma % 11
		dt = 11 - resto
		dt2 = dt.toString()
		
		//mx.controls.Alert.show('Es dt2 ' + dt2 + '')
		
		if (dt2 == '10')
		{
			if (us_rut.substr(largo-1, 1) == 'K')
			{
				is_ok = 1
				//mx.controls.Alert.show('Es K')
			}
		}
		
		if (dt2 == '11')
		{
			if (us_rut.substr(largo - 1, 1) == '0')
			{
				is_ok = 1
				//mx.controls.Alert.show('Es 0')
			}
		}
		
		if (dt2.substr(0, 1) == us_rut.substr(largo - 1, 1))
		{
			is_ok = 1
			//mx.controls.Alert.show('dt2 sub ' + dt2.substr(0, 1) + ' y pase poe aqui')
		}
	}
	
	if (is_ok == 0)
	{
		mx.controls.Alert.show('El R.U.T. ingresado no es valido.', 'Ingreso')
		focusManager.setFocus(lbl_rut);
	}
	
	if (is_ok == 1)
	{
		if (this.rb_alumno.selected)
		{
			ro_pagos.busca_deudas_por_alumno(this.lbl_rut.text);
		}
		else
		{
			ro_pagos.busca_deudas(this.lbl_rut.text);	
		}
		
	}
	
}


//***********************************************************************************************************
private function puntos():void {
	var rut_temp:String;
	
	if (lbl_rut.length == 2) {
		lbl_rut.text = lbl_rut.text + '.'
		rut_temp = lbl_rut.text + '.'
		focusManager.setFocus(lbl_rut);
		lbl_rut.setSelection(lbl_rut.length,lbl_rut.length);
	}
	if (lbl_rut.length == 6) {
		lbl_rut.text = lbl_rut.text + '.'
		rut_temp = lbl_rut.text + '.'
		focusManager.setFocus(lbl_rut);
		lbl_rut.setSelection(lbl_rut.length,lbl_rut.length);
	}
	if (lbl_rut.length == 10) {
		lbl_rut.text = lbl_rut.text + '-'
		rut_temp = lbl_rut.text + '.'
		focusManager.setFocus(lbl_rut);
		lbl_rut.setSelection(lbl_rut.length,lbl_rut.length);
	}
}

//***********************************************************************************************************
private function lbl_rut_presskey(event:KeyboardEvent):void{
	
	var rut_temp:String = lbl_rut.text
	rut_temp = rut_temp.toUpperCase()
	
	if (event.charCode==13){
		valida_rut(rut_temp);
	}else{
		if (event.charCode >= 48 && event.charCode <= 57){
			puntos()
		}else{
			Keyboard.BACKSPACE
		}
	}
}

private function seleccionar_deuda():void
{
	if (this.dg_deudas.selectedItem != null)
	{
		this.dg_deudas.enabled = false;
		this.ro_pagos.busca_operaciones(this.dg_deudas.selectedItem.campo_uno);
		this.ro_pagos.busca_totales(this.dg_deudas.selectedItem.campo_uno);
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar una deuda","Alerta");
	}
	
}

//***********************************************************************************************************
private function result_busca_deudas(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No se encontraron deudas activas para el RUT indicado", "Información");
	}
	else
	{
		this.dg_deudas.dataProvider = event.result;
		this.dg_operaciones.dataProvider = null;
	}
}
//***********************************************************************************************************
private function result_busca_operaciones(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No se encontraron operaciones para la deuda seleccionada", "Información");
	}
	else
	{
		this.dg_operaciones.dataProvider = event.result;
	}
}
//***********************************************************************************************************
private function result_busca_totales(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No se encontraron totales para la deuda seleccionada", "Información");
	}
	else
	{
		this.lbl_total_cobros.text = event.result[0].campo_uno;
		this.lbl_total_abonos.text = event.result[0].campo_dos;
		this.deuda_total = event.result[0].campo_tres;
		this.ro_pagos.busca_deuda_mes(this.dg_deudas.selectedItem.campo_uno);
	}
}
//***********************************************************************************************************
private function result_busca_deuda_mes(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No se encontro la deuda mensual para la deuda seleccionada", "Información");
	}
	else
	{
		var deuda_mes:String;
		deuda_mes = event.result[0].data;
		this.num_cuotas = event.result[0].label;
		pago_mes = String(int(deuda_mes) - int(this.lbl_total_abonos.text));
		
		if (int(pago_mes) < 0)
			pago_mes = "0";
		
		
		this.btn_seleccionar.enabled = false;
		this.lbl_rut.editable = false;
		this.btn_buscar.enabled = false;
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