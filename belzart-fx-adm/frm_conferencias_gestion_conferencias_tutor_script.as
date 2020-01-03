// ActionScript file
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DateField;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

public var func_mod_fun_idn:String;
public var conf_idn:String;
private var eje_aca_selec:String;
private var conf_selec:String;
public static const millisecondsPerMinute:int = 1000 * 60;

public var url_frame:URLRequest;
//*******************************************************************************************************
public function inicio():void
{
//	limpiar_pantalla();
	func_mod_fun_idn = Application.application.parameters.func_mod_fun_idn;
//	func_mod_fun_idn = '46098'
//	ro_desencripta.desencriptar_func_mod_fun_idn("Iplacex", par_func_mod_fun_idn);
//	ro_gestion_conferencias.muestra_conferencias(func_mod_fun_idn);
	
	ds.fill(conferencias_disp,"by_func_dia",func_mod_fun_idn);
	ds.fill(conferencias_activas,"by_func_activas",func_mod_fun_idn);
	ds.fill(conferencias_futuras,"by_func_futuras",func_mod_fun_idn);
}
//*******************************************************************************************************
public function commit_conferencia():void
{
	this.conferencias_disp[this.dg_conferencias_dia.selectedIndex].campo_doce = "2";
	ds.commit();
}

//***********************************************************************************************************
private function dg_conferencias_click():void
{
	if (dg_conferencias_dia.selectedItem.campo_doce == 1)
	{
		
		this.btn_iniciar_conferencia.enabled = true;
	}
	else
	{
		this.btn_iniciar_conferencia.enabled = false;
	}
}
//***********************************************************************************************************

private function ver_ramos_asociados_click():void
{
	if (this.dg_conferencias.selectedItem != null)
	{
		this.ro_gestion_conferencias.muestra_ramos_asociados(this.dg_conferencias.selectedItem.campo_uno);
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar una conferencia","Alerta");
	}
}

//******************************************************************************************************
private function btn_ver_todas():void
{
	
	var popup:frm_conferencias_gestion_conferencias_tutor_popup_todas = frm_conferencias_gestion_conferencias_tutor_popup_todas(PopUpManager.createPopUp( this, frm_conferencias_gestion_conferencias_tutor_popup_todas , true));
	mx.managers.PopUpManager.centerPopUp(popup);
	
}
//***********************************************************************************************************
private function finalizar_conferencia():void
{
	if (this.dg_conferencias_activas.selectedItem != null)
	{
		this.conferencias_activas[this.dg_conferencias_activas.selectedIndex].campo_doce = "3";
		ds.commit();
		if (this.dg_conferencias_activas.dataProvider.length == 0)
		{
			this.btn_finalizar_conferencia.enabled = false;	
		}
		
		inicio();
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar una conferencia para finalizar","Alerta");
	}
	
	
	
	
}
//***********************************************************************************************************
private function iniciar_conferencia():void
{
	this.ro_gestion_conferencias.obtener_hora_servidor();
}
//***********************************************************************************************************
 private function result_obtener_hora_servidor(event:ResultEvent):void{

	 
	 if (event.result.length >0 )
	 {
		 var hora_actual:String;
		 var min_actual:String;
		 var hora_ini:String;
		 var min_ini:String;
		 var max_hora_ini:String;
		 var max_min_ini:String;
		 
		 hora_actual = event.result[0].data;
		 min_actual = event.result[0].label;
		 hora_ini = dg_conferencias_dia.selectedItem.campo_siete;
		 min_ini = dg_conferencias_dia.selectedItem.campo_ocho;
		 max_hora_ini = dg_conferencias_dia.selectedItem.campo_diez;
		 max_min_ini = dg_conferencias_dia.selectedItem.campo_once;
		 
		 
		 if (int(hora_actual) < 10) hora_actual = "0" + hora_actual;
		 if (int(min_actual) < 10) min_actual = "0" + min_actual;
		 if (int(hora_ini) < 10) hora_ini = "0" + hora_ini;
		 if (int(min_ini) < 10) min_ini = "0" + min_ini;
		 if (int(max_hora_ini) < 10) max_hora_ini = "0" + max_hora_ini;
		 if (int(max_min_ini) < 10) max_min_ini = "0" + max_min_ini;
		
		 if (  (int(hora_ini)*60 + int(min_ini)) <= (int(hora_actual)*60 + int(min_actual) ))
		 {
			if ( (int(max_hora_ini)*60 + int(max_min_ini)) > (int(hora_actual)*60 + int(min_actual) )) 
			{
				
				this.btn_finalizar_conferencia.enabled = true;
				conf_idn = this.dg_conferencias_dia.selectedItem.campo_uno;
				var popup:frm_video_conferencia_tutor = frm_video_conferencia_tutor(PopUpManager.createPopUp( this, frm_video_conferencia_tutor , true));
				popup.sala = this.conf_idn;
				popup.func_mod_fun_idn = this.func_mod_fun_idn;
				mx.managers.PopUpManager.centerPopUp(popup);
			//	url_frame = new URLRequest("http://164.77.193.131:8100/lcds/belzart-fx-adm/frm_video_conferencia_tutor.html#view=" + this.conf_idn+"&func="+this.func_mod_fun_idn);
		//		url_frame = new URLRequest("http://164.77.193.131:8500/lcds/belzart-fx-adm/frm_video_conferencia_tutor.html#view=" + this.conf_idn+"&func="+this.func_mod_fun_idn);
		//		navigateToURL(url_frame, "_blank");	
				commit_conferencia();
			}
			else
			{
				mx.controls.Alert.show("La hora actual del servidor es: " + hora_actual + ":" + min_actual + " - Ha expirado la hora máxima de inicio","Alerta" );
			}
		 }
		 else
		 {
			 mx.controls.Alert.show("La hora actual del servidor es: " + hora_actual + ":" + min_actual + " - Espere hasta las " + hora_ini + ":" +  min_ini,"Alerta" );
		 }
	 }
	 else
	 {
		 mx.controls.Alert.show("Ocurrió un error al comprobar la hora del servidor","Error");
	 }
 }
//***********************************************************************************************************
private function result_desencriptar_func_mod_fun_idn(event:ResultEvent):void{
	var arreglo1:Object;
	
	arreglo1 = event.result; 
//	func_mod_fun_idn=arreglo1[0].campo_uno
//	func_mod_fun_idn = '46470'
	ro_gestion_conferencias.muestra_conferencias(func_mod_fun_idn);
	
	ds.fill(conferencias_disp,"by_func_dia",func_mod_fun_idn);
	ds.fill(conferencias_activas,"by_func_activas",func_mod_fun_idn);
	ds.fill(conferencias_futuras,"by_func_futuras",func_mod_fun_idn);
//	ds.fill(conferencias, 'by_func', {func_mod_fun_idn: func_mod_fun_idn})
//	ro_gestion_conferencias.muestra_conferencias_dia(func_mod_fun_idn);
}
private function actualizar(event:ResultEvent):void{
	
//	this.dg_conferencias_dia.dataProvider = event.result;
//	mx.controls.Alert.show(event.result.length);
}


//***********************************************************************************************************
private function result_muestra_conferencias(event:ResultEvent):void
{
	if (event.result.length >0 )
	{
		this.dg_conferencias.dataProvider = event.result;
	}
}
//******************************************************************************************************
private function limpiar_pantalla():void
{
	this.dg_conferencias.dataProvider = null;
	this.btn_iniciar_conferencia.enabled = false;
	this.dg_conferencias_dia.dataProvider = null;
}

//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}