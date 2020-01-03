// ActionScript file

import libreria.*;

import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import flash.events.KeyboardEvent;

public var monto:String;
//***********************************************************************************************************
private function inicio():void
{
	this.lbl_monto.text = this.lbl_monto.text + ' ' + monto;
	this.ro_pagos_sedes.orden_pago_muestra_banco();
}


//***********************************************************************************************************
private function agregar_detalle():void
{
	if (this.cmb_bancos.selectedIndex > 0)
	{
		if (this.lbl_serie.text == "")
		{
			mx.controls.Alert.show("Debe ingresar un numero de serie","Alerta");
		}
		else
		{
			if (this.lbl_rut.enabled == true)
			{
				mx.controls.Alert.show("Debe ingresar un RUT de Girador válido","Alerta");
			}
			else
			{
				if (this.lbl_nombres.text == "")
				{
					mx.controls.Alert.show("Debe ingresar un Nombre de Girador","Alerta");	
				}
				else
				{
					if (this.lbl_ap_paterno.text == "")
					{
						mx.controls.Alert.show("Debe ingresar un Apellido Paterno de Girador","Alerta");
					}
					else
					{
						if (this.lbl_ap_materno.text == "")
						{
							mx.controls.Alert.show("Debe ingresar un Apellido Materno de Girador","Alerta");
						}
						else
						{
							this.parentApplication.pago.banco_cheque = this.cmb_bancos.selectedItem.data;
							this.parentApplication.pago.plazo_cheque = this.ns_plazo.value.toString();
							this.parentApplication.pago.serie_cheque = this.lbl_serie.text;
							this.parentApplication.pago.rut_cheque = this.lbl_rut.text;
							this.parentApplication.pago.nombres_cheque = this.lbl_nombres.text;
							this.parentApplication.pago.paterno_cheque = this.lbl_ap_paterno.text;
							this.parentApplication.pago.materno_cheque = this.lbl_ap_materno.text;
							this.parentApplication.pago.agregar_medio();
							btn_cancelar_click();
							
							
						}
					}
				}
			}
		}
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar un Banco","Alerta");		
	}
	
	
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
		this.lbl_rut.enabled = false;
		this.lbl_nombres.setFocus();
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

//***********************************************************************************************************
private function result_orden_pago_muestra_banco(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No se encontraron bancos", "Información");
	}
	else
	{
		this.cmb_bancos.dataProvider = event.result;
	}
}

//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}

//******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}
