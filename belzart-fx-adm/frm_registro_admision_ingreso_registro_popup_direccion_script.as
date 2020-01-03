// ActionScript file


import flash.events.KeyboardEvent;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

public var pantalla:String;

private var envio_defecto:String;


//*******************************************************************************************************
private function inicio():void{
	this.cmb_tipo_direccion.setFocus();
	var arreglo: ArrayCollection = new ArrayCollection;
	var o_dos_campos:obj_dos_campos = new obj_dos_campos;
	o_dos_campos.data = '0';
	o_dos_campos.label = 'R.U.T.';
	arreglo.addItem(o_dos_campos);
	o_dos_campos = new obj_dos_campos;
	o_dos_campos.data = '1';
	o_dos_campos.label = 'Nombre';
	arreglo.addItem(o_dos_campos);
	o_dos_campos = new obj_dos_campos;
	o_dos_campos.data = '2';
	o_dos_campos.label = 'Apellidos';
	arreglo.addItem(o_dos_campos);
	
	this.cmb_tipo_busqueda.dataProvider = arreglo;
	
	
	ro_ingreso_registro.muestra_tipo_direccion();
	ro_ingreso_registro.muestra_pais();
	
}

//*******************************************************************************************************
private function cmt_tipo_busqueda_change():void
{
	
}

//***********************************************************************************************************
private function lbl_buscar_direccion_presskey(event:KeyboardEvent):void{
	
	var rut_temp:String = lbl_buscar_direccion.text
	rut_temp = rut_temp.toUpperCase()
	
	if (this.lbl_buscar_direccion.text == "")
	{
		if (event.charCode==13){
			this.lbl_calle.setFocus();
		}
	}
	else
	{
		if (this.cmb_tipo_busqueda.selectedIndex == 0)
			
		{
			if (event.charCode==13){
				this.cmb_tipo_busqueda.setFocus();
			}else{
				if (event.charCode >= 48 && event.charCode <= 57){
					puntos()
				}else{
					Keyboard.BACKSPACE
				}
			}
		}
	}
	
	
	
}


//***********************************************************************************************************
private function buscar_direccion():void{
	if (this.cmb_tipo_busqueda.selectedIndex == 0)
		
	{var rut_temp:String = lbl_buscar_direccion.text
	rut_temp = rut_temp.toUpperCase()
	
	valida_rut(rut_temp);
	}
	else
		btn_buscar_click();

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
	
	if (lbl_buscar_direccion.length == 12)
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
		focusManager.setFocus(lbl_buscar_direccion);
	}
	
	if (is_ok == 1)
	{
		btn_buscar_click();
	}
	
}
//***********************************************************************************************************
private function puntos():void {
	var rut_temp:String;
	
	if (lbl_buscar_direccion.length == 2) {
		lbl_buscar_direccion.text = lbl_buscar_direccion.text + '.'
		rut_temp = lbl_buscar_direccion.text + '.'
		focusManager.setFocus(lbl_buscar_direccion);
		lbl_buscar_direccion.setSelection(lbl_buscar_direccion.length,lbl_buscar_direccion.length);
	}
	if (lbl_buscar_direccion.length == 6) {
		lbl_buscar_direccion.text = lbl_buscar_direccion.text + '.'
		rut_temp = lbl_buscar_direccion.text + '.'
		focusManager.setFocus(lbl_buscar_direccion);
		lbl_buscar_direccion.setSelection(lbl_buscar_direccion.length,lbl_buscar_direccion.length);
	}
	if (lbl_buscar_direccion.length == 10) {
		lbl_buscar_direccion.text = lbl_buscar_direccion.text + '-'
		rut_temp = lbl_buscar_direccion.text + '.'
		focusManager.setFocus(lbl_buscar_direccion);
		lbl_buscar_direccion.setSelection(lbl_buscar_direccion.length,lbl_buscar_direccion.length);
	}
}



//******************************************************************************************************
private function mayusculas(texto:TextInput):void
{
	var texto_final:String;
	if (texto.text.length > 0)
	{
		texto_final = texto.text.toUpperCase();
		texto.text = texto_final;
	}
	//	mx.controls.Alert.show(texto);
}


//*******************************************************************************************************
private function btn_buscar_click():void
{
	if (this.cmb_tipo_busqueda.selectedIndex == 0)
	{
		ro_ingreso_registro.muestra_direcciones(this.lbl_buscar_direccion.text);
	}
	
	if (this.cmb_tipo_busqueda.selectedIndex == 1)
	{
		ro_ingreso_registro.muestra_direcciones_nombre(this.lbl_buscar_direccion.text);
	}
	
	if (this.cmb_tipo_busqueda.selectedIndex == 2)
	{
		ro_ingreso_registro.muestra_direcciones_apellidos(this.lbl_buscar_direccion.text);
	}
}

//*******************************************************************************************************
private function result_muestra_tipo_direcciones(event:ResultEvent):void
{
	cmb_tipo_direccion.dataProvider = event.result;
}
//*******************************************************************************************************
private function result_muestra_pais(event:ResultEvent):void
{
	cmb_pais.dataProvider = event.result;
//	ro_ingreso_registro.muestra_comuna(cmb_pais.selectedItem.data);
	ro_ingreso_registro.muestra_regiones(cmb_pais.selectedItem.data);
}
//*******************************************************************************************************
private function result_muestra_direcciones(event:ResultEvent):void
{
	if (event.result.length> 0)
	{
		dg_direcciones.dataProvider = event.result;	
		this.dg_direcciones.setFocus();
	}
	else
	{
		mx.controls.Alert.show("No se encontraron direcciones","Alerta");
		this.lbl_buscar_direccion.setFocus();
	}
	
}
//*******************************************************************************************************
private function result_muestra_comuna(event:ResultEvent):void
{
	cmb_comuna.dataProvider = event.result;
	
	
}
//*******************************************************************************************************
private function result_muestra_regiones(event:ResultEvent):void
{
	this.cmb_region.dataProvider = event.result;
}
//*******************************************************************************************************
private function cmb_comuna_change():void
{	
}

//*******************************************************************************************************
private function cmb_pais_change():void
{	
//	ro_ingreso_registro.muestra_comuna(cmb_pais.selectedItem.data);
	ro_ingreso_registro.muestra_regiones(cmb_pais.selectedItem.data);
}
//*******************************************************************************************************

private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}
//*******************************************************************************************************
private function btn_guardar_click():void
{	if (this.lbl_calle.text == "")
	{
		mx.controls.Alert.show("Debe ingresar la calle","Alerta");
		this.lbl_calle.setFocus();
	}
	else if (this.lbl_numero.text == "")
	{
		mx.controls.Alert.show("Debe ingresar un número","Alerta");
		this.lbl_numero.setFocus();
	}
	else if (this.cmb_comuna.selectedItem == null )
	{
		mx.controls.Alert.show("Debe indicar una comuna","Alerta");
		this.cmb_comuna.setFocus();
	}
	else if (this.cmb_tipo_direccion.selectedIndex == 0)
	{
		mx.controls.Alert.show("Debe indicar el tipo de dirección","Alerta");
		this.cmb_tipo_direccion.setFocus();
	}
	else
		ro_ingreso_registro.agrega_direccion(lbl_calle.text, lbl_numero.text, lbl_depto.text, lbl_referencia.text, lbl_cod_zip.text, cmb_comuna.selectedItem.data);
}

//*******************************************************************************************************

private function btn_seleccionar_click():void
{
	if (this.dg_direcciones.selectedItem == null)
		mx.controls.Alert.show("Debe seleccionar una dirección","Alerta");
	else if (this.cmb_tipo_direccion.selectedIndex == 0)
		mx.controls.Alert.show("Debe seleccionar el tipo de dirección","Alerta");
	else
		seleccionar_direccion();
}
//******************************************************************************************************
private function seleccionar_direccion():void
{
	var arreglo:ArrayCollection = new ArrayCollection;
	
	var o_trece_campos:libreria.obj_trece_campos = new libreria.obj_trece_campos;
	var o_quince_campos:obj_quince_campos = new obj_quince_campos;
	
	var formulario:Array;
	formulario = this.parentApplication.cnv_pantalla.getChildren();
	
	if (formulario[0].dg_direcciones.dataProvider != null) {
		arreglo = formulario[0].dg_direcciones.dataProvider;
	}
	
	if (this.pantalla == "modifica")
	{
		
		o_quince_campos.campo_uno = dg_direcciones.selectedItem.campo_uno; //dir_idn
		o_quince_campos.campo_dos = dg_direcciones.selectedItem.campo_dos; //dir_direccion
		o_quince_campos.campo_tres = dg_direcciones.selectedItem.campo_tres; // dir_numero
		o_quince_campos.campo_cuatro = dg_direcciones.selectedItem.campo_cuatro; // dir_depto
		o_quince_campos.campo_cinco = dg_direcciones.selectedItem.campo_seis; // seg_div_pol_idn
		o_quince_campos.campo_seis = dg_direcciones.selectedItem.campo_siete; //seg_div_pol_nombre
		o_quince_campos.campo_siete = dg_direcciones.selectedItem.campo_ocho; //div_pol_nombre
		o_quince_campos.campo_ocho = dg_direcciones.selectedItem.campo_nueve; //pais_nombre
		o_quince_campos.campo_nueve = cmb_tipo_direccion.selectedItem.data; 
		//dg_direcciones.selectedItem.campo_diez; // ent_codigo_pais
		o_quince_campos.campo_diez =  cmb_tipo_direccion.selectedLabel;
		o_quince_campos.campo_once = "NO";
		o_quince_campos.campo_doce = dg_direcciones.selectedItem.campo_cinco; //dir_cod_zip
		o_quince_campos.campo_trece = "D";
		o_quince_campos.campo_catorce = dg_direcciones.selectedItem.campo_once; //dir_referencia
		o_quince_campos.campo_quince = "Por Activar";

		
		arreglo.addItem(o_quince_campos);
	}
	else
	{
		o_trece_campos.campo_uno = dg_direcciones.selectedItem.campo_uno;
		o_trece_campos.campo_dos = dg_direcciones.selectedItem.campo_dos;
		o_trece_campos.campo_tres = dg_direcciones.selectedItem.campo_tres;
		o_trece_campos.campo_cuatro = dg_direcciones.selectedItem.campo_cuatro;
		o_trece_campos.campo_cinco = dg_direcciones.selectedItem.campo_seis;
		o_trece_campos.campo_seis = dg_direcciones.selectedItem.campo_siete;
		o_trece_campos.campo_siete = dg_direcciones.selectedItem.campo_ocho;
		o_trece_campos.campo_ocho = dg_direcciones.selectedItem.campo_nueve;
		o_trece_campos.campo_nueve = cmb_tipo_direccion.selectedItem.data;
		o_trece_campos.campo_diez = cmb_tipo_direccion.selectedLabel; 
		o_trece_campos.campo_once = "NO";
		o_trece_campos.campo_doce = dg_direcciones.selectedItem.campo_cinco;
		o_trece_campos.campo_trece = dg_direcciones.selectedItem.campo_once;

		arreglo.addItem(o_trece_campos);
	
	}
	formulario[0].dg_direcciones.dataProvider = arreglo;
	formulario[0].seleccionar_ultima_direccion();
	
//	mx.controls.Alert.show(String(parentApplication.dg_direcciones.dataProvider.length));
	PopUpManager.removePopUp(this);	
}
//******************************************************************************************************
private function result_agrega_direccion(event:ResultEvent):void
{	
	var x:int
	
	if (event.result.length <1 )
		mx.controls.Alert.show("Ha ocurrido un error al guardar la dirección. Intente nuevamente","Error");
	else
	{	
		var arreglo:ArrayCollection = new ArrayCollection;
	 	var o_trece_campos:libreria.obj_trece_campos = new libreria.obj_trece_campos;
		var o_quince_campos:obj_quince_campos = new obj_quince_campos;
		
		var formulario:Array;
		formulario = this.parentApplication.cnv_pantalla.getChildren();
		
		if (formulario[0].dg_direcciones.dataProvider != null) {
			arreglo = formulario[0].dg_direcciones.dataProvider;
		}
		
		if (this.pantalla == "modifica")
		{
			o_quince_campos.campo_uno = event.result[0].campo_uno; //dir_idn
			o_quince_campos.campo_dos = this.lbl_calle.text; //dir_direccion
			o_quince_campos.campo_tres = this.lbl_numero.text; // dir_numero
			o_quince_campos.campo_cuatro = this.lbl_depto.text; // dir_depto
			o_quince_campos.campo_cinco = this.cmb_comuna.selectedIndex.toString(); // seg_div_pol_idn
			o_quince_campos.campo_seis = this.cmb_comuna.selectedLabel; //seg_div_pol_nombre
			o_quince_campos.campo_siete = this.cmb_region.selectedLabel; //div_pol_nombre
			o_quince_campos.campo_ocho = this.cmb_pais.selectedItem.label; //pais_nombre
			o_quince_campos.campo_nueve = cmb_tipo_direccion.selectedItem.data; 
			//dg_direcciones.selectedItem.campo_diez; // ent_codigo_pais
			o_quince_campos.campo_diez =  cmb_tipo_direccion.selectedLabel;
			o_quince_campos.campo_once = "NO";
			o_quince_campos.campo_doce = this.lbl_cod_zip.text; //dir_cod_zip
			o_quince_campos.campo_trece = "D";
			o_quince_campos.campo_catorce = this.lbl_referencia.text; //dir_referencia
			o_quince_campos.campo_quince = "Por Activar";
		
			arreglo.addItem(o_quince_campos);
		}
		else
		{
			o_trece_campos.campo_uno = event.result[0].campo_uno;
			o_trece_campos.campo_dos = this.lbl_calle.text;
			o_trece_campos.campo_tres = this.lbl_numero.text;
			o_trece_campos.campo_cuatro = this.lbl_depto.text;
			o_trece_campos.campo_cinco = this.cmb_comuna.selectedIndex.toString();
			o_trece_campos.campo_seis = this.cmb_comuna.selectedLabel;
			o_trece_campos.campo_siete = this.cmb_comuna.selectedLabel;
			o_trece_campos.campo_ocho = this.cmb_pais.selectedItem.label;
			o_trece_campos.campo_nueve = cmb_tipo_direccion.selectedItem.data;
			o_trece_campos.campo_diez = cmb_tipo_direccion.selectedLabel; 
			o_trece_campos.campo_once = "NO";
			o_trece_campos.campo_doce = this.lbl_cod_zip.text;
			o_trece_campos.campo_trece = "NO";

			arreglo.addItem(o_trece_campos);
		
		}
		formulario[0].dg_direcciones.dataProvider = arreglo;
		formulario[0].seleccionar_ultima_direccion();
		PopUpManager.removePopUp(this);	
	}
		
}

//******************************************************************************************************
private function btn_nueva_direccion_click():void
{	
	dg_direcciones.selectedItem = null;
	cmb_tipo_direccion.selectedIndex= 0;
	lbl_buscar_direccion.text = "";
	lbl_calle.text = "";
	lbl_numero.text = "";
	lbl_depto.text = "";
	lbl_referencia.text = "";
	lbl_cod_zip.text = "";
	this.cmb_region.selectedIndex = 0;
	this.cmb_comuna.dataProvider = null;
	ro_ingreso_registro.muestra_pais();
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");	
}
