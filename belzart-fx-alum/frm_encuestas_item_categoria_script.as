import flash.display.DisplayObject;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

public var enc_cat_idn:String;
public var enc_ver_idn:String;
public var ultimo_encabezado:String = "";
//*****************************************************************************************************
private function inicio():void
{
	this.ro_encuestas.cargar_preguntas(enc_cat_idn, enc_ver_idn);
}
//*****************************************************************************************************
private function result_cargar_preguntas(event:ResultEvent):void{
	var i:int = 0;
	var j:int = 0;
	var o_un_campo:obj_un_campo_string;
	if (event.result.length > 0)
	{
		this.height = event.result.length * 53;
		this.lbl_categoria.text = event.result[0].campo_uno;
		var pregunta:frm_encuestas_item_pregunta
		var encabezado:frm_encuestas_item_encabezado
		for (i=0;i<event.result.length; i++)
		{
			if (this.ultimo_encabezado != event.result[i].campo_tres)
			{
				encabezado = new frm_encuestas_item_encabezado;
				encabezado.enc_pre_idn = event.result[i].campo_dos;
				encabezado.enc_cat_idn = this.enc_cat_idn;
				encabezado.enc_ver_idn = this.enc_ver_idn;
				this.cnv_preguntas.addChild(encabezado);
				this.ultimo_encabezado = event.result[i].campo_tres;
				this.height = this.height + 90;
			}

			
			pregunta = new frm_encuestas_item_pregunta;
			pregunta.enc_pre_idn = event.result[i].campo_dos;
			pregunta.enc_cat_idn = this.enc_cat_idn;
			pregunta.enc_ver_idn = this.enc_ver_idn;
			this.cnv_preguntas.addChild(pregunta);
		}
		
	}
	else
	{
		mx.controls.Alert.show("Error en la categoría N°" + this.enc_cat_idn,"Error");
	}
	
	
}


//*****************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString,"Error");
}