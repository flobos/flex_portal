import libreria.*;

import mx.collections.ArrayCollection;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.ArrayUtil;


public var codigo_encuesta:String;
public var nombre_encuesta:String;
public var tc_idn:String;


//***********************************************************************************************************
private function tw_creationComplete():void{
	lbl_codigo.text = codigo_encuesta;
	lbl_nombre.text = nombre_encuesta;
	ro_encuesta_preguntas_alumno.encuesta_muestra_preguntas_tipo_nota(Number(lbl_codigo.text));
}

//***********************************************************************************************************
private function btn_reponder_click():void{
	var valida:Number;
	
	var y:Number;
	var i:Number;
	
	//var arreglo_preguntas =  new Array();
	//var arreglo_preguntas_desarrollo =  new Array();
	var arreglo_preguntas:Array;
	var arreglo_preguntas_desarrollo:Array;
	
	

	
  //arreglo_preguntas = rpt_preguntas.dataProvider
  //arreglo_preguntas_desarrollo = rpt_preguntas_desarrollo.dataProvider
	arreglo_preguntas =  ArrayUtil.toArray(this.rpt_preguntas.dataProvider);
	arreglo_preguntas_desarrollo =  ArrayUtil.toArray(this.rpt_preguntas_desarrollo.dataProvider);
	
	valida = 1;
	for(i = 0; i < arreglo_preguntas.length ; i++)
	{
		if (ns_nota[i].value == 0){
			valida = 0;
		}
	}
	if (valida == 0){

		mx.controls.Alert.show("Existe algunas repuestas con valor 0. debe contestarlas todas ...","ERROR");			
	}else{
		
		var obj1:Object=new Object;
	    var obj2:Object=new Object;	


     	var largo:Number;	
		largo = 0;
	  //var arreglo13:Array = new Array;
		var arreglo13:ArrayCollection = new ArrayCollection;
		
		
		for(  i = 0; i < arreglo_preguntas.length ; i++ )
			
			
			{
		      //arreglo13.addItemAt(i, {_remoteClass : "libreria_alm.obj_dos_campos" ,data: lbl_codigo_pregunta[i].text  , label: ns_nota[i].value });
			   	obj1.data = lbl_codigo_pregunta[i].text;
		        obj1.label = String(ns_nota[i].value);	
		        arreglo13.addItem(obj1);
			}
			
			
	
			
			
			
	largo = arreglo13.length ;
	for(  y = 0; y < arreglo_preguntas_desarrollo.length ; y++ )
		{
			  //arreglo13.addItemAt(largo ,{_remoteClass : "libreria_alm.obj_dos_campos" ,data: lbl_codigo_pregunta_desarrollo[y].text  , label: librerias.f_proper_primera_letra(librerias.f_trim(ta_pregunta[y].text)) });
				obj2.data = lbl_codigo_pregunta_desarrollo[y].text;
		        obj2.label = librerias.f_proper_primera_letra(librerias.f_trim(ta_pregunta[y].text));	
		        arreglo13.addItem(obj2);
			largo += 1;
		}
		
		
		
		
		
		
		
		
		
	ro_encuesta_preguntas_alumno.encuesta_inserta_encuesta_pregunta_alumno(tc_idn,	Number(lbl_codigo.text), arreglo13 );
	}
}

//***********************************************************************************************************
private function btn_cerrar_click():void{
	PopUpManager.removePopUp(this);
}

//***********************************************************************************************************
private function encuesta_muestra_preguntas_tipo_nota_result(event:ResultEvent):void{
	rpt_preguntas.dataProvider = event.result;
	ro_encuesta_preguntas_alumno.encuesta_muestra_preguntas_tipo_desarrollo(Number(lbl_codigo.text));
}

//***********************************************************************************************************
private function encuesta_muestra_preguntas_tipo_desarrollo_result(event:ResultEvent):void{
	rpt_preguntas_desarrollo.dataProvider = event.result;
	vb_preguntas.enabled = true;
}

//***********************************************************************************************************
private function encuesta_inserta_encuesta_pregunta_alumno_result(event:ResultEvent):void{
	mx.controls.Alert.show("Gracias por responder esta encuesta, su opinion es muy importante para nosotros ...","EXITO");	
	parentApplication.ro_encuesta_alumno.encuesta_muestra_alumno(tc_idn);
	parentApplication.dg_encuestas.dataProvider = undefined;
	PopUpManager.removePopUp(this);
}