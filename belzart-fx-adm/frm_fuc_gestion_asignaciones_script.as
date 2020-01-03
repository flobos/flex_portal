// ActionScript file
import com.kcc.tempos.utils.exporter.ExcelExporterUtil;

import flash.events.*;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import mx.rpc.http.HTTPService;

[Bindable]
private var uploadexcelURL:String;
private var downloadexcelURL:String;
private var xmlProperties:XML; 
private var servicePropReader:HTTPService; 


public var func_mod_fun_idn:String;
public var mod_idn:String;
private var conf_idn:String;

private var toma_curso:String = "0";
private var eje_idn:String = "";
private var eje_aca_idn:String = "";
private var pro_idn:String = "";
private var car_idn:String = "";
private var mal_idn:String = "";
private var num_seleccionados:int;
public var arreglo_modificaciones:Array;
public var arreglo_matriculas:Array;
[Bindable]
private var matriculas_multiples:Boolean = false;

//*******************************************************************************************************
private function buscar_matriculas():void
{
	this.ro_fuc_gestion_asignaciones.buscar_matriculas(func_mod_fun_idn, eje_idn,eje_aca_idn,pro_idn,car_idn,mal_idn, toma_curso);
	this.ro_fuc_gestion_asignaciones.buscar_matriculas_asignadas(func_mod_fun_idn, eje_idn,eje_aca_idn,pro_idn,car_idn,mal_idn, toma_curso);
}

private function btn_elimina_selec_click(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	
}

//*******************************************************************************************************
private function exportar_sin_asignacion():void 
{ 
	if (this.dg_matriculas.dataProvider != null && this.dg_matriculas.dataProvider.length > 0)
	{
	
		var bytes:ByteArray = ExcelExporterUtil.dataGridExporter(this.dg_matriculas, "matriculas_no_asignadas.xls");
		
		var urlRequest : URLRequest = new URLRequest();
		urlRequest.url = uploadexcelURL + '?folder='+ 'reportes_fuc';
		urlRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
		urlRequest.method = URLRequestMethod.POST;
		var n_archivo:String = "matriculas_sin_asignacion" + ".xls";
		urlRequest.data = UploadPostHelper.getPostData( n_archivo, bytes );
		urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
		var urlLoader : URLLoader = new URLLoader();
		urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		urlLoader.load(urlRequest);
		this.btn_descargar_no_asignados.enabled = true;
	}
	else
	{
		mx.controls.Alert.show("No existen datos para generar planilla","Alerta");
	}
}  

//*******************************************************************************************************
private function exportar_con_asignacion():void 
{ 
	if (this.dg_matriculas_asignadas.dataProvider != null && this.dg_matriculas_asignadas.dataProvider.length > 0)
	{
		var bytes:ByteArray = ExcelExporterUtil.dataGridExporter(this.dg_matriculas_asignadas, "matriculas_no_asignadas.xls");
		
		var urlRequest : URLRequest = new URLRequest();
		urlRequest.url = uploadexcelURL + '?folder='+ 'reportes_fuc';
		urlRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
		urlRequest.method = URLRequestMethod.POST;
		var n_archivo:String = "matriculas_con_asignacion" + ".xls";
		urlRequest.data = UploadPostHelper.getPostData( n_archivo, bytes );
		urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
		var urlLoader : URLLoader = new URLLoader();
		urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
		urlLoader.load(urlRequest);
		this.btn_descargar_asignados.enabled = true;
	}
	else
	{
		mx.controls.Alert.show("No existen datos para generar planilla","Alerta");
	}
} 

//*******************************************************************************************************
private function descargar_no_asignados():void 
{ 
	var url:String;
	url = downloadexcelURL + "matriculas_sin_asignacion.xls";
	bajar_no_asignados.iniciarDescarga(url);
}
//*******************************************************************************************************
private function descargar_asignados():void 
{ 
	var url:String;
	url = downloadexcelURL + "matriculas_con_asignacion.xls";
	bajar_asignados.iniciarDescarga(url);
}
//*******************************************************************************************************
private function eliminar_asignaciones():void
{
	var i:int;
	for (i = 0; i < rp_matriculas_asignadas.dataProvider.length; i++)
	{
		if(this.chk_matricula[i].selected == true)
		{
			this.ro_fuc_gestion_asignaciones.eliminar_asignacion(chk_matricula[i].label);
		}
	}
}

//*******************************************************************************************************
private function inicio():void
{
	func_mod_fun_idn = Application.application.parameters.func_mod_fun_idn;
	cargar_pantalla();
	getProperties();
}
//******************************************************************************************************
private function popup_agregar_funcionario(event:Event):void
{
	var popup:frm_fuc_gestion_asignaciones_popup_agrega_funcionario = frm_fuc_gestion_asignaciones_popup_agrega_funcionario(PopUpManager.createPopUp( this, frm_fuc_gestion_asignaciones_popup_agrega_funcionario , true));
	popup.indice_motivo = event.target.instanceIndices;
	mx.managers.PopUpManager.centerPopUp(popup);
	
}

//***********************************************************************************************************
private function btn_quitar_fun_click():void
{
	this.btn_agrega_funcionario.enabled = true;
	this.cmb_ejecuciones.dataProvider = null;
	this.cmb_ejecuciones.enabled = false;
	
}

//******************************************************************************************************
private function cargar_pantalla():void
{
	var arreglo:ArrayCollection = new ArrayCollection;
	var obj:obj_dos_campos = new obj_dos_campos;
	obj.data = "0";
	obj.label = "- Todas -";
	arreglo.addItem(obj);
	
	obj = new obj_dos_campos;
	obj.data = "1";
	obj.label = "Activas";
	arreglo.addItem(obj);
	
	obj = new obj_dos_campos;
	obj.data = "2";
	obj.label = "Inactivas";
	arreglo.addItem(obj);
	
	
	this.cmb_toma_curso.dataProvider = arreglo;
	this.cmb_toma_curso.selectedIndex = 0;
	
	limpiar_motivos();
	this.rp_matriculas.dataProvider = null;
	this.rp_motivos.dataProvider = null;
	this.rp_matriculas_asignadas.dataProvider = null;
	this.dg_matriculas.dataProvider = null;
	this.ro_fuc_gestion_asignaciones.buscar_ejecuciones(func_mod_fun_idn);
	this.ro_fuc_gestion_asignaciones.buscar_ejecuciones_academicas(func_mod_fun_idn);
	this.ro_fuc_gestion_asignaciones.buscar_promociones(func_mod_fun_idn);
	this.ro_fuc_gestion_asignaciones.buscar_mallas(func_mod_fun_idn);
	this.ro_fuc_gestion_asignaciones.buscar_carreras(func_mod_fun_idn);
	
	
	
}
//******************************************************************************************************
private function bnt_guardar_click():void
{	var i:int = 0;
	var j:int = 0;
	
	if (num_seleccionados < 0)
	{
		mx.controls.Alert.show("No ha seleccionado matricula(s)","Alerta");
	}
	else
	{
		if (rp_motivos.dataProvider == null)
		{
			mx.controls.Alert.show("No existen motivos a asociar","Alerta");
		}
		else
		{
			if (arreglo_modificaciones.length < 1)
			{
				mx.controls.Alert.show("No ha efectuado cambios","Alerta");
			}
			else
			{
				for (i = 0; i < rp_matriculas.dataProvider.length; i++)
				{
					if(this.chk_selected[i].selected == true)
					{
						j= 0;
						for (j = 0; j < arreglo_modificaciones.length; j++)
						{
							this.ro_fuc_gestion_asignaciones.insertar_asignacion(this.rp_motivos.dataProvider[arreglo_modificaciones[j]].campo_cuatro, lbl_matricula[i].text, this.rp_motivos.dataProvider[arreglo_modificaciones[j]].campo_uno);
						}
					}
				}
				mx.controls.Alert.show("Los cambios fueron guardados","Información");
				buscar_matriculas();
			}
		}
	}
}

//******************************************************************************************************
private function limpiar_motivos():void
{
	this.rp_motivos.dataProvider = null;
	matriculas_multiples = false;
	arreglo_modificaciones = new Array;
}

private function chk_selecionar_todas_change():void
{
	var i:int;
	if (this.rp_matriculas.dataProvider != null)
	{
		if(this.chk_seleccionar_todas.selected)
		{
			matriculas_multiples = true;
			this.ro_fuc_gestion_asignaciones.buscar_motivos(this.func_mod_fun_idn);	
			i = 0;
			for (i=0; i < rp_matriculas.dataProvider.length; i++)
			{
				chk_selected[i].selected = true;
			}
			num_seleccionados = rp_matriculas.dataProvider.length;
		}
		else
		{
			lbl_matricula_seleccionada.text = "Asignaciones de la matrícula "
			matriculas_multiples = false;
			this.rp_motivos.dataProvider = null;	
			i = 0;
			for (i=0; i < rp_matriculas.dataProvider.length; i++)
			{
				chk_selected[i].selected = false;
				
				num_seleccionados = 0;
			}
		}	
	}
	
}


//******************************************************************************************************
private function rp_matriculas_change(event:Event):void
{
	limpiar_motivos();
	var indice:int;
	var i:int = 0;
	var item:Object=event.currentTarget.getRepeaterItem();
	var obj:Object = rp_matriculas.dataProvider;
	
	indice = event.target.instanceIndices;
		
	if (this.chk_selected[indice].selected == true)
	{
		num_seleccionados++;
		if (num_seleccionados == 1)
		{
			lbl_matricula_seleccionada.text = "Asignaciones de la matrícula " + lbl_matricula[indice].text;
			this.ro_fuc_gestion_asignaciones.buscar_motivos_matriculas(this.func_mod_fun_idn,lbl_matricula[indice].text);	
		}
		else
		{
			matriculas_multiples = true;
			this.ro_fuc_gestion_asignaciones.buscar_motivos(this.func_mod_fun_idn);	
		}	
	}
	else
	{
		num_seleccionados--;
		if (num_seleccionados == 1)
		{
			i = 0;
			for (i=0; i < rp_matriculas.dataProvider.length; i++)
			{
				if(this.chk_selected[i].selected == true)
				{
					indice = i;
				}
			}
			lbl_matricula_seleccionada.text = "Asignaciones de la matrícula " + lbl_matricula[indice].text;
			this.ro_fuc_gestion_asignaciones.buscar_motivos_matriculas(this.func_mod_fun_idn,lbl_matricula[indice].text);
		}
		else 
		{
			if(num_seleccionados > 1)
			{
				matriculas_multiples = true;
				this.ro_fuc_gestion_asignaciones.buscar_motivos(this.func_mod_fun_idn);	
			}
			else
			{
				lbl_matricula_seleccionada.text = "Asignaciones de la matrícula "
				matriculas_multiples = false;
				this.rp_motivos.dataProvider = null;	
			}	
		}
		
	}
	
/*	if (num_seleccionados == 1)
	{
		this.ro_fuc_gestion_asignaciones.buscar_motivos_matriculas(this.func_mod_fun_idn,lbl_matricula[indice].text);	
	}
	else
	{
		matriculas_multiples = true;
		this.ro_fuc_gestion_asignaciones.buscar_motivos(this.func_mod_fun_idn);	
	}	
	*/
	
}
//******************************************************************************************************
private function cmb_ejecuciones_change():void
{
	limpiar_motivos();
	if(cmb_ejecuciones.selectedIndex > 0)
	{
		eje_idn = cmb_ejecuciones.selectedItem.data;
	}
	else
	{
		eje_idn = "";
	}
	
}
//******************************************************************************************************
private function cmb_toma_curso_change():void
{
	limpiar_motivos();
		toma_curso = cmb_toma_curso.selectedItem.data;
}
//******************************************************************************************************
private function cmb_ejecuciones_academicas_change():void
{
	limpiar_motivos();
	if(cmb_ejecuciones_academicas.selectedIndex > 0)
	{
		eje_aca_idn = cmb_ejecuciones_academicas.selectedItem.data;
	}
	else
	{
		eje_aca_idn = "";
	}
}

//******************************************************************************************************
private function cmb_carreras_change():void
{
	limpiar_motivos();
	if(cmb_carreras.selectedIndex > 0)
	{
		car_idn = cmb_carreras.selectedItem.data;
	}
	else
	{
		car_idn = "";
	}
}

//******************************************************************************************************
private function cmb_promociones_change():void
{
	limpiar_motivos();
	if(cmb_promociones.selectedIndex > 0)
	{
		pro_idn = cmb_promociones.selectedItem.data;
	}
	else
	{
		pro_idn = "";
	}

}
//******************************************************************************************************
private function cmb_mallas_change():void
{
	limpiar_motivos();
	if(cmb_mallas.selectedIndex > 0)
	{
		mal_idn = cmb_mallas.selectedItem.data;
	}
	else
	{
		mal_idn = "";
	}
}

//******************************************************************************************************
private function result_buscar_motivos(event:ResultEvent):void
{
	if (event.result.length <2 )
	{
		limpiar_motivos();
		mx.controls.Alert.show("No se encontraron motivos","Alerta");
	}
	else
	{
		this.rp_motivos.dataProvider = event.result;
	}
}

//******************************************************************************************************
private function result_buscar_mallas(event:ResultEvent):void
{
	if (event.result.length <2 )
	{
		this.cmb_mallas.dataProvider = undefined;
		mx.controls.Alert.show("No se encontraron mallas","Alerta");
	}
	else
	{
		this.cmb_mallas.dataProvider = event.result;
	}
}

//******************************************************************************************************
private function result_eliminar_asignacion(event:ResultEvent):void
{
	if (event.result.length > 0 )
	{
		mx.controls.Alert.show("No se pudo eliminar la matrícula " + event.result[0].campo_uno,"Alerta");
		buscar_matriculas();
	}
	else
	{
		buscar_matriculas();
	}
}


//******************************************************************************************************
private function result_buscar_carreras(event:ResultEvent):void
{
	if (event.result.length <2 )
	{
		this.cmb_carreras.dataProvider = undefined;
		mx.controls.Alert.show("No se encontraron carreras","Alerta");
	}
	else
	{
		this.cmb_carreras.dataProvider = event.result;
	}
}

//******************************************************************************************************
private function result_buscar_promociones(event:ResultEvent):void
{
	if (event.result.length <2 )
	{
		this.cmb_promociones.dataProvider = undefined;
		mx.controls.Alert.show("No se encontraron promociones","Alerta");
	}
	else
	{
		this.cmb_promociones.dataProvider = event.result;
	}
}

//******************************************************************************************************
private function result_buscar_ejecuciones_academicas(event:ResultEvent):void
{
	if (event.result.length <2 )
	{
		this.cmb_ejecuciones_academicas.dataProvider = undefined;
		mx.controls.Alert.show("No se encontraron ejecuciones académicas","Alerta");
	}
	else
	{
		this.cmb_ejecuciones_academicas.dataProvider = event.result;
	}
}

//******************************************************************************************************
private function result_buscar_ejecuciones(event:ResultEvent):void
{
	if (event.result.length <2 )
	{
		this.cmb_ejecuciones.dataProvider = undefined;
		mx.controls.Alert.show("No se encontraron ejecuciones activas","Alerta");
	}
	else
	{
		this.cmb_ejecuciones.dataProvider = event.result;
	}
}

//******************************************************************************************************
private function result_buscar_matriculas(event:ResultEvent):void
{
		this.rp_matriculas.dataProvider = event.result;
		this.dg_matriculas.dataProvider = event.result;
		this.lbl_num_matriculas.text = event.result.length.toString();
}
//******************************************************************************************************
private function result_buscar_matriculas_asignadas(event:ResultEvent):void
{
		this.rp_matriculas_asignadas.dataProvider = event.result;
		this.dg_matriculas_asignadas.dataProvider = event.result;
		this.lbl_num_matriculas0.text = event.result.length.toString();
}
//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
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
	downloadexcelURL = xmlProperties.property.(name=="excelURLdownload").value;
	uploadexcelURL = xmlProperties.property.(name=="excelURL").value;
}	

