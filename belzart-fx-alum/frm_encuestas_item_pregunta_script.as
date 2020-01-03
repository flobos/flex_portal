import flash.events.Event;
import flash.events.KeyboardEvent;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.TextArea;
import mx.managers.*;
import mx.rpc.events.*;

private var tb_respuesta:TextArea = new TextArea;
public var respuesta_desarrollo:String = new String;
public var cod_respuesta:String;
public var enc_pre_idn:String;
public var enc_cat_idn:String;
public var enc_ver_idn:String;
public var ultimo_encabezado:ArrayCollection;
public var encabezado:ArrayCollection = new ArrayCollection;
public var respuesta:String = "";
public var pregunta_desarrollo:Boolean = false;
//*****************************************************************************************************
private function inicio():void
{
	this.respuesta_desarrollo = "";
	this.ro_encuestas.cargar_pregunta(enc_pre_idn);
}
//*****************************************************************************************************
private function result_cargar_pregunta(event:ResultEvent):void{
	
	if (event.result.length > 0)
	{
		this.txt_pregunta.text = event.result[0].campo_uno;
		this.ro_encuestas.busca_respuestas(this.enc_pre_idn, this.enc_ver_idn, this.enc_cat_idn);
	}
	else
	{
		mx.controls.Alert.show("No se encontró la pregunta N°" + this.enc_pre_idn,"Alerta");
	}
	
	
}
public function get_encabezado():ArrayCollection
{
	return this.encabezado;
}
//*****************************************************************************************************
private function result_busca_respuestas(event:ResultEvent):void{
	var i:int = 0;
	var o_un_campo:obj_un_campo_string;
	if (event.result.length > 0)
	{
		if (event.result.length > 1)
		{
			for (i = 0; i < event.result.length; i++)
			{
				o_un_campo = new obj_un_campo_string;
				o_un_campo.campo_uno = event.result[i].campo_tres;
				this.encabezado.addItem(o_un_campo);
				
			}
			this.rpt_respuestas.dataProvider = event.result;
		}
		else
		{
			this.cod_respuesta = event.result[0].campo_uno;
			this.rpt_respuestas.visible = false;
			tb_respuesta.width = 300;
			tb_respuesta.height = 38;
			this.hb_alternativas.addChild(tb_respuesta);
			tb_respuesta.addEventListener(KeyboardEvent.KEY_UP,cambio_respuesta);
			this.pregunta_desarrollo = true;
		}
				
	}
	else
	{
		mx.controls.Alert.show("No se encontraron las respuestas de la pregunta N°" + this.enc_pre_idn,"Error");
	}
	
	
}
//*****************************************************************************************************
private function cambio_respuesta(event:KeyboardEvent):void
{
	this.respuesta_desarrollo = this.tb_respuesta.text;
}

//*****************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString,"Error");
}