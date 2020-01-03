// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.core.Application;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
//******************************************************************************************************
private var par_rut:String;
private var arreglo:ArrayCollection = new ArrayCollection;
public var cod_pregunta_popup:String;
private var func_mod_fun_idn:String;

[Bindable]  
private var par_func_mod_fun_idn:String;  
          
//******************************************************************************************************
private function inicio():void
{
	func_mod_fun_idn=Application.application.func_mod_fun_idn;
	ro_asigna_preguntas.muestra_ramos(func_mod_fun_idn);
	
	rp_preguntas_seleccionadas.dataProvider = Application.application.arreglo_preguntas;
}
//******************************************************************************************************
private function result_muestra_ramos(event:ResultEvent):void
{
	cmb_ramo.dataProvider=event.result;
	ro_asigna_preguntas.muestra_unidades();
}
//******************************************************************************************************
private function result_muestra_unidades(event:ResultEvent):void
{
	cmb_unidad.dataProvider=event.result;
	
}

//*******************************************************************************************************
private function cmb_ramo_change():void{
	lbl_pro_cam_idn.text = cmb_ramo.selectedItem.data 
}

//*******************************************************************************************************
private function btn_guardar_click():void
{
	var arre_guarda:ArrayCollection = new ArrayCollection;
	
	if (cmb_ramo.selectedIndex > 0 && cmb_unidad.selectedIndex > 0)
	{
		for(x = 0; x < rp_preguntas_seleccionadas.dataProvider.length; x++)
		{
			if (chk_ok_sel[x].selected==true)
			{
				var o_tres_campos_obj:obj_tres_campos = new obj_tres_campos;
	
				o_tres_campos_obj.campo_uno = lbl_cod_preg_cam[x].text;
				o_tres_campos_obj.campo_dos = String(cmb_ramo.selectedItem.data);
				o_tres_campos_obj.campo_tres = String(cmb_unidad.selectedItem.data);
				arre_guarda.addItem(o_tres_campos_obj);
					
			}
		}
		ro_asigna_preguntas.asigna_pregunta(arre_guarda);
	}
	else
		mx.controls.Alert.show("Faltan campos necesarios para poder realizar la operación de guardar", "Ayuda")	
}

//*******************************************************************************************************
private function limpiar():void
{
	var arreglo_vacio:ArrayCollection = new ArrayCollection;
	var o_tres_campos:obj_tres_campos = new obj_tres_campos;
	rp_preguntas_seleccionadas.dataProvider = arreglo_vacio;
	Application.application.arreglo_preguntas.dataProvider = arreglo_vacio;
	PopUpManager.removePopUp(this);
	cmb_ramo.selectedIndex=0;
	cmb_unidad.selectedIndex=0;
	lbl_pro_cam_idn.text = '';
}
//*******************************************************************************************************
private function chk_todos_click_2():void
{
	if (chk_todos_2.selected==true)
	{
		chk_todos_2.label="Quitar Seleccion";
		seleccion_2(true);
	}
	else
	{
		seleccion_2(false);
		chk_todos_2.label="Seleccionar Todo";
	}
}
//*******************************************************************************************************
private function seleccion_2(valor:Boolean):void
{
	var i:int; 
	if (rp_preguntas_seleccionadas.dataProvider != undefined)
	{
		for(i = 0; i < rp_preguntas_seleccionadas.dataProvider.length; i++) 
		{
			chk_ok_sel[i].selected=valor;
		}
	}

}
//*******************************************************************************************************
private function btn_salir_click():void
{
	PopUpManager.removePopUp(this);	
}
//*******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}
//******************************************************************************************************