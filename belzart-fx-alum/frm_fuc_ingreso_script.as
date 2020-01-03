import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.events.DragEvent;
import mx.managers.*;
import mx.rpc.events.*;

public var criterio:String;
public 	var obj66:Object;
public 	var obj67:Object;

public var arreglo_tutoria:ArrayCollection;


private var mat_idn:String;
private var empList:String;
private var modalidad_campus:Number;
//***********************************************************************************************************
private function inicio():void
{
	//lbl_num_fuc.text = ""
	//lbl_ejecutivo.text = ""
	//lbl_rut_ejecutivo.text = ""
	mat_idn = this.parentApplication.mat_idn;
	ro.alumno_muestra_fuc(mat_idn);
	ro.busca_mod_cam_por_matricula(mat_idn);
}
//***********************************************************************************************************
private function result_alumno_muestra_fuc(event:ResultEvent):void
{
	var arreglo1:Object;
	arreglo1 = event.result;
	
	txt_rut.text = arreglo1[0].campo_uno;
	txt_matricula.text = arreglo1[0].campo_dos;
	txt_promo.text = arreglo1[0].campo_tres;
	txt_act_academica.text = arreglo1[0].campo_seis;
	txt_nombre_alumno.text = arreglo1[0].campo_cinco;
	txt_malla.text = arreglo1[0].campo_siete;
	lbl_division_politica.text = arreglo1[0].campo_nueve;
}
//***********************************************************************************************************
private function result_busca_mod_cam_por_matricula(event:ResultEvent):void
{
	var arreglo3:Object;
	arreglo3 = event.result;
	
	modalidad_campus = arreglo3[0].data;
	lbl_institucion.text = arreglo3[0].label


	//mx.controls.Alert.show(modalidad_campus + ' ' + mat_idn);
	
	
	ro.muestra_criterios_consulta(Number(modalidad_campus), mat_idn);
}
/***********************************************************************/
private function result_muestra_criterios_consulta(event:ResultEvent):void
{
	/*mx.controls.Alert.show(parentApplication.lbl_modalidad.text);*/

	/*var arreglo2:Array
	arreglo2 = event.result;
	
	mx.controls.Alert.show(arreglo2[0].data);*/
	if(event.result.length > 0)
	{
		cmb_criterios.dataProvider = event.result
			
		cmb_criterios.dataProvider.addItemAt({label:"-- Seleccione --",data:"000",data2:"000"},0);
		cmb_criterios.dataProvider.sortItemsBy("data","ASC");
		cmb_criterios.selectedIndex = 0
	}
	else
	{
		mx.controls.Alert.show("No existen criterios de consulta asignados para esta matrícula","Error");
	}
}

/***********************************************************************/

private function result_busca_mod_cam_criterio(event:ResultEvent):void
{
	/*mx.controls.Alert.show(parentApplication.lbl_modalidad.text);*/

	var arreglo2:Object;
	arreglo2 = event.result;
	
	lbl_mod_cam_criterio.text = arreglo2[0].campo_uno;
	
	ro.muestra_motivos_consulta(String(lbl_mod_cam_criterio.text));
	/*cmb_criterios.dataProvider = event.result*/
	

}

/***********************************************************************/

private function result_muestra_motivos_consulta(event:ResultEvent):void
{
	if(event.result.length > 0)
	{
		dg_disponibles.dataProvider = event.result
		edita_datagrid()	
	}
	else
	{
		mx.controls.Alert.show("No existen motivos de consulta asignados para esta matrícula","Error");
	}
}

/***********************************************************************/

private function click_btn_enviar():void
{
	if (librerias.f_trim(txt_consulta.text) == '' || (dg_seleccionados.dataProvider == null || dg_seleccionados.dataProvider.length == 0))  
		{	
			mx.controls.Alert.show('Debe especificar la duda o consulta y/o motivo que desea plantear. Por favor, inténtelo nuevamente', 'Información');
			txt_consulta.setFocus();
		}
	else
		{
			ro.inserta_fuc_web(mat_idn,txt_consulta.text);
		}
}
//***********************************************************************************************************
private function result_inserta_fuc_web(event:ResultEvent):void
{
	var arreglo:Object;
	var i:int;
	var y:int;
	arreglo = event.result;
	lbl_fuc_numero.text = String(arreglo[0].campo_uno);
	

	for(i=0;i<dg_seleccionados.dataProvider.length;i++) 
	{
		if (dg_seleccionados.dataProvider.getItemAt(i).data2 != 106)
		{
			ro.inserta_motivos_fuc(arreglo[0].campo_uno, dg_seleccionados.dataProvider.getItemAt(i).data, lbl_division_politica.text,dg_seleccionados.dataProvider.getItemAt(i).data2,'');
		}
		else
		{
			for(y=0;y<arreglo_tutoria.length;y++)
			{	
				if(arreglo_tutoria[y].data == dg_seleccionados.dataProvider.getItemAt(y).data)
				{
					ro.inserta_motivos_fuc(arreglo[0].campo_uno, dg_seleccionados.dataProvider[i].data, lbl_division_politica.text,dg_seleccionados.dataProvider[i].data2, arreglo_tutoria[y].label)
				}
			}
			
		}
	}	
	

}
/***********************************************************************/
/*

function devuelve_datos_dg(event){
	var arreglo2:Object;
	
	arreglo2 = event.result.motivos.motivo;
	
	dg_disponibles.dataProvider = event.result.motivos.motivo
	edita_datagrid()
}
*/
/***********************************************************************/
private function edita_datagrid():void
{
	var arreglo99:Array;
	var i:int;
	var j:int;
	for(i=0;i<dg_disponibles.dataProvider.length;i++) 
	{
		for(j=0;j<dg_seleccionados.dataProvider.length;j++)
		{
			if(dg_disponibles.dataProvider.getItemAt(i).data == dg_seleccionados.dataProvider.getItemAt(j).data)
			{
				dg_disponibles.dataProvider.removeItemAt(i)
			}
		}
	}
}

/***********************************************************************/

private function enviar_mensaje():void
{
	mx.controls.Alert.show("El Formulario de Consulta Nº "+lbl_fuc_numero.text+" ha sido enviado correctamente");
	lbl_fuc_numero.visible = true;
	cmb_criterios.enabled = false;
	dg_disponibles.enabled = false;
	dg_seleccionados.enabled = false;
	txt_consulta.enabled = false;
	btn_enviar.enabled = false;
	//PopUpManager.removePopUp(this)
}

/***********************************************************************/
/*
function cerrar(){
		lbl_fuc_numero.text = ""
//		getURL("javascript:window.opener=self; window.close();");
		var url :URLRequest = new URLRequest("javascript:window.opener=self; window.close();");
		navigateToURL(url, "_blank");
}
*/
/***********************************************************************/

/***********************************************************************/
private function cmb_criterios_change():void
{
	if(String(cmb_criterios.selectedItem.data)!='000')
	{
		ro.muestra_motivos_consulta(String(cmb_criterios.selectedItem.data), String(cmb_criterios.selectedItem.data2));
	}
}

/***********************************************************************/

private function doDragEnter(event:DragEvent):void	{
//    event.handled="true";
}
/***********************************************************************/

private function doDragExit(event:DragEvent):void {
    event.target.hideDropFeedback();
}
/***********************************************************************/
private function doDragOver(event:DragEvent):void {
 /*   event.currentTarget.showDropFeedback();

    if (KeyboardEvent.keyDown(Keyboard.CONTROL))
        event.action = mx.managers.DragManager.COPY;
    else
        event.action = DragManager.MOVE;*/
}
/***********************************************************************/
private function doDragDrop(event:DragEvent):void {

    doDragExit(event);
    var items:Object = event.dragSource.dataForFormat("items");
    var dest:Object = event.target;
    var dropLoc:Object = dest.getDropLocation()

    items.reverse()

    for(var i:int = 0; i < items.length; i++) {
        dest.addItemAt(dropLoc, items[i]);
    }
}
/***********************************************************************/
private function doDragComplete(event:DragEvent):void {
    doDragExit(event);
    var src:Object = event.target;

    if (event.action == DragManager.MOVE) {

        var items:Object = src.selectedIndices;

       items.sort(sortByNumber)		// If user selects the listitems in random order, we first sort the array to have all the items in order
       items.reverse()		        // then we reverse the array. In list when any item is removed, it decreases the index of the items below it.
                                    // so we remove the bottom most item first.
        var s:String="";
        for(var i:int = 0; i < items.length; i++) {
            s=s+items[i]+" : ";
        }

        for(var j:int = 0; j < items.length; j++) {
            src.removeItemAt(items[j])
        }

    }
}
/***********************************************************************/
private function sortByNumber(a:int, b:int):Boolean {
  return (a > b);
}
/***********************************************************************/
/*
function btn_paya_click(event)
{	

}
*/
/***********************************************************************/
private function dg_disponibles_cellPress():void
{
	if(dg_disponibles.selectedItem.data2 == 106)
	{
		lbl_motivo.text = String(cmb_criterios.selectedItem.label);
		lbl_mod_cam_mot_idn.text = String(dg_disponibles.selectedItem.data);
		var popup12:frm_fuc_muestra_toma_cursos = frm_fuc_muestra_toma_cursos(PopUpManager.createPopUp( this, frm_fuc_muestra_toma_cursos , true));
		popup12.matricula = this.mat_idn; 
		mx.managers.PopUpManager.centerPopUp(popup12);
//		var popup12:frm_fuc_muestra_toma_cursos = mx.managers.PopUpManager.createPopUp(this, frm_fuc_muestra_toma_cursos, true);
	}

	if (dg_seleccionados.dataProvider != null){
		var objeto_seleccionado:Object = new Object();
		
		objeto_seleccionado.data = dg_disponibles.selectedItem.data;
		objeto_seleccionado.data2 = dg_disponibles.selectedItem.data2;
		objeto_seleccionado.label = dg_disponibles.selectedItem.label;
		
		dg_seleccionados.dataProvider.addItem(objeto_seleccionado);
		dg_disponibles.dataProvider.removeItemAt(dg_disponibles.selectedIndex);
	}
	else{
		var arreglo:ArrayCollection = new ArrayCollection;
		var objeto_seleccionado2:Object = new Object();
		
		objeto_seleccionado2.data = dg_disponibles.selectedItem.data;
		objeto_seleccionado2.data2 = dg_disponibles.selectedItem.data2;
		objeto_seleccionado2.label = dg_disponibles.selectedItem.label;
		
		arreglo.addItem(objeto_seleccionado2);
		dg_seleccionados.dataProvider = arreglo;
		dg_disponibles.dataProvider.removeItemAt(dg_disponibles.selectedIndex);
	}
	
	
	
}
/***********************************************************************/
private function dg_seleccionados_cellPress():void
{	
	if (dg_hide.dataProvider != null){
		for(var i:int = 0; i < dg_hide.dataProvider.length; i++) 
		 {
			 if(dg_seleccionados.dataProvider.selectedItem.data == dg_hide.dataProvider.getItemAt(i).data)
			 {
			 	dg_hide.dataProvider.removeItemAt(i);
			 }
		 }
	}
	dg_seleccionados.dataProvider.removeItemAt(dg_seleccionados.selectedIndex);
	
	ro.muestra_motivos_consulta(String(cmb_criterios.selectedItem.data), String(cmb_criterios.selectedItem.data2));
	
}
/***********************************************************************/
private function result_inserta_fuc(event:ResultEvent):void
{
	if (event.result.length > 0)
	{
		mx.controls.Alert.show("No tiene funcionarios asociados para gestionar su consulta","Información");
	}
	else
	{
		enviar_mensaje();
	}
}
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
