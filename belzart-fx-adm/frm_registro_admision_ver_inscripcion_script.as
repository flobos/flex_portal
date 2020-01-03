// ActionScript file
import flash.net.URLRequest;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.Button;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;



public var porcentaje_pago_popup:String;
public var direccion_pago_popup:String;
public var forma_pago_popup:String;
public var medio_pago_popup:String;
public var tipo_pago_popup:String;
public var numChild:Number = 0;
public var mod_cam_idn:String;
private var func_mod_fun_idn:String;
private var insc_idn:String;
private var operaciones_generadas:int = 0;
private var total_pagadores:int = 0;
private var total_productos:int = 0;
private var error_ingreso_alumno:int = 0;
private var arreglo_pagadores:ArrayCollection = new ArrayCollection;
private var arreglo_pagador:ArrayCollection = new ArrayCollection;
public var url_frame:URLRequest;
//*******************************************************************************************************
private function inicio():void
{
	func_mod_fun_idn = Application.application.parameters.func_mod_fun_idn;
	obtiene_modalidad_campus(func_mod_fun_idn);
}
//*******************************************************************************************************
private function nueva_consulta():void
{
	this.lbl_inscripcion.text = "";
	this.lbl_buscar_rut.text = "";
	this.btn_buscar_inscripcion.enabled = true;
	this.btn_buscar_rut.enabled = true;
	this.btn_informes.enabled = false;
	this.tn_productos.removeAllChildren();
	this.lbl_inscripcion.enabled = true;
	this.lbl_buscar_rut.enabled = true;
	this.lbl_fecha_ingreso.text = "";
}

//******************************************************************************************************
private function obtiene_modalidad_campus(f_mod_fun_idn:String):void
{
	ro_ver_inscripcion.obtiene_modalidad_campus(f_mod_fun_idn);
}
//***********************************************************************************************************
private function result_obtiene_modalidad_campus(event:ResultEvent):void
{
	var i:int;
	
	if (event.result.length > 0)
	{
		this.mod_cam_idn = event.result[0].campo_uno;
	}
	else
	{
		mx.controls.Alert.show("No se pudo obtener la modalidad del campus","Error");
	}
}


//******************************************************************************************************
public function cambiar_titulo_producto(titulo:String, indice:int):void{
	var formulario:Array;
	
	formulario = this.tn_productos.getChildren();
	formulario[indice].label = titulo;
	
}
//******************************************************************************************************

private function result_busca_inscripcion(event:ResultEvent):void {
	this.tn_productos.removeAllChildren();
	var i:int= 0;
	if (event.result.length <1 )
		mx.controls.Alert.show("No se encontró la inscripción","Alerta");
	else
	{
		this.lbl_inscripcion.enabled = false;
		this.lbl_buscar_rut.enabled = false;
		for (i=0; i< event.result.length; i++)
		{
			var formulario:frm_registro_admision_ver_inscripcion_popup_agrega_malla = new frm_registro_admision_ver_inscripcion_popup_agrega_malla;
			formulario.insc_idn = this.lbl_inscripcion.text;
			formulario.pro_mal_idn = event.result[i].campo_dos;
			formulario.indice = i;
			formulario.ent_reg_idn = event.result[i].campo_uno;
			formulario.ent_nombre = event.result[i].campo_cuatro;
			formulario.fecha_inicio_clases = event.result[i].campo_cinco;
			this.lbl_fecha_ingreso.text = event.result[i].campo_tres;
			formulario.label = "Producto N°" + event.result[i].campo_dos + '/'+ event.result[i].campo_uno;
			tn_productos.addChild(formulario);
			tn_productos.selectedIndex = tn_productos.numChildren - 1;
		}
	}
	this.btn_informes.enabled = true;
}

public function carga_inscripcion(insc_idn:String):void
{
	this.lbl_inscripcion.text = insc_idn;
	this.ro_ver_inscripcion.busca_inscripcion(insc_idn);
}

//******************************************************************************************************
private function buscar_inscripcion():void
{
	if (this.lbl_inscripcion.text != "")
	{
		this.ro_ver_inscripcion.busca_inscripcion(this.lbl_inscripcion.text);
	}
	else
	{
		mx.controls.Alert.show("Debe ingresar un número de inscripción a buscar","Alerta");
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
private function popup_reportes():void
{
	var buscar:frm_registro_admision_ingreso_inscripcion_popup_reportes = frm_registro_admision_ingreso_inscripcion_popup_reportes(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_inscripcion_popup_reportes , true));
	mx.managers.PopUpManager.centerPopUp(buscar)
}
//*******************************************************************************************************
private function btn_informes_click():void{
	
	
	var i:int = 0;
	var j:int = 0;
	var ind:int = 0;
	var productos:Array = new Array();
	var o_once_campos:obj_once_campos;
	var valor_beca:String = '0';
	var valor_matricula:String = '0';
	productos = tn_productos.getChildren();
	
	
	for (i=0; i < productos.length ; i++)
	{
		for (j=0; j < productos[i].rp_pagadores.dataProvider.length; j++)
		{
			if (productos[i].lbl_id_entidad[j].text != '65')
			{
				for (ind=0; ind < productos[i].rp_pagadores.dataProvider.length; ind++)
				{
					if (productos[i].lbl_id_entidad[ind].text == '65')
					{
						valor_beca = productos[i].lbl_total_pagar[ind].text;
					}
				}
				o_once_campos = new obj_once_campos;
				o_once_campos.campo_uno = productos[i].lbl_id_entidad[j].text;
				o_once_campos.campo_dos = productos[i].cmb_alumno_asociado.selectedItem.data;
				o_once_campos.campo_tres = productos[i].pro_mal_idn
				o_once_campos.campo_cuatro = productos[i].lbl_valor_arancel.text;
				o_once_campos.campo_cinco = valor_beca;
				o_once_campos.campo_seis = valor_matricula;
				o_once_campos.campo_siete = productos[i].tip_prod_idn;
				o_once_campos.campo_ocho = productos[i].eje_adm_idn;
				o_once_campos.campo_nueve = productos[i].lbl_entidad[j].text;
				o_once_campos.campo_diez = productos[i].cmb_alumno_asociado.selectedItem.label;
				o_once_campos.campo_once = productos[i].titulo_carrera;
				this.arreglo_pagador.addItem(o_once_campos);
			}
		}
	
		
	}
	
	
	
	
	
	
	var buscar:frm_registro_admision_ingreso_inscripcion_popup_reportes = frm_registro_admision_ingreso_inscripcion_popup_reportes(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_inscripcion_popup_reportes , true));
	buscar.arreglo_pag = this.arreglo_pagador;
	buscar.mod_cam_idn = this.mod_cam_idn;
	mx.controls.Alert.show(this.mod_cam_idn);
	buscar.func_mod_fun_idn = this.func_mod_fun_idn;
	buscar.insc_idn = this.lbl_inscripcion.text;
	mx.managers.PopUpManager.centerPopUp(buscar);
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
	
	if (lbl_buscar_rut.length == 12)
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
		focusManager.setFocus(lbl_buscar_rut);
	}
	
	if (is_ok == 1)
	{
	//	btn_buscar_registro_click();
		buscar_rut();
	}
	
}

private function btn_buscar_rut_click():void
{
	valida_rut(lbl_buscar_rut.text)
}

private function buscar_rut():void
{
	var popup:frm_registro_admision_ver_inscripcion_popup_busca_rut = frm_registro_admision_ver_inscripcion_popup_busca_rut(PopUpManager.createPopUp( this, frm_registro_admision_ver_inscripcion_popup_busca_rut , true));
	popup.ent_idn = this.lbl_buscar_rut.text;
	mx.managers.PopUpManager.centerPopUp(popup);	

}
//***********************************************************************************************************
private function puntos():void {
	var rut_temp:String;
	
	if (lbl_buscar_rut.length == 2) {
		lbl_buscar_rut.text = lbl_buscar_rut.text + '.'
		rut_temp = lbl_buscar_rut.text + '.'
		focusManager.setFocus(lbl_buscar_rut);
		lbl_buscar_rut.setSelection(lbl_buscar_rut.length,lbl_buscar_rut.length);
	}
	if (lbl_buscar_rut.length == 6) {
		lbl_buscar_rut.text = lbl_buscar_rut.text + '.'
		rut_temp = lbl_buscar_rut.text + '.'
		focusManager.setFocus(lbl_buscar_rut);
		lbl_buscar_rut.setSelection(lbl_buscar_rut.length,lbl_buscar_rut.length);
	}
	if (lbl_buscar_rut.length == 10) {
		lbl_buscar_rut.text = lbl_buscar_rut.text + '-'
		rut_temp = lbl_buscar_rut.text + '.'
		focusManager.setFocus(lbl_buscar_rut);
		lbl_buscar_rut.setSelection(lbl_buscar_rut.length,lbl_buscar_rut.length);
	}
}

//***********************************************************************************************************
private function lbl_buscar_rut_presskey(event:KeyboardEvent):void{
	
	var rut_temp:String = lbl_buscar_rut.text
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
