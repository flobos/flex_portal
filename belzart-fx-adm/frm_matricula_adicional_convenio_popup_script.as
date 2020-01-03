import flash.events.KeyboardEvent;
import libreria.*;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
public var resultado:ResultEvent;
public var indice_motivo:int;
import flash.net.URLRequest;
import mx.core.Application;
import mx.rpc.events.FaultEvent;
import mx.events.ValidationResultEvent;
import mx.managers.*;
private var func_mod_fun_idn:String; 
private var v_arreglo_valida:Array;

//*************************************************************************************************************************************************
private function inicio_carga():void{
	dg_convenio.dataProvider=resultado.result;}

//*************************************************************************************************************************************************
private function btn_cancelar_click():void{
	PopUpManager.removePopUp(this);}

//*************************************************************************************************************************************************
private function btn_seleccionar_click():void{
	if (dg_convenio.selectedItem !=null){
		this.parentApplication.asigna_convenio(dg_convenio.selectedItem.campo_uno);
		this.parentApplication.asigna_convenio_nombre (dg_convenio.selectedItem.campo_dos + ' (' + dg_convenio.selectedItem.campo_tres + ' %)');
		this.parentApplication.f_guarda_descuento();
		PopUpManager.removePopUp(this);}
	else {
		mx.controls.Alert.show("Debe seleccionar un Convenio","Alerta");}} 

//*************************************************************************************************************************************************
private function result_guarda_datos_descuento(event:ResultEvent):void{
	if (event.result.length == 0 ){
		mx.controls.Alert.show("Error al Guardar los Datos.","Alerta");}}