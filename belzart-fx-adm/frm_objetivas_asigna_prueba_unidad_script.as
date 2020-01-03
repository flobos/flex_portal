// ActionScript file
import libreria.*;
import mx.core.Application;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.rpc.events.*;

[Bindable]  
private var par_func_mod_fun_idn:String;

public var func_mod_fun_idn:String;
public var arreglo:ArrayCollection = new ArrayCollection;
public var pondera:int;
private var correlativo:int;
public var contador:int;
//*******************************************************************************************************
private function inicio():void
{
	
	par_func_mod_fun_idn = Application.application.parameters.par_func_mod_fun_idn;
	ro_desencripta.desencriptar_func_mod_fun_idn("Iplacex", par_func_mod_fun_idn);
	
	
	contador=0;
	lbl_total_obj_cantidad.text="0";
	lbl_total_des_cantidad.text="0";
	lbl_total_cantidad.text="0";
	lbl_total_obj_ponderacion.text="0";
	lbl_total_des_ponderacion.text="0";
	lbl_total_ponderacion.text="0";
	canvas_ramos.enabled=false;
	btn_guardar.enabled=false;

}
//*******************************************************************************************************
private function txt_puntaje_keypress(event:KeyboardEvent):void
{
	if (event.charCode == 13)
	{
		cmb_exigencia.setFocus();
	}	
}
//*******************************************************************************************************
private function llena_combo_exigencia():void
{
	var x:int;
	var array_exigencia:Array = new Array();

	for(x = 30; x < 61; x++)
	{
		array_exigencia.push({data:x, label:String(x)});
	}
	
	cmb_exigencia.dataProvider=array_exigencia;
	cmb_exigencia.selectedIndex=30;
}
//*******************************************************************************************************
private function result_desencriptar_func_mod_fun_idn(event:ResultEvent):void
{
	//func_mod_fun_idn='46126';
	func_mod_fun_idn = event.result[0].campo_uno;
	ro_asigna_prueba_unidad.muestra_ejecuciones(func_mod_fun_idn);
	//mx.controls.Alert.show(func_mod_fun_idn);
}
//*******************************************************************************************************
private function result_muestra_ejecuciones(event:ResultEvent):void
{
	cmb_ejecucion.dataProvider=event.result;
	ro_asigna_prueba_unidad.muestra_unidades();
}
//*******************************************************************************************************
private function result_muestra_unidades(event:ResultEvent):void
{
	cmb_unidad.dataProvider=event.result;
	ro_asigna_prueba_unidad.muestra_clase();
	//ro_asigna_prueba_unidad.muestra_tipo_pregunta();
}
//*******************************************************************************************************
private function result_muestra_clases(event:ResultEvent):void
{
	cmb_clase.dataProvider=event.result;
	ro_asigna_prueba_unidad.muestra_tipo_pregunta();
}


//*******************************************************************************************************
private function cmb_ejecucion_change():void
{
	ro_asigna_prueba_unidad.muestra_tipo_prueba(cmb_ejecucion.selectedItem.data);
	rp_ramos_selec.dataProvider=null;
	arreglo=new ArrayCollection;
	rp_ramos.dataProvider=null;
	rp_ramos_ok.dataProvider=null;
	lbl_codigo_ejecucion.text = cmb_ejecucion.selectedItem.data;
	correlativo = 0;
}
//*******************************************************************************************************
private function result_muestra_tipo_prueba(event:ResultEvent):void
{
	cmb_tipo_prueba.dataProvider=event.result;
	
}
//*******************************************************************************************************
private function result_muestra_tipo_pregunta(event:ResultEvent):void
{
	cmb_tip_pregunta.dataProvider=event.result;
	llena_combo_exigencia();
}
//*******************************************************************************************************
private function cmb_tipo_prueba_change():void
{
	ro_asigna_prueba_unidad.muestra_ramos_ejecucion(cmb_ejecucion.selectedItem.data, cmb_tipo_prueba.selectedItem.campo_uno, cmb_tipo_prueba.selectedItem.campo_tres);
	rp_ramos_selec.dataProvider=null;
	arreglo=new ArrayCollection;
	rp_ramos.enabled=false;
	
	lbl_total_obj_cantidad.text = "0";
	lbl_total_des_cantidad.text = "0";
	
	lbl_total_obj_ponderacion.text = "0 Pts";
	lbl_total_des_ponderacion.text = "0 Pts";
	
	lbl_total_cantidad.text = "0";
	lbl_total_ponderacion.text = "0 Pts";
	pondera = 0;
}
//*******************************************************************************************************
private function result_muestra_ramos_ejecucion(event:ResultEvent):void
{
	rp_ramos.dataProvider=event.result;
	ro_asigna_prueba_unidad.muestra_ramos_ejecucion_con_prueba(cmb_ejecucion.selectedItem.data, cmb_tipo_prueba.selectedItem.campo_uno, cmb_tipo_prueba.selectedItem.campo_tres);
}
//*******************************************************************************************************
private function result_muestra_ramos_ejecucion_con_prueba(event:ResultEvent):void
{
	rp_ramos_ok.dataProvider = event.result;
	
	var ob:Object;
	var x:int;
	var arreglo_ok:ArrayCollection = new ArrayCollection;
	var cod_paso:String
	ob = event.result;
	cod_paso='0';
	for( x = 0; x < ob.length; x++)
	{
		
		if(cod_paso==ob[x].campo_uno) // filtra evaluaciones de ejecucion repetidas
		{
			chk_ramo_ok[x].visible 	= false;
			lbl_eje_idn[x].visible 	= false;
			lbl_cur_nombre[x].visible 	= false;
			lbl_tip_jor_nombre[x].visible 	= false;
			lbl_sec_nombre[x].visible 	= false;
			lbl_tipo_pru_idn[x].visible 	= false;
			lbl_uni_nombre[x].visible 	= false;
			lbl_cla_nombre[x].visible 	= false;
			lbl_tip_preg_tipo[x].visible 	= false;
			lbl_tip_pru_cantidad[x].visible 	= false;
			lbl_tip_pru_porcentaje[x].visible 	= false;
			
		}	
		else
		{
			chk_ramo_ok[x].visible 	= true;
			lbl_eje_idn.visible 	= true;
			lbl_cur_nombre.visible 	= true;
			lbl_tip_jor_nombre.visible 	= true;
			lbl_sec_nombre.visible 	= true;
			lbl_tipo_pru_idn.visible 	= true;
			lbl_uni_nombre[x].visible 	= true;
			lbl_cla_nombre[x].visible 	= true;
			lbl_tip_preg_tipo[x].visible 	= true;
			lbl_tip_pru_cantidad[x].visible 	= true;
			lbl_tip_pru_porcentaje[x].visible 	= true;
			cod_paso=ob[x].campo_uno;
		}
		
				
	}
	
}
//*******************************************************************************************************
private function btn_agregar_click():void
{
	var x:int;
	var sw:int;
	var i:int;
	var f:int;
	var p_o:int;
	var p_d:int;
	var puntaje:int;
	if (txt_puntaje.text=='')
		txt_puntaje.text="0";

	puntaje = int(txt_puntaje.text);
		
		if(cmb_ejecucion.selectedIndex > 0 && cmb_clase.selectedIndex > 0 && cmb_tipo_prueba.selectedIndex > 0 && cmb_unidad.selectedIndex > 0 && cmb_tip_pregunta.selectedIndex > 0 && num_cantidad.value > 0 && num_ponderacion.value > 0)
		{
			if (rp_ramos_selec.dataProvider == null)//si no hay pruebas agregadas
			{
				sw=0
			}
			else //si hay pruebas agregadas
			{
				for(i = 0; i < rp_ramos_selec.dataProvider.length; i++) 
				{
					// si la unidad, clase y tipo de pregunta ya ha sido agregada
					if (lbl_cod_clase[i].text == cmb_clase.selectedItem.data && lbl_cod_unidad[i].text == cmb_unidad.selectedItem.data && lbl_cod_tip_pregunta[i].text==cmb_tip_pregunta.selectedItem.data)
					{

						sw=1;
						f=i;
						break;
					}
				}
			}
			// si no se han agregado preguntas (o al menos no para la unidad, clase, tipo) 
			// y el puntaje de la prueba no supera el puntaje total a asignar
			if (sw==0 && pondera + num_ponderacion.value <puntaje +1)
			{
				correlativo = correlativo + 1;
				var o_nueve_campos:obj_nueve_campos = new obj_nueve_campos;
				o_nueve_campos.campo_uno = String(correlativo);
				o_nueve_campos.campo_dos = cmb_unidad.selectedItem.data;
				o_nueve_campos.campo_tres = cmb_tip_pregunta.selectedItem.data;
				o_nueve_campos.campo_cuatro = cmb_unidad.selectedItem.label;
				o_nueve_campos.campo_cinco = cmb_clase.selectedItem.data;
				o_nueve_campos.campo_seis = cmb_tip_pregunta.selectedItem.label;
				o_nueve_campos.campo_siete = String(num_cantidad.value);
				o_nueve_campos.campo_ocho = String(num_ponderacion.value);
				o_nueve_campos.campo_nueve = cmb_clase.selectedItem.label;

				arreglo.addItem(o_nueve_campos);	
				
			}
			else
			{
				if (sw==1) //si la unidad, clase y tipo ya ha sido agregada
					p_o = pondera - Number(lbl_porcentaje_selec[f].text) + num_ponderacion.value
				else //si la unidad, clase y tipo no ha sido agregada
					p_o = pondera + num_ponderacion.value; 
					
				if (p_o < puntaje + 1 && sw==1) //si la unidad y clase ya ha sido agregada y la nueva ponderacion no sobrepasa el puntaje total
				{
					arreglo[f].campo_siete = String(num_cantidad.value);
					arreglo[f].campo_ocho = String(num_ponderacion.value);
				}
				else if (p_o > puntaje) //si la nueva ponderacion supera al puntaje
					mx.controls.Alert.show("No se pudo efectuar la operacion ya que las sumas de los puntajes superan el puntaje máximo que es de: " + txt_puntaje.text + " Puntos", "Ayuda");
			}
				
			sw=0;
			f=-1;
	
			rp_ramos_selec.dataProvider=arreglo;
			
			
		}
		else
			mx.controls.Alert.show("Faltan datos necesarios para poder efectuar la operación de 'Agregar'", "Ayuda");
		
		suma();
	
	
}
//******************************************************************************************************
private function suma():void
{
	var i:int;
	var c_o:int;
	var c_d:int;
	var p_o:int;
	var p_d:int;
	var obj:Object;
	var grupo:Boolean;
	
	
	
	obj=rp_ramos_selec.dataProvider;
	
	c_o = 0;
	p_o = 0;
	c_d = 0;
	p_d = 0;
	
	for(i = 0; i < rp_ramos_selec.dataProvider.length; i++) 
	{
		if (obj[i].campo_tres=='1') // si es pregunta objetiva
		{
			c_o = c_o + Number(obj[i].campo_siete);
			p_o = p_o + Number(obj[i].campo_ocho);
		}
		else // si es pregunta de desarrollo
		{
			c_d = c_d + Number(obj[i].campo_siete);
			p_d = p_d + Number(obj[i].campo_ocho);
		}	
	}
	
	lbl_total_obj_cantidad.text = String(c_o);
	lbl_total_des_cantidad.text = String(c_d);
	
	lbl_total_obj_ponderacion.text = String(p_o) + " Pts";
	lbl_total_des_ponderacion.text = String(p_d) + " Pts";
	
	lbl_total_cantidad.text = String(c_o + c_d);
	lbl_total_ponderacion.text = String(p_o + p_d) + " Pts";
	pondera = p_o + p_d
	
	if (p_o + p_d==int(txt_puntaje.text))
	{
		canvas_ramos.enabled=true;
		chk_todos.enabled=true;
		btn_guardar.enabled=true;
		txt_puntaje.enabled=false;
	}
	else
	{
		canvas_ramos.enabled=false;
		chk_todos.enabled=false;
		btn_guardar.enabled=false;
		txt_puntaje.enabled=true;
	}
	
	
	
}
//******************************************************************************************************

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
//******************************************************************************************************
private function chk_todos_ok_click():void
{
	if (chk_todos_ok.selected==true)
	{
		chk_todos_ok.label="Quitar Seleccion";
		seleccion2(true);
	}
	else
	{
		seleccion2(false);
		chk_todos_ok.label="Seleccionar Todo";
	}
}
//******************************************************************************************************
private function seleccion(valor:Boolean):void
{
	var i:int; 
	if (rp_ramos.dataProvider != null)
	{
		for(i = 0; i < rp_ramos.dataProvider.length; i++) 
		{
			chk_ok[i].selected=valor;
		}
	}

}
//******************************************************************************************************
private function seleccion2(valor:Boolean):void
{
	var i:int; 
	if (rp_ramos_ok.dataProvider != null)
	{
		for(i = 0; i < rp_ramos_ok.dataProvider.length; i++) 
		{
			chk_ramo_ok[i].selected=valor;
		}
	}

}


//******************************************************************************************************
private function btn_guardar_click():void
{
	var i:int; 
	var x:int;
	var arre_guarda:ArrayCollection = new ArrayCollection;
	
	
	
	
	
	if (rp_ramos.dataProvider != null)
	{
		for(i = 0; i < rp_ramos.dataProvider.length; i++) 
		{
			if (chk_ok[i].selected==true)
			{
				for(x = 0; x < rp_ramos_selec.dataProvider.length; x++) 
				{
					var o_seis_campos_obj:obj_seis_campos = new obj_seis_campos;
					o_seis_campos_obj.campo_uno = lbl_cod[i].text;
					o_seis_campos_obj.campo_dos = lbl_cod_tip_pregunta[x].text;
					o_seis_campos_obj.campo_tres = lbl_cod_unidad[x].text;
					o_seis_campos_obj.campo_cuatro = lbl_cantidad_selec[x].text;
					o_seis_campos_obj.campo_cinco = lbl_porcentaje_selec[x].text;
					o_seis_campos_obj.campo_seis = lbl_cod_clase[x].text;
					arre_guarda.addItem(o_seis_campos_obj);	
				}
			}	
		}
		
		ro_asigna_prueba_unidad.guarda_prueba_unidad(arre_guarda, txt_puntaje.text, cmb_exigencia.selectedLabel, this.st_tiempo.value.toString());
		
	}
	
	
}
//******************************************************************************************************
private function btn_elimina_click():void
{
	var i:int; 
	var x:int;
	var arre_elimina:ArrayCollection = new ArrayCollection;
	
	if (rp_ramos_ok.dataProvider != null)
	{
		for(i = 0; i < rp_ramos_ok.dataProvider.length; i++) 
		{
			if (chk_ramo_ok[i].selected==true && chk_ramo_ok[i].visible==true)
			{
				var o_un_campo_obj:obj_un_campo_string = new obj_un_campo_string;
				o_un_campo_obj.campo_uno = lbl_eje_idn[i].text;
				arre_elimina.addItem(o_un_campo_obj);
			}
			
		}
		//mx.controls.Alert.show(arre_elimina[0].campo_uno);
		ro_asigna_prueba_unidad.elimina_ramos_ok(arre_elimina);
	}	
}
//******************************************************************************************************
private function muestra_ramos_ok():void
{
	ro_asigna_prueba_unidad.muestra_ramos_ejecucion(cmb_ejecucion.selectedItem.data, cmb_tipo_prueba.selectedItem.campo_uno, cmb_tipo_prueba.selectedItem.campo_tres );
}
//******************************************************************************************************
private function btn_nuevo_click():void
{
	cmb_ejecucion.selectedIndex=0;
	cmb_clase.selectedIndex=0;
	lbl_total_obj_cantidad.text="0";
	lbl_total_des_cantidad.text="0";
	lbl_total_cantidad.text="0";
	lbl_total_obj_ponderacion.text="0";
	lbl_total_des_ponderacion.text="0";
	lbl_total_ponderacion.text="0";
	lbl_codigo_ejecucion.text = "";
	txt_puntaje.text="0"
	contador=0
	
	canvas_ramos.enabled=false;
	btn_guardar.enabled=false;
	
	num_cantidad.value=0;
	num_ponderacion.value=0;
	
	cmb_tipo_prueba.dataProvider=null;
	cmb_unidad.selectedIndex=0;
	cmb_tip_pregunta.selectedIndex=0;
	
	rp_ramos_selec.dataProvider=null;
	arreglo=new ArrayCollection;
	rp_ramos.dataProvider=null;
	rp_ramos_ok.dataProvider=null;
	
	cmb_ejecucion.setFocus();
	
	chk_todos.selected = false;
	chk_todos.enabled = false;
	chk_todos_ok.selected = false;
	correlativo = 0;
	pondera = 0;
}

//******************************************************************************************************
private function cuenta_selec_click(evento:Event):void
{
	var item:Object=evento.currentTarget.getRepeaterItem();
	var obj:Object = rp_ramos_selec.dataProvider;

	if (chk_ok.selected==true)
		contador = contador +1
	else
		contador = contador -1
	
}

//******************************************************************************************************
private function btn_elimina_selec_click(evento:Event):void
{
	
	var item:Object=evento.currentTarget.getRepeaterItem();
	var obj:Object = rp_ramos_selec.dataProvider;
	var i:int;
	var arre_nuevo:ArrayCollection = new ArrayCollection;
	var sw:int = 0;
	
	for(i = 0; i < rp_ramos_selec.dataProvider.length; i++) 
	{
		if (item.campo_uno!=obj[i].campo_uno)
		{
			var o_ocho_campos:obj_ocho_campos = new obj_ocho_campos;
			o_ocho_campos.campo_uno = obj[i].campo_uno;
			o_ocho_campos.campo_dos = obj[i].campo_dos;
			o_ocho_campos.campo_tres = obj[i].campo_tres;
			o_ocho_campos.campo_cuatro = obj[i].campo_cuatro;
			o_ocho_campos.campo_cinco = obj[i].campo_cinco;
			o_ocho_campos.campo_seis = obj[i].campo_seis;
			o_ocho_campos.campo_siete = obj[i].campo_siete;
			o_ocho_campos.campo_ocho = obj[i].campo_ocho;
	
			arre_nuevo.addItem(o_ocho_campos);	
		}
		
	}
	arreglo = new ArrayCollection;
	rp_ramos_selec.dataProvider=null;
	rp_ramos_selec.dataProvider=arre_nuevo;
	arreglo = arre_nuevo;
	suma();
	
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}
//******************************************************************************************************