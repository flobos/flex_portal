import flash.net.*;

import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;


//***********************************************************************************************************
private function frm_matriculas_load():void
{
	ro_matriculas_alumno.muestra_encuestas_pendientes_por_idn(parentApplication.alu_idn);
}

private function contestar_encuesta():void
{
	if (this.dg_encuestas.selectedItem != null)
	{
		var popup1:frm_encuestas_ver_encuesta = frm_encuestas_ver_encuesta(PopUpManager.createPopUp( this, frm_encuestas_ver_encuesta , true));
		popup1.enc_ver_idn = this.dg_encuestas.selectedItem.campo_tres;
		popup1.mat_idn = this.dg_encuestas.selectedItem.campo_cuatro;
		popup1.enc_eje_mat_idn = this.dg_encuestas.selectedItem.campo_uno;
		mx.managers.PopUpManager.centerPopUp(popup1)
		PopUpManager.removePopUp(this);
	}
	else
	{
		mx.controls.Alert.show("Seleccione una encuesta","Alerta");
	}
}
//***********************************************************************************************************
private function result_muestra_encuestas_pendientes_por_idn(event:ResultEvent):void
{
	if (event.result.length > 0)
	{
		this.dg_encuestas.dataProvider = event.result;
		mx.controls.Alert.show("Existen encuestas pendientes");
		this.dg_encuestas.visible = true;
		this.btn_responder_encuesta.visible = true;
		this.dt_matriculas.visible = false;
		this.txt_mat_1.visible = false;
		this.btn_entrar.visible = false;
	}
	else
	{
		this.btn_responder_encuesta.visible = false;
		this.dg_encuestas.visible = false;
		this.dt_matriculas.visible = true;
		this.txt_mat_1.visible = true;
		this.btn_entrar.visible = true;
		ro_matriculas_alumno.muestra_matriculas_por_idn(parentApplication.alu_idn);
		lbl_alu_idn.text = parentApplication.alu_idn
	}
}
//***********************************************************************************************************
private function btn_entrar_click():void
{
	if(dt_matriculas.selectedItem.campo_cinco == undefined)
	{
		mx.controls.Alert.show('Debe seleccionar una matricula de recuadro antes de continuar.', 'InformaciÃ³n')
	}
	else
	{
		parentApplication.mat_idn = dt_matriculas.selectedItem.campo_cinco;
		parentApplication.mal_idn = dt_matriculas.selectedItem.campo_ocho;
		
		parentApplication.tip_idn = dt_matriculas.selectedItem.campo_seis;
		
		parentApplication.ro_alumnos_main.muestra_menus_aula_virtual(dt_matriculas.selectedItem.campo_cinco);
		parentApplication.ro_alumnos_main.muestra_toma_cursos_principal(dt_matriculas.selectedItem.campo_cinco);
		
		parentApplication.lbl_mat_idn.text = dt_matriculas.selectedItem.campo_cinco;
		parentApplication.lbl_tip_prod_idn.text = dt_matriculas.selectedItem.campo_seis;
		
		parentApplication.pl_principal.visible = true;	
		
		PopUpManager.removePopUp(this); 
		
		if(parentApplication.lbl_tip_prod_idn.text == '100')
		{
			//	var popup1100:popup_noticia_ced = popup_noticia_ced(PopUpManager.createPopUp(this, popup_noticia_ced , true));
			//	mx.managers.PopUpManager.centerPopUp(popup1100);
			
		}
		
		//Comentado por Lobo volver a despues 
		//if(parentApplication.flag_deuda.text == '1' && parentApplication.lbl_tip_prod_idn.text == '100')
		//{
		//mx.controls.Alert.show('Estimado Alumno(a):' + '\n\n' + 'Segï¿½n lo establecido en el artï¿½culo 11 del reglamento acadï¿½mico, "El alumno que (...) se atrase en el pago de (...), podrï¿½ ser suspendido de su derecho a rendir evaluaciones, en cuyo caso para todos los efectos acadï¿½micos se entendera que el alumno no se presentï¿½ a la evaluaciï¿½n".' + '\n\n' + 'Dado lo anterior se recomienda que regularice su situaciï¿½n a la brevedad, para evitar que la aplicaciï¿½n del artï¿½culo antes citado le genere problemas en su rendimiento acadï¿½mico.', 'Informaciï¿½n');
		//}
	}
}
//***********************************************************************************************************
private function dt_matriculas_result(event:ResultEvent):void
{
	dt_matriculas.dataProvider = event.result;
	
	
}
//***********************************************************************************************************
private function no_devuelve_datos(event:ResultEvent):void
{
	//	mx.controls.Alert.show(event.fault.faultstring, 'Error');
}
//***********************************************************************************************************
private function result_muestra_matriculas_por_idn(event:ResultEvent):void
{
	var arreglo1:Object;
	arreglo1 = event.result;
	
	if(event.result.length > 0)
	{
		var popup21:frm_mensaje_deuda = frm_mensaje_deuda(PopUpManager.createPopUp( this, frm_mensaje_deuda , true));
		popup21.alu_idn = lbl_alu_idn.text;
		mx.managers.PopUpManager.centerPopUp(popup21);
		
		dt_matriculas.dataProvider = arreglo1;
	}
	else
	{
		no_devuelve_datos(event);
	}
} 
//***********************************************************************************************************
private function clic_ayuda():void
{
	var url :URLRequest = new URLRequest("http://164.77.193.131:8100/flex/flex_alm_ipx/ayuda_zona_segura.htm");
	navigateToURL(url, "_blank");
	//navigateToURL("http://164.77.193.131:8100/flex/flex_alm_ipx/ayuda_zona_segura.htm", "_blank");
	
}

private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString,"Error");
}
