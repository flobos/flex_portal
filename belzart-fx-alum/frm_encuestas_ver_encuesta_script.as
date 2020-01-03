import libreria.*;

import mx.collections.ArrayCollection;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;
public var mat_idn:String;
public var enc_ver_idn:String;
public var enc_eje_mat_idn:String;
//*****************************************************************************************************
private function inicio():void
{
	this.ro_encuestas.cargar_categorias(enc_ver_idn);
	this.x = 0;
	this.y = 0;
}
//*****************************************************************************************************
private function result_cargar_categorias(event:ResultEvent):void{
	var i:int = 0;
	if (event.result.length > 0)
	{
		this.title = event.result[0].campo_uno;
		this.lbl_matricula.text = this.lbl_matricula.text + " " + mat_idn;
		var categoria:frm_encuestas_item_categoria
		this.lbl_encabezado.text = event.result[0].campo_tres;
		for (i=0;i<event.result.length; i++)
		{
			categoria = new frm_encuestas_item_categoria;
			categoria.enc_cat_idn = event.result[i].campo_dos;
			categoria.enc_ver_idn = this.enc_ver_idn;
			this.cnv_categorias.addChild(categoria);
			if (i== event.result.length - 1)
			{
				this.btn_enviar.enabled = true;
			}
		}
		
		this.btn_enviar.y = this.height - 50;
		
	}
	else
	{
		mx.controls.Alert.show("Error en la encuesta N°" + this.enc_ver_idn,"Error");
	}
	
	
}


//*****************************************************************************************************
private function btn_enviar_click():void
{
	this.btn_enviar.enabled = false;
	var i:int = 0;
	var j:int = 0;
	var categorias:Array = new Array;
	var preguntas:Array = new Array;
	var preguntas_sin_responder:Boolean = false;
	var arreglo_respuestas:ArrayCollection = new ArrayCollection;
	var o_dos_campos:obj_dos_campos = new obj_dos_campos;
	
	categorias = cnv_categorias.getChildren();
	for (i=0; i < cnv_categorias.getChildren().length; i++)
	{
		preguntas = categorias[i].cnv_preguntas.getChildren();
		j = 0;
		for (j = 0;j < preguntas.length; j++)
		{
			if (preguntas[j].toString().indexOf("encuestas_item_pregunta")!= -1)
			{
				if (preguntas[j].respuesta == "" && preguntas[j].respuesta_desarrollo == "")
				{
					preguntas_sin_responder = true;
				}
			}
		}
	}
	
	if (preguntas_sin_responder)
	{
		mx.controls.Alert.show("Por favor conteste todas las preguntas","Alerta");
		this.btn_enviar.enabled = true;
	}
	else
	{
		i = 0;
		
		for (i=0; i < cnv_categorias.getChildren().length; i++)
		{
			preguntas = categorias[i].cnv_preguntas.getChildren();
			j = 0;
			for (j = 0;j < preguntas.length; j++)
			{
				if (preguntas[j].toString().indexOf("encuestas_item_pregunta")!= -1)
				{
					o_dos_campos = new obj_dos_campos;
					if (preguntas[j].respuesta != "")
					{
						
						o_dos_campos.data = preguntas[j].respuesta;
						o_dos_campos.label = "";
						arreglo_respuestas.addItem(o_dos_campos);	
					}
					else if (preguntas[j].respuesta_desarrollo != "")
					{
						o_dos_campos.data = preguntas[j].cod_respuesta;
						o_dos_campos.label = preguntas[j].respuesta_desarrollo;
						arreglo_respuestas.addItem(o_dos_campos);
						
					}
				}
			}
		}
		this.ro_encuestas.guarda_respuestas(this.mat_idn, arreglo_respuestas, enc_eje_mat_idn);
	}
}
//*****************************************************************************************************
//*****************************************************************************************************
private function result_guarda_respuestas(event:ResultEvent):void{
	
	parentApplication.carga();
	PopUpManager.removePopUp(this);
	
}

//*****************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString,"Error");
}