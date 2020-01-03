// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
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
private var direcciones_activar:ArrayCollection;
private var telefonos_eliminar:ArrayCollection;
public var telefonos_agregar:ArrayCollection;
private var electronicos_eliminar:ArrayCollection;
public var electronicos_agregar:ArrayCollection;
private var error_fonos:Number;
private var dir_envio_default:String;
private var ent_idn:String;
private var ent_nombre:String;
private var ent_reg_idn:String;
private var estado_foto:String;
private var tip_ent_nombre:String;
private var hay_foto:Boolean = false;
public var requisitos:ArrayCollection = new ArrayCollection;
public var educacionales:ArrayCollection = new ArrayCollection;
public var laborales:ArrayCollection = new ArrayCollection;
[Bindable]
public var identificador:String;
public var id_entidad:String;
//*******************************************************************************************************
private function inicio():void
{
	limpia_pantalla();
	ro_ingreso_registro.muestra_estado_civil();
	ro_ingreso_registro.muestra_nacionalidad();
	llena_combo_sexo();
	ro_modifica_registro.busca_entidad(identificador, id_entidad);

}
//*******************************************************************************************************
public function seleccionar_ultima_direccion():void
{
	if (this.dg_direcciones.dataProvider.length > 0)
	{
		this.dg_direcciones.selectedIndex = this.dg_direcciones.dataProvider.length - 1;
	}
	this.btn_direccion_envio.setFocus();
}
//******************************************************************************************************
public function levantar_fonos(codigo:String):void
{
	var popup:frm_registro_admision_ingreso_registro_popup_fonos = frm_registro_admision_ingreso_registro_popup_fonos(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_fonos , true));
	popup.cod_area = codigo;
	mx.managers.PopUpManager.centerPopUp(popup);
}
//******************************************************************************************************
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

//******************************************************************************************************
private function popup_requisitos():void
{
	var popup:frm_registro_admision_ingreso_registro_popup_requisitos = frm_registro_admision_ingreso_registro_popup_requisitos(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_requisitos , true));
	popup.pantalla = "modifica";
	mx.managers.PopUpManager.centerPopUp(popup);
	
}
//***********************************************************************************************************
private function ver_foto():void
{
	var popup:frm_registro_admision_foto_entidad = frm_registro_admision_foto_entidad(PopUpManager.createPopUp( this, frm_registro_admision_foto_entidad , true));
	popup.pantalla = "modifica";
	popup.id_entidad = this.ent_idn;
	popup.rut = this.identificador; 
	popup.tiene_foto = this.hay_foto;
	if (this.parentApplication.foto != null)
	{
		popup.foto_entidad = this.parentApplication.foto;
	}
	mx.managers.PopUpManager.centerPopUp(popup);
}

//***********************************************************************************************************
private function result_busca_entidades(event:ResultEvent):void
{	
	ent_idn = event.result[0].campo_uno;
	ent_nombre = event.result[0].campo_dos;
	ent_reg_idn = event.result[0].campo_tres;
	tip_ent_nombre = event.result[0].campo_cuatro;
	
	if (event.result[0].campo_cinco == '1')
	{
		hay_foto = true;
	}
	
	ro_modifica_registro.busca_requisitos(ent_reg_idn);
	ro_modifica_registro.busca_educacionales(ent_idn);
	ro_modifica_registro.busca_laborales(ent_idn);
	ro_modifica_registro.busca_datos_personales(ent_reg_idn);
	ro_modifica_registro.busca_direcciones(ent_reg_idn);
	ro_modifica_registro.busca_fonos(ent_idn);
	ro_modifica_registro.busca_electronicos(ent_idn);
	limpia_pantalla();
}
//***********************************************************************************************************
private function result_agrega_requisito(event:ResultEvent):void
{
}
//***********************************************************************************************************
private function result_quitar_requisito(event:ResultEvent):void
{
}
//***********************************************************************************************************
private function result_agrega_educacional(event:ResultEvent):void
{
}
//***********************************************************************************************************
private function result_agrega_laboral(event:ResultEvent):void
{
}
//***********************************************************************************************************
private function result_quitar_educacional(event:ResultEvent):void
{
}
//***********************************************************************************************************
private function result_quitar_laboral(event:ResultEvent):void
{
}
//***********************************************************************************************************
private function result_busca_datos_personales(event:ResultEvent):void
{
	this.lbl_nombre.text = event.result[0].campo_uno;
	this.lbl_ap_paterno.text = event.result[0].campo_dos;
	this.lbl_ap_materno.text = event.result[0].campo_tres;
	this.lbl_usuario.text = event.result[0].campo_cinco;
	this.lbl_password.text = event.result[0].campo_seis;
	this.lbl_fecha_nac.text = event.result[0].campo_siete;
	this.cmb_nacionalidad.selectedIndex = event.result[0].campo_ocho;
	this.cmb_sexo.selectedIndex = event.result[0].campo_nueve;
	this.cmb_estado_civil.selectedIndex = event.result[0].campo_diez;
}
//***********************************************************************************************************
private function result_busca_requisitos(event:ResultEvent):void
{
	var i:int;
	
	if (event.result.length > 0)
	{
		var obj:obj_ocho_campos;
		for (i=0; i< event.result.length; i++)
		{
			obj = new obj_ocho_campos;
			obj.campo_uno = event.result[i].campo_uno;
			obj.campo_dos = event.result[i].campo_dos;
			obj.campo_tres = event.result[i].campo_tres;
			obj.campo_cuatro = event.result[i].campo_cuatro;
			obj.campo_cinco = event.result[i].campo_cinco;
			obj.campo_seis = event.result[i].campo_seis;
			obj.campo_siete = event.result[i].campo_siete;
			obj.campo_ocho = event.result[i].campo_ocho;
			requisitos.addItem(obj);
		}
	}
}
//***********************************************************************************************************
private function result_busca_educacionales(event:ResultEvent):void
{
	var i:int;
	
	if (event.result.length > 0)
	{
		var obj:obj_ocho_campos;
		for (i=0; i< event.result.length; i++)
		{
			obj = new obj_ocho_campos;
			obj.campo_uno = event.result[i].campo_uno;
			obj.campo_dos = event.result[i].campo_dos;
			obj.campo_tres = event.result[i].campo_tres;
			obj.campo_cuatro = event.result[i].campo_cuatro;
			obj.campo_cinco = event.result[i].campo_cinco;
			obj.campo_seis = event.result[i].campo_seis;
			obj.campo_siete = event.result[i].campo_siete;
			obj.campo_ocho = event.result[i].campo_ocho;
			educacionales.addItem(obj);
		}
	}
}

//***********************************************************************************************************
private function result_busca_laborales(event:ResultEvent):void
{
	var i:int;
	
	if (event.result.length > 0)
	{
		var obj:obj_siete_campos;
		for (i=0; i< event.result.length; i++)
		{
			obj = new obj_siete_campos;
			obj.campo_uno = event.result[i].campo_uno;
			obj.campo_dos = event.result[i].campo_dos;
			obj.campo_tres = event.result[i].campo_tres;
			obj.campo_cuatro = event.result[i].campo_cuatro;
			obj.campo_cinco = event.result[i].campo_cinco;
			obj.campo_seis = event.result[i].campo_seis;
			obj.campo_siete = event.result[i].campo_siete;
			laborales.addItem(obj);
		}
	}
}
//***********************************************************************************************************
private function result_busca_direcciones(event:ResultEvent):void
{
	var x:Number;
	var arreglo:ArrayCollection = new ArrayCollection;
	
	for (x = 0; x < event.result.length; x++)
	{
		var o_dieciseis_campos:obj_dieciseis_campos = new obj_dieciseis_campos;
		o_dieciseis_campos.campo_uno = event.result[x].campo_uno;
		o_dieciseis_campos.campo_dos = event.result[x].campo_dos;
		o_dieciseis_campos.campo_tres = event.result[x].campo_tres;
		o_dieciseis_campos.campo_cuatro = event.result[x].campo_cuatro;
		o_dieciseis_campos.campo_cinco = event.result[x].campo_cinco;
		o_dieciseis_campos.campo_seis = event.result[x].campo_seis;
		o_dieciseis_campos.campo_siete = event.result[x].campo_siete;
		o_dieciseis_campos.campo_ocho = event.result[x].campo_ocho;
		o_dieciseis_campos.campo_nueve = event.result[x].campo_nueve;
		o_dieciseis_campos.campo_diez = event.result[x].campo_diez;
		o_dieciseis_campos.campo_once = event.result[x].campo_once;
		o_dieciseis_campos.campo_doce = event.result[x].campo_doce;
		o_dieciseis_campos.campo_trece = event.result[x].campo_trece;
		o_dieciseis_campos.campo_catorce = event.result[x].campo_catorce;
		o_dieciseis_campos.campo_quince = event.result[x].campo_quince;
		
		arreglo.addItem(o_dieciseis_campos);
	}
	
	
	dg_direcciones.dataProvider = arreglo;
}

//***********************************************************************************************************
private function entidades_click( e:ListEvent ):void {
//	mx.controls.Alert.show(this.dg_alumnos.selectedItem.campo_uno);

}
//******************************************************************************************************
/*private function borrar_datos():void
{
	ro_ingreso_registro.elimina_datos(idn_entidad);
}*/

//******************************************************************************************************
private function result_desencriptar_func_mod_fun_idn(event:ResultEvent):void
{
	func_mod_fun_idn = event.result[0].campo_uno;
}
//******************************************************************************************************
private function result_muestra_nacionalidad(event:ResultEvent):void
{ 
	cmb_nacionalidad.dataProvider=event.result;
}
//******************************************************************************************************
private function result_busca_electronicos(event:ResultEvent):void
{ 
	dg_electronicos.dataProvider=event.result;
}
//******************************************************************************************************
private function result_busca_fonos(event:ResultEvent):void
{ 
	dg_telefonos.dataProvider=event.result;
}
//******************************************************************************************************
private function result_muestra_estado_civil(event:ResultEvent):void
{ 
	cmb_estado_civil.dataProvider=event.result;
}
//******************************************************************************************************
private function popup_agregar_direccion():void
{
	var popup:frm_registro_admision_ingreso_registro_popup_direccion = frm_registro_admision_ingreso_registro_popup_direccion(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_direccion , true));
	popup.pantalla = "modifica";
	mx.managers.PopUpManager.centerPopUp(popup);
		
}
//******************************************************************************************************
private function popup_agregar_electronico():void
{
	var popup:frm_registro_admision_ingreso_registro_popup_electronicos = frm_registro_admision_ingreso_registro_popup_electronicos(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_electronicos , true));
	mx.managers.PopUpManager.centerPopUp(popup);
		
}
//******************************************************************************************************
private function popup_agregar_fono():void
{
	var popup:frm_registro_admision_ingreso_registro_popup_fonos = frm_registro_admision_ingreso_registro_popup_fonos(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_fonos , true));
	mx.managers.PopUpManager.centerPopUp(popup);
		
}
 
//******************************************************************************************************
private function btn_direccion_envio_click():void
{
	var x:int
	if ((dg_direcciones.selectedItem == null)||((dg_direcciones.selectedItem.campo_quince != "Activa")&&(dg_direcciones.selectedItem.campo_quince != "Por Activar")))
		mx.controls.Alert.show("Debe seleccionar una dirección activa o por activar","Alerta")
	else
		for( x = 0; x < dg_direcciones.dataProvider.length ; x++ ){
			if (x== dg_direcciones.selectedIndex){
				dg_direcciones.dataProvider[x].campo_once = "SI";
				envio_default = 1;
				dir_envio_default = dg_direcciones.dataProvider[x].campo_uno;
				}
			else
				dg_direcciones.dataProvider[x].campo_once = "NO";
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
	if (dg_direcciones.selectedItem.campo_once == "SI"){
		mx.controls.Alert.show("No puede desactivar la dirección de envío","Alerta");
	}
	else
	{
		if (dg_direcciones.selectedItem.campo_quince =="Activa")
		{
			if (dg_direcciones.selectedItem.campo_trece != "D"){
//			
//			dg_direcciones.selectedItem.campo_catorce;
			direcciones_eliminar.addItem(dg_direcciones.selectedItem.campo_uno);
			dg_direcciones.selectedItem.campo_quince = "Por desactivar";
			}
			else
			{
			
				dg_direcciones.selectedItem.campo_quince = "Por desactivar";
			}	
		}
		else
		{
			mx.controls.Alert.show("Solo puede desactivar una dirección activa","Alerta");
		}
	}
}

//******************************************************************************************************
private function btn_quitar_fono_click():void
{
	if (dg_telefonos.selectedItem.campo_cinco =="Activo")
	{
		telefonos_eliminar.addItem(dg_telefonos.selectedItem.campo_uno);
		dg_telefonos.selectedItem.campo_cinco = "Por desactivar";
		dg_telefonos.dataProvider.refresh();
	}
	else
	{
		mx.controls.Alert.show("Solo puede desactivar un Fono activo","Alerta");
	}
		
}
//******************************************************************************************************
private function btn_quitar_electronico_click():void
{
	if (dg_electronicos.selectedItem.campo_cuatro =="Activo")
	{	
		electronicos_eliminar.addItem(dg_electronicos.selectedItem.campo_uno);
		dg_electronicos.selectedItem.campo_cuatro = "Por desactivar";
		dg_electronicos.dataProvider.refresh();
	}
	else
	{
		mx.controls.Alert.show("Solo puede desactivar un Contacto Electrónico activo","Alerta");
	}
}
private function guardar_direccion_fono_electronico():void
{
	var x:int;
	var env_defecto:String;
	
	
//	mx.controls.Alert.show(educacionales.length.toString(),"alsd");
	
	for( x = 0; x < requisitos.length ; x++ ){
		if (requisitos[x].campo_uno == "N")
		{
			ro_modifica_registro.agrega_requisito(ent_reg_idn, requisitos[x].campo_dos, requisitos[x].campo_cinco, requisitos[x].campo_seis, requisitos[x].campo_siete);	
		}
	}
	
	for( x = 0; x < educacionales.length ; x++ ){
		if (educacionales[x].campo_siete == "N")
		{
			ro_modifica_registro.agrega_educacional(educacionales[x].campo_uno, educacionales[x].campo_dos, educacionales[x].campo_cinco, educacionales[x].campo_seis, educacionales[x].campo_tres, this.ent_idn)
		}
	}
	
	for( x = 0; x < laborales.length ; x++ ){
		if (laborales[x].campo_uno == "N")
		{
			ro_modifica_registro.agrega_laboral(laborales[x].campo_tres, laborales[x].campo_cuatro, laborales[x].campo_cinco, laborales[x].campo_seis, laborales[x].campo_siete, this.ent_idn)
		}
	}
	
	for( x = 0; x < requisitos.length ; x++ ){
		if (requisitos[x].campo_cuatro == "A eliminar")
		{
			ro_modifica_registro.quitar_requisito(requisitos[x].campo_uno);	
		}
	}
	
	for( x = 0; x < educacionales.length ; x++ ){
		if (educacionales[x].campo_cuatro == "A eliminar")
		{
			ro_modifica_registro.quitar_educacional(educacionales[x].campo_ocho);	
		}
	}
	
	for( x = 0; x < laborales.length ; x++ ){
		if (laborales[x].campo_cuatro == "A eliminar")
		{
			ro_modifica_registro.quitar_laboral(laborales[x].campo_dos);	
		}
	}
	
	for( x = 0; x < direcciones_eliminar.length ; x++ ){
		ro_modifica_registro.elimina_direccion(ent_reg_idn,direcciones_eliminar[x].toString());
	}
	
	
	for( x = 0; x < dg_direcciones.dataProvider.length ; x++ ){
		if (dg_direcciones.dataProvider[x].campo_trece == "D")
		{
			if (dg_direcciones.dataProvider[x].campo_once == "SI")
				env_defecto = "1";
			else
				env_defecto = "0";
			ro_modifica_registro.agrega_direccion(ent_reg_idn,dg_direcciones.dataProvider[x].campo_uno, dg_direcciones.dataProvider[x].campo_nueve, env_defecto);
		}
	}
	
	
	for( x = 0; x < telefonos_agregar.length ; x++ ){
		ro_ingreso_registro.agrega_fono(ent_idn,telefonos_agregar[x].toString());
	}
	
	for( x = 0; x < telefonos_eliminar.length ; x++ ){
		ro_modifica_registro.elimina_telefono(telefonos_eliminar[x].toString());
	}
	
	for( x = 0; x < electronicos_agregar.length ; x++ ){
		ro_ingreso_registro.agrega_electronico(electronicos_agregar[x].toString(),ent_idn);
	}
	
	for( x = 0; x < electronicos_eliminar.length ; x++ ){
		ro_modifica_registro.elimina_electronico(electronicos_eliminar[x].toString());
	}
	
	
	if (envio_default == 1){
		ro_modifica_registro.establece_direccion_default(dir_envio_default,ent_reg_idn);
	}
	
}
//******************************************************************************************************
private function btn_guardar_click():void
{	
	if (this.parentApplication.foto != null)
	{
		estado_foto = "1";
		ro.doUpload(this.parentApplication.foto,ent_idn,identificador);
	}
	
	
	if (tip_ent_nombre == "Pers. Jurídica")
	{
		if (lbl_nombre.text == "")
			mx.controls.Alert.show("Indique el Nombre de la Institución","Alerta");
		else
			ro_modifica_registro.modifica_entidad_empresa(ent_idn,
												identificador, 
												lbl_nombre.text, 
												lbl_usuario.text, 
												lbl_password.text,
												estado_foto);
	}
	else{
		if (lbl_nombre.text == "")
			mx.controls.Alert.show("Indique los Nombres","Alerta");
		else if (lbl_ap_paterno.text == "")
			mx.controls.Alert.show("Indique el Apellido Paterno","Alerta");
		else if (lbl_ap_materno.text == "")
			mx.controls.Alert.show("Indique el Apellido Materno","Alerta");	
		else if (lbl_fecha_nac.text == "")
			mx.controls.Alert.show("Indique la Fecha de Nacimiento","Alerta");
		else if (cmb_nacionalidad.selectedIndex == 0)
			mx.controls.Alert.show("Indique la Nacionalidad", "Alerta");
		else if (cmb_sexo.selectedIndex == 0)
			mx.controls.Alert.show("Indique el Sexo", "Alerta");		
		else if (cmb_estado_civil.selectedIndex == 0)
			mx.controls.Alert.show("Indique el Estado Civil", "Alerta");				
		else
		ro_modifica_registro.modifica_entidad_persona(ent_idn,
												identificador, 
												lbl_ap_paterno.text, 
												lbl_ap_materno.text, 
												lbl_nombre.text, 
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
private function result_agrega_fono(event:ResultEvent):void
{
	if (event.result.length <1 )
		error_fonos = 1;
}
//******************************************************************************************************
private function result_establece_direccion_default(event:ResultEvent):void
{
}
//******************************************************************************************************
private function result_agrega_electronico(event:ResultEvent):void
{
}
//******************************************************************************************************
private function result_agrega_direccion(event:ResultEvent):void
{
}

//******************************************************************************************************

private function result_modifica_entidad(event:ResultEvent):void {
	guardar_direccion_fono_electronico();
    mx.controls.Alert.show("Registro Modificado","Información");
    limpia_pantalla();
 } 

//******************************************************************************************************
private function popup_laborales():void
{
	var popup:frm_registro_admision_ingreso_registro_popup_laborales = frm_registro_admision_ingreso_registro_popup_laborales(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_laborales , true));
	popup.pantalla = "modifica";
	mx.managers.PopUpManager.centerPopUp(popup);
	
}
//******************************************************************************************************
private function popup_educacionales():void
{
	var popup:frm_registro_admision_ingreso_registro_popup_educacionales = frm_registro_admision_ingreso_registro_popup_educacionales(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_registro_popup_educacionales , true));
	popup.pantalla = "modifica";
	mx.managers.PopUpManager.centerPopUp(popup);
	
}
 //******************************************************************************************************
private function limpia_pantalla():void
{
	
	pantalla = "modifica";
	direcciones_eliminar = new ArrayCollection;
	direcciones_activar = new ArrayCollection;
	telefonos_eliminar = new ArrayCollection;
	telefonos_agregar = new ArrayCollection;
	electronicos_eliminar = new ArrayCollection;
	electronicos_agregar = new ArrayCollection;
	this.requisitos = new ArrayCollection;

	var fecha_actual:Date = new Date();
	
	dg_direcciones.dataProvider = null;
	dg_telefonos.dataProvider = null;
	dg_electronicos.dataProvider = null;
	
	lbl_nombre.text = "";
	lbl_ap_paterno.text = "";
	lbl_ap_materno.text = "";
	lbl_usuario.text = "";
	lbl_password.text = "";
	lbl_fecha_nac.text = "";
	cmb_nacionalidad.selectedIndex = 0;
	cmb_sexo.selectedIndex = 0;
	cmb_estado_civil.selectedIndex = 0;
	
	if (tip_ent_nombre == "Pers. Jurídica")
	{
		this.txt_sexo.visible = false;
		this.cmb_sexo.visible = false;
		this.text_ap_materno.visible = false;
		this.lbl_ap_materno.visible = false;
		this.text_ap_paterno.visible = false;
		this.lbl_ap_paterno.visible = false;
		this.text_est_civil.visible = false;
		this.cmb_estado_civil.visible = false;
		this.text_fecha_nac.visible = false;
		this.lbl_fecha_nac.visible = false;
		this.btn_antecedentes_laborales.visible = false;
		this.btn_ver_foto.visible = false;
		this.btn_antecedentes_educacionales.visible = false;
	}
	
	
}
