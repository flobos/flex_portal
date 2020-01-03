import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

public var matricula:String;
/*var estado:String;

//***********************************************************************************************************	
function ltrim(matter) {
	var i:Number;
    if ((matter.length>1) || (matter.length == 1 && matter.charCodeAt(0)>32 && matter.charCodeAt(0)<255)) {
        i = 0;
        while (i<matter.length && (matter.charCodeAt(i)<=32 || matter.charCodeAt(i)>=255)) {
            i++;
        }
        matter = matter.substring(i);
    } else {
        matter = "";
    }
    return matter;
}
//***********************************************************************************************************
function rtrim(matter) {
	var i:Number;
    if ((matter.length>1) || (matter.length == 1 && matter.charCodeAt(0)>32 && matter.charCodeAt(0)<255)) {
        i = matter.length-1;
       while (i>=0 && (matter.charCodeAt(i)<=32 || matter.charCodeAt(i)>=255)) {
            i--;
        }
        matter = matter.substring(0, i+1);
    } else {
        matter = "";
    }
    return matter;
}
//***********************************************************************************************************
function trim(matter) {
    return ltrim(rtrim(matter));
} 

/****************************************************************************************/

/*function result_muestra_motivos_fuc(event) {
	
	dg_motivos.dataProvider = event.result;	

}
/****************************************************************************************/
private function result_ro_fuc_muestra_toma_cursos(event:ResultEvent):void
{
	dg_cursos.dataProvider = event.result;
	lbl_matricula.text = matricula;
//	edita_datagrid()
}
/****************************************************************************************/
private function valida_datos():void
{
	//lbl_fuc_numero.text = parentApplication.lbl_num_fuc.text;
	ro.ro_fuc_muestra_toma_cursos(matricula);
}
/****************************************************************************************/
/*function cambia_vista_motivo(){
	ro.cambia_vista_motivo(parentApplication.lbl_num_motivo.text);
}
/****************************************************************************************/
/*function resolucion_motivo(){
	var popup97 = 
	popup97 = undefined
	popup97 = mx.managers.PopUpManager.createPopUp(this, frm_fuc_muestra_resolucion_motivo, true);
	
}
/****************************************************************************************/
/*function getCellData(modal){
	parentApplication.lbl_num_motivo.text = ""
	var obj:Object;
	obj =  dg_motivos.selectedItem;
	estado = obj.estado;
	if(trim(estado) != 'Resuelto'){
		mx.controls.Alert.show('No es posible ver la resoluci�n del Motivo espec�fico, ya que este no se encuentra resuelto')
	}
	else
	{
		parentApplication.lbl_num_motivo.text = obj.idn;		
		//mx.controls.Alert.show(parentApplication.lbl_num_motivo.text);
		if(obj.vista == 'No'){
			cambia_vista_motivo()
		}
		resolucion_motivo()
	}
}
/****************************************************************************************/

private function btn_terminar_click():void
{
	var i:int;
	var arreglo:ArrayCollection = new ArrayCollection;
	if(dg_cursos_selec.dataProvider.length == 0)
	{
		mx.controls.Alert.show("Debe seleccionar al menos un Curso por el cual enviará la Consulta Académica","Información");
	}
	else
	{
		for(i=0;i<dg_cursos_selec.dataProvider.length;i++){
			var o_dos_campos:obj_dos_campos = new obj_dos_campos;
			o_dos_campos.data = this.parentApplication.mod.getChildAt(0).lbl_mod_cam_mot_idn.text;
			o_dos_campos.label = dg_cursos_selec.dataProvider.getItemAt(i).data;
			arreglo.addItem(o_dos_campos);
		}
		
		
		this.parentApplication.mod.getChildAt(0).arreglo_tutoria = arreglo;
		PopUpManager.removePopUp(this);
	}
}

/****************************************************************************************/

private function btn_cerrar_click():void
{
	PopUpManager.removePopUp(this)
}

/****************************************************************************************/

private function dg_cursos_cellPress():void
{
	var o_dos_campos:obj_dos_campos = new obj_dos_campos;
	o_dos_campos.data = dg_cursos.selectedItem.data;
	o_dos_campos.label = dg_cursos.selectedItem.label;
	
	if(dg_cursos_selec.dataProvider == null)
	{
		var arreglo:ArrayCollection = new ArrayCollection;
		arreglo.addItem(o_dos_campos);
		dg_cursos_selec.dataProvider = arreglo;
	}
	else
	{
		dg_cursos_selec.dataProvider.addItem(o_dos_campos);	
	}
	dg_cursos.dataProvider.removeItemAt(dg_cursos.selectedIndex);
	///edita_datagrid()
}

/****************************************************************************************/

private function dg_cursos_selec_cellPress():void
{
	var o_dos_campos:obj_dos_campos = new obj_dos_campos;
	o_dos_campos.data = dg_cursos_selec.selectedItem.data;
	o_dos_campos.label = dg_cursos_selec.selectedItem.label;
	
	dg_cursos.dataProvider.addItem(o_dos_campos);
	dg_cursos_selec.dataProvider.removeItemAt(dg_cursos_selec.selectedIndex);
	
//	ro.ro_fuc_muestra_toma_cursos(parentApplication.txt_matricula.text);

}

/****************************************************************************************/

private function edita_datagrid():void
{
	var arreglo99:Array;
	var i:int;
	var j:int;
	for(i=0;i<dg_cursos.dataProvider.length;i++) 
	{
		for(j=0;j<dg_cursos_selec.dataProvider.length;j++)
		{
			if(dg_cursos.dataProvider.getItemAt(i).data == dg_cursos_selec.dataProvider.getItemAt(j).data)
			{
				dg_cursos.dataProvider.removeItemAt(i)
			}
		}
	}
}
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
