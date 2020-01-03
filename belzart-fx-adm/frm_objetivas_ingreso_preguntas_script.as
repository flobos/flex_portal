import flash.events.Event;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.*;
import mx.managers.*;
import mx.rpc.events.*;
import mx.rpc.http.HTTPService;
[Bindable]  
private var par_func_mod_fun_idn:String;
public var existe:Boolean;
public var cod_pregunta:String;
public var cod_preg_mod_cam:String;
public var arreglo_preguntas:ArrayCollection = new ArrayCollection;
public var func_mod_fun_idn:String;


public var ServerResponse:String;
public var ServerResponseRaw:String;
public var uploadURL:String;
public var uploadFOLDER:String;
private var xmlProperties:XML; 
private var servicePropReader:HTTPService; 


//*******************************************************************************************************
private function inicio():void
{
	var arreglo:ArrayCollection = new ArrayCollection;
	for( x = 0; x < NS_CantRes.value ; x++ )
	{
		var o_tres_campos:obj_tres_campos = new obj_tres_campos;
		o_tres_campos.campo_uno = "-";
		o_tres_campos.campo_dos = "";
		o_tres_campos.campo_tres = "0";
		arreglo.addItem(o_tres_campos);
	}
	rp_alternativas.dataProvider=arreglo;
	par_func_mod_fun_idn = Application.application.parameters.par_func_mod_fun_idn;
	ro_desencripta.desencriptar_func_mod_fun_idn("Iplacex", par_func_mod_fun_idn);
	ro_ingreso_preguntas.muestra_tipo_pregunta();
	ro_ingreso_preguntas.muestra_ramos(func_mod_fun_idn);
	
	getProperties();
	this.addEventListener(UploadEvent.UPLOAD_EVENT, uploadEventHandler);
}
//*******************************************************************************************************
private function cmb_ramo_change():void{
	lbl_pro_cam_idn.text = cmb_ramo.selectedItem.data 
}
//******************************************************************************************************
private function NS_CantRes_change():void
{
	var arreglo:ArrayCollection = new ArrayCollection;
	for( x = 0; x < NS_CantRes.value ; x++ )
	{
		var o_tres_campos:obj_tres_campos = new obj_tres_campos;
		o_tres_campos.campo_uno = "-";
		//String.fromCharCode(x+97) + ")";
		o_tres_campos.campo_dos = "";
		o_tres_campos.campo_tres = "0";
		arreglo.addItem(o_tres_campos);
	}
	rp_alternativas.dataProvider=arreglo;	
}

//******************************************************************************************************
private function result_muestra_ramos(event:ResultEvent):void
{
	cmb_ramo.dataProvider = event.result;
	ro_ingreso_preguntas.muestra_unidades();
}
//******************************************************************************************************
private function result_muestra_clase(event:ResultEvent):void
{
	cmb_clase.dataProvider = event.result;
}

//******************************************************************************************************
private function result_muestra_unidades(event:ResultEvent):void
{
	cmb_unidad.dataProvider=event.result;
	ro_ingreso_preguntas.muestra_clase();
}

//******************************************************************************************************
private function result_desencriptar_func_mod_fun_idn(event:ResultEvent):void
{
	func_mod_fun_idn = event.result[0].campo_uno;
	ro_ingreso_preguntas.muestra_tipo_pregunta();
	ro_ingreso_preguntas.muestra_ramos(func_mod_fun_idn);
}

//******************************************************************************************************
private function result_muestra_tipo_pregunta(event:ResultEvent):void
{
	cmb_tip_pregunta.dataProvider = event.result;
}

//******************************************************************************************************
private function btn_guardar_click():void
{
	var item:Object=rp_alternativas.dataProvider;
	var x:int;
	var alt:String;
	var op_alt:String;
	
	if( txt_pregunta.length>0 && txt_pauta.length>0 && cmb_tip_pregunta.selectedIndex>0) //si se han completado todos los campos
	{
		alt='';
		op_alt='0'
		if (cmb_tip_pregunta.selectedItem.data=='1') //si es una pregunta objetiva
		{
			for( x = 0; x < NS_CantRes.value && alt=='' ; x++ )
			{
				if (txt_respuesta[x].text=='')
					alt=String(x+1); //si encuentra una alternativa vacia asigna el indice de la misma al string alt.
				if (opt_correcta[x].selected==true)
					op_alt='1'; //flag que marca 1 cuando encuentra una alternativa correcta seleccionada
			}
		}
		else //si no es una pregunta objetiva
		{
			alt='';
			op_alt='1';
		}
		if (alt=='') //si no es pregunta objetiva, o  bien, si es una pregunta objetiva que tiene todas sus alternativas
		{
			if (op_alt=='1') //si no es una pregunta objetiva, o bien, si es una pregunta objetiva que tiene todas sus alternativas y una es correcta
			{
				if (lbl_codigo_pregunta.text=='0') // si la pregunta no existe en la base de datos
	   			{
					ro_ingreso_preguntas.agrega_pregunta(String(cmb_tip_pregunta.selectedItem.data), String(txt_pregunta.text), String(txt_pauta.text), '',func_mod_fun_idn, txt_imagen.text);
					
				}
				else // si la pregunta fue cargada de una existente en la base de datos
				{ 
					mx.controls.Alert.show("Para modificar una pregunta existente debe utilizar el menú de modificación de preguntas", "Alerta");
				}
			}
			else //si es una pregunta objetiva que no tiene alternativa seleccionada.
				mx.controls.Alert.show("Antes de realizar la operacion de guardar debe marcar la alternativa correcta", "Ayuda");
		}
		else	//si es una pregunta objetiva que no tiene todas sus alternativas
		{			
			mx.controls.Alert.show("La alternativa '" + alt + "' se encuentra incompleta, no se puede efectuar la operacion Guardar", "Ayuda")
		}
	}
	else //si no se han completado todos los campos
		mx.controls.Alert.show("Existen campos sin completar necesarios para poder efectuar la operacion de guardar", "Ayuda")
}

//******************************************************************************************************
private function cmb_tip_pregunta_change():void
{
	if (cmb_tip_pregunta.selectedItem.data=='1')
		tw_alternativas.enabled=true;
	else
		tw_alternativas.enabled=false;
}

//******************************************************************************************************
private function popup_buscar():void
{
	var buscar:frm_objetivas_ingreso_preguntas_popup_busca_pregunta = frm_objetivas_ingreso_preguntas_popup_busca_pregunta(PopUpManager.createPopUp( this, frm_objetivas_ingreso_preguntas_popup_busca_pregunta , true));
	mx.managers.PopUpManager.centerPopUp(buscar)
}
//******************************************************************************************************
private function result_muestra_preg_idn(event:ResultEvent):void
{
	var x:int;
	var correcta:String;
	var num_preg_sel:int;
	var arre_preguntas:ArrayCollection = new ArrayCollection;
	var arre_guarda:ArrayCollection = new ArrayCollection;
	cod_pregunta=event.result[0].data;
	cod_preg_mod_cam=event.result[0].label;

	//  si tiene imagen adjunta, entonces la sube al servidor	
	if (this.progressBar.label != "seleccione imagen JPG")
	{
		archivo_subida.iniciarSubida(uploadURL+"?folder=" + cod_pregunta);
	}


	mx.controls.Alert.show("Pregunta Guardada.", "Ayuda")
//  actualiza las preguntas seleccionadas	 	
	if (rp_preguntas_seleccionadas.dataProvider != null) //si ya existen preguntas seleccionadas
	num_preg_sel = rp_preguntas_seleccionadas.dataProvider.length;
	else
	num_preg_sel = 0;
	
	
	var o_cuatro_campos_obj:obj_cuatro_campos = new obj_cuatro_campos;

//  si num_preg_sel mayor a cero, llena arreglo_preguntas con las preguntas seleccionadas ya existentes	
	for ( x = 0; x < num_preg_sel ; x++ ){
	o_cuatro_campos_obj.campo_uno = lbl_preg_mod_cam_idn[x].text;
	o_cuatro_campos_obj.campo_dos = lbl_cod_sel[x].text;
	o_cuatro_campos_obj.campo_tres = lbl_pregunta_sel[x].text;
	o_cuatro_campos_obj.campo_cuatro = lbl_tipo_sel[x].text;
	arre_preguntas.addItem(o_cuatro_campos_obj);	
	}
	
//	añade la pregunta creada al listado de seleccionadas
	o_cuatro_campos_obj.campo_uno = event.result[0].label;
	o_cuatro_campos_obj.campo_dos = event.result[0].data;
	o_cuatro_campos_obj.campo_tres = txt_pregunta.text ;
	o_cuatro_campos_obj.campo_cuatro = cmb_tip_pregunta.selectedItem.label;
	arre_preguntas.addItem(o_cuatro_campos_obj);
	

	rp_preguntas_seleccionadas.dataProvider = arre_preguntas; //rellena la seleccion de preguntas
	x=0;
//	si es pregunta objetiva, entonces guarda las respuestas
	if (cmb_tip_pregunta.selectedItem.data=='1') 
	{
		for( x = 0; x < NS_CantRes.value ; x++ )
		{
			if (opt_correcta[x].selected==true)
				correcta='1';
			else
			correcta='0';
			
			var o_cinco_campos_obj:obj_cinco_campos = new obj_cinco_campos;
			o_cinco_campos_obj.campo_uno = cod_pregunta;
			o_cinco_campos_obj.campo_dos = '0';
			o_cinco_campos_obj.campo_tres = txt_respuesta[x].text;
			o_cinco_campos_obj.campo_cuatro = correcta;
			o_cinco_campos_obj.campo_cinco = '';
			arre_guarda.addItem(o_cinco_campos_obj);	
		}
			ro_ingreso_preguntas.agrega_respuesta(arre_guarda);		
	}
}

//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}

//******************************************************************************************************
private function btn_nuevo_click():void
{
	cmb_tip_pregunta.selectedIndex=0;
	limpia();
}
//******************************************************************************************************
private function btn_nueva_seleccion_click():void
{
	var arre_preguntas:ArrayCollection = new ArrayCollection;
	
	rp_preguntas_seleccionadas.dataProvider=arre_preguntas;
}

//*******************************************************************************************************
private function txt_pregunta_change():void
{
	lbl_caracteres.text = String(txt_pregunta.length) + "/5000"
}

//*******************************************************************************************************
private function txt_pregunta_keyDown(event:KeyboardEvent):void
{
	lbl_caracteres.text = String(txt_pregunta.length) + "/5000" 
}

//*******************************************************************************************************
private function txt_respuesta_keyDown(event:KeyboardEvent, evento:Event):void
{
	var opt:TextInput=TextInput(evento.currentTarget);
	var item:Object=opt.getRepeaterItem();
}

//******************************************************************************************************
private function agrega_post_guardar():void
{
	
	//limpia();
}

//******************************************************************************************************
private function btn_eliminar_click():void
{
	if(lbl_codigo_pregunta.text!='0')
	{
		mx.controls.Alert.show("¿Realmente desea realizar los cambios a la pregunta?", "Cambio pregunta", 3, this, alert_elimina_pregunta);
	}
	else
		mx.controls.Alert.show("Antes de poder efectuar esta operación, debe buscar y seleccionar la pregunta que desea eliminar", "Ayuda");
} 

//******************************************************************************************************
private function alert_elimina_pregunta(event:CloseEvent):void 
{
    if (event.detail==Alert.YES){
    	//quita la pregunta eliminada del listado
		var num_preg_sel:int = 0;
		var arre_preguntas:ArrayCollection = new ArrayCollection;
		
		num_preg_sel = rp_preguntas_seleccionadas.dataProvider.length;

		for ( x = 0; x < num_preg_sel ; x++ ){
			var o_cuatro_campos_obj:obj_cuatro_campos = new obj_cuatro_campos;
			o_cuatro_campos_obj.campo_uno = lbl_preg_mod_cam_idn[x].text;
			o_cuatro_campos_obj.campo_dos = lbl_cod_sel[x].text;
			o_cuatro_campos_obj.campo_tres = lbl_pregunta_sel[x].text;
			o_cuatro_campos_obj.campo_cuatro = lbl_tipo_sel[x].text;
			
			// si no es la pregunta eliminada la agrega al arreglo de preguntas	
			if (o_cuatro_campos_obj.campo_dos != lbl_codigo_pregunta.text)
			arre_preguntas.addItem(o_cuatro_campos_obj);	
			}
	
		rp_preguntas_seleccionadas.dataProvider = arre_preguntas;
				
		// elimina la pregunta de la base de datos
    	ro_ingreso_preguntas.elimina_pregunta(lbl_codigo_pregunta.text);
    }
}

//******************************************************************************************************
private function result_elimina_pregunta():void
{
	lbl_codigo_pregunta.text='0'
	txt_pregunta.text='';
	txt_pauta.text='';
	opt_correcta[0].selected=false
	var arreglo:ArrayCollection = new ArrayCollection;
	for( x = 0; x < NS_CantRes.value ; x++ )
	{
		var o_tres_campos:obj_tres_campos = new obj_tres_campos;
		o_tres_campos.campo_uno = "-";
		o_tres_campos.campo_dos = "";
		o_tres_campos.campo_tres = "0";
		arreglo.addItem(o_tres_campos);
	}
	rp_alternativas.dataProvider=arreglo;
}

//******************************************************************************************************
private function limpia():void
{
	
	lbl_codigo_pregunta.text='0'
	txt_pregunta.text='';
	txt_pauta.text='';
	opt_correcta[0].selected=false
	//arreglo_preguntas= new ArrayCollection;
	
	//rp_preguntas_seleccionadas.dataProvider=arreglo_preguntas;
	
	var arreglo:ArrayCollection = new ArrayCollection;
	for( x = 0; x < NS_CantRes.value ; x++ )
	{
		var o_cuatro_campos:obj_cuatro_campos = new obj_cuatro_campos;
		o_cuatro_campos.campo_uno = "-";
		o_cuatro_campos.campo_dos = "";
		o_cuatro_campos.campo_tres = "0";
		o_cuatro_campos.campo_cuatro = "0";
		arreglo.addItem(o_cuatro_campos);
	}
	rp_alternativas.dataProvider=arreglo;
}
//******************************************************************************************************
private function limpia_todo():void
{
	
	lbl_codigo_pregunta.text='0'
	txt_pregunta.text='';
	txt_pauta.text='';
	opt_correcta[0].selected=false
	arreglo_preguntas= new ArrayCollection;
	
	rp_preguntas_seleccionadas.dataProvider=arreglo_preguntas;
	
	var arreglo:ArrayCollection = new ArrayCollection;
	for( x = 0; x < NS_CantRes.value ; x++ )
	{
		var o_cuatro_campos:obj_cuatro_campos = new obj_cuatro_campos;
		o_cuatro_campos.campo_uno = "-";
		o_cuatro_campos.campo_dos = "";
		o_cuatro_campos.campo_tres = "0";
		o_cuatro_campos.campo_cuatro = "0";
		arreglo.addItem(o_cuatro_campos);
	}
	rp_alternativas.dataProvider=arreglo;
}



//******************************************************************************************************
private function btn_asignar_preguntas_click():void
{	
	var arre_guarda:ArrayCollection = new ArrayCollection;
	if (cmb_ramo.selectedIndex > 0 && cmb_unidad.selectedIndex > 0 && cmb_clase.selectedIndex > 0)
	{	if (rp_preguntas_seleccionadas.dataProvider.length > 0){
			for(x = 0; x < rp_preguntas_seleccionadas.dataProvider.length; x++)
			{
				if (chk_ok_sel[x].selected==true)
				{
					var o_cuatro_campos_obj:obj_cuatro_campos = new obj_cuatro_campos;
					o_cuatro_campos_obj.campo_uno = lbl_preg_mod_cam_idn[x].text;
					o_cuatro_campos_obj.campo_dos = String(cmb_ramo.selectedItem.data);
					o_cuatro_campos_obj.campo_tres = String(cmb_unidad.selectedItem.data);
					o_cuatro_campos_obj.campo_cuatro = String(cmb_clase.selectedItem.data);
					arre_guarda.addItem(o_cuatro_campos_obj);
				}
			}
			ro_ingreso_preguntas.asigna_pregunta(arre_guarda);
			mx.controls.Alert.show("Preguntas asignadas")
		}
		else{
			mx.controls.Alert.show("No existen preguntas seleccionadas")
		}		
	}
	else
		mx.controls.Alert.show("Faltan campos necesarios para poder realizar la operación de guardar", "Ayuda")	
}

//******************************************************************************************************
private function result_asigna_reguntas_cursos(event:ResultEvent):void
{
	///******	    rp_preguntas_seleccionadas.dataProvider = event.result;
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
	if (rp_preguntas_seleccionadas.dataProvider != null)
	{
		for(i = 0; i < rp_preguntas_seleccionadas.dataProvider.length; i++) 
		{
			chk_ok_sel[i].selected=valor;
		}
	}
}

//******************************************************************************************************
private function cmb_unidad_change():void
{
	
}

//******************************************************************************************************
private function carga_asigna_pregunta_CursosUnidad(event:ResultEvent):void
{
	    rp_preguntas_seleccionadas.dataProvider = event.result;
}

//******************************************************************************************************
private function Result_carga_asigna_pregunta_CursosUnidad_asignadas(event:ResultEvent):void
{
	    rp_preguntas_seleccionadas.dataProvider = event.result;
}
 
//******************************************************************************************************

///////////////////////////////////////////funciones subida de archivo///////////////////////////////
private function click_btn_examinar():void{
archivo_subida.examinar()
}



//*****************************************************************************************************
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
			uploadFOLDER = xmlProperties.property.(name=="UploadFOLDER").value;
		}	

