// ActionScript file
import flash.events.KeyboardEvent;
import flash.net.URLRequest;
import flash.xml.XMLDocument;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.*;
import mx.graphics.ImageSnapshot;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import mx.utils.URLUtil;

private var arreglo_detalle:ArrayCollection = new ArrayCollection;
private var abono:int;
private var total_asignado:Boolean = false;
private var monto_asignado:int = 0;
private var arreglo_medios:ArrayCollection = new ArrayCollection;
private var det_ope_idn:String = "";
private var det_ope_idn_cargos:String = "";
private var det_ope_idn_cargo:String = "";
private var doc_ele_idn:String;
private var ord_pag_idn:String;
private var pro_mal_idn:String;
public var func_mod_fun_idn:String;
public var fun_rut:String;
private var num_boleta:String;
private var arreglo_cargos:ArrayCollection = new ArrayCollection;
private var cargos:int;
//variables de detalle de cheque
public var banco_cheque:String = "";
public var plazo_cheque:String = "";
public var serie_cheque:String = "";
public var rut_cheque:String = "";
public var nombres_cheque:String = "";
public var paterno_cheque:String = "";
public var materno_cheque:String = "";
public var pago_mes:String;
public var nombre_item:String;
public var total_cobros:String;
public var total_abonos:String;
public var num_cuotas:String;
public var deu_idn:String;
public var deuda_total:String;
//***********************************************************************************************************
private function inicio():void
{
	this.lbl_deuda_total.text = this.deuda_total;
	this.lbl_pago_mes.text = this.pago_mes; 
	this.ro_pagos.busca_medio_pago();
	this.ro_pagos.busca_concepto_pago();
	this.dg_detalle_pagos.dataProvider = arreglo_detalle;
	this.dg_medios.dataProvider = arreglo_medios;
	
}


//***********************************************************************************************************
private function result_busca_medio_pago(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		this.btn_agregar_pago.enabled = false;
		mx.controls.Alert.show("No se encontraron medios de pago", "Información");
	}
	else
	{
		this.cmb_medio_pago.dataProvider = event.result;
	}
}

//***********************************************************************************************************
private function result_busca_concepto_pago(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No se encontraron conceptos de pago", "Información");
	}
	else
	{
		this.cmb_concepto.dataProvider = event.result;
	}
}



//***********************************************************************************************************
private function agregar_pago():void {
	if (total_cobros != "")
	{
		var pago:int = 0;
		
		if (this.pagos.selection != null)
		{
			if (this.rb_deuda_mes.selected == true)
			{
				if (this.lbl_pago_mes.text != "0")
				{
					pago = int(this.lbl_pago_mes.text);
					agrega_pago(pago);
				}
				else
				{
					mx.controls.Alert.show("El pago mensual es cero","Alerta");
				}
			}
			if (this.rb_deuda_total.selected == true)
			{
				pago = int(this.lbl_deuda_total.text);
				agrega_pago(pago);
			}
			if (this.rb_deuda_otro.selected == true)
			{
				if (this.lbl_otro_pago.text != "")
				{
					if (int(this.lbl_otro_pago.text) <= int(this.lbl_deuda_total.text))
					{
						pago = int(this.lbl_otro_pago.text);
						agrega_pago(pago);
					}
					else
					{
						mx.controls.Alert.show("La cantidad indicada es mayor a la deuda total","Alerta");
					}
				}
				else
				{
					mx.controls.Alert.show("Debe indicar una cantidad a cancelar","Alerta");
				}
			}
		}
		else
			
		{
			mx.controls.Alert.show("Debe seleccionar un tipo de pago","Alerta");
		}
		
	}
	else
	{
		mx.controls.Alert.show("No existen deudas seleccionadas", "Alerta");
	}
	
}

//***********************************************************************************************************
private function agregar_cobro():void
{
	if (this.cmb_concepto.selectedItem != null && this.lbl_valor_cargo.text != "")
	{
		agregar_cobros(this.cmb_concepto.selectedLabel, int(this.lbl_valor_cargo.text));
		var o_dos_campos:obj_dos_campos = new obj_dos_campos;
		o_dos_campos.data = this.cmb_concepto.selectedItem.data;
		o_dos_campos.label = this.lbl_valor_cargo.text;
		this.arreglo_cargos.addItem(o_dos_campos);
		this.cargos = this.cargos + int(this.lbl_valor_cargo.text);
		this.cmb_concepto.enabled = false; 
		this.btn_agregar_cargo.enabled = false;
		this.lbl_valor_cargo.editable = false;
//		this.abono = this.abono + int(this.lbl_valor_cargo.text);
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar un concepto de cargo e indicar un valor","Alerta");
	}
}


//***********************************************************************************************************
private function agrega_pago(pago:int):void{
	var n_cuotas:int = int(this.num_cuotas);
	var valor_cuota:int = int(total_cobros)/n_cuotas;
	var total_abono:int = int(total_abonos);
	var i:int = 0;
	var cuota_actual:int = 1;
	var resto_cuota:int = 0;
	var cuotas_restantes:int = 0;
	var flag_cuotas:Boolean = true;
	abono = pago;
	
	this.btn_agregar_pago.enabled = false;
	this.pagos.enabled = false;
	this.lbl_otro_pago.enabled = false;
	this.btn_guardar_pagos.enabled = true;
	
	if (total_abono != 0)
	{
		for (i=0;i<n_cuotas;i++)
		{
			if (flag_cuotas)
			{
				if ((total_abono - valor_cuota) >= 0)
				{
					cuota_actual = i + 2;
					if (total_abono >0)
					{
						total_abono = total_abono - valor_cuota;
					}
				}
				else
				{
					cuota_actual = i + 1;
					resto_cuota = valor_cuota - total_abono;
					flag_cuotas = false;
				}
			}
		}	
	}
	else
	{
		cuota_actual = 1;
	}
	
	
	cuotas_restantes = n_cuotas - (cuota_actual - 1);
	i = 0;
	
	for (i=0;i<cuotas_restantes; i++)
	{
		
		if (pago != 0)
		{
			//			if (valor_cuota - resto_cuota > pago  )
			//			{
			if(resto_cuota > 0 && resto_cuota != valor_cuota && resto_cuota < pago)
			{
				
				agregar_detalle_pago(resto_cuota.toString() + " de cuota N° " +(i+cuota_actual).toString() + " de " +n_cuotas.toString(), resto_cuota);
				pago = pago - resto_cuota;
				resto_cuota = 0;
				
			}
			else
			{
				if (pago > valor_cuota)
				{
					agregar_detalle_pago("Cuota N° " +(i+cuota_actual).toString() + " de " +n_cuotas.toString() , valor_cuota);
					pago = pago - valor_cuota;	
				}
				else
				{
					if (pago == valor_cuota)
					{
						agregar_detalle_pago("Cuota N° " +(i+cuota_actual).toString() + " de " +n_cuotas.toString() , pago);
					}
					else
					{
						agregar_detalle_pago(pago.toString()+" de cuota N° " +(i+cuota_actual).toString() + " de " +n_cuotas.toString(), pago);
					}
					pago = 0;
				}
			}
			/*			}
			else
			{
			agregar_detalle_pago(pago.toString()+" de cuota NÂ° " +(i+cuota_actual).toString() + " de " +n_cuotas.toString(), pago);
			pago = 0;
			mx.controls.Alert.show("dsfa");
			}		*/	
		}
	}
	
}
//***********************************************************************************************************

private function confirmar_pago():void{
	
	if (this.dg_detalle_pagos.dataProvider.length >0)
	{
		this.btn_guardar_pagos.enabled = false;
		this.btn_agregar_cargo.enabled = false;
		this.lbl_valor.text = (abono + cargos).toString();
		this.btn_agregar_medio.enabled = true;
		this.cmb_concepto.enabled = false;
		mx.controls.Alert.show("Ahora indique Medio(s) de Pago","Alerta");
	}
	else
	{
		mx.controls.Alert.show("Debe desglosar un pago","Alerta");
	}
}
//***********************************************************************************************************
public function agregar_medio():void{
	if (total_asignado == true)
	{
		mx.controls.Alert.show("Ya asignó el total del pago","Alerta");
	}
	else
	{
		if (this.cmb_medio_pago.selectedItem.label == "Cheque" && this.banco_cheque == "")
		{
			var cheque:frm_registro_admision_pagos_detalle_cheque = frm_registro_admision_pagos_detalle_cheque(PopUpManager.createPopUp( this, frm_registro_admision_pagos_detalle_cheque , true));
			cheque.monto = this.lbl_valor.text;
			mx.managers.PopUpManager.centerPopUp(cheque);
		}
		else
		{
			if (this.lbl_valor.text != ""){
				
				if (monto_asignado + int(this.lbl_valor.text) <= (abono + cargos))
				{
					monto_asignado = monto_asignado + int(this.lbl_valor.text);
					
					
					var o_once_campos:obj_once_campos = new obj_once_campos;
					o_once_campos.campo_uno = this.lbl_valor.text;
					o_once_campos.campo_dos = this.cmb_medio_pago.selectedItem.data;
					o_once_campos.campo_tres = this.cmb_medio_pago.selectedItem.label;
					o_once_campos.campo_cuatro = this.banco_cheque;
					o_once_campos.campo_cinco = this.plazo_cheque;
					o_once_campos.campo_seis = this.serie_cheque;
					o_once_campos.campo_siete = this.rut_cheque;
					o_once_campos.campo_ocho = this.nombres_cheque;
					o_once_campos.campo_nueve = this.paterno_cheque;
					o_once_campos.campo_diez = this.materno_cheque;
					
					
					this.arreglo_medios.addItem(o_once_campos);
					this.dg_medios.dataProvider = arreglo_medios;
					
					this.banco_cheque = "";
					this.plazo_cheque = "";
					this.serie_cheque = "";
					this.rut_cheque = "";
					this.nombres_cheque = "";
					this.paterno_cheque = "";
					this.materno_cheque = "";
					
					
					if (monto_asignado == (abono + cargos))
					{
						this.btn_agregar_medio.enabled = false;
						this.btn_guardar_pago.enabled = true;
					}
					else
					{
						this.lbl_valor.text = ((abono + cargos) - monto_asignado).toString();
					}
				}
				else
				{
					mx.controls.Alert.show("La suma a asignar supera el valor total del pago","Alerta");	
				}
			}
			else
			{
				mx.controls.Alert.show("Debe indicar un valor","Alerta")
			}
		}
		
		
	}
	
}
//***********************************************************************************************************
private function generar_cargos():void
{
	if (this.arreglo_cargos.length > 0)
	{
		this.ro_pagos.generar_cargos(this.arreglo_cargos, this.deu_idn);
		
	}
	else
	{
		this.ro_pagos.agrega_detalle_operacion(deu_idn, this.abono.toString());
	}
}
//***********************************************************************************************************

private function result_generar_cargos(event:ResultEvent):void{
	
	if (event.result.length > 0 )
	{
		this.ro_pagos.agrega_detalle_operacion(deu_idn, this.abono.toString());
		this.det_ope_idn_cargo = event.result[0].campo_uno;
	}else{
		
		mx.controls.Alert.show('No se pudieron generar los cargos', 'Alerta')
	}
	
	
	
}

//***********************************************************************************************************
private function guardar_pago():void
{
	if (this.lbl_fecha_actual.text != "" )
	{
		if (this.lbl_num_boleta.text != "")
		{
			this.ro_pagos.valida_boleta(this.lbl_num_boleta.text, fun_rut);
		}
		else
		{
			this.ro_pagos.valida_boleta_automatica(fun_rut);
		}
		
	}
	else
	{
		mx.controls.Alert.show("Seleccione una fecha de Boleta","Alerta");
	}
}
//******************************************************************************************************
private function result_valida_boleta(event:ResultEvent):void{
	
	if (event.result[0].data == "1"){
		
		generar_cargos();
		
	}else{
		
		mx.controls.Alert.show('Error de verificación de la boleta , verifique info en sistema ...', 'Alerta')
		
	}
	
	
	
}
//******************************************************************************************************
private function result_valida_boleta_automatica(event:ResultEvent):void{
	
	if (event.result[0].data == "1"){
		
		generar_cargos();
		
	}else{
		
		mx.controls.Alert.show('Error de verificación de la boleta automática , verifique info en sistema ...', 'Alerta')
		
	}
	
	
	
}
//******************************************************************************************************
private function result_agrega_detalle_operacion(event:ResultEvent):void
{	
	var x:int;
	if (event.result.length <1 )
		mx.controls.Alert.show("No se pudo generar el detalle de la operación","Alert");
	else{
		this.det_ope_idn = event.result[0].campo_uno;
		generar_glosa_detalle_operacion();
		
		if (cargos == 0)
		{
			generar_boleta_electronica();	
		}
		else
		{
			
			this.ro_pagos.agrega_detalle_operacion_cargos(deu_idn, this.cargos.toString(), this.cmb_concepto.selectedItem.data);
		}
		
	}
}
//******************************************************************************************************
private function result_agrega_detalle_operacion_cargos(event:ResultEvent):void
{	
	var x:int;
	if (event.result.length <1 )
		mx.controls.Alert.show("No se pudo generar el detalle de la operación de los cargos","Alert");
	else{
		this.det_ope_idn_cargos = event.result[0].campo_uno;
		generar_glosa_detalle_operacion_cargos();
		generar_boleta_electronica();	
		}
}
//***********************************************************************************************************
private function generar_boleta_electronica():void{
	
	if (this.lbl_num_boleta.text == "")
	{
		this.ro_pagos.muestra_boleta_sede(this.fun_rut);
		
	}
	else
	{
		this.ro_pagos.agrega_boleta_electronica((abono + cargos).toString(), this.lbl_num_boleta.text);	
	}
	
}

//******************************************************************************************************
private function result_muestra_boleta_sede(event:ResultEvent):void
{	
	if (event.result.length <1 ){
		mx.controls.Alert.show("No se encontro la boleta/sede","Alerta");
	}
	else
	{
		mx.controls.Alert.show("El Numero de Boleta actual es " + event.result[0].campo_uno + ". ¿Desea continuar?", "Confirmar", 3, this, alertClickHandler);
	}
}

//******************************************************************************************************
private function alertClickHandler(event:CloseEvent):void {
	var mod_ejecuciones:String;
	if (event.detail==Alert.YES){
		this.ro_pagos.agrega_boleta_electronica_automatica((abono + cargos).toString(), this.fun_rut);
	}
	else
	{
		mx.controls.Alert.show("Comuníquese con la Dirección de Informática para corregir el número de boleta automático","Alerta");
		ro_pagos.borrar_datos(this.det_ope_idn, this.det_ope_idn_cargos, this.det_ope_idn_cargo);
	}
	
}

//******************************************************************************************************
private function result_agrega_boleta_electronica(event:ResultEvent):void
{	
	var x:int;
	if (event.result.length <1 )
		mx.controls.Alert.show("No se pudo generar la boleta electrónica","Alert");
	else{
		this.doc_ele_idn = event.result[0].data;
		this.num_boleta = event.result[0].label;
		generar_orden_pago();
	}
}
//***********************************************************************************************************
private function generar_orden_pago():void{
	this.ro_pagos.agrega_orden_pago(this.det_ope_idn, this.func_mod_fun_idn, this.det_ope_idn_cargos);
}
//******************************************************************************************************
private function result_agrega_orden_pago(event:ResultEvent):void
{	
	var x:int;
	if (event.result.length <1 || (event.result.length < 2 && this.cargos > 0))
		mx.controls.Alert.show("No se pudo generar la operacion/orden de pago","Alert");
	else{
		if (event.result[0].data != "")
		{
			this.ord_pag_idn = event.result[0].data;
			agregar_detalle_orden_pago();
		}
		else
		{
			mx.controls.Alert.show("No se pudo generar la orden de pago","Alert");
		}
	}
}
//***********************************************************************************************************
private function agregar_detalle_orden_pago():void{
	this.ro_pagos.agrega_detalle_orden_pago(this.ord_pag_idn, this.arreglo_medios, this.doc_ele_idn);
}
//******************************************************************************************************
private function result_agrega_detalle_orden_pago(event:ResultEvent):void
{
	if (event.result.length <1 )
		mx.controls.Alert.show("Error al ingresar el pago. Comuníquese con la Dirección de Informática","Alert");
	else{
		generar_boleta();
	}
}
//***********************************************************************************************************
private function generar_boleta():void
{
	var i:int;
	var fecha_emision:String = this.lbl_fecha_actual.text;
	var valor_codigo:String = this.pro_mal_idn;
	var xml_boleta:XMLDocument = new XMLDocument;
	
	var str_xml:String;
	str_xml = "<BOLETA>";
	str_xml = str_xml + "<Encabezado>";
	str_xml = str_xml + "<IdDoc>";
	str_xml = str_xml + "<TipoDTE>41</TipoDTE>";
	str_xml = str_xml + "<Folio>" + this.doc_ele_idn + "</Folio>";
	str_xml = str_xml + "<FchEmis>" + fecha_emision +"</FchEmis>";
	str_xml = str_xml + "<IndServicio>3</IndServicio>";
	str_xml = str_xml + "</IdDoc>";
	str_xml = str_xml + "<Emisor>";
	str_xml = str_xml + "<RUTEmisor>78.230.020-2</RUTEmisor>";
	str_xml = str_xml + "<RznSoc>SOC INSTITUTO PROFESIONAL LATINOAMERICANO DE COMERCIO EXTERIOR LTDA</RznSoc>";
	str_xml = str_xml + "<GiroEmis>INSTITUTOS PROFESIONALES</GiroEmis>";
	str_xml = str_xml + "<DirOrigen>18 de Septiembre NÂ°182</DirOrigen>";
	str_xml = str_xml + "<CmnaOrigen>Santiago</CmnaOrigen>";
	str_xml = str_xml + "<CiudadOrigen>Santiago</CiudadOrigen>";
	str_xml = str_xml + "</Emisor>";
	str_xml = str_xml + "<Receptor>";	
	str_xml = str_xml + "<RUTRecep>15.598.305-1</RUTRecep>";
	str_xml = str_xml + "<CdgIntRecep>17</CdgIntRecep>";
	str_xml = str_xml + "<DirRecep>4 Oriente</DirRecep>";
	str_xml = str_xml + "<CmnaRecep>Talca</CmnaRecep>";
	str_xml = str_xml + "<CiudadRecep>Talca</CiudadRecep>";
	str_xml = str_xml + "</Receptor>";
	str_xml = str_xml + "<Totales>";
	str_xml = str_xml + "<MntExe>"+(abono + cargos).toString()+"</MntExe>";
	str_xml = str_xml + "<MntTotal>"+(abono + cargos).toString()+"</MntTotal>";
	str_xml = str_xml + "<TmstFirma>2012-03-16 15:00:00</TmstFirma>";
	str_xml = str_xml + "</Totales>";
	str_xml = str_xml + "</Encabezado>";
	
	for(i = 0; i < this.dg_detalle_pagos.dataProvider.length; i++)
	{
		str_xml = str_xml + "<Detalle>";
		str_xml = str_xml + "<CdgItem>";
		str_xml = str_xml + "<TpoCodigo>INT1</TpoCodigo>";
		str_xml = str_xml + "<VlrCodigo>"+valor_codigo+"</TpoCodigo>";
		str_xml = str_xml + "</CdgItem>";
		str_xml = str_xml + "<NmbItem>"+nombre_item+"</NmbItem>";
		str_xml = str_xml + "<DscItem>"+this.dg_detalle_pagos.dataProvider[i].campo_uno+"</DscItem>";
		str_xml = str_xml + "<MontoItem>"+this.dg_detalle_pagos.dataProvider[i].campo_dos+"</MontoItem>";
		str_xml = str_xml + "</Detalle>";
	}
	str_xml = str_xml + "</BOLETA>";
	
	
	mx.controls.Alert.show("Pago ingresado correctamente","Boleta N°" + this.num_boleta); 
	
	
	
	var request:URLRequest = new URLRequest("http://192.168.1.10/reportes_flex_net/frm_reporte_boletas_sedes_nuevo.aspx?codigo=" + String(this.doc_ele_idn));
	navigateToURL(request, "_blank");
	limpiar_pantalla();
	this.parentApplication.limpiar_pantalla();
	this.btn_cancelar_click();
	//comprobante electronico
	/*
	var boleta:frm_registro_admision_pagos_boleta = frm_registro_admision_pagos_boleta(PopUpManager.createPopUp( this, frm_registro_admision_pagos_boleta , true));
	boleta.detalle = this.arreglo_detalle;
	boleta.nombre_alumno = this.dg_deudas.selectedItem.campo_tres;
	boleta.curso_alumno = this.dg_deudas.selectedItem.campo_dos;
	boleta.total = this.abono.toString();
	boleta.num_boleta = this.num_boleta;
	
	boleta.fecha = this.lbl_fecha_actual.text;
	
	mx.managers.PopUpManager.centerPopUp(boleta);
	*/
}


//***********************************************************************************************************
private function limpiar_pantalla():void
{
	this.lbl_deuda_total.text = "";
	this.lbl_pago_mes.text = "";
	this.lbl_otro_pago.text = "";
	this.rb_deuda_mes.selected = false;
	this.btn_agregar_pago.enabled = true;
	this.rb_deuda_total.selected = false;
	this.rb_deuda_otro.selected = false;
	this.dg_detalle_pagos.dataProvider = null;
	this.btn_guardar_pagos.enabled = false;
	this.lbl_valor.text = "";
	this.btn_guardar_pago.enabled = false;
	this.lbl_fecha_actual.text = "";
	this.lbl_num_boleta.text = "";
	this.cmb_medio_pago.selectedIndex = 0;
	this.dg_medios.dataProvider = null;
	this.lbl_otro_pago.enabled = true;
	this.lbl_deuda_total.enabled = true;
	this.lbl_pago_mes.enabled = true;
	
	arreglo_detalle = new ArrayCollection;
	num_cuotas = "";
	abono = 0;
	total_asignado = false;
	monto_asignado = 0;
	arreglo_medios = new ArrayCollection;
	det_ope_idn = "";
	doc_ele_idn = "";
	ord_pag_idn = "";
	pro_mal_idn = "";
	num_boleta = "";
	cargos = 0;
	
	
}
//***********************************************************************************************************
private function generar_glosa_detalle_operacion():void{

	var i:int = 0;
	for (i = 0; i< this.dg_detalle_pagos.dataProvider.length;i++)
	{
		if (this.dg_detalle_pagos.dataProvider[i].campo_tres == "4")
		{
			this.ro_pagos.agrega_glosa_detalle_operacion(this.det_ope_idn, dg_detalle_pagos.dataProvider[i].campo_uno,  dg_detalle_pagos.dataProvider[i].campo_dos);	
		}
		
	}

}
//***********************************************************************************************************
private function generar_glosa_detalle_operacion_cargos():void{
	
	var i:int = 0;
	for (i = 0; i< this.dg_detalle_pagos.dataProvider.length;i++)
	{
		if (this.dg_detalle_pagos.dataProvider[i].campo_tres != "4")
		{
			this.ro_pagos.agrega_glosa_detalle_operacion(this.det_ope_idn_cargos, dg_detalle_pagos.dataProvider[i].campo_uno,  dg_detalle_pagos.dataProvider[i].campo_dos);	
		}
		
	}
	
}
//******************************************************************************************************
private function result_agrega_glosa_detalle_operacion(event:ResultEvent):void
{	
	var x:int;
	if (event.result.length <1 )
		mx.controls.Alert.show("No se pudo generar la glosa del detalle de operacion","Alert");
	else{
	}
}
//***********************************************************************************************************
private function agregar_cobros(detalle:String, valor:int):void{
	
	var o_tres_campos:obj_tres_campos = new obj_tres_campos;
	o_tres_campos.campo_uno = detalle;
	o_tres_campos.campo_dos = valor.toString();
	o_tres_campos.campo_tres = this.cmb_concepto.selectedItem.data;
		
	this.arreglo_detalle.addItem(o_tres_campos);
	this.dg_detalle_pagos.dataProvider = this.arreglo_detalle;
	
}
//***********************************************************************************************************
private function agregar_detalle_pago(detalle:String, valor:int):void{
	
	var o_tres_campos:obj_tres_campos = new obj_tres_campos;
	o_tres_campos.campo_uno = detalle;
	o_tres_campos.campo_dos = valor.toString();
	o_tres_campos.campo_tres = "4";
	
	this.arreglo_detalle.addItem(o_tres_campos);
	this.dg_detalle_pagos.dataProvider = this.arreglo_detalle;
	
}
//******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);
}

//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}
//******************************************************************************************************

private function formatea_fecha(date:Date):String {
	return dfconv.format(date);
} 
