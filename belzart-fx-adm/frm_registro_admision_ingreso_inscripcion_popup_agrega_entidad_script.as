// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

//*******************************************************************************************************
import flash.events.KeyboardEvent;

private function inicio():void
{
	llena_combo_tipo_busqueda();
}
//***********************************************************************************************************
private function lbl_parametro_presskey(event:KeyboardEvent):void{
	
	var rut_temp:String = lbl_parametro.text
	rut_temp = rut_temp.toUpperCase()
	
		
	if (this.cmb_tipo_busqueda.selectedIndex == 0)
		
	{
		if (event.charCode==13){
			valida_rut(rut_temp);
		}else{
			if (event.charCode >= 48 && event.charCode <= 57){
				puntos()
			}else{
				Keyboard.BACKSPACE
			}
		}
		if (event.charCode==13){
			buscar_entidades();
		}
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
	
	if (lbl_parametro.length == 12)
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
		focusManager.setFocus(lbl_parametro);
	}
	
	if (is_ok == 1)
	{
		buscar_entidades();
	}
	
}
//***********************************************************************************************************
private function puntos():void {
	var rut_temp:String;
	
	if (lbl_parametro.length == 2) {
		lbl_parametro.text = lbl_parametro.text + '.'
		rut_temp = lbl_parametro.text + '.'
		focusManager.setFocus(lbl_parametro);
		lbl_parametro.setSelection(lbl_parametro.length,lbl_parametro.length);
	}
	if (lbl_parametro.length == 6) {
		lbl_parametro.text = lbl_parametro.text + '.'
		rut_temp = lbl_parametro.text + '.'
		focusManager.setFocus(lbl_parametro);
		lbl_parametro.setSelection(lbl_parametro.length,lbl_parametro.length);
	}
	if (lbl_parametro.length == 10) {
		lbl_parametro.text = lbl_parametro.text + '-'
		rut_temp = lbl_parametro.text + '.'
		focusManager.setFocus(lbl_parametro);
		lbl_parametro.setSelection(lbl_parametro.length,lbl_parametro.length);
	}
}

//******************************************************************************************************
private function llena_combo_tipo_busqueda():void
{
	var arreglo:ArrayCollection = new ArrayCollection;
	var o_dos_campos:obj_dos_campos = new obj_dos_campos;
	var o_dos_campos2:obj_dos_campos = new obj_dos_campos;
	var o_dos_campos3:obj_dos_campos = new obj_dos_campos;
	o_dos_campos.data = "0";
	o_dos_campos.label = "Cód. País";
	arreglo.addItem(o_dos_campos);
	o_dos_campos2.data = "1";
	o_dos_campos2.label = "Nombre";
	arreglo.addItem(o_dos_campos2);
	o_dos_campos3.data = "2";
	o_dos_campos3.label = "Apellido Paterno";
	arreglo.addItem(o_dos_campos3);
	cmb_tipo_busqueda.dataProvider = arreglo;	
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
//******************************************************************************************************
private function selecciona_documentacion():void
{	
	if (this.chk_documentacion.selected == true){
		if (this.dg_entidades.selectedItem == null)
		{
			this.chk_documentacion.selected = false;
			mx.controls.Alert.show("Debe seleccionar una Entidad","Alerta");
		}
		else
		{
			habilitar_documentacion();
		}
	}
	if (this.chk_pago.selected == true){
		if (this.dg_entidades.selectedItem == null)
		{
			this.chk_pago.selected = false;
			mx.controls.Alert.show("Debe seleccionar una Entidad","Alerta");
		}
		else
		{
			habilitar_documentacion();
		}
	}
}
//******************************************************************************************************
private function habilitar_documentacion():void
{
	this.cmb_dir_env_doc.enabled = true;
	ro_ingreso_inscripcion.muestra_direcciones(this.dg_entidades.selectedItem.campo_uno);
}
//******************************************************************************************************
private function deshabilitar_documentacion():void
{	
	this.chk_documentacion.selected = false;
	this.cmb_dir_env_doc.dataProvider = null;
	this.cmb_dir_env_doc.enabled = false;
}
//******************************************************************************************************
private function buscar_entidades():void
{	
	if (this.lbl_parametro.text ==""){
		this.dg_entidades.dataProvider = null;
		deshabilitar_documentacion();
	}
	else {
		ro_ingreso_inscripcion.busca_entidades(this.lbl_parametro.text, this.cmb_tipo_busqueda.selectedIndex);	
	}
}
//******************************************************************************************************
private function btn_agregar_click():void
{
	var arreglo:ArrayCollection = new ArrayCollection;
	var o_diez_campos:obj_diez_campos = new obj_diez_campos;
	var documentacion:String;
	var id_direccion:String;
	var direccion:String;
	var pago:String;
	var id_dir_pago:String;
	var dir_pago:String;
	if (this.dg_entidades.selectedItem != null)
	{	
		if (this.chk_documentacion.selected == true || this.chk_pago.selected ==true)
		{
				if (this.chk_documentacion.selected == true){
					documentacion = "SI";
					direccion = this.cmb_dir_env_doc.selectedLabel;
					id_direccion = this.cmb_dir_env_doc.selectedIndex.toString();
				}
				else
				{
					documentacion = "NO";
					direccion = "";
					direccion = "";
				}
				if (this.chk_pago.selected == true){
					pago = "SI";
					id_dir_pago = this.cmb_dir_env_doc.selectedIndex.toString();
					dir_pago = this.cmb_dir_env_doc.selectedLabel;
				}
				else
				{
					pago = "NO";
					id_dir_pago = "";
					dir_pago = "";
				}
				o_diez_campos.campo_uno = dg_entidades.selectedItem.campo_uno;
				o_diez_campos.campo_dos = dg_entidades.selectedItem.campo_dos;
				o_diez_campos.campo_tres = dg_entidades.selectedItem.campo_tres;
				o_diez_campos.campo_cuatro = dg_entidades.selectedItem.campo_cuatro;
				o_diez_campos.campo_cinco = documentacion;
				o_diez_campos.campo_seis = id_direccion;
				o_diez_campos.campo_siete = direccion;
				o_diez_campos.campo_ocho = pago;
				o_diez_campos.campo_nueve = id_dir_pago;
				o_diez_campos.campo_diez = dir_pago;
				arreglo.addItem(o_diez_campos);
				
				if (this.parentApplication.rp_entidades.dataProvider == null)
				{
					this.parentApplication.rp_entidades.dataProvider = arreglo;
				}
				else
				{
					this.parentApplication.rp_entidades.dataProvider.addItem(o_diez_campos);
				}
				this.parentApplication.pl_productos.enabled = true;
				btn_cancelar_click();
		}
		else
		{
			mx.controls.Alert.show("Debe seleccionar Alumno y/o Pagador", "Alerta");
		}
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar una Entidad","Alerta");
	}
	
}
//***********************************************************************************************************
private function btn_limpiar_pantalla_click():void
{
	deshabilitar_documentacion();
	this.lbl_parametro.text = "";
	this.cmb_tipo_busqueda.selectedIndex = 0;
	this.dg_entidades.dataProvider = null;
}
//***********************************************************************************************************
private function result_busca_entidades(event:ResultEvent):void
{
	this.dg_entidades.dataProvider = event.result;
}
//***********************************************************************************************************
private function result_muestra_direcciones(event:ResultEvent):void
{
	var i:int;
	if (event.result.length <1 )
		mx.controls.Alert.show("No existen direcciones asociadas a la Entidad","Alerta");
	else
	{
		this.cmb_dir_env_doc.dataProvider = event.result;
		for (i = 0; i < this.cmb_dir_env_doc.dataProvider.length; i++)
		{
			if (this.cmb_dir_env_doc.dataProvider[i].campo_tres == 1){
				this.cmb_dir_env_doc.selectedIndex = i;
			}
		}
	}
	
	
}

//***********************************************************************************************************
/*private function result_muestra_forma_pago(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("Error en Base de Datos. No existe Forma de Pago","Alerta");
	else
	{
		cmb_forma_pago.dataProvider = event.result;
	}
}

//***********************************************************************************************************
private function result_muestra_medio_pago(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("Error en Base de Datos. No existe Medio de Pago","Alerta");
	else
	{
		cmb_medio_pago.dataProvider = event.result;
	}
}


//***********************************************************************************************************
private function result_muestra_tipo_pago(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("Error en Base de Datos. No existe Tipo de Pago","Alerta");
	else
	{
		cmb_tipo_pago.dataProvider = event.result;
	}
}

//***********************************************************************************************************
private function result_muestra_tipo_jornada(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("Error en Base de Datos. No existe tipo de Jornada","Alerta");
	else
	{
		cmb_jornada.dataProvider = event.result;
	}
}
*/