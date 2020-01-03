// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
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
	par_func_mod_fun_idn = Application.application.parameters.par_func_mod_fun_idn;
	ro_asigna_preguntas.desencriptar_func_mod_fun_idn("Iplacex", par_func_mod_fun_idn);
}
//******************************************************************************************************
private function result_desencriptar_func_mod_fun_idn(event:ResultEvent):void
{
	func_mod_fun_idn = event.result[0].campo_uno;
	ro_asigna_preguntas.muestra_ramos(func_mod_fun_idn);
}
//******************************************************************************************************
private function result_muestra_ramos(event:ResultEvent):void
{
	rp_ramos.dataProvider=event.result;
	ro_asigna_preguntas.muestra_unidades();
	ro_asigna_preguntas.muestra_clases();
}
//******************************************************************************************************
private function result_muestra_unidades(event:ResultEvent):void
{
	cmb_unidad.dataProvider=event.result;
	
	var criterio_buscar:Array = new Array();
	criterio_buscar.push({data:0, label:"-- Seleccione --"});
	criterio_buscar.push({data:1, label:"Código"});
	criterio_buscar.push({data:2, label:"Pregunta"});
	criterio_buscar.push({data:3, label:"Pauta"});
	
	cmb_buscar_por.dataProvider=criterio_buscar;
	ro_ingreso_preguntas.muestra_tipo_pregunta();
}
//******************************************************************************************************
private function result_muestra_clases(event:ResultEvent):void {
	cmb_clase.dataProvider=event.result;
}

//******************************************************************************************************
private function btn_buscar_click():void
{
	var tip_preg_idn:String;
	
	if (cmb_tip_pregunta.selectedIndex<1)
		tip_preg_idn="0";
	else
		tip_preg_idn=String(cmb_tip_pregunta.selectedIndex);
	
	ro_asigna_preguntas.busca_pregunta(String(cmb_buscar_por.selectedItem.data), txt_criterio.text, tip_preg_idn, func_mod_fun_idn);	
}
//******************************************************************************************************
private function result_busca_pregunta(event:ResultEvent):void
{
		//dg_preguntas.dataProvider=event.result;
	rp_preguntas.dataProvider=event.result;
}
//******************************************************************************************************
private function result_muestra_tipo_pregunta(event:ResultEvent):void
{
	cmb_tip_pregunta.dataProvider = event.result;
}
//*******************************************************************************************************
private function btn_agregar_click():void
{
	var sw:int;
	var x:int;
	var i:int;
	sw=0;
	for(x = 0; x < rp_preguntas.dataProvider.length; x++)
	{
		if (chk_ok[x].selected==true)
		{
			if (rp_preguntas_seleccionadas.dataProvider == null)// si es la primera pregunta seleccionada
			{
				sw=0
			}
			else
			{
				for(i = 0; i < rp_preguntas_seleccionadas.dataProvider.length; i++) 
				{
					if (lbl_cod_sel[i].text==lbl_cod[x].text)
					{
						sw=1;
						break;
					}
				}
			}
			if (sw==0)
			{
				var o_cuatro_campos:obj_cuatro_campos = new obj_cuatro_campos;
				o_cuatro_campos.campo_uno = lbl_cod[x].text;
				o_cuatro_campos.campo_dos = lbl_pregunta[x].text;
				o_cuatro_campos.campo_tres = lbl_tipo[x].text;
				o_cuatro_campos.campo_cuatro = lbl_preg_mod_cam_idn[x].text;
				arreglo.addItem(o_cuatro_campos);	
			}
		sw=0;
		}

	}
	rp_preguntas_seleccionadas.dataProvider=arreglo;
	
	
}
//*******************************************************************************************************
private function btn_alternativas_click(event:Event):void
{
	var opt:Button=Button(event.currentTarget);
	var item:Object=opt.getRepeaterItem();
	
	if(item.campo_uno!=null)
	{
		
		if (item.campo_tres=='1'){
			cod_pregunta_popup=item.campo_uno;
			var alternativas:frm_objetivas_asigna_preguntas_ramo_popup_muestra_alternativas=frm_objetivas_asigna_preguntas_ramo_popup_muestra_alternativas(PopUpManager.createPopUp( this, frm_objetivas_asigna_preguntas_ramo_popup_muestra_alternativas , true));
			mx.managers.PopUpManager.centerPopUp(alternativas)
		}
		else
			mx.controls.Alert.show("Esta pregunta es de desarollo, por lo cual no posee alternativas", "Ayuda");
	}
}
//*******************************************************************************************************
private function btn_guardar_click():void
{
	var arre_guarda:ArrayCollection = new ArrayCollection;
	var x:int;
	var i:int;
	var cont_ramos:int;
	cont_ramos=0;
	if (cmb_unidad.selectedIndex > 0 && cmb_clase.selectedIndex > 0 && rp_preguntas_seleccionadas.dataProvider!=null)
	{
		for(i = 0; i < rp_ramos.dataProvider.length; i++)
		{
			if (chk_ramo_ok[i].selected==true)
			{ 
				cont_ramos = cont_ramos + 1;
				for(x = 0; x < rp_preguntas_seleccionadas.dataProvider.length; x++)
				{
						var o_cuatro_campos_obj:obj_cuatro_campos = new obj_cuatro_campos;
						o_cuatro_campos_obj.campo_uno = lbl_preg_mod_cam_idn_sel[x].text;
						o_cuatro_campos_obj.campo_dos = chk_ramo_ok[i].label;
						o_cuatro_campos_obj.campo_tres = String(cmb_unidad.selectedItem.data);
						o_cuatro_campos_obj.campo_cuatro = String(cmb_clase.selectedItem.data);
						arre_guarda.addItem(o_cuatro_campos_obj);	
				}
			}
		}
		if (cont_ramos > 0){ //Si hay ramos seleccionados
			ro_asigna_preguntas.asigna_pregunta(arre_guarda);//mx.controls.Alert.show(arre_guarda[0].campo_uno + " - " + arre_guarda[0].campo_dos + " - " + arre_guarda[0].campo_tres);
			mx.controls.Alert.show("Preguntas asignadas", "Ayuda")
		}
		else
			mx.controls.Alert.show("Debe seleccionar a lo menos un ramo para poder realizar la operación de guardar", "Ayuda")
	}
	else
		mx.controls.Alert.show("Faltan campos necesarios para poder realizar la operación de guardar", "Ayuda")	
}
//*******************************************************************************************************
private function limpiar():void
{
	var arreglo_vacio:ArrayCollection = new ArrayCollection;
	var o_tres_campos:obj_tres_campos = new obj_tres_campos;
	var i:int;
	
	
	rp_preguntas.dataProvider = arreglo_vacio;
	rp_preguntas_seleccionadas.dataProvider = arreglo_vacio;
	
	cmb_unidad.selectedIndex=0;
	cmb_buscar_por.selectedIndex=0;
	
	txt_criterio.text='';
	
	if (rp_ramos.dataProvider!= null)
	{
		for(i = 0; i < rp_ramos.dataProvider.length; i++)
		{
			chk_ramo_ok[i].selected=false;
		}
	}
	
	
	
}
//*******************************************************************************************************
private function txt_criterio_keyDown(event:KeyboardEvent):void
{
	if (event.keyCode == Keyboard.ENTER)
	{
		btn_buscar_click();
	}
}
//*******************************************************************************************************
private function cmb_tip_pregunta_change():void
{
	ro_asigna_preguntas.preguntas_x_tipo(String(cmb_tip_pregunta.selectedIndex))
}
//*******************************************************************************************************
private function chk_todos_click():void
{
	if (chk_todos.selected==true)
	{
		chk_todos.label="Quitar Seleccion";
		seleccion(true);
	}
	else
	{
		seleccion(false);
		chk_todos.label="Seleccionar Todo";
	}
}
//*******************************************************************************************************
private function seleccion(valor:Boolean):void
{
	var i:int; 
	if (rp_preguntas.dataProvider != null)
	{
		for(i = 0; i < rp_preguntas.dataProvider.length; i++) 
		{
			chk_ok[i].selected=valor;
		}
	}

}
//*******************************************************************************************************
private function btn_elimina_selec_click(evento:Event):void
{
	var item:Object=evento.currentTarget.getRepeaterItem();
	var obj:Object = rp_preguntas_seleccionadas.dataProvider;
	var i:int;
	var arre_nuevo:ArrayCollection = new ArrayCollection;
	var sw:int = 0;
	
	for(i = 0; i < rp_preguntas_seleccionadas.dataProvider.length; i++) 
	{
		if (item.campo_uno!=obj[i].campo_uno)
		{
			var o_cuatro_campos:obj_cuatro_campos = new obj_cuatro_campos;
			o_cuatro_campos.campo_uno = obj[i].campo_uno;
			o_cuatro_campos.campo_dos = obj[i].campo_dos;
			o_cuatro_campos.campo_tres = obj[i].campo_tres;
			o_cuatro_campos.campo_cuatro = obj[i].campo_cuatro;
	
			arre_nuevo.addItem(o_cuatro_campos);	
		}
		
	}
	arreglo = new ArrayCollection;
	arreglo = arre_nuevo;
	rp_preguntas_seleccionadas.dataProvider=null;
	rp_preguntas_seleccionadas.dataProvider=arre_nuevo;
}
//******************************************************************************************************


private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}
//******************************************************************************************************