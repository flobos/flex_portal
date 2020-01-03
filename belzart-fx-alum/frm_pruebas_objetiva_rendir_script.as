import flash.events.TimerEvent;
import flash.utils.ByteArray;
import flash.utils.Timer;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.formatters.NumberBaseRoundType;
import mx.graphics.codec.*;
import mx.managers.*;
import mx.rpc.events.*;
import mx.rpc.http.HTTPService;

public var tc_idn:String 
public var tip_pru_idn:String
public var mat_idn:String
private var pro_eva_idn:String
private var tiempo_prueba:String;
private var fin_tiempo_prueba:String;

[Bindable]
private var uploadFOLDER:String;
private var uploadSnapURL:String;
private var xmlProperties:XML; 
private var servicePropReader:HTTPService; 
private var num_preguntas:Number;
private var hora_inicio:String;
private var hora_fin:String;
private var segundos_restantes:Number;

[Bindable] 
private var reloj:Timer;


private function cargar():void{
	this.fin_tiempo_prueba = '0';
	pro_eva_idn = this.parentApplication.pro_eva_idn;
	tc_idn = this.parentApplication.tc_idn;
	tip_pru_idn = parentApplication.tipo_prueba;
	mat_idn = this.parentApplication.lbl_mat_idn.text;
	tiempo_prueba = this.parentApplication.tiempo_prueba;
	
	if (tiempo_prueba != '0'){
		lbl_comenzar_prueba.text = "Ud. dispondrá de "+tiempo_prueba+" minutos para completar la evaluación. Una vez cumplida la hora de término de la prueba ya no podrá enviar sus respuestas. Para comenzar la evaluación haga click en el botón Comenzar Prueba."
		lbl_comenzar_prueba.visible = true;
		this.btn_comenzar_prueba.visible = true;
	}
		
	else if (tiempo_prueba == '0')
	{
		ro_preguntas.muestra_preguntas(tc_idn, tip_pru_idn, pro_eva_idn)
	}
	
	this.txt_info.text = "Toma de Curso N°" +tc_idn + " / Matrícula " + mat_idn + " / Cód. Prueba N°" +  tip_pru_idn + " / Pro. Ev. N°" + this.pro_eva_idn;
	this.txt_intro.text = "Estimado(a) "+ this.parentApplication.lbl_nombre.text + ": A continuación se presenta una serie preguntas de selección mÃºltiple las que deberá responder seleccionando la alternativa correcta segÃºn el enunciado correspondiente."
	
	//	ro_preguntas.muestra_preguntas(tc_idn, tip_pru_idn)
	getProperties();
}

private function initRelojRestalo():void 
{
	reloj = new Timer(1000, segundos_restantes);
	reloj.addEventListener(TimerEvent.TIMER, actualizaReloj);
	reloj.addEventListener(TimerEvent.TIMER_COMPLETE, fin_tiempo);
	reloj.start();
}

private function fin_tiempo(event:TimerEvent):void{
	this.btn_envia.enabled = false;
	this.fin_tiempo_prueba = '1';
	ro_preguntas.genera_trabajo(tc_idn, tip_pru_idn, this.pro_eva_idn);
}

private function actualizaReloj(event:TimerEvent):void 
{
	segundos_restantes = segundos_restantes-1;
	var minutos_restantes:Number;
	var resto_segundos:Number;
	
	numberFormatter.rounding = NumberBaseRoundType.DOWN;
	minutos_restantes = Number(numberFormatter.format(segundos_restantes/60));
	resto_segundos = segundos_restantes - minutos_restantes * 60;
	
	lbl_hora.text = "Tiempo restante para finalizar la prueba: " +String(minutos_restantes)+ ":" +String(resto_segundos);
}


private function btn_comenzar_click():void
{	
	ro_preguntas.ingresa_inicio_rendicion(tc_idn, tip_pru_idn, Number(tiempo_prueba));
	
}

private function tomar_snapshot(objeto:VBox):ByteArray
{
	var bmpd:BitmapData = new BitmapData(objeto.width,objeto.height);
	bmpd.draw(objeto);
	var jpgenc:JPEGEncoder = new JPEGEncoder(80);
	var imgByteArray:ByteArray = jpgenc.encode(bmpd);
	return imgByteArray;
}


private function click_btn_envia():void{
	
	this.btn_envia.enabled = false;
	
	var arreglo111:ArrayCollection = new ArrayCollection;
	var i:Number;
	var j:Number;
	
	for (i = 0; i < rb_codigo.length; i++)
		for (j = 0; j < rb_codigo[i].length; j++)
			
			if (rb_codigo[i][j].selected == true){
				
				var o_un_campo:obj_un_campo_string = new obj_un_campo_string;
				o_un_campo.campo_uno = librerias.f_trim(String(rb_codigo[i][j].label));
				arreglo111.addItem(o_un_campo);
				y += 1
			}
	
	if (arreglo111.length < num_preguntas){
		this.btn_envia.enabled = true;
		mx.controls.Alert.show('Debe Responder todas las preguntas.','Alerta')
	}else{
		
        this.lbl_guardando.visible = true;
		//tomar_captura();
		ro_preguntas.genera_trabajo(tc_idn, tip_pru_idn, pro_eva_idn)
				
		
	}
}

private function tomar_captura():void
{
	
	
	prueba_objetiva.verticalScrollPosition = 0;
	var snapshot:ByteArray;
	snapshot = tomar_snapshot(prueba_objetiva);
	var urlRequest : URLRequest = new URLRequest();
	urlRequest.url = uploadSnapURL + '?folder='+ mat_idn;
	urlRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
	urlRequest.method = URLRequestMethod.POST;
	var n_archivo:String = tc_idn + "_" + tip_pru_idn + "_" + pro_eva_idn + ".jpg";
	urlRequest.data = UploadPostHelper.getPostData( n_archivo, snapshot );
	urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
	var urlLoader : URLLoader = new URLLoader();
	urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
	urlLoader.load(urlRequest);
	
}

private function result_ingresa_inicio_rendicion(event:ResultEvent):void{
	
	if (event.result.length > 0)
	{
		hora_inicio = event.result[0].campo_uno;
		hora_fin = event.result[0].campo_dos;
		segundos_restantes = Number(event.result[0].campo_tres);
		
		mx.controls.Alert.show("Hora de inicio: " + hora_inicio+ " \nHora de término: "+hora_fin,"Disponibilidad de la Prueba");
		this.lbl_hora_inicio.text = "La hora de inicio fue: " + hora_inicio;
		this.lbl_hora_inicio.visible = true;
		
		this.lbl_hora_fin.text = "La hora de término es: " + hora_fin;
		this.lbl_hora_fin.visible = true;
		ro_preguntas.muestra_preguntas(tc_idn, tip_pru_idn, pro_eva_idn);
		this.btn_comenzar_prueba.enabled = false;
		initRelojRestalo();
		this.lbl_hora.visible = true;
		
	}
	else
	{
		mx.controls.Alert.show("La hora de envío de la prueba ha expirado","Alerta");
	}
	
	
}

private function result_muestra_preguntas(event:ResultEvent):void{
	var i:Number;
	rpt_preguntas.dataProvider =  event.result;
	var arreglo_preguntas:Object =  new Object();
	arreglo_preguntas = rpt_preguntas.dataProvider;
	num_preguntas = arreglo_preguntas.length;
	for(i = 0; i < arreglo_preguntas.length ; i++)
	{
		ro_preguntas.muestra_respuestas(Number(librerias.f_trim(lbl_codigo[i].text)))
	}
}

private function result_muestra_respuestas(event:ResultEvent):void{
	
	var codigo:String	
	var arreglo2:Object;
	var x:Number
	var arreglo_preguntas1:Object;
	arreglo_preguntas1 = rpt_preguntas.dataProvider
	arreglo2 = event.result; 
	codigo = arreglo2[0].campo_uno
	for(x = 0; x < arreglo_preguntas1.length ; x++)
	{
		if (lbl_codigo[x].text == codigo){
			
			rpt_respuestas[x].dataProvider = event.result
			
		}
	}
}


private function result_genera_trabajo(event:ResultEvent):void{
	
	var y:Number = 0;
	var i:Number;
	var j:Number;
	var arreglo_trabajo:Object;
	
	if (event.result[0].campo_uno == null){
		mx.controls.Alert.show("No se pudo generar el código de trabajo","Error");
	}
	else {
		if (this.fin_tiempo_prueba == '1')
		{
			mx.controls.Alert.show("El tiempo se ha acabado, contáctese con Iplacex para regular su evaluación. Su código de evaluación es: "+ event.result[0].campo_uno,"Alerta");
		}
		else
		{
			arreglo_trabajo = event.result; 
			lbl_trab_idn.text = arreglo_trabajo[0].campo_uno
			var arreglo100:Array = new Array();
			
			
			for (i = 0; i < rb_codigo.length; i++)
				for (j = 0; j < rb_codigo[i].length; j++)
					
					if (rb_codigo[i][j].selected == true){
						
						var o_un_campo:String;
						o_un_campo = 	librerias.f_trim(String(rb_codigo[i][j].label));
						arreglo100.push(o_un_campo);
						y += 1
					}
			
			if (arreglo100.length == 0){
				mx.controls.Alert.show('Debe Responder a lo menos una pregunta.','Info')
			}else{
				ro_preguntas.genera_respuestas_alumnos(librerias.f_trim(lbl_trab_idn.text), arreglo100)
			}
			
		}
		
		
	}
}

private function result_genera_respuestas_alumnos(event:Event):void{
	
	ro_preguntas.calcula_nota(librerias.f_trim(lbl_trab_idn.text))
	
}

private function result_calcula_nota(event:ResultEvent):void{
	
	var not_nota:String
	var not_trabajo:String
	
	var arreglo_nota:Object;
	arreglo_nota = event.result; 
	
	not_nota = arreglo_nota[0].data
	not_trabajo = arreglo_nota[0].label 
	
	
	parentApplication.trabajo = not_trabajo;
	parentApplication.nota= not_nota;
	
	parentApplication.moduloSeleccionado = "frm_pruebas_objetiva_rendir_popup_comprobante.mxml.swf";
	//	var popup32:frm_pruebas_objetiva_rendir_popup_conprobante = frm_pruebas_objetiva_rendir_popup_conprobante(PopUpManager.createPopUp( this, frm_pruebas_objetiva_rendir_popup_conprobante , true));
	//	mx.managers.PopUpManager.centerPopUp(popup32)
	
	//	PopUpManager.removePopUp(this)
	
	
	
}


private function formatea_fecha(date:Date):String {
	return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString,"Error");
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
	uploadFOLDER = xmlProperties.property.(name=="UploadImgFOLDER").value;
	uploadSnapURL = xmlProperties.property.(name=="UploadSnapURL").value;
}	

