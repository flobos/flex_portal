// ActionScript file
import flash.events.TimerEvent;
import flash.utils.Timer;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.rpc.events.*;


private const TIMER_INTERVAL:int = 10;
private var baseTimer:int;
private var t:Timer;
private var tiempo:Date = new Date(0, 0, 0, 0, 0, 0, 000);
private var arreglo_preguntas:ArrayCollection = new ArrayCollection;
private var arreglo_respuestas:ArrayCollection = new ArrayCollection;
private var num_pregunta
private var trab_idn:String;
private var cant_obj:String;
private var cant_des:String;
private var tc_idn:String;
private var tip_pru_idn:String;
private var tip_preg_idn:String;
private var tiempo_prueba:int;

//****************************************************************************************************************************************
private function inicio():void 
{
	trab_idn="1100738"
	tiempo_prueba=50;
	lbl_tiempo_total.text=dateFormatter.format(tiempo_prueba)
	ro_prueba.muestra_detalle_prueba_alumno(trab_idn);
	
	t = new Timer(TIMER_INTERVAL);
	t.addEventListener(TimerEvent.TIMER, updateTimer);
	btn_responder.enabled=false;
	btn_anterior.enabled=false;
	btn_siguiente.enabled=false;
}
//****************************************************************************************************************************************
private function result_muestra_detalle_prueba_alumno(event:ResultEvent):void
{
	cant_des='0';
	cant_obj='0';
	
	mx.controls.Alert.show(String(event.result.length),'Ayuda');
	if(event.result.length>0)
	{
		
		for(x = 0; x < event.result.length; x++)
		{
			if(event.result[x].campo_dos == '2')
				cant_des = event.result[x].campo_uno;
			else
				cant_obj = event.result[x].campo_uno;
			
		} 
		
		//lbl_alumno.text = event.result[0].campo_diez;
		//lbl_tipo_prueba.text = event.result[0].campo_seis;
		//lbl_ramo.text = event.result[0].campo_cinco;
		//lbl_trab_idn.text = trab_idn;
		tw_prueba_alumno.title = "N° Rendición de Prueba " + trab_idn
		
		tc_idn=event.result[0].campo_tres;
		tip_pru_idn=event.result[0].campo_cuatro;
		
		txt_pregunta.htmlText="La Prueba Consta de un total de <b>" + String(int(cant_des)+int(cant_obj)) + "</b> Preguntas de las cuales <b>" + cant_obj + "</b> son de Selección Multiple y <b>" + cant_des + "</b> Preguntas de desarrollo, deberá responder esta evaluación en el tiempo indicado.<BR><BR>Para dar inicio a la Prueba deberá precionar el botón <b>COMENZAR PRUEBA</b>, una vez presionado comenzará a correr el Tiempo y este no se detendrá hasta que ud. presione el botón <b>FINALIZAR PRUEBA</b> o se agote el tiempo estipulado en la evaluación.<BR><BR>Podrá visualizar las Preguntas  de su evaluación en la barra que se encuentra en la parte inferior de la Pantalla, estas solo seran visibles una vez ke inicie la prueba."
		slider_preguntas.minimum=1;
		slider_preguntas.maximum=int(cant_des)+int(cant_obj);
		slider_preguntas.snapInterval=1;
        slider_preguntas.tickInterval=1;
       
       
       	slider_preguntas.labels = [slider_preguntas.minimum, slider_preguntas.maximum];
       
        
    
		if(event.result[0].campo_siete=="0")
		{
		//	mx.controls.Alert.show("NO TIME");
		}
		
	}
	ro_prueba.muestra_prueba_alumno(trab_idn)
}
//****************************************************************************************************************************************
private function updateTimer(evt:TimerEvent):void 
{
	var ms:Number = getTimer() - baseTimer;
	var d:Date = new Date(0, 0, 0, 0, 0, 0, ms);
	var e:Date = new Date(0, 0, 0, 0, 0, 0, ms);
	
	
	counter.text = dateFormatter.format(d);
	if (tiempo_prueba!=0)
	{
		if (dateFormatter.format(d)== dateFormatter.format(tiempo_prueba))
		{
			mx.controls.Alert.show("Tiempo Finalizado");
			t.stop();
		}		
	}
	
}
//****************************************************************************************************************************************
private function startTimer():void 
{
	baseTimer = getTimer();
	t.start();
	
}
//****************************************************************************************************************************************
private function stopTimer():void 
{
	t.stop();
}
//****************************************************************************************************************************************
private function result_muestra_prueba_alumno(event:ResultEvent):void
{
	var preg_idn:String
	var i:int;
	i=0;
	
	for( x = 0; x < event.result.length ; x++ )
	{
		if (preg_idn!=event.result[x].campo_uno)
		{
			var o_nueve_campos:obj_nueve_campos = new obj_nueve_campos;
			o_nueve_campos.campo_uno = event.result[x].campo_uno;
			o_nueve_campos.campo_dos = event.result[x].campo_dos;
			o_nueve_campos.campo_tres = event.result[x].campo_tres;
			o_nueve_campos.campo_cuatro = event.result[x].campo_cuatro;
			o_nueve_campos.campo_cinco = event.result[x].campo_cinco;
			o_nueve_campos.campo_seis = event.result[x].campo_seis;
			o_nueve_campos.campo_siete = event.result[x].campo_siete;

			if (event.result[x].campo_nueve== null)
				o_nueve_campos.campo_ocho = "0";
			else
				o_nueve_campos.campo_ocho = "1";

			o_nueve_campos.campo_nueve = event.result[x].campo_ocho;
			arreglo_preguntas.addItem(o_nueve_campos);
			preg_idn=event.result[x].campo_uno
		}
			var o_nueve_campos:obj_nueve_campos = new obj_nueve_campos;
			o_nueve_campos.campo_uno = event.result[x].campo_uno;
			o_nueve_campos.campo_dos = event.result[x].campo_dos;
			o_nueve_campos.campo_tres = event.result[x].campo_tres;
			o_nueve_campos.campo_cuatro = event.result[x].campo_cuatro;
			o_nueve_campos.campo_cinco = event.result[x].campo_cinco;
			
			o_nueve_campos.campo_siete = event.result[x].campo_siete;
			o_nueve_campos.campo_seis = event.result[x].campo_seis;
			if (event.result[x].campo_nueve== null)
			{
				o_nueve_campos.campo_seis = event.result[x].campo_seis;
				o_nueve_campos.campo_ocho = "0";
			}
			else
			{
					if (event.result[x].campo_seis==event.result[x].campo_nueve)
						o_nueve_campos.campo_ocho = "1";
					else
						if(event.result[x].campo_ocho=='2')
							o_nueve_campos.campo_ocho = "1";
					
					//mx.controls.Alert.show(o_nueve_campos.campo_siete);
					if(event.result[x].campo_ocho=='2')
						o_nueve_campos.campo_seis = event.result[x].campo_nueve;
			}
			
			
				
			
			o_nueve_campos.campo_nueve = event.result[x].campo_ocho;
			arreglo_respuestas.addItem(o_nueve_campos);
			//mx.controls.Alert.show(event.result[x].campo_ocho);
	}
	
	//slider_preguntas.value=1;
	
	slider_preguntas_on_change();
	
	btn_responder.enabled=true;
	btn_anterior.enabled=true;
	btn_siguiente.enabled=true;
		
	startTimer();	
}
//****************************************************************************************************************************************
private function slider_preguntas_on_change():void
{
	
	lbl_num_pregunta.text=String(slider_preguntas.value);
	txt_pregunta.text=arreglo_preguntas[slider_preguntas.value-1].campo_tres
	tip_preg_idn=arreglo_preguntas[slider_preguntas.value-1].campo_nueve;
	
	var arreglo_alternativas:ArrayCollection = new ArrayCollection;
	var sw:int=0;	
	for (x = 0; x < arreglo_respuestas.length; x++)
	{
		if (arreglo_preguntas[slider_preguntas.value-1].campo_dos == arreglo_respuestas[x].campo_dos)
		{
			if(arreglo_respuestas[x].campo_ocho=='1')
				sw=1;
		
				var o_seis_campos:obj_seis_campos = new obj_seis_campos;
				o_seis_campos.campo_uno = "*";
				o_seis_campos.campo_dos = arreglo_respuestas[x].campo_cinco
				o_seis_campos.campo_tres = arreglo_respuestas[x].campo_seis;
				o_seis_campos.campo_cuatro = arreglo_respuestas[x].campo_siete;
				o_seis_campos.campo_cinco = arreglo_respuestas[x].campo_ocho;
				o_seis_campos.campo_seis = arreglo_respuestas[x].campo_nueve;
				arreglo_alternativas.addItem(o_seis_campos);
			
		}
	}
	rp_alternativas.dataProvider = arreglo_alternativas;
	if (sw==1)
	{
	
		for(x = 0; x < rp_alternativas.dataProvider.length; x++)
		{
				if (lbl_correcta[x].text=='1')
					opt_correcta[x].selected=true;
				
				opt_correcta[x].enabled=false;
		}
	}
	
	for(x = 0; x < rp_alternativas.dataProvider.length; x++)
	{
		if(lbl_tip_preg_idn[x].text=='2')
		{
			txt_respuesta[x].width=0;
			txt_respuesta[x].visible=false;
			txt_respuesta_input[x].width=544;
			txt_respuesta_input[x].height=50;
			txt_respuesta_input[x].visible=true;
			opt_correcta[x].selected=true;
			opt_correcta[x].visible=false;
			lbl_titulo_correcta.visible=false;
			/*width="544" id="txt_respuesta"
			width="0" id="txt_respuesta_input"*/
			if (lbl_correcta[x].text=='1')
				txt_respuesta_input[x].enabled=false
		}
		else
			lbl_titulo_correcta.visible=true;
	}
	

}
//****************************************************************************************************************************************
private function btn_responder_click()
{
	var sw:int;
	sw=0;
	for (x = 0; x < rp_alternativas.dataProvider.length; x++)
	{
		if(opt_correcta[x].selected == true && lbl_tip_preg_idn[x].text == '1')
			sw=1;
		else
			if 	(lbl_tip_preg_idn[x].text == '2' && txt_respuesta_input[x].text != '')
				sw=1;

		
	}
	if (sw==1)
		mx.controls.Alert.show("¿Realmente desea elegir esa alternativa como su respuesta?", "¿Respuesta Correcta?", 3, this, alertRespuesta);
	else
		mx.controls.Alert.show("Antes debe seleccionar una alternativa", "Ayuda")

}
//****************************************************************************************************************************************
private function alertRespuesta(event:CloseEvent):void 
{
	var eje_aca_res_idn:String;
    if (event.detail==Alert.YES)
    {
    	for (x = 0; x < rp_alternativas.dataProvider.length; x++)
		{
			if (lbl_tip_preg_idn[x].text=='1')
			{
				if(opt_correcta[x].selected == true)
				{
					eje_aca_res_idn
					lbl_correcta[x].text ="1"
					for( var c:int=0; c< arreglo_respuestas.length; c++)
					{
						if (lbl_eje_aca_res_idn[x].text == arreglo_respuestas[c].campo_cinco)
						{
							arreglo_respuestas[c].campo_ocho="1"
							slider_preguntas.value=slider_preguntas.value + 1;
							ro_prueba.guarda_respuesta_alumno(arreglo_respuestas[c].campo_uno,lbl_eje_aca_res_idn[x].text, txt_respuesta[x].text);
							slider_preguntas_on_change();
						}
					}
				}
				opt_correcta[x].enabled=false;
			}
			else
			{
				for( var c:int=0; c< arreglo_respuestas.length; c++)
				{
					if (lbl_eje_aca_res_idn[x].text == arreglo_respuestas[c].campo_cinco)
					{
						arreglo_respuestas[c].campo_ocho="1"
						arreglo_respuestas[c].campo_seis=txt_respuesta_input[x].text
						slider_preguntas.value=slider_preguntas.value + 1;
						ro_prueba.guarda_respuesta_alumno(arreglo_respuestas[c].campo_uno,lbl_eje_aca_res_idn[x].text, txt_respuesta_input[x].text);
						slider_preguntas_on_change();
						
					}
				}
			}
		
		
		}
    	
    }
}
//****************************************************************************************************************************************
private function btn_siguiente_click():void
{
	slider_preguntas.value=slider_preguntas.value + 1;
	slider_preguntas_on_change();
}
//****************************************************************************************************************************************
private function btn_anterior_click():void
{
	slider_preguntas.value=slider_preguntas.value - 1;
	slider_preguntas_on_change();
}
//****************************************************************************************************************************************
private function txt_respuesta_input_click():void
{
	for (x = 0; x < rp_alternativas.dataProvider.length; x++)
	{
		txt_respuesta_input[x].text='';		
	}
	
}