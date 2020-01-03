// ActionScript file
import flash.events.KeyboardEvent;
import flash.utils.ByteArray;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

[Bindable]  
private var par_func_mod_fun_idn:String;
public var func_mod_fun_idn:String;
private var envio_default:Number;
private var idn_entidad:String;
private var idn_entidad_registro:String;
public var pantalla:String;
private var direcciones_eliminar:ArrayCollection;
private var telefonos_eliminar:ArrayCollection;
public var telefonos_agregar:ArrayCollection;
private var electronicos_eliminar:ArrayCollection;
public var electronicos_agregar:ArrayCollection;
private var error_fonos:Number;
private var dir_envio_default:String;

public var foto:ByteArray;

public function set_foto(foto_entidad:ByteArray):void
{
	this.foto = foto_entidad;
}

//*******************************************************************************************************
private function inicio():void
{
	
	var criterio_buscar:Array = new Array();
	criterio_buscar.push({data:0, label:"Nombre"});
	criterio_buscar.push({data:1, label:"Apellido Paterno"});
	
	cmb_buscar_por.dataProvider=criterio_buscar;
	
//	this.lbl_buscar_registro.addEventListener(KeyboardEvent.KEY_DOWN, tecla_presionada);
	lbl_buscar_registro.setFocus();
}

private function tecla_presionada( e:KeyboardEvent ):void{
	if( e.charCode == 13 ){
		btn_buscar_registro_click();
	}
}

//******************************************************************************************************
private function btn_buscar_registro_click():void
{
	
	if (this.lbl_buscar_registro.text != ""){
		if (this.lbl_buscar_registro.text.length <12)
		{
			mx.controls.Alert.show("El parámetro ingresado es incorrecto","Alerta");
		}
		else
		{
			ro_modifica_registro.busca_entidades(lbl_buscar_registro.text)
		}
	}
}
//******************************************************************************************************
private function btn_buscar_otro_click():void
{
	if (this.lbl_otra_busqueda.text != ""){
		ro_modifica_registro.busca_entidades_nombre(lbl_otra_busqueda.text,this.cmb_buscar_por.selectedIndex.toString());
	}
}
//***********************************************************************************************************
private function result_busca_entidades(event:ResultEvent):void
{
	var ingreso:frm_registro_admision_ingreso_registro = new frm_registro_admision_ingreso_registro;
	
	this.cnv_pantalla.removeAllChildren();
	if (event.result.length <1 )
	{
		ingreso.identificador = this.lbl_buscar_registro.text;
		this.cnv_pantalla.addChild(ingreso);
		this.lbl_buscar_registro.enabled = false;
	}
	else
	{
		
		var popup1:frm_registro_admision_master_registro_popup_entidades = frm_registro_admision_master_registro_popup_entidades(PopUpManager.createPopUp( this, frm_registro_admision_master_registro_popup_entidades , true));
		popup1.dg_entidades.dataProvider = event.result;
		mx.managers.PopUpManager.centerPopUp(popup1)
		

	}
}

//***********************************************************************************************************
private function result_busca_entidades_nombre(event:ResultEvent):void
{
	var ingreso:frm_registro_admision_ingreso_registro = new frm_registro_admision_ingreso_registro;
	
	this.cnv_pantalla.removeAllChildren();
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No se encontraron entidades con el parámetro especificado", "Información");
	}
	else
	{
		
		var popup1:frm_registro_admision_master_registro_popup_entidades = frm_registro_admision_master_registro_popup_entidades(PopUpManager.createPopUp( this, frm_registro_admision_master_registro_popup_entidades , true));
		popup1.dg_entidades.dataProvider = event.result;
		mx.managers.PopUpManager.centerPopUp(popup1)
		

	}
}

public function cargar_ingreso():void
{
	var ingreso:frm_registro_admision_ingreso_registro = new frm_registro_admision_ingreso_registro;
	ingreso.identificador = this.lbl_buscar_registro.text;
	this.cnv_pantalla.addChild(ingreso);
	this.lbl_buscar_registro.enabled = false;
}

public function cargar_modificar(id_entidad:String):void
{
	var modifica:frm_registro_admision_modifica_registro = new frm_registro_admision_modifica_registro;
	modifica.identificador = this.lbl_buscar_registro.text;
	modifica.id_entidad= id_entidad;
	this.cnv_pantalla.addChild(modifica);
	this.lbl_buscar_registro.enabled = false;
	this.lbl_otra_busqueda.enabled = false;
}

private function entidades_click( e:ListEvent ):void {
//	mx.controls.Alert.show(this.dg_alumnos.selectedItem.campo_uno);
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}

 
public function btn_limpiar_pantalla_click():void
{
	lbl_otra_busqueda.text = "";
	lbl_otra_busqueda.enabled = true;
	lbl_buscar_registro.text = "";
	lbl_buscar_registro.enabled = true;
	cmb_buscar_por.selectedIndex = 0;
	cnv_pantalla.removeAllChildren();
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
	
	if (lbl_buscar_registro.length == 12)
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
		focusManager.setFocus(lbl_buscar_registro);
	}
	
	if (is_ok == 1)
	{
		btn_buscar_registro_click();
	}
	
}
//***********************************************************************************************************
private function puntos():void {
	var rut_temp:String;
	
	if (lbl_buscar_registro.length == 2) {
		lbl_buscar_registro.text = lbl_buscar_registro.text + '.'
		rut_temp = lbl_buscar_registro.text + '.'
		focusManager.setFocus(lbl_buscar_registro);
		lbl_buscar_registro.setSelection(lbl_buscar_registro.length,lbl_buscar_registro.length);
	}
	if (lbl_buscar_registro.length == 6) {
		lbl_buscar_registro.text = lbl_buscar_registro.text + '.'
		rut_temp = lbl_buscar_registro.text + '.'
		focusManager.setFocus(lbl_buscar_registro);
		lbl_buscar_registro.setSelection(lbl_buscar_registro.length,lbl_buscar_registro.length);
	}
	if (lbl_buscar_registro.length == 10) {
		lbl_buscar_registro.text = lbl_buscar_registro.text + '-'
		rut_temp = lbl_buscar_registro.text + '.'
		focusManager.setFocus(lbl_buscar_registro);
		lbl_buscar_registro.setSelection(lbl_buscar_registro.length,lbl_buscar_registro.length);
	}
}

//***********************************************************************************************************
private function lbl_buscar_registro_presskey(event:KeyboardEvent):void{
	
	var rut_temp:String = lbl_buscar_registro.text
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
//	if (event.charCode==13){
//		btn_buscar_registro_click();
//	}
}
//***********************************************************************************************************
private function buscar_registro():void{
	
	var rut_temp:String = lbl_buscar_registro.text
	rut_temp = rut_temp.toUpperCase()
	
	valida_rut(rut_temp);
	//	if (event.charCode==13){
	//		btn_buscar_registro_click();
	//	}
}