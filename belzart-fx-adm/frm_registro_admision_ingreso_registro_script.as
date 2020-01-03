// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

[Bindable]  
private var par_func_mod_fun_idn:String;
public var func_mod_fun_idn:String;
private var envio_default:Number;
private var idn_entidad:String;
private var idn_entidad_registro:String;
private var error_fonos:Number;
private var error_electronicos:Number;
private var error_direcciones:Number;
private var error_educacionales:Number;
private var error_laborales:Number;
private var error_registro_envio:Number;
private var error_requisitos:Number;
public var pantalla:String;
public var identificador:String;
public var requisitos:ArrayCollection = new ArrayCollection;
public var educacionales:ArrayCollection = new ArrayCollection;
public var laborales:ArrayCollection = new ArrayCollection;
private var estado_foto:int = 0;
//*******************************************************************************************************
private function inicio():void
{
	this.cmb_tipo_entidad.setFocus();
	pantalla = "ingreso";
	limpia_pantalla();
	ro_ingreso_registro.muestra_tipo_entidad();
	ro_ingreso_registro.muestra_estado_civil();
	ro_ingreso_registro.muestra_nacionalidad();
	llena_combo_sexo();
}
//*******************************************************************************************************
public function seleccionar_ultima_direccion():void
{
	if (this.dg_direcciones.dataProvider.length > 0)
	{
		this.dg_direcciones.selectedIndex = this.dg_direcciones.dataProvider.length - 1;
	}
}


//*******************************************************************************************************
private function comprueba_edad():void
{
	var now:Date = new Date();
	
	if (this.lbl_fecha_nac.selectedDate > now)
	{
		mx.controls.Alert.show("La fecha de nacimiento no es válida","Alerta");
	}
	else
	{
		now.setFullYear(now.getFullYear() - 17);
		if (this.lbl_fecha_nac.selectedDate > now)
		{
			mx.controls.Alert.show("La entidad es menor de 17 años","Alerta");
			this.cmb_nacionalidad.setFocus(); 		
		}	
	}

}

//*******************************************************************************************************
private function ingreso():void
{
	if (this.cmb_tipo_entidad.selectedIndex ==1)
		{
			this.lbl_ap_paterno.visible = false;
			this.txt_ap_paterno.visible = false;
			this.lbl_ap_materno.visible = false;
			this.txt_ap_materno.visible = false;
			this.lbl_fecha_nac.visible = false;
			this.lbl_nombre2.visible = false;
			this.txt_fecha_nac.visible = false;
			this.btn_antecedentes_educacionales.visible = false;
			this.btn_antecedentes_laborales.visible = false;
			this.btn_cargar_fotografia.visible = false;
			this.cmb_sexo.visible = false;
			this.txt_sexo.visible = false;
			this.cmb_estado_civil.visible = false;
			this.txt_estado_civil.visible = false;
			this.txt_nombre2.visible = false;
		}
	this.cnv_antecedentes.visible = true;
	this.cmb_tipo_entidad.enabled = false;
	this.lbl_nombre.setFocus();
}


//******************************************************************************************************
private function llena_combo_sexo():void
{
	var arreglo:ArrayCollection = new ArrayCollection;
	var o_dos_campos:obj_dos_campos = new obj_dos_campos;
	var o_dos_campos2:obj_dos_campos = new obj_dos_campos;
	var o_dos_campos3:obj_dos_campos = new obj_dos_campos;
	o_dos_campos.data = "0";
	o_dos_campos.label = "-- Seleccione --";
	arreglo.addItem(o_dos_campos);
	o_dos_campos2.data = "M";
	o_dos_campos2.label = "Masculino";
	arreglo.addItem(o_dos_campos2);
	o_dos_campos3.data = "F";
	o_dos_campos3.label = "Femenino";
	arreglo.addItem(o_dos_campos3);
	cmb_sexo.dataProvider = arreglo;	
	
}

private function formato(texto:TextInput):void
{
	var texto_final:String;
	if (texto.text.length > 1)
	{
		texto_final = texto.text.substr(0,1).toUpperCase() + texto.text.substr(1,int.MAX_VALUE).toLowerCase();
		texto.text = texto_final;
	}
//	mx.controls.Alert.show(texto);
}

private function btn_guardar_click():void
{	
	this.btn_guardar_registro.enabled = false;
	var nombre:String;
	nombre = lbl_nombre.text + ' ' + lbl_nombre2.text;
	if (this.parentApplication.foto != null)
	{
		estado_foto = 1;
	}
	// si no ha ingresado direcciones
	if (dg_direcciones.dataProvider.length < 1)
	{	mx.controls.Alert.show("Agregue una Dirección","Alerta")
		this.btn_guardar_registro.enabled = true;
	}
	// si no ha seleccionado una dirección de envío por defecto
	else if (envio_default != 1)
	{
		mx.controls.Alert.show("Establezca una Dirección de Envío","Alerta")
		this.btn_guardar_registro.enabled = true;	
	}
	else if (cmb_nacionalidad.selectedIndex == 0)
	{	mx.controls.Alert.show("Indique la Nacionalidad", "Alerta");
		this.btn_guardar_registro.enabled = true;
	}
	// si corresponde a una institucion
	else if (cmb_tipo_entidad.selectedIndex == 1){
		if (lbl_nombre.text == "")
		{
			mx.controls.Alert.show("Indique el Nombre de la Institución","Alerta");
			this.btn_guardar_registro.enabled = true;
		}
		else
			ro_ingreso_registro.agrega_entidad_empresa(identificador, 
														nombre, 
														lbl_fecha_ingreso.text, 
														lbl_usuario.text, 
														lbl_password.text,
														cmb_nacionalidad.selectedIndex.toString(),
														estado_foto)
	} 
	// si corresponde a una persona natural
	else if (cmb_tipo_entidad.selectedIndex == 0){
		if (lbl_nombre.text == "")
		{
			mx.controls.Alert.show("Indique los Nombres","Alerta");
			this.btn_guardar_registro.enabled = true;
		}
		else if (lbl_ap_paterno.text == "")
		{	
			mx.controls.Alert.show("Indique el Apellido Paterno","Alerta");
			this.btn_guardar_registro.enabled = true;
		}
		else if (lbl_ap_materno.text == "")
		{
			this.btn_guardar_registro.enabled = true;
			mx.controls.Alert.show("Indique el Apellido Materno","Alerta");
		}
		else if (lbl_fecha_nac.text == "")
		{
			mx.controls.Alert.show("Indique la Fecha de Nacimiento","Alerta");
			this.btn_guardar_registro.enabled = true;
		}
		else if (cmb_nacionalidad.selectedIndex == 0)
		{
			mx.controls.Alert.show("Indique la Nacionalidad", "Alerta");
			this.btn_guardar_registro.enabled = true;
		}
		else if (cmb_sexo.selectedIndex == 0)
		{
			mx.controls.Alert.show("Indique el Sexo", "Alerta");
			this.btn_guardar_registro.enabled = true;
		}
		else if (cmb_estado_civil.selectedIndex == 0)
		{
			mx.controls.Alert.show("Indique el Estado Civil", "Alerta");
			this.btn_guardar_registro.enabled = true;
		}
		else
			ro_ingreso_registro.agrega_entidad_persona(identificador, 
														lbl_ap_paterno.text, 
														lbl_ap_materno.text, 
														nombre, 
														lbl_fecha_ingreso.text, 
														lbl_usuario.text, 
														lbl_password.text, 
														lbl_fecha_nac.text, 
														cmb_nacionalidad.selectedIndex.toString(), 
														cmb_sexo.selectedIndex.toString(), 
														cmb_estado_civil.selectedIndex.toString(),
														estado_foto)
	}
}


//******************************************************************************************************
private function result_agrega_entidad_persona(event:ResultEvent):void
{	
	var i:int;
	if (event.result.length <1 )
		mx.controls.Alert.show("Ha ocurrido un error al guardar la entidad. Intente nuevamente","Error");
	else
	{	
		idn_entidad = event.result[0].campo_uno;
		
		if (dg_telefonos.dataProvider.length > 0)
			agregar_telefonos();
		if (dg_electronicos.dataProvider.length >0)
			agregar_electronicos();
		
		if (this.educacionales.length >0)
			agregar_educacionales();
		
		if (this.laborales.length >0)
			agregar_laborales();
		
		if (error_electronicos != 1 && error_fonos !=1 && error_laborales != 1 && error_educacionales != 1)
			ro_ingreso_registro.agrega_entidad_registro(idn_entidad, String(cmb_tipo_entidad.selectedItem.data));
		else
			{
			borrar_datos();
			mx.controls.Alert.show("Ha ocurrido un error al ingresar","Error");
			limpia_pantalla();
			}	
		if (error_registro_envio != 1 && error_direcciones != 1 && error_requisitos != 1){
			mx.controls.Alert.show("Registro Ingresado Exitosamente","Información");
			this.btn_guardar_registro.enabled = false;
		}
		else
			{
			borrar_datos();
			mx.controls.Alert.show("Ha ocurrido un error al ingresar","Error");
			limpia_pantalla();
			}
	}
		
}
//******************************************************************************************************
private function result_muestra_nacionalidad(event:ResultEvent):void
{ 
	cmb_nacionalidad.dataProvider=event.result;
}
//******************************************************************************************************
private function result_agrega_entidad_registro(event:ResultEvent):void
{
	var x:int;
	var i:int;
	var env_defecto:String;
	if (event.result.length <1 ){
		mx.controls.Alert.show("error al ingresar entidad_registro");
		borrar_datos();
	}
	else{
		idn_entidad_registro = event.result[0].campo_uno;
		
		for (i = 0; i < requisitos.length; i++){
			ro_ingreso_registro.agrega_requisito(idn_entidad_registro, requisitos[i].campo_dos, requisitos[i].campo_cinco, requisitos[i].campo_seis, requisitos[i].campo_siete);
		}
		
		for( x = 0; x < dg_direcciones.dataProvider.length ; x++ ){
			if (dg_direcciones.dataProvider[x].campo_once == "SI")
				env_defecto = "1";
			else
				env_defecto = "0";
			
			ro_ingreso_registro.agrega_registro_direccion(idn_entidad_registro, dg_direcciones.dataProvider[x].campo_uno, dg_direcciones.dataProvider[x].campo_nueve, env_defecto);
		}
		
		if (this.parentApplication.foto != null)
		{
			ro.doUpload(this.parentApplication.foto,idn_entidad,identificador);
		}

	}	
}
//******************************************************************************************************
private function handleResult(event:ResultEvent):void
{
	if (event.result!=""){
	//	this.ro_ingreso_registro.guarda_foto(idn_entidad);
			
		
	}else{
		
		Alert.show("Problemas de conexion al subir la foto , Inténtelo mas tarde")
	}
	
	
}

//******************************************************************************************************
private function result_guarda_foto(event:ResultEvent):void
{
	
}
//******************************************************************************************************
private function result_agrega_registro_direccion(event:ResultEvent):void
{	
	var x:int;
	if (event.result.length <1 )
		error_direcciones = 1;
	else{
//	mx.controls.Alert.show(idn_entidad_registro+ "/"+event.result[0].campo_uno+ "/"+event.result[0].campo_dos+ "/"+event.result[0].campo_tres);
		ro_ingreso_registro.agrega_entidad_registro_envio(idn_entidad_registro, event.result[0].campo_uno, event.result[0].campo_dos, event.result[0].campo_tres);
	}
}

//******************************************************************************************************
private function result_agrega_entidad_registro_envio(event:ResultEvent):void
{	
	var x:int;
	if (event.result.length <1 )
		error_registro_envio = 1;
}
//******************************************************************************************************
private function result_agrega_requisito(event:ResultEvent):void
{	
	if (event.result.length <1 ){
		error_requisitos = 1;
		mx.controls.Alert.show("Ocurrio un error al ingresar los requisitos","Alerta");
	}

	
}
//******************************************************************************************************
private function borrar_datos():void
{
	ro_ingreso_registro.elimina_datos(idn_entidad);
}

//******************************************************************************************************
private function agregar_electronicos():void
{
	var x:int;
	
	for( x = 0; x < dg_electronicos.dataProvider.length ; x++ ){
		ro_ingreso_registro.agrega_electronico(dg_electronicos.dataProvider[x].campo_uno, idn_entidad)
		}
}
//******************************************************************************************************
private function result_agrega_electronico(event:ResultEvent):void
{
	if (event.result.length <1 )
		error_electronicos = 1;
}

//******************************************************************************************************
private function agregar_educacionales():void
{
	var x:int;
	
	for( x = 0; x < this.educacionales.length ; x++ ){
		ro_ingreso_registro.agrega_educacional(educacionales[x].campo_uno, educacionales[x].campo_dos, educacionales[x].campo_cinco, educacionales[x].campo_seis, educacionales[x].campo_tres, idn_entidad)
	}
}
//******************************************************************************************************
private function result_agrega_educacional(event:ResultEvent):void
{
	if (event.result.length <1 )
		error_educacionales = 1;
}

//******************************************************************************************************
private function agregar_laborales():void
{
	var x:int;
	
	for( x = 0; x < this.laborales.length ; x++ ){
		ro_ingreso_registro.agrega_laboral(laborales[x].campo_tres,laborales[x].campo_cuatro,laborales[x].campo_cinco,laborales[x].campo_seis,laborales[x].campo_siete, idn_entidad)
	}
}
//******************************************************************************************************
private function result_agrega_laboral(event:ResultEvent):void
{
	if (event.result.length <1 )
		error_laborales = 1;
}
//******************************************************************************************************
private function agregar_telefonos():void
{
	var x:int;
	
	for( x = 0; x < dg_telefonos.dataProvider.length ; x++ ){
		ro_ingreso_registro.agrega_fono(idn_entidad,dg_telefonos.dataProvider[x].campo_uno)
	}
}
//******************************************************************************************************
private function result_agrega_fono(event:ResultEvent):void
{
	if (event.result.length <1 )
		error_fonos = 1;
}


//******************************************************************************************************
private function result_muestra_tipo_entidad(event:ResultEvent):void
{ 
	cmb_tipo_entidad.dataProvider=event.result;
}
//******************************************************************************************************
private function result_muestra_estado_civil(event:ResultEvent):void
{ 
	cmb_estado_civil.dataProvider=event.result;
}
//******************************************************************************************************
private function popup_agregar_direccion():void
{
	this.btn_direccion_envio.setFocus();
	var popup:frm_registro_admision_ingreso_registro_popup_direccion = frm_registro_admision_ingreso_registro_popup_direccion(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_direccion , true));
	mx.managers.PopUpManager.centerPopUp(popup);
}
//******************************************************************************************************
private function popup_requisitos():void
{
	if (this.cmb_tipo_entidad.selectedIndex == 0)
	{
		this.btn_antecedentes_laborales.setFocus();
	}
	else
	{
		this.btn_guardar_registro.setFocus();
	}
	var popup:frm_registro_admision_ingreso_registro_popup_requisitos = frm_registro_admision_ingreso_registro_popup_requisitos(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_requisitos , true));
	popup.pantalla = "ingreso";
	mx.managers.PopUpManager.centerPopUp(popup);
	
}
//******************************************************************************************************
private function popup_laborales():void
{
	this.btn_antecedentes_educacionales.setFocus();
	var popup:frm_registro_admision_ingreso_registro_popup_laborales = frm_registro_admision_ingreso_registro_popup_laborales(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_laborales , true));
	popup.pantalla = "ingreso";
	mx.managers.PopUpManager.centerPopUp(popup);
	
}
//******************************************************************************************************
private function popup_educacionales():void
{
	this.btn_guardar_registro.setFocus();
	var popup:frm_registro_admision_ingreso_registro_popup_educacionales = frm_registro_admision_ingreso_registro_popup_educacionales(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_educacionales , true));
	popup.pantalla = "ingreso";
	mx.managers.PopUpManager.centerPopUp(popup);
	
}
//******************************************************************************************************
private function popup_fotografia():void
{
	var popup:frm_registro_admision_foto_entidad = frm_registro_admision_foto_entidad(PopUpManager.createPopUp( this, frm_registro_admision_foto_entidad , true));
	popup.pantalla = "ingreso";
	popup.rut = identificador; 
	if (this.parentApplication.foto != null)
	{
		popup.foto_entidad = this.parentApplication.foto;
	}
	mx.managers.PopUpManager.centerPopUp(popup);
	
}
//******************************************************************************************************
private function popup_agregar_electronico():void
{
	this.btn_requisitos.setFocus();
	var popup:frm_registro_admision_ingreso_registro_popup_electronicos = frm_registro_admision_ingreso_registro_popup_electronicos(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_electronicos , true));
	mx.managers.PopUpManager.centerPopUp(popup);
		
}
//******************************************************************************************************
private function popup_agregar_fono():void
{
	this.btn_agregar_electronico.setFocus();	
	var popup:frm_registro_admision_ingreso_registro_popup_fonos = frm_registro_admision_ingreso_registro_popup_fonos(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_fonos , true));
	mx.managers.PopUpManager.centerPopUp(popup);
		
}
//******************************************************************************************************
public function levantar_fonos(codigo:String):void
{
	var popup:frm_registro_admision_ingreso_registro_popup_fonos = frm_registro_admision_ingreso_registro_popup_fonos(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_fonos , true));
	popup.cod_area = codigo;
	mx.managers.PopUpManager.centerPopUp(popup);
	
}
//******************************************************************************************************
private function btn_direccion_envio_click():void
{
	var x:int
	if (dg_direcciones.selectedItem == null)
		mx.controls.Alert.show("Debe seleccionar una dirección","Alerta")
	else
	{
		for( x = 0; x < dg_direcciones.dataProvider.length ; x++ ){
		
			if (x== dg_direcciones.selectedIndex){
				dg_direcciones.dataProvider[x].campo_once = "SI";
				envio_default = 1;
				}
			else
				dg_direcciones.dataProvider[x].campo_once = "NO";
		}
		this.btn_agregar_telefonico.setFocus();
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
private function btn_quitar_direccion_click():void
{
	dg_direcciones.dataProvider.removeItemAt(dg_direcciones.selectedIndex);
}

//******************************************************************************************************
private function btn_quitar_fono_click():void
{
	dg_telefonos.dataProvider.removeItemAt(dg_telefonos.selectedIndex);
}
//******************************************************************************************************
private function btn_quitar_electronico_click():void
{
	dg_electronicos.dataProvider.removeItemAt(dg_electronicos.selectedIndex);
}
 
//******************************************************************************************************
private function limpia_pantalla():void
{
	var fecha_actual:Date = new Date();
	this.cmb_tipo_entidad.enabled = true;
	lbl_fecha_ingreso.selectedDate = fecha_actual;
	dg_direcciones.dataProvider = null;
	dg_telefonos.dataProvider = null;
	dg_electronicos.dataProvider = null;
	this.cnv_antecedentes.visible = false;
	lbl_nombre.text = "";
	lbl_ap_paterno.text = "";
	lbl_ap_materno.text = "";
	lbl_usuario.text = "";
	lbl_password.text = "";
	lbl_fecha_nac.text = "";
	cmb_nacionalidad.selectedIndex = 0;
	cmb_sexo.selectedIndex = 0;
	cmb_estado_civil.selectedIndex = 0;
	cmb_tipo_entidad.selectedIndex = 0;
	this.requisitos = new ArrayCollection;
	this.educacionales = new ArrayCollection;
	this.laborales = new ArrayCollection;
	this.lbl_ap_paterno.visible = true;
	this.txt_ap_paterno.visible = true;
	this.lbl_ap_materno.visible = true;
	this.txt_ap_materno.visible = true;
	this.lbl_fecha_nac.visible = true;
	this.txt_fecha_nac.visible = true;
	this.cmb_sexo.visible = true;
	this.txt_sexo.visible = true;
	this.cmb_estado_civil.visible = true;
	this.txt_estado_civil.visible = true;
	
	

}
