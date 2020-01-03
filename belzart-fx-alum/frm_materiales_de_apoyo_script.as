import flash.events.Event;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

// ActionScript Document
private var eje_aca_idn:String;
////**********************************************************************************************************
private function inicio():void
{
	eje_aca_idn = this.parentApplication.eje_aca_idn;
	ro_materiales_apoyo.carga_unidades_materiales(eje_aca_idn);		
	mx.controls.Alert.show('Seleccione la Unidad que desea visualizar, en la parte superior de esta pantalla.', 'Información');
}
//*********************************************************************************************
private function cmb_unidades_change(event:Event):void
{
	ro_materiales_apoyo.materiales_apoyo_carga_menu(eje_aca_idn,cmb_unidades.selectedItem.data);
	lst_material_detalle.dataProvider.removeAll();
}
//*********************************************************************************************
private function result_materiales_apoyo_carga_menu(event:ResultEvent):void{

	hl_menu.dataProvider = event.result;
		
}
//*********************************************************************************************
private function hl_menu_change(event:Event):void
{
	lbl_tip_prod_idn.text = String(this.hl_menu.selectedItem.campo_uno);
	lbl_control.text = String(this.hl_menu.selectedItem.campo_dos);
	lbl_eje_aca_idn.text = eje_aca_idn;


	ro_materiales_apoyo.material_apoyo_carga_detalle_materiales(eje_aca_idn, String(this.hl_menu.selectedItem.campo_uno), cmb_unidades.selectedItem.data);
}

//*********************************************************************************************
private function devuelve_xml(arreglo:ArrayCollection):XMLList
{
	var i:int;
	var menu_p:String="";
	
	var s_lista:String="<?xml version='1.0' encoding='utf-8'?>" + "\n";
	
	if(arreglo.length > 0)
	{	for(i=0;i<arreglo.length;i++)
		{
			s_lista = s_lista + "<node data='" + arreglo[i].campo_uno + "' url='" + arreglo[i].campo_tres +"' label='" + arreglo[i].campo_dos + "' material='" + arreglo[i].campo_cuatro + "'/>" + "\n"
			
		}
	}
	return XMLList(s_lista);
}
//*********************************************************************************************
private function result_carga_unidades_materiales(event:ResultEvent):void
{
	cmb_unidades.dataProvider = event.result;
}

//*********************************************************************************************
private function btn_cerrar_click():void {
	PopUpManager.removePopUp(this)
}
//*********************************************************************************************
[Bindable]
public var selectedNode:Object;
            
private function carga_url_material(event:Event):void
{
	var url:String;
	var tip_menu:String;
	var URL_material:String;
	var tipo:Number;
	selectedNode = Tree(event.target).selectedItem;
	URL_material = selectedNode.@url;
	tipo = selectedNode.@material;
	url = librerias.f_trim('http://164.77.193.131:8100/cfusion/ipxcf/upload_mat_apo/' + String(selectedNode.@data)  + '/' + URL_material)
	archivo_bajada.iniciarDescarga(url);
}
	
/*	
private function carga_url_material(event:Object):void{
	

	var URL_material:String;
	var tipo:Number;
	var url:String;
	var obj:Object;
	obj = event.target.selectedNode.attributes;
	URL_material = obj.url;
	tipo = obj.material;
	
	url = librerias.f_trim('http://164.77.193.131:8100/cfusion/ipxcf/upload_mat_apo/' + String(obj.data)  + '/' + URL_material)
	mx.controls.Alert.show(url);
	archivo_bajada.iniciarDescarga(url);
//	archivo_bajada.download(librerias.f_trim(url), url.split('/').pop())

}
*/
//*********************************************************************************************
private function no_devuelve_datos(event:Event):void{
	mx.controls.Alert.show('No se han encontrado datos.', 'Información');
}

private function result_material_apoyo_carga_detalle_materiales(event:ResultEvent):void
{
	var arreglo_menu:ArrayCollection = new ArrayCollection;
	var x:int;

	for( x = 0; x < event.result.length ; x++ )
	{
		var o_cuatro_campos:obj_cuatro_campos = new obj_cuatro_campos;
		o_cuatro_campos.campo_uno = event.result[x].campo_uno
		o_cuatro_campos.campo_dos = event.result[x].campo_dos
		o_cuatro_campos.campo_tres = event.result[x].campo_tres
		o_cuatro_campos.campo_cuatro = event.result[x].campo_cuatro
		arreglo_menu.addItem(o_cuatro_campos);
	}
	
	lst_material_detalle.dataProvider = devuelve_xml(arreglo_menu);
}


private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
