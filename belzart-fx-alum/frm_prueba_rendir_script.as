import flash.events.Event;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;
import mx.rpc.http.HTTPService;

// ActionScript Document
public var obj_cmb:Object;
public var matricula:String;
public var eje_aca:String;
public var valida_guarda:String;
public var aux:String;
public var mal_nombre:String;
public var cur_nombre:String;
public var nombre_alumno:String;
public var tc_idn:String;
public var ServerResponse:String;
public var ServerResponseRaw:String;
private var total_dt_grupos:int;
private var dt_grupo_guardados:int = 0;
public var uploadURL:String;

private var xmlProperties:XML; 
private var servicePropReader:HTTPService; 

private function result_muestra_informacion_de_toma_curso(event:ResultEvent):void{

var arreglo100:Object;
	arreglo100 = event.result; 
	
	if (arreglo100.length == 0){
	
		mx.controls.Alert.show('No se pudo recuperar datos, intente nuevamente','ERRROR' )	
	}
	else{
	
	matricula = arreglo100[0].campo_dos;
	eje_aca = arreglo100[0].campo_tres
	mal_nombre =arreglo100[0].campo_cuatro
	cur_nombre = arreglo100[0].campo_cinco
	nombre_alumno = arreglo100[0].campo_uno
	
	ro_grupos.ro_carga_tipo_evaluacion(matricula, eje_aca);

		}
}
//**********************************************************************************************************
private function carga():void
{	
	getProperties();
	this.addEventListener(UploadEvent.UPLOAD_EVENT, uploadEventHandler);
			
			
	txt_rut.enabled = false;
	btn_ingresar.enabled = false;

	btn_si.enabled = false;
	btn_no.enabled = false;
	btn_examinar.enabled =false;
	btn_guardar.enabled = false;
	valida_guarda = '0';
	tc_idn = this.parentApplication.tc_idn;
	
	ro_grupos.muestra_informacion_de_toma_curso(tc_idn);
	
}

private function uploadEventHandler(event:UploadEvent):void {
			ServerResponse = event.ServerResponse;
			ServerResponseRaw = event.ServerResponseRaw;
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

			uploadURL = xmlProperties.property.(name=="UploadURL").value;
		}	
//*****************************************************************************************************
private function devuelve_datos_correlativos_trabajo(event:ResultEvent):void
{
	var arreglo:Object;
	arreglo = event.result; 
	
	if (arreglo.length == 0){
		mx.controls.Alert.show('Se produjo un error a generar codigo de envio entente nuevamente', 'Información')
	}
	else
	{
		lbl_correlativo_trabajo.text = arreglo[0].campo_uno;
	
		if (valida_guarda == '0')
		{
			var nombre_carpeta:String;
			lbl_ya.text = trim(lbl_correlativo_trabajo.text) + "_" + trim(eje_aca) + "_" + trim(cmb_prueba.selectedItem.data) +"_"+ trim(dt_grupos.dataProvider.getItemAt(0).matricula);
			archivo_subida.iniciarSubida(uploadURL+"?folder=" + lbl_ya.text );
			valida_guarda = '1';
			
		}
		else
		{
			mx.controls.Alert.show('No puede ingresar dos veces', 'Ingreso')
		}
	}
}
//***********************************************************************************************************
private function devuelve_datos_carga_tipo_evaluacion(event:ResultEvent):void
{
	cmb_prueba.dataProvider =  event.result;
	 
}
//***********************************************************************************************************	
private function cmb_prueba_change(event:Event):void
{
	if (cmb_prueba.selectedItem.label != "Seleccione")
	{	
		dt_grupos.dataProvider = undefined;
		ro_grupos.ro_comprueba_unico_participante(trim(matricula), trim(String(cmb_prueba.selectedItem.data)),trim(eje_aca) );
	}
	else
	{
		dt_grupos.dataProvider.removeAll();
		
		txt_rut.enabled = false;
		cmb_prueba.enabled = true;
		btn_si.enabled = false;
		btn_no.enabled = false;
		
	}
}
//***********************************************************************************************************
private function devuelve_datos_comprueba_unico_participante(event:ResultEvent):void
{
	var arreglo22:Object;
	arreglo22 = event.result; 
	
	if (arreglo22.length == 0)
	 {
		mx.controls.Alert.show('Usted ya existe fue ingresado en un grupo para la prueba: ' + trim(cmb_prueba.selectedItem.label) + ' , en el ramo seleccionado');
		cmb_prueba.enabled = false;
	 }
	 else
	 {
			if (dt_grupos.dataProvider.length <1){
				var arreglo:ArrayCollection = new ArrayCollection;
				arreglo.addItem({nombre: arreglo22[0].data, matricula: arreglo22[0].label, responsable: "1"})
				dt_grupos.dataProvider = arreglo;
				btn_si.enabled = true;
				btn_no.enabled = true;
				btn_si.setFocus();
				cmb_prueba.enabled = false;
			}
			else {
				dt_grupos.dataProvider.addItem( {nombre: arreglo22[0].data, matricula: arreglo22[0].label, responsable: "1"} );
				btn_si.enabled = true;
				btn_no.enabled = true;
				btn_si.setFocus();
				cmb_prueba.enabled = false;
			}
	 }
}
//***********************************************************************************************************	
private function txt_usuario_presskey(event:KeyboardEvent):void
{
	var rut_temp:String = txt_rut.text
	rut_temp = rut_temp.toUpperCase()
			
	if (event.charCode==13)
	{
		valida_rut(rut_temp);
	}
	else
	{
		if (event.charCode >= 48 && event.charCode <= 57)
		{
			puntos()
		}
		else
		{
			Keyboard.BACKSPACE
		}
	}
	
	if (event.charCode==13)
	{
		btn_ingresar.enabled=true;
		btn_ingresar.setFocus();
	}
}
//***********************************************************************************************************	
private function busca_alumno():void
{
	if (cmb_prueba.selectedItem.label != "Seleccione")
	{
		ro_grupos.ro_consulta_busca_alumno(trim(txt_rut.text), String(cmb_prueba.selectedItem.data), eje_aca);
	}
	else
	{
		mx.controls.Alert.show('Debe elegir una Evaluacion', 'Ingreso');
	}
}
//***********************************************************************************************************	
private function devuelve_datos_consulta_busca_alumno(event:ResultEvent):void
{
	var arreglo:Object;
	var i:Number;
	arreglo = event.result; 
	
	if (arreglo.length < 1 )
	{
		mx.controls.Alert.show('Alumno no pertenece a las misma sección o ya tiene grupo para esta prueba', 'Información');
			txt_rut.text = '';
			txt_rut.setFocus()
	}
	else
	{
		var cont:Number
		cont = 0;
		for(i=0;i<dt_grupos.dataProvider.length;i++) 
		{			
			if (trim(dt_grupos.dataProvider.getItemAt(i).matricula) == trim(arreglo[0].label))
			{
				cont = 1
			}
		}
		
		if(cont == 0)
		{
			dt_grupos.dataProvider.addItem( {nombre: trim(arreglo[0].data), matricula: trim(arreglo[0].label), responsable: "0"} );
			//btn_siguiente.enabled = true;
			btn_examinar.enabled = true;
			cmb_prueba.enabled = false;
			txt_rut.text = '';
			txt_rut.setFocus()
		}
		else
		{
			mx.controls.Alert.show('Ud. ya ingreso este alumno al grupo ', 'Información');	
			txt_rut.text = '';
			txt_rut.setFocus()
		
		}		
	}		
}

private function cancelar():void
{
	cmb_prueba.enabled = true;
	txt_rut.text = "";
	dt_grupos.dataProvider.removeAll();
	cmb_prueba.setFocus();
}

private function salir():void
{
	PopUpManager.removePopUp(this)
}
//***********************************************************************************************************	
private function prueba_grupal():void
{
	txt_rut.enabled = true;
	txt_rut.setFocus();
	btn_si.enabled = false;
	btn_no.enabled = false;
}
//***********************************************************************************************************	
private function prueba_individual():void
{
	txt_rut.enabled = false;
	//btn_siguiente.enabled = true;
	//btn_siguiente.setFocus();
	btn_si.enabled = false;
	btn_no.enabled = false;
	btn_examinar.enabled = true;
	
}
//***********************************************************************************************************
private function no_devuelve_carga(event:Event):void
{
	mx.controls.Alert.show('No hay evaluaciones disponibles en este momento.', 'Información')
}
private function valida_rut(rut_temp:String):void{
 	var dt:Number
	var dt2:String
 	var resto:Number
 	var i:Number
 	var suma:Number
	var j:Number
    var is_ok:Number
	var us_rut:String 
	var largo:Number
		
	us_rut = rut_temp
	is_ok = 0

	if (txt_rut.length == 12)
	{
		j = 2
      	suma = 0
		largo = us_rut.length
		i = us_rut.length - 2
		
		while(i>0)
		{
			if (us_rut.substr(i-1, 1) != '.')
			{
				if (j > 7)
				{
					j = 2
				}
				suma = suma + Number(us_rut.substr(i-1, 1)) * j
				j = j + 1
			}
			i--
		}
		
		resto = suma % 11
		dt = 11 - resto
		dt2 = dt.toString()

		if (dt2 == '10')
		{
			if (us_rut.substr(largo-1, 1) == 'K')
			{
				is_ok = 1

			}
		}

		if (dt2 == '11')
		{
			if (us_rut.substr(largo - 1, 1) == '0')
			{
				is_ok = 1
			}
		}
		
		if (dt2.substr(0, 1) == us_rut.substr(largo - 1, 1))
		{
			is_ok = 1
		}
	}
	
	if (is_ok == 0)
	{
			mx.controls.Alert.show('El R.U.T. ingresado no es valido.', 'Ingreso')
			focusManager.setFocus(txt_rut);
	}
	
	if (is_ok == 1)
	{
			btn_ingresar.setFocus();
	}
}
//***********************************************************************************************************	
private function puntos():void {
	var rut_temp:String;
	
	if (txt_rut.length == 2) {
		txt_rut.text = txt_rut.text + '.'
		rut_temp = txt_rut.text + '.'
		focusManager.setFocus(txt_rut);
		txt_rut.setSelection(txt_rut.length,txt_rut.length);
	}
	if (txt_rut.length == 6) {
		txt_rut.text = txt_rut.text + '.'
		rut_temp = txt_rut.text + '.'
		focusManager.setFocus(txt_rut);
		txt_rut.setSelection(txt_rut.length,txt_rut.length);
	}
	if (txt_rut.length == 10) {
		txt_rut.text = txt_rut.text + '-'
		rut_temp = txt_rut.text + '.'
		focusManager.setFocus(txt_rut);
		txt_rut.setSelection(txt_rut.length,txt_rut.length);
	}
}
//***********************************************************************************************************	
private function ltrim(matter:String):String {
	var i:Number;
    if ((matter.length>1) || (matter.length == 1 && matter.charCodeAt(0)>32 && matter.charCodeAt(0)<255)) {
        i = 0;
        while (i<matter.length && (matter.charCodeAt(i)<=32 || matter.charCodeAt(i)>=255)) {
            i++;
        }
        matter = matter.substring(i);
    } else {
        matter = "";
    }
    return matter;
}
//***********************************************************************************************************
private function rtrim(matter:String):String {
	var i:Number;
    if ((matter.length>1) || (matter.length == 1 && matter.charCodeAt(0)>32 && matter.charCodeAt(0)<255)) {
        i = matter.length-1;
       while (i>=0 && (matter.charCodeAt(i)<=32 || matter.charCodeAt(i)>=255)) {
            i--;
        }
        matter = matter.substring(0, i+1);
    } else {
        matter = "";
    }
    return matter;
}
//***********************************************************************************************************
private function trim(matter:String):String {
    return ltrim(rtrim(matter));
} 
	
///////////////////////////////////////////funciones subida de archivo///////////////////////////////
private function click_btn_examinar():void{
archivo_subida.examinar()
}

private function generar_grupos():void {
	var i:Number;
		btn_guardar.visible = false;
		lbl_presione.visible = true;
		txt_rut.enabled = false;
		btn_ingresar.enabled = false;
		lbl_count_grilla.text = dt_grupos.dataProvider.length;
		
		lbl_ya.text = trim(lbl_correlativo_trabajo.text) + "_" + trim(eje_aca) + "_" + trim(cmb_prueba.selectedItem.data) +"_"+ trim(dt_grupos.dataProvider.getItemAt(0).matricula);
		
		ro_grupos.ro_genera_grupos_trabajo_web(trim(eje_aca), trim(String(cmb_prueba.selectedItem.data)), String(dt_grupos.dataProvider.length), lbl_correlativo_trabajo.text,'101', trim(String(test.text)),trim(String(lbl_ya.text)))
		
		this.total_dt_grupos = dt_grupos.dataProvider.length;	
			
		for(i = 0; i < dt_grupos.dataProvider.length ; i++ )
		{	
			ro_grupos.ro_genera_detalle_grupos_trabajo_web(String(dt_grupos.dataProvider[i].matricula), String(dt_grupos.dataProvider[i].responsable),lbl_correlativo_trabajo.text); 
			ro_grupos.ro_actualiza_nota(String(dt_grupos.dataProvider[i].matricula), String(dt_grupos.dataProvider[i].responsable),trim(eje_aca),trim(String(cmb_prueba.selectedItem.data)) ,lbl_correlativo_trabajo.text)
		}
}

private function click_btn_guardar():void {
	btn_guardar.enabled = false
	
	ro_grupos.ro_obtiene_correlativo_trabajos() 
}



private function result_ro_actualiza_nota(event:ResultEvent):void
{
	this.dt_grupo_guardados++;
	if (dt_grupo_guardados == total_dt_grupos)
	{
		parentApplication.moduloSeleccionado = "frm_comprobante_web.mxml.swf";
	}
}

private function result_ro_genera_grupos_trabajo_web(event:ResultEvent):void
{
	parentApplication.archivo = test.text;
	parentApplication.trabajo = lbl_correlativo_trabajo.text;
	parentApplication.tipo_prueba = cmb_prueba.selectedItem.label;
	parentApplication.encargado = nombre_alumno
	parentApplication.mal_nombre = mal_nombre;
	parentApplication.cur_nombre = cur_nombre;
	
	
//    var popup2:frm_comprobante_web = frm_comprobante_web(PopUpManager.createPopUp( this, frm_comprobante_web , true));
//	mx.managers.PopUpManager.centerPopUp(popup2)
}

private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
/*
private function uploadFile(url:String):void {
			
			if (archivo_subida.iniciarSubida(url)) {
				progressBar.label = "Espere... mientras sube el archivo";
			} else {
				progressBar.label = "Error no se pudo subir el archivo.";
				btn_guardar.enabled = false;
			}
		}	
		*/
/*
private function addEvent(event:Object):void {
	var p:String;
    if (event.fileReference.type == ".doc" || event.fileReference.type == ".xls" || event.fileReference.type == ".pdf") {
	
			var tmp:String = "";
			for (p in event) {
				if (p == "target") continue;
				tmp += p + ": " + event[p] + " ";
			}
			ta.text += tmp + "\n";
			ta.y += 20;
			progressBar.label = "A seleccionado el archivo: " + trim(event.fileReference.name)
			
	}
	else
	{
			mx.controls.Alert.show('el archivo debe ser solo documentos Word(*.doc), Pdf(*.pdf),Excel(*.xls)', 'Ingreso')
			btn_guardar.enabled = false;
	}
}
*/		