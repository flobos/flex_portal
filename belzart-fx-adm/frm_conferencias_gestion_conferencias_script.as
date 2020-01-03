// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

public var func_mod_fun_idn:String;
private var conf_idn:String;
private var eje_aca_selec:String;
private var conf_selec:String;

//*******************************************************************************************************
private function inicio():void
{
	
	var par_func_mod_fun_idn:String = Application.application.parameters.par_func_mod_fun_idn;
	ro_desencripta.desencriptar_func_mod_fun_idn("Iplacex", par_func_mod_fun_idn);

	ro_gestion_conferencias.muestra_ejecuciones();
}

//*****************************************************
private function result_desencriptar_func_mod_fun_idn(event:ResultEvent):void{
	var arreglo1:Object;
	
	arreglo1 = event.result; 
	func_mod_fun_idn=arreglo1[0].campo_uno
	func_mod_fun_idn = '46470'
}

//***********************************************************************************************************
private function result_buscar_conferencias(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No se han encontrado conferencias para el día especificado","Alerta");
	}
	else
	{
		this.rp_conferencias.dataProvider = event.result;
	}
}
//***********************************************************************************************************
private function result_muestra_ejecuciones(event:ResultEvent):void
{
	if (event.result.length > 0)
	{
		this.cmb_ejecuciones.dataProvider = event.result;
		limpiar_pantalla();
	}
	else
	{
		mx.controls.Alert.show("No se encontraron ejecuciones activas","ERROR");
	}
}

//***********************************************************************************************************
private function cmb_ejecuciones_change():void
{
	this.dg_cursos.dataProvider = null;
	this.rp_conferencias.dataProvider = null;
	if (this.cmb_ejecuciones.selectedIndex > 0)
		
	{
		ro_gestion_conferencias.muestra_cursos(this.cmb_ejecuciones.selectedItem.data);
	}
}
//***********************************************************************************************************
private function buscar_conferencias():void
{
	if (this.dg_cursos.selectedItem != null)
	{
		ro_gestion_conferencias.muestra_conferencias(this.dg_cursos.selectedItem.campo_uno);
	}
	else
	{
		this.rp_conferencias.dataProvider = null;
	}
}
//***********************************************************************************************************
private function result_muestra_cursos(event:ResultEvent):void
{
	if (event.result.length > 0)
	{
		this.dg_cursos.dataProvider = event.result;
	}
	else
	{
		mx.controls.Alert.show("No se encontraron ejecuciones académicas asociadas a la ejecución seleccionada","ERROR");
	}
}
//***********************************************************************************************************
private function result_muestra_conferencias(event:ResultEvent):void
{
	if (event.result.length > 0)
	{
		this.rp_conferencias.dataProvider = event.result;
	}
	else
	{
		mx.controls.Alert.show("No se encontraron conferencias asociadas","Alerta");
		this.rp_conferencias.dataProvider = null;
	}
}
//***********************************************************************************************************
private function btn_eliminar_click(evento:Event):void
{
	var item:Object=evento.currentTarget.getRepeaterItem();
	conf_selec = item.campo_uno;
	mx.controls.Alert.show("¿Realmente desea eliminar la Conferencia?", "Eliminar Conferencia", 3, this, eliminar_conferencia);
}
//******************************************************************************************************
private function eliminar_conferencia(event:CloseEvent):void 
{
	if (event.detail==Alert.YES)
	{
		mx.controls.Alert.show("¿Desea eliminar la Conferencia para todos los cursos?", "Eliminar Conferencia", 3, this, eliminar_conferencia_ejecuciones);
	}
}	
//******************************************************************************************************
private function eliminar_conferencia_ejecuciones(event:CloseEvent):void 
{
	if (event.detail==Alert.YES)
	{
		ro_gestion_conferencias.elimina_conferencia(conf_selec)
	}
	else
	{
		ro_gestion_conferencias.elimina_conferencia_eje_aca(conf_selec, dg_cursos.selectedItem.campo_uno)
	}
}
//***********************************************************************************************************
private function result_elimina_conferencia(event:ResultEvent):void
{
		mx.controls.Alert.show("La Conferencia fue eliminada","Alerta");
		limpiar_pantalla();
}
//***********************************************************************************************************
private function result_elimina_conferencia_eje_aca(event:ResultEvent):void
{
	mx.controls.Alert.show("La Conferencia fue eliminada para el Ramo seleccionado","Alerta");
	limpiar_pantalla();
}
//******************************************************************************************************
private function limpiar_pantalla():void
{
	this.dg_cursos.dataProvider = null;
	this.rp_conferencias.dataProvider = null;
	this.cmb_ejecuciones.selectedIndex = 0;
}

//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}