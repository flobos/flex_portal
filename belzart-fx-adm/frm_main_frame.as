// ActionScript file
import flash.events.Event;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.managers.SystemManager;
import mx.rpc.events.*;
import mx.rpc.http.HTTPService;
private var flexURL:String;
private var xmlProperties:XML; 
private var servicePropReader:HTTPService; 

public var sub_entidad:int;
public var sub_fun_mod_idn:int
public var loadedSM:SystemManager;
public var rut_usuario:String;
public var rut_usuario_enc:String;
public var func_mod_fun_idn:String;
public var func_mod_fun_idn_enc:String;
public var mod_idn:String;
public var mod_idn_enc:String;

public var eje_aca_idn:String;

public function set_iFrame_visible():void{
	this.iFrame.visible = true;
}

public function sub_entidad_identificacion():void
{
	this.echoRO.return_sub_entidad_identificacion();
}

//***********************************************************************************************************
private function result_encriptador_modalidad(event:ResultEvent):void
{
	mod_idn_enc=String(event.result[0].campo_uno);
}
//***********************************************************************************************************
private function result_encriptador_rut(event:ResultEvent):void
{
	rut_usuario_enc=String(event.result[0].campo_uno);
}
//***********************************************************************************************************
private function result_encriptador_func(event:ResultEvent):void
{
	func_mod_fun_idn_enc=String(event.result[0].campo_uno);
	ro_frm_main_frame.encripta_mod_idn("Iplacex", String(mod_idn));
}
//***********************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");	
} 
//***********************************************************************************************************
private function inicio():void
{
	getProperties();
	this.pnl_principal.visible = false;
	var login:frm_identificacion=frm_identificacion(PopUpManager.createPopUp( this, frm_identificacion , true));
	mx.managers.PopUpManager.centerPopUp(login)
}
//***********************************************************************************************************
private function result_return_funcion_modalidad(event:ResultEvent):void
{
	ro_frm_main_frame.carga_menus_asignados(rut_usuario);
	func_mod_fun_idn=String(event.result[0].campo_uno);
	//func_mod_fun_idn = '46470';
	ro_frm_main_frame.encripta_func_mod_fun_idn("Iplacex", String(event.result[0].campo_uno));
	
	
	/*if(mod_idn != '100')
	{
		ro_frm_main_frame.muestra_ejecuciones_academicas(Number(func_mod_fun_idn));
		mx.controls.Alert.show("func_mod_fun_idn" + String(func_mod_fun_idn));
	}*/
}
//***********************************************************************************************************
/*private function result_muestra_ejecuciones_academicas(event:ResultEvent):void
{
	cmb_ramos.dataProvider =  event.result;
}*/
//***********************************************************************************************************
private function result_return_sub_entidad_identificacion(event:ResultEvent):void
{
	var popup1:frm_funcion_modalidad_popup = frm_funcion_modalidad_popup(PopUpManager.createPopUp( this, frm_funcion_modalidad_popup , true));
	mx.managers.PopUpManager.centerPopUp(popup1)
	                                                                                                                                                                                
	l_ent_reg_nombre.text = String(event.result[0].label);
	rut_usuario=event.result[0].data;
	this.ro_frm_main_frame.registro_login(rut_usuario);
	l_ent_reg_rut.text=rut_usuario;
	ro_frm_main_frame.encripta_rut("Iplacex", rut_usuario);
}
//***********************************************************************************************************
private function result_carga_menus_asignados(event:ResultEvent):void
{
	
	var arreglo1:Array
	
	
//--------------------------   ASIGNA RESULTADO A ARREGLO   -----------------------------	
	
	var arreglo_menu:ArrayCollection = new ArrayCollection;
	var x:int;

	for( x = 0; x < event.result.length ; x++ )
	{
		var o_seis_campos:obj_seis_campos = new obj_seis_campos;
		o_seis_campos.campo_uno = event.result[x].campo_uno
		o_seis_campos.campo_dos = event.result[x].campo_dos
		o_seis_campos.campo_tres = event.result[x].campo_tres
		o_seis_campos.campo_cuatro = event.result[x].campo_cuatro
		o_seis_campos.campo_cinco = event.result[x].campo_cinco
		o_seis_campos.campo_seis = event.result[x].campo_seis
		arreglo_menu.addItem(o_seis_campos);
	}
//------------------------------------------------------------------------------------------	

	if(arreglo_menu.length != 0)
	{
		tree_menu.dataProvider = devuelve_xml(arreglo_menu);
		tree_menu.enabled =  true;
		iFrame.source=flexURL+"flex/flex_ipx_adm/frm_adm_mensajeria.mxml?par_rut=" + rut_usuario + "&par_func_mod_fun_idn=" + func_mod_fun_idn_enc + "&par_eje=" + eje_aca_idn +"&par_mod_idn=" + mod_idn;
		
	}
	else
	{
 		mx.controls.Alert.show('Ud. no tiene menus asignados. Comuniquese con su Admnistrador de Sistema.', 'Información');
	}
 
	
	
}
//***********************************************************************************************************
private function devuelve_xml(arreglo:ArrayCollection):XMLList
{
	var i:int;
	var menu_p:String="";
	
	var s_lista:String="<?xml version='1.0' encoding='utf-8'?>" + "\n";
	
	if(arreglo.length > 0)
	{
		for(i=0;i<arreglo.length;i++)
		{
			if(menu_p != String(arreglo[i].campo_cuatro))
			{
				if(i!=0)
				{
					s_lista = s_lista + "</nodes>" + "\n";
				}
								
				s_lista = s_lista + "<nodes label='" + String(arreglo[i].campo_cuatro) + "'>" + "\n";
				
				menu_p = String(arreglo[i].campo_cuatro);
			}
			
			s_lista = s_lista + "<node data='" + String(arreglo[i].campo_seis) + "' url='" + String(arreglo[i].campo_cinco) + "' label='" + String(arreglo[i].campo_dos) + "' id='" +  String(arreglo[i].campo_uno) +  "' />" + "\n"
			
		}
		
		if(i!=0)
		{
			s_lista = s_lista + "</nodes>";
		}
	}
	return XMLList(s_lista);
}
//***********************************************************************************************************
[Bindable]
public var selectedNode:Object;
            
private function click_tree_menu(event:Event):void
{
	var url:String;
	var tip_menu:String;
	var menu_id:String;
	selectedNode = Tree(event.target).selectedItem;
	url=String(selectedNode.@url);
	tip_menu=String(selectedNode.@data);
	menu_id = String(selectedNode.@id);
	
	this.ro_frm_main_frame.registro_acceso_menu(String(selectedNode.@id), rut_usuario);
	
	if (url != "")
	{
		if (tip_menu=='12'){
			
			iFrame.source=String(url) + "?par_rut=" + rut_usuario + "&par_func_mod_fun_idn=" + func_mod_fun_idn_enc + "&par_eje=" + eje_aca_idn + "&par_mod=" + mod_idn_enc +"&func_mod_fun_idn=" + func_mod_fun_idn ;
		}
		else
			{
				iFrame.source=flexURL+"flex/flex_ipx_adm/" + String(url) + "?par_rut=" + rut_usuario + "&par_func_mod_fun_idn=" + func_mod_fun_idn_enc + "&par_eje=" + eje_aca_idn + "&par_mod=" + mod_idn_enc +"&func_mod_fun_idn=" + func_mod_fun_idn ;
			}	
		
	}
}
  
//***********************************************************************************************************
public function click_cambio_funcion():void
{
//	this.iFrame.removeAllChildren(); 
	iFrame.visible=false; 
	var popup1:frm_funcion_modalidad_popup = frm_funcion_modalidad_popup(mx.managers.PopUpManager.createPopUp(this, frm_funcion_modalidad_popup, true));
	mx.managers.PopUpManager.centerPopUp(popup1)  
}
//***********************************************************************************************************
public function click_mensaje():void
{
	iFrame.source= flexURL+"flex/flex_ipx_adm/frm_adm_mensajeria.mxml?par_rut=" + rut_usuario + "&par_func_mod_fun_idn=" + func_mod_fun_idn_enc + "&par_eje=" + eje_aca_idn ;
}

//*****************************************************************************************************
private function getProperties():void {
	servicePropReader = new HTTPService();
	servicePropReader.url = "assets/properties.xml";		
	servicePropReader.resultFormat = "e4x";					
	servicePropReader.contentType = "application/xml";
	
	servicePropReader.addEventListener(ResultEvent.RESULT, propertyReaderResultHandler);
	servicePropReader.send();								
}
//*****************************************************************************************************
private function propertyReaderResultHandler(event:ResultEvent):void {
	xmlProperties = XML(event.result);
	flexURL = xmlProperties.property.(name=="flexURL").value;

}	

