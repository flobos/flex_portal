// ActionScript file
import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.Button;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;



public var porcentaje_pago_popup:String;
public var direccion_pago_popup:String;
public var forma_pago_popup:String;
public var medio_pago_popup:String;
public var tipo_pago_popup:String;
public var numChild:Number = 0;
public var mod_cam_idn:String;
private var func_mod_fun_idn:String;
private var insc_idn:String;
private var operaciones_generadas:int = 0;
private var total_pagadores:int = 0;
private var total_productos:int = 0;
private var error_ingreso_alumno:int = 0;
private var arreglo_pagadores:ArrayCollection = new ArrayCollection;

public var url_frame:URLRequest;
//*******************************************************************************************************
private function inicio():void
{
	agregar_iplacex();
	
	
	func_mod_fun_idn = Application.application.parameters.func_mod_fun_idn;
	obtiene_modalidad_campus(func_mod_fun_idn);
//	llena_combo_tipo_admision();
}
//******************************************************************************************************
private function agregar_iplacex():void
{
	var arreglo:ArrayCollection = new ArrayCollection;
	var o_diez_campos:obj_diez_campos = new obj_diez_campos;
	
	o_diez_campos.campo_uno = '65';
	o_diez_campos.campo_dos = '78.230.020-2';
	o_diez_campos.campo_tres = 'IPLACEX LTDA.';
	o_diez_campos.campo_cuatro = 'Pers. Jurídica';
	o_diez_campos.campo_cinco = 'NO';
	o_diez_campos.campo_seis = 'null';
	o_diez_campos.campo_siete = '';
	o_diez_campos.campo_ocho = 'SI';
	o_diez_campos.campo_nueve = '0';
	o_diez_campos.campo_diez = 'Casa - AVENIDA COLIN 0815 Talca';
	arreglo.addItem(o_diez_campos);
	
	this.rp_entidades.dataProvider = arreglo;
}

//******************************************************************************************************
private function obtiene_modalidad_campus(f_mod_fun_idn:String):void
{
	ro_ingreso_inscripcion.obtiene_modalidad_campus(f_mod_fun_idn);
}
//***********************************************************************************************************
private function result_obtiene_modalidad_campus(event:ResultEvent):void
{
	var i:int;
	
	if (event.result.length > 0)
	{
		this.mod_cam_idn = event.result[0].campo_uno;
	}
	else
	{
		mx.controls.Alert.show("No se pudo obtener la modalidad del campus","Error");
	}
}
//******************************************************************************************************
/*private function llena_combo_tipo_admision():void
{
	var arreglo:ArrayCollection = new ArrayCollection;
	var o_dos_campos:obj_dos_campos = new obj_dos_campos;
	var o_dos_campos2:obj_dos_campos = new obj_dos_campos;
	var o_dos_campos3:obj_dos_campos = new obj_dos_campos;
	o_dos_campos.data = "N";
	o_dos_campos.label = "-- Seleccione --";
	arreglo.addItem(o_dos_campos);
	o_dos_campos2.data = "0";
	o_dos_campos2.label = "Normal";
	arreglo.addItem(o_dos_campos2);
	o_dos_campos3.data = "1";
	o_dos_campos3.label = "Especial";
	arreglo.addItem(o_dos_campos3);
	cmb_tipo_admision.dataProvider = arreglo;	
}*/
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}
//******************************************************************************************************

private function formatea_fecha(date:Date):String {
     return dfconv.format(date);
 } 
//******************************************************************************************************
private function popup_reportes():void
{
	var buscar:frm_registro_admision_ingreso_inscripcion_popup_reportes = frm_registro_admision_ingreso_inscripcion_popup_reportes(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_inscripcion_popup_reportes , true));
	mx.managers.PopUpManager.centerPopUp(buscar)
}
//*******************************************************************************************************
private function btn_detalle_click(event:Event):void
{
	var opt:Button=Button(event.currentTarget);
	var item:Object=opt.getRepeaterItem();
	var detalle:String;
	detalle = "Identificador: " + item.campo_dos + "\n";
	detalle = detalle + "Tipo: " + item.campo_cuatro + "\n";
	
	if (item.campo_siete != "")
	{
		detalle = detalle + "Envío Material: " + item.campo_siete + "\n";
	}
	if (item.campo_diez != "")
	{
		detalle = detalle + "Envío Pago: " + item.campo_diez + "\n";
	}
	mx.controls.Alert.show(detalle, item.campo_tres);
}


//******************************************************************************************************
private function popup_agrega_entidad():void
{
	var buscar:frm_registro_admision_ingreso_inscripcion_popup_agrega_entidad = frm_registro_admision_ingreso_inscripcion_popup_agrega_entidad(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_inscripcion_popup_agrega_entidad , true));
	mx.managers.PopUpManager.centerPopUp(buscar)
}

//******************************************************************************************************
public function cambiar_titulo_producto(titulo:String):void{
	var producto_seleccionado:int = new int;
	var formulario:Array;
	
	formulario = this.tn_productos.getChildren();
	producto_seleccionado = this.tn_productos.selectedIndex;
	formulario[producto_seleccionado].label = titulo;

}
//******************************************************************************************************
public function reiniciar_resumen():void{
	this.lbl_pago_malla.text = "0";
	this.lbl_asignado_malla.text = "0";
	this.lbl_asignar_malla.text = "0";
	this.lbl_pago_total.text = "0";
	this.lbl_asignado_total.text = "0";
	this.lbl_asignar_total.text = "0";
}

//******************************************************************************************************
public function agregar_producto():void {
	var formulario:frm_registro_admision_ingreso_inscripcion_popup_agrega_malla = new frm_registro_admision_ingreso_inscripcion_popup_agrega_malla;
	var o_dos_campos:obj_dos_campos;
	var arreglo:ArrayCollection = new ArrayCollection;
	var arreglo_pagadores:ArrayCollection = new ArrayCollection;
	var i:int;
	
	if (this.rp_entidades.dataProvider != null)
	{	
		for (i = 0; i < this.rp_entidades.dataProvider.length; i++)
		{
			o_dos_campos = new obj_dos_campos();
			if (lbl_toma_cursos[i].text != "NO")
			{
				o_dos_campos.data = lbl_id_entidad[i].text;
				o_dos_campos.label = lbl_nombre[i].text;
				arreglo.addItem(o_dos_campos);
			}
			o_dos_campos = new obj_dos_campos();
			if (lbl_pago[i].text != "NO")
			{
				o_dos_campos.data = lbl_id_entidad[i].text;
				o_dos_campos.label = lbl_nombre[i].text;
				arreglo_pagadores.addItem(o_dos_campos);
			}
		}
	}
	if (arreglo.length > 0)
	{
		if (arreglo_pagadores.length > 0)
		{
			formulario.alumnos_toma_curso = null;
			formulario.alumnos_toma_curso = arreglo;
			formulario.pagadores = null;
			formulario.pagadores = arreglo_pagadores;
			formulario.label = "Nuevo Producto";
			numChild = tn_productos.numChildren + 1;
			tn_productos.addChild(formulario);
			tn_productos.selectedIndex = tn_productos.numChildren - 1;
			this.pnl_entidades.enabled = false;
			
		}
		else
		{
			mx.controls.Alert.show("Debe añadir entidades con pago asociado","Alerta");
		}
	}
	else
	{
		mx.controls.Alert.show("Debe añadir entidades con toma de curso asignada", "Alerta");
	}
	
}
//*******************************************************************************************************

public function removeTab():void {
	if(tn_productos.numChildren > 0){
		numChild --;
		tn_productos.removeChildAt(tn_productos.selectedIndex);
		if (numChild == 0)
		{
			this.pnl_entidades.enabled = true;
		}
	}
	
}

//*******************************************************************************************************

private function btn_guardar_click():void
{	var pruductos:Array = new Array();
	var i:int;
	var flag:Boolean = false;
//	var form:frm_registro_admision_ingreso_inscripcion_popup_agrega_malla = this.tn[tn_productos.selectedIndex].form;
//	var form:frm_registro_admision_ingreso_inscripcion_popup_agrega_malla = this.tn_productos.getTabAt(tn_productos.selectedIndex);
	pruductos = tn_productos.getChildren();
	
	if (this.lbl_fecha_ingreso.text == "")
	{
		mx.controls.Alert.show("Debe seleccionar una fecha de ingreso","Alerta");
		this.lbl_fecha_ingreso.setFocus();
	}
	else
	{
		for (i=0; i < pruductos.length ; i++)
		{
			if (pruductos[i].producto_establecido == true)
			{
				flag = true;
			}
		}
		
		if(flag == false)
		{
			mx.controls.Alert.show("No existen productos confirmados para la inscripción actual","Alerta");
		}
		else
		{
			generar_inscripcion();
			this.btn_guardar.enabled = false;
		}
	
	}
		
}
//*******************************************************************************************************
private function generar_inscripcion():void
{
	ro_ingreso_inscripcion.ingreso_inscripcion('1'); // 1 es el tipo de inscripcion
}

//***********************************************************************************************************
private function result_ingreso_inscripcion(event:ResultEvent):void
{
	var i:int;
	
	if (event.result.length > 0)
	{
		insc_idn = event.result[0].campo_uno;
		guardar_productos();
	}
	else
	{
		mx.controls.Alert.show("No se pudo generar la inscripción","Error");
	}
}

//*******************************************************************************************************
private function guardar_productos():void
{
	var productos:Array = new Array();
	var i:int;
	
	var flag:Boolean = false;
	productos = tn_productos.getChildren();
	
	for (i=0; i < productos.length ; i++)
	{
		if (productos[i].producto_establecido == true)
		{
			total_pagadores = total_pagadores + productos[i].total_pagadores;
			total_productos++;
		}
	}
	
//	mx.controls.Alert.show(total_pagadores.toString(), total_productos.toString());
	
	for (i=0; i < productos.length ; i++)
	{
		if (productos[i].producto_establecido == true)
		{
			guardar_producto(i);
		}
	}

}
//*******************************************************************************************************
private function guardar_producto(i:int):void{
	var j:int;
	var productos:Array = new Array();
	productos = tn_productos.getChildren();
	
	guardar_alumno_producto(i);
		
	for (j=0; j < productos[i].rp_pagadores.dataProvider.length; j++)
	{
		guardar_pagador_producto(i,j);
		
	}
	
}
//*******************************************************************************************************
private function guardar_alumno_producto(i:int):void
{
	var productos:Array = new Array();
	productos = tn_productos.getChildren();
	ro_ingreso_inscripcion.ingreso_detalle_alumno(insc_idn, productos[i].cmb_alumno_asociado.selectedItem.data, productos[i].pro_mal_idn, lbl_fecha_ingreso.text, func_mod_fun_idn, productos[i].lbl_fecha_inicio_clases.text , i.toString(), 0);
}


//*******************************************************************************************************
private function result_ingreso_detalle_alumno(event:ResultEvent):void
{
	var i:int;
	
	if (event.result.length > 0)
	{
		guardar_jornada(event.result[0].campo_uno,event.result[0].campo_dos,event.result[0].campo_tres );
	}
	else
	{
		error_ingreso_alumno = 1;
	}
}
//*******************************************************************************************************
private function guardar_jornada(det_insc_idn:String, i:String, j:String):void
{
	var productos:Array = new Array();
	productos = tn_productos.getChildren();
	
	ro_ingreso_inscripcion.ingreso_parametro_jornada(det_insc_idn, productos[i].cmb_jornada.selectedItem.data);
}


//*******************************************************************************************************
private function guardar_pagador_producto(i:int, j:int):void
{
	var productos:Array = new Array();
	productos = tn_productos.getChildren();
//	mx.controls.Alert.show(insc_idn +'/'+ productos[i].lbl_id_entidad[j].text +'/'+ productos[i].pro_mal_idn +'/'+ lbl_fecha_ingreso.text +'/'+ func_mod_fun_idn +'/'+ i.toString() +'/'+ j.toString())
	ro_ingreso_inscripcion.ingreso_detalle_pagador(insc_idn, productos[i].lbl_id_entidad[j].text, productos[i].pro_mal_idn, lbl_fecha_ingreso.text, func_mod_fun_idn, i.toString(), j.toString());
}

//*******************************************************************************************************
private function result_ingreso_detalle_pagador(event:ResultEvent):void
{
	var i:int;
	
	if (event.result.length > 0)
	{
		generar_deuda_pagador(event.result[0].campo_uno, event.result[0].campo_dos, event.result[0].campo_tres);
	}
	else
	{
		mx.controls.Alert.show("No se pudo generar el detalle de inscripción","Error");
	}
}


//*******************************************************************************************************
private function result_ingreso_parametro_jornada(event:ResultEvent):void
{
	if (event.result.length > 0)
	{
	}
	else
	{
		mx.controls.Alert.show("No se pudo guardar el tipo de jornada","Error");
	}
}


//*******************************************************************************************************
private function generar_deuda_pagador(det_insc_idn:String, i_ind:String,j_ind:String):void
{
	var i:int = int(i_ind);
	var j:int = int(j_ind);
	var productos:Array = new Array();
	productos = tn_productos.getChildren();
//	mx.controls.Alert.show(det_insc_idn +'/'+ productos[i].lbl_id_medio_cobro[j].text +'/'+ productos[i].lbl_id_financiamiento[j].text +'/'+'100' +'/'+'1'+'/'+ i.toString()+'/'+j.toString());
	ro_ingreso_inscripcion.ingreso_deuda_pagador(det_insc_idn, productos[i].lbl_id_medio_cobro[j].text, productos[i].lbl_id_financiamiento[j].text,'100' ,'1', i.toString(),j.toString());
	
}
//*******************************************************************************************************
private function result_ingreso_deuda_pagador(event:ResultEvent):void
{
	var i:int;
	
	if (event.result.length > 0)
	{
		generar_detalle_operaciones(event.result[0].campo_uno, event.result[0].campo_dos, event.result[0].campo_tres);
	}
	else
	{
		mx.controls.Alert.show("No se pudo generar el detalle de deuda","Error");
	}
}
//*******************************************************************************************************
private function generar_detalle_operaciones(deu_idn:String, i_ind:String, j_ind:String):void
{
	var i:int = int(i_ind);
	var j:int = int(j_ind);
	var productos:Array = new Array();
	productos = tn_productos.getChildren();
	
	ro_ingreso_inscripcion.ingreso_detalle_operaciones(deu_idn, productos[i].lbl_total_pagar[j].text, '1', '0',productos[i].lbl_fecha_inicio_pago[j].text, productos[i].lbl_num_cuotas[j].text, productos[i].lbl_dia_vencimiento[j].text, i.toString(), j.toString())
}
	
//*******************************************************************************************************
private function result_ingreso_detalle_operaciones(event:ResultEvent):void
{
	var i:int;
	
	if (event.result.length > 0)
	{
		this.operaciones_generadas++;
		
		generar_contrato(event.result[0].campo_dos, event.result[0].campo_tres);
		
		if (operaciones_generadas == total_pagadores)
		{
			mx.controls.Alert.show("La inscripción N°"+ this.insc_idn+" se ha realizado exitosamente","Alerta");
			this.btn_informes.enabled = true;
		}
	//	mx.controls.Alert.show(event.result[0].campo_uno, event.result[0].campo_dos +'-'+ event.result[0].campo_tres);
	}
	else
	{
		mx.controls.Alert.show("No se pudo generar el detalle de deuda","Error");
	}
}
//*******************************************************************************************************	
private function generar_contrato(i_ind:String, j_ind:String):void
{
	var i:int = int(i_ind);
	var j:int = int(j_ind);
	var ind:int = 0;
	var productos:Array = new Array();
	productos = tn_productos.getChildren();
	var valor_beca:String = '0';
	var valor_matricula:String = '0';
	var o_once_campos:obj_once_campos;
	if (productos[i].lbl_id_entidad[j].text != '65')
	{
		
		//buscar valor beca
		for (ind=0; ind < productos[i].rp_pagadores.dataProvider.length; ind++)
		{
			if (productos[i].lbl_id_entidad[ind].text == '65')
			{
				valor_beca = productos[i].lbl_total_pagar[ind].text;
			}
		}
		o_once_campos = new obj_once_campos;
		o_once_campos.campo_uno = productos[i].lbl_id_entidad[j].text;
		o_once_campos.campo_dos = productos[i].cmb_alumno_asociado.selectedItem.data;
		o_once_campos.campo_tres = productos[i].pro_mal_idn
		o_once_campos.campo_cuatro = productos[i].lbl_valor_arancel.text;
		o_once_campos.campo_cinco = valor_beca;
		o_once_campos.campo_seis = valor_matricula;
		o_once_campos.campo_siete = productos[i].tip_prod_idn;
		o_once_campos.campo_ocho = productos[i].eje_adm_idn;
		o_once_campos.campo_nueve = productos[i].lbl_entidad[j].text;
		o_once_campos.campo_diez = productos[i].cmb_alumno_asociado.selectedItem.label;
		o_once_campos.campo_once = productos[i].titulo_carrera;
		this.arreglo_pagadores.addItem(o_once_campos);
//		
//		mx.controls.Alert.show("asdf");
		
		
//		url_frame = new URLRequest("http://192.168.1.10/reportes_flex_net/frm_contrato_ingreso_inscripcion.aspx?insc_idn="+insc_idn+"&pag_idn="+productos[i].lbl_id_entidad[j].text+"&alu_idn="+productos[i].cmb_alumno_asociado.selectedItem.data+"&pro_mal_idn="+productos[i].pro_mal_idn+"&func_mod_fun_idn="+this.func_mod_fun_idn+"&ara_tot="+productos[i].lbl_valor_arancel.text+"&bec_tot="+valor_beca+"&mat_tot="+valor_matricula);
//		navigateToURL(url_frame, "_blank");
	}
	
	
}

//*******************************************************************************************************
private function btn_informes_click():void{
	var buscar:frm_registro_admision_ingreso_inscripcion_popup_reportes = frm_registro_admision_ingreso_inscripcion_popup_reportes(PopUpManager.createPopUp( this, frm_registro_admision_ingreso_inscripcion_popup_reportes , true));
	buscar.arreglo_pag = this.arreglo_pagadores;
	buscar.mod_cam_idn = this.mod_cam_idn;
	buscar.func_mod_fun_idn = this.func_mod_fun_idn;
	buscar.insc_idn = this.insc_idn;
	mx.managers.PopUpManager.centerPopUp(buscar);
}

//*******************************************************************************************************
private function btn_elimina_selec_click(evento:Event):void
{
	if (this.tn_productos.numChildren == 0)
	{
		var item:Object=evento.currentTarget.getRepeaterItem();
		var obj:Object = rp_entidades.dataProvider;
		var i:int;
		var x:int;
		for(i = 0; i < rp_entidades.dataProvider.length; i++) 
		{
			if (item.campo_uno==obj[i].campo_uno)
			{
				x= i;	
			}
			
		}
		this.rp_entidades.dataProvider.removeItemAt(x);
		if (this.rp_entidades.dataProvider.length == 0)
		{
			this.pl_productos.enabled = false;
		}
		
	}
	else
	{
		mx.controls.Alert.show("Ya ha agregado productos, para modificar entidades debe realizar una nueva inscripción","Alerta");
	}
	
	
}

