// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

[Bindable]  
private var par_func_mod_fun_idn:String;

public var arreglo:ArrayCollection = new ArrayCollection;

public var pondera:int;
private var correlativo:int;

public var objetivas:int;
public var desarrollo:int;
public var func_mod_fun_idn:String;

private var arreglo_preguntas:ArrayCollection = new ArrayCollection;
//******************************************************************************************************
private function inicio():void
{
	objetivas = 0;
	desarrollo = 0;
	
	par_func_mod_fun_idn = Application.application.parameters.par_func_mod_fun_idn;
	ro_desencripta.desencriptar_func_mod_fun_idn("Iplacex", par_func_mod_fun_idn);
} 
//******************************************************************************************************
private function result_desencriptar_func_mod_fun_idn(event:ResultEvent):void
{
	func_mod_fun_idn = event.result[0].campo_uno;
	//mx.controls.Alert.show(func_mod_fun_idn);
	ro_asigna_preguntas_prueba_unidad.muestra_ejecuciones(func_mod_fun_idn);
}
//******************************************************************************************************
private function result_muestra_ejecuciones(event:ResultEvent):void
{
	cmb_ejecucion.dataProvider=event.result;
	ro_asigna_preguntas_prueba_unidad.muestra_tipo_pregunta();
}
//********************************************************************************************************
private function result_muestra_detalle_prueba_cantidades(event:ResultEvent):void
{
	if (event.result[0].campo_uno!= undefined)
		lbl_cant_obj.text = event.result[0].campo_uno;
	else
		lbl_cant_obj.text = "0";
	
	if (event.result[0].campo_dos!= undefined)
		lbl_porc_obj.text = event.result[0].campo_dos;
	else
		lbl_porc_obj.text = "0";
	
	if (event.result[0].campo_tres!= undefined)	
		lbl_cant_des.text = event.result[0].campo_tres;
	else
		lbl_cant_des.text = "0";
	
	if (event.result[0].campo_cuatro!= undefined)
		lbl_porc_des.text = event.result[0].campo_cuatro;
	else
		lbl_porc_des.text = "0";
	
	if (event.result[0].campo_cinco!= undefined)
		lbl_puntaje_total.text = event.result[0].campo_cinco;
	else
		lbl_puntaje_total.text = "0";	
	
	if (event.result[0].campo_seis!= undefined)
		lbl_exigencia.text = event.result[0].campo_seis + " %";
	else
		lbl_exigencia.text = "0 %";
	
	lbl_cantidad_total.text = String(int(lbl_cant_des.text) + int(lbl_cant_obj.text));
	
	total_objetivas.text = String(objetivas) + " de " + lbl_cant_obj.text
	total_desarrollo.text = String(desarrollo) + " de " + lbl_cant_des.text
	//ro_asigna_preguntas_prueba_unidad.muestra_detalle_prueba(cmb_tipo_prueba.selectedItem.data2);
	
}
//********************************************************************************************************
private function result_muestra_tipo_pregunta(event:ResultEvent):void
{
	cmb_tip_pregunta.dataProvider=event.result;
}
//********************************************************************************************************
private function cmb_ejecucion_change():void
{
	cmb_ramo.dataProvider = undefined;
	cmb_tipo_prueba.dataProvider = undefined;
	cambio();
	ro_asigna_preguntas_prueba_unidad.muestra_ramos_ejecucion(cmb_ejecucion.selectedItem.data);
	lbl_codigo_ejecucion.text = cmb_ejecucion.selectedItem.data	
}
//********************************************************************************************************
private function cmb_ramo_change():void
{
	cmb_tipo_prueba.dataProvider = undefined;
	cambio();
	ro_asigna_preguntas_prueba_unidad.muestra_tipo_prueba(cmb_ramo.selectedItem.data);	
}
//********************************************************************************************************
private function cmb_tip_prueba_change():void
{
	ro_asigna_preguntas_prueba_unidad.muestra_detalle_prueba_cantidades(cmb_tipo_prueba.selectedItem.data2)
	cambio();
}
//********************************************************************************************************
private function result_muestra_ramos_ejecucion(event:ResultEvent):void
{
	cmb_ramo.dataProvider=event.result;
}
//********************************************************************************************************
private function result_muestra_preguntas(event:ResultEvent):void
{	var i:int;
	var j:int;
	var sw:int=0;
	var arre_preg:ArrayCollection = new ArrayCollection;
	
	if (event.result.length > 0)
	{
		rp_preguntas.dataProvider = event.result;
		chk_todos.label="Quitar Seleccion";
		seleccion(true);
		
		for(i = 0; i < rp_preguntas.dataProvider.length; i++) {
			sw=0;
			for(j = 0; j < rp_preguntas_asignadas.dataProvider.length; j++) {
				if (chk_ok[i].label == lbl_pregunta_idn_asig[j].text){
					sw=1;
				}
			}
			if (sw!=1) {
				arre_preg.addItem(rp_preguntas.dataProvider[i]);
			}
			j=0;	
		}
		rp_preguntas.dataProvider = undefined;
		rp_preguntas.dataProvider = arre_preg;
		
		
	}
	else
		rp_preguntas.dataProvider = undefined;
	
	
}

//********************************************************************************************************
private function result_muestra_preguntas_asignadas(event:ResultEvent):void
{
	if (event.result.length > 0)
	{
		rp_preguntas_asignadas.dataProvider = event.result;
	}
	else
		rp_preguntas_asignadas.dataProvider = undefined;
	
	
}

//********************************************************************************************************
private function result_muestra_tipo_prueba(event:ResultEvent):void
{
	cmb_tipo_prueba.dataProvider=event.result;
}

private function result_asigna_preguntas(event:ResultEvent):void
{
	limpiar();
	
}
//********************************************************************************************************
private function cmb_tip_pregunta_change():void
{
	
	ro_asigna_preguntas_prueba_unidad.muestra_preguntas_asignadas(cmb_tipo_prueba.selectedItem.data2, cmb_tip_pregunta.selectedItem.data);
	ro_asigna_preguntas_prueba_unidad.muestra_preguntas(cmb_ramo.selectedItem.data2, cmb_tipo_prueba.selectedItem.data2, cmb_tip_pregunta.selectedItem.data, func_mod_fun_idn);
	
}
//********************************************************************************************************
private function btn_detalle_click():void
{
	var login:frm_objetivas_asigna_preguntas_prueba_unidad_popup = frm_objetivas_asigna_preguntas_prueba_unidad_popup(PopUpManager.createPopUp( this, frm_objetivas_asigna_preguntas_prueba_unidad_popup , true));
	mx.managers.PopUpManager.centerPopUp(login)
}
//********************************************************************************************************	
private function seleccionar_todo():void
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
	for(i = 0; i < rp_preguntas.dataProvider.length; i++) 
	{
		chk_ok[i].selected=valor;
	}
}
//*******************************************************************************************************
private function cambio():void
{
	rp_preguntas.dataProvider = undefined;
	rp_preguntas_asignadas.dataProvider = undefined;
	rp_preguntas_sel.dataProvider = undefined;
	rp_preguntas.dataProvider = undefined;
	cmb_tip_pregunta.selectedIndex=0;
	objetivas=0;
	desarrollo=0;
	lbl_cant_obj.text = "0";
	lbl_cant_des.text = "0";
	lbl_porc_obj.text = "0";
	lbl_porc_des.text = "0";
	lbl_puntaje_total.text = "0";
	lbl_cantidad_total.text = "0";
	lbl_exigencia.text = "0";
	arreglo= new ArrayCollection;
	total_objetivas.text = "0 de 0";
	total_desarrollo.text = "0 de 0";
}
//*******************************************************************************************************
private function btn_agregar_click():void
{
	var sw:int;
	var x:int;
	var i:int;
	
	
	for(x = 0; x < rp_preguntas.dataProvider.length; x++)
	{
		sw=0;
		
		if (chk_ok[x].selected==true)
		{
			if (rp_preguntas_sel.dataProvider!=null)
				for(i = 0; i < rp_preguntas_sel.dataProvider.length; i++) 
				{
					if (lbl_cod_sel[i].text==chk_ok[x].label)
					{
						sw=1;
						break;
					}
				}
			else
				sw=0;
			
			if (sw==0)
			{
				
				var o_nueve_campos:obj_nueve_campos = new obj_nueve_campos;
				o_nueve_campos.campo_uno = chk_ok[x].label;
				o_nueve_campos.campo_dos = lbl_pregunta[x].text;
				o_nueve_campos.campo_tres = lbl_uni_idn[x].text;
				o_nueve_campos.campo_cuatro = lbl_tip_preg_idn[x].text;
				o_nueve_campos.campo_cinco = cmb_tip_pregunta.selectedLabel;
				o_nueve_campos.campo_seis = lbl_uni_nombre[x].text;
				o_nueve_campos.campo_siete = cmb_tipo_prueba.selectedItem.data2;
				o_nueve_campos.campo_ocho = lbl_cla_nombre[x].text;
				o_nueve_campos.campo_nueve = lbl_cla_idn[x].text;
				arreglo.addItem(o_nueve_campos);	
			}
		}
		
	}
	rp_preguntas_sel.dataProvider=arreglo;
	contar();
	
}
//******************************************************************************************************
private function btn_elimina_selec_click(evento:Event):void
{
	var item:Object=evento.currentTarget.getRepeaterItem();
	var obj:Object = rp_preguntas_sel.dataProvider;
	var i:int;
	var arre_nuevo:ArrayCollection = new ArrayCollection;
	var sw:int = 0;
	
	for(i = 0; i < rp_preguntas_sel.dataProvider.length; i++) 
	{
		if (item.campo_uno!=obj[i].campo_uno)
		{
			var o_nueve_campos:obj_nueve_campos = new obj_nueve_campos;
			o_nueve_campos.campo_uno = obj[i].campo_uno;
			o_nueve_campos.campo_dos = obj[i].campo_dos;
			o_nueve_campos.campo_tres = obj[i].campo_tres;
			o_nueve_campos.campo_cuatro = obj[i].campo_cuatro;
			o_nueve_campos.campo_cinco = obj[i].campo_cinco;
			o_nueve_campos.campo_seis = obj[i].campo_seis;
			o_nueve_campos.campo_siete = obj[i].campo_siete;
			o_nueve_campos.campo_ocho = obj[i].campo_ocho;
			o_nueve_campos.campo_nueve = obj[i].campo_nueve;
			
			
			arre_nuevo.addItem(o_nueve_campos);	
		}
		
	}
	arreglo = new ArrayCollection;
	rp_preguntas_sel.dataProvider=undefined;
	rp_preguntas_sel.dataProvider=arre_nuevo;
	arreglo = arre_nuevo;
	contar();
	
}
//******************************************************************************************************
private function btn_elimina_asig_click(evento:Event):void
{
	var item:Object=evento.currentTarget.getRepeaterItem();
	var obj:Object = rp_preguntas_sel.dataProvider;
	var i:int;
	var arre_nuevo:ArrayCollection = new ArrayCollection;
	var sw:int = 0;
	
	
	ro_asigna_preguntas_prueba_unidad.desasigna_preguntas(this.cmb_ramo.selectedItem.data, item.campo_tres, item.campo_cuatro, item.campo_uno)
		
}
//********************************************************************************************************
private function result_desasigna_preguntas(event:ResultEvent):void
{
	if (event.result.length > 0)
	{
		mx.controls.Alert.show("Ocurrio un error al eliminar la pregunta asignada. Por favor contáctese con la Dirección de Informática", "Error");
	}
	else
	{
		mx.controls.Alert.show("Se ha eliminado la pregunta seleccionada", "Información");
		cmb_tip_pregunta_change();
	}

}
//*******************************************************************************************************
private function btn_guardar_click():void
{
	var arre_guarda:ArrayCollection = new ArrayCollection;
	var x:int;
	
	if (objetivas >= (Number(lbl_cant_obj.text)) && desarrollo >= (Number(lbl_cant_des.text)))
	{
		
		for(x = 0; x < rp_preguntas_sel.dataProvider.length; x++)
		{
			var o_cuatro_campos_obj:obj_cuatro_campos = new obj_cuatro_campos;
			
			o_cuatro_campos_obj.campo_uno = cmb_tipo_prueba.selectedItem.data2;
			o_cuatro_campos_obj.campo_dos = lbl_uni_idn_sel[x].text;
			o_cuatro_campos_obj.campo_tres = lbl_cla_idn_sel[x].text;
			o_cuatro_campos_obj.campo_cuatro = lbl_cod_sel[x].text;
			
			arre_guarda.addItem(o_cuatro_campos_obj);	
			
			//			mx.controls.Alert.show("Uno" + cmb_tipo_prueba.selectedItem.data2 + "Dos" + lbl_uni_idn_sel[x].text + "Tres" +
			//			 lbl_cla_idn_sel[x].text + "Cuatro" + lbl_cod_sel[x].text,"Ayuda");
			
		}
		
		if (arre_guarda.length > 0) {
			ro_asigna_preguntas_prueba_unidad.asigna_preguntas(arre_guarda);
			mx.controls.Alert.show("Preguntas asignadas");
		}
		else {
			mx.controls.Alert.show("No se han asignado preguntas");
		}
		
		
		
	}
	else
	{
		mx.controls.Alert.show("El nÃºmero de preguntas seleccionadas debe ser a lo menos igual al nÃºmero de preguntas asociadas a la prueba","Ayuda");
	}
}
//*******************************************************************************************************
private function contar():void
{
	var i:int;
	objetivas = 0;
	desarrollo = 0;
	
	for(i = 0; i < rp_preguntas_sel.dataProvider.length; i++) 
	{
		if (rp_preguntas_sel.dataProvider[i].campo_cuatro == '1')
			objetivas = objetivas + 1
		else
			desarrollo = desarrollo + 1
	}
	
	for(i = 0; i < rp_preguntas_asignadas.dataProvider.length; i++) 
	{
		if (cmb_tip_pregunta.selectedIndex == 1)
			objetivas = objetivas + 1
		else
			desarrollo = desarrollo + 1
	}
	total_objetivas.text = String(objetivas) + " de " + lbl_cant_obj.text
	total_desarrollo.text = String(desarrollo) + " de " + lbl_cant_des.text
}
//*******************************************************************************************************
private function limpiar():void
{
	cmb_ejecucion.selectedIndex=0;
	cmb_ramo.dataProvider = undefined;
	cmb_tipo_prueba.dataProvider = undefined;
	cambio();
}
//*******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}
//******************************************************************************************************