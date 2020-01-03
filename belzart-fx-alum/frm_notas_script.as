import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

//***********************************************************************************************************
private function inicio():void
{
	if (this.parentApplication.tc_idn != 0)
	{
	//	if (this.parentApplication.flag_deuda.text == 0)
	//	{
			ro_muestra_notas.procesos_muestra_web(this.parentApplication.tc_idn);
			//	ro_muestra_notas.notas_muestra_web(this.parentApplication.tc_idn);	
	//	}
	//	else
	//	{
	//		mx.controls.Alert.show("No puede visualizar sus notas por tener una deuda pendiente de pago.","Alerta");
	//	}
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar un ramo.","Alerta");
	}
}


private function no_devuelve_datos(event:FaultEvent):void{
mx.controls.Alert.show(event.fault.faultString, 'Error')
}

private function result_procesos_muestra_web(event:ResultEvent):void {

	if (event.result.length < 1)
	{
		mx.controls.Alert.show("No se encontro la información de los procesos", "Alerta");		
	}
	else
	{
		this.dg_procesos.dataProvider = event.result;
	}
	
}

private function cargar_notas():void
{
	if (this.dg_procesos.selectedItem != null)
	{
		this.dg_notas.dataProvider = null;
		ro_muestra_notas.notas_muestra_web(this.parentApplication.tc_idn, this.dg_procesos.selectedItem.campo_uno);
	}
}


private function result_notas_muestra_web(event:ResultEvent):void {
	var arreglo:Object;
	arreglo = event.result;	
	lbl_tipo.text = arreglo[0].tipo; 
	
	if (arreglo[0].campo_seis == null)
	{	
		lbl_promedio_lbl.visible = false;//---
	}
	else
	{
		lbl_promedio_lbl.visible = true;//----
		lbl_promedio.visible = true;
		lbl_promedio.text = arreglo[0].campo_seis;
	}
	dg_notas.dataProvider = event.result;

}

private function genera_detalle():void
{
	if (dg_notas.selectedItem.campo_dos != null)
	{
		if (dg_notas.selectedItem.campo_diez != "105")
		{
			
			if (dg_notas.selectedItem.campo_nueve == '2'){
				
				
				var popup_respuestas:frm_notas_pop_correccion_objetivas = frm_notas_pop_correccion_objetivas(PopUpManager.createPopUp( this, frm_notas_pop_correccion_objetivas , true));
				popup_respuestas.trabajo = dg_notas.selectedItem.campo_ocho;
				mx.managers.PopUpManager.centerPopUp(popup_respuestas)
				
				
				
			}else{
				
				var popup2:nota_detalle_alumno = nota_detalle_alumno(PopUpManager.createPopUp( this, nota_detalle_alumno , true));
				popup2.trab_idn = dg_notas.selectedItem.campo_ocho;
				popup2.promedio = lbl_promedio.text;
				mx.managers.PopUpManager.centerPopUp(popup2)
				
				
			}
			
		}
		else
		{
			mx.controls.Alert.show('No puede acceder a la correción de su prueba. Sin rendición por deuda.', 'Información')
		}
	}
	else
	{
		mx.controls.Alert.show('Debe seleccionar una prueba que ya haya sido evaluada.','Información');
	}

	/*popup2.archivo = dt_pruebas.selectedItem.campo_cinco
	popup2.puntaje_evaluacion = puntaje_total
	popup2.porcentaje_evaluacion = porcentaje_total */
	
	
	
}
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
