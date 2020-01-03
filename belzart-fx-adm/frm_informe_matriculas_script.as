// ActionScript file
import flash.net.URLRequest;

import libreria.*;

import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import mx.collections.ArrayCollection;


private var func_mod_fun_idn:String;
private var mod_cam_idn:String;
private var rut_usuario:String;
public var url_frame:URLRequest;
//******************************************************************************************************
private function inicio():void
{
	func_mod_fun_idn = Application.application.parameters.func_mod_fun_idn;
//	rut_usuario = Application.application.parameters.par_rut;
	this.ro_informes_matriculas.busca_periodos();
	this.ro_informes_matriculas.busca_informes();
}

//***********************************************************************************************************
private function result_busca_periodos(event:ResultEvent):void
{
	if (event.result.length > 0)
	{
		this.cmb_periodos.dataProvider = event.result;
	}
	else
	{
		mx.controls.Alert.show("No se encontraron periodos","Alerta");
	}
	
}
//***********************************************************************************************************
private function result_busca_informes(event:ResultEvent):void
{
	if (event.result.length > 1)
	{
	//	this.tr_informes.dataProvider = event.result;
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
		
			arreglo_menu.addItem(o_seis_campos);
			
			if(arreglo_menu.length != 0)
			{
				tr_informes.dataProvider = devuelve_xml(arreglo_menu);
				
			}
			
			
		}
		
	}
	else
	{
		mx.controls.Alert.show("No se encontraron informes","Alerta");
	}
	
}

private function devuelve_xml(arreglo:ArrayCollection):XMLList
{
	var i:int;
	var menu_p:String="";
	
	var s_lista:String="<?xml version='1.0' encoding='utf-8'?>" + "\n";
	
	if(arreglo.length > 0)
	{
		for(i=0;i<arreglo.length;i++)
		{
			if(menu_p != String(arreglo[i].campo_tres))
			{
				if(i!=0)
				{
					s_lista = s_lista + "</nodes>" + "\n";
				}
				
				s_lista = s_lista + "<nodes label='" + String(arreglo[i].campo_tres) + "'>" + "\n";
				
				menu_p = String(arreglo[i].campo_tres);
			}
			
			s_lista = s_lista + "<node data='" + String(arreglo[i].campo_uno) + "' url='" + String(arreglo[i].campo_uno) + "' label='" + String(arreglo[i].campo_dos) + "' id='" +  String(arreglo[i].campo_uno) +  "' />" + "\n"
			
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
	
	
	
	
		if (url != "")
		{
			if (this.lbl_fecha_inicio.text != "" && this.cmb_periodos.selectedItem != null)
			{
			url_frame = new URLRequest("http://164.77.193.133/reportes_flex_net/" + url + "?fecha="+this.lbl_fecha_inicio.text + "&eje_ano="+this.cmb_periodos.selectedLabel);
			navigateToURL(url_frame, "_blank");	
			}
			else
			{
				mx.controls.Alert.show("Debe seleccionar fecha de corte y un año académico","Alerta");
			}
		}
		
	
}
//******************************************************************************************************
private function guardar_proceso():void
{
//	this.ro_informes_matriculas.guardar_proceso(this.cmb_procesos.selectedItem.data);
}
//***********************************************************************************************************
private function result_guarda_proceso(event:ResultEvent):void
{
	if (event.result.length > 0)
	{
		mx.controls.Alert.show("El proceso fue guardado exitosamente","Alerta");
	}
	else
	{
		mx.controls.Alert.show("El proceso no se pudo guardar","Alerta");
	}
	
}
//******************************************************************************************************
private function mostrar_reporte():void
{
/*	if (this.cmb_informes.selectedIndex > 0)
	{
		if (this.lbl_fecha_inicio.text != "")
		{
			url_frame = new URLRequest("http://164.77.193.133/reportes_flex_net/" + this.cmb_informes.selectedItem.data + "?fecha="+this.lbl_fecha_inicio.text);
			navigateToURL(url_frame, "_blank");
			this.cmb_informes.selectedIndex = 0;
		}
		else
		{
			mx.controls.Alert.show("Debe seleccionar fecha de corte","Alerta");
		}
	}*/
}

//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}

private function formatea_fecha(date:Date):String {
	return dfconv.format(date);
}  

//*******