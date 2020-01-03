import flash.events.Event;

import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;


public var num_fuc:String;
public var num_motivo:String;

private var estado:String;
//***********************************************************************************************************	
private function ltrim(matter:String):String
{
	var i:Number;
	
    if ((matter.length>1) || (matter.length == 1 && matter.charCodeAt(0)>32 && matter.charCodeAt(0)<255)) 
	{
        i = 0;
        while (i<matter.length && (matter.charCodeAt(i)<=32 || matter.charCodeAt(i)>=255)) 
		{
            i++;
        }
        matter = matter.substring(i);
    } 
	else 
	{
        matter = "";
    }
	
    return matter;
}
//***********************************************************************************************************
private function rtrim(matter:String):String
{
	var i:Number;
	
    if ((matter.length>1) || (matter.length == 1 && matter.charCodeAt(0)>32 && matter.charCodeAt(0)<255)) 
	{
       i = matter.length-1;
       while (i>=0 && (matter.charCodeAt(i)<=32 || matter.charCodeAt(i)>=255)) 
	   {
            i--;
       }
        matter = matter.substring(0, i+1);
    } 
	else 
	{
        matter = "";
    }
	
    return matter;
}
//***********************************************************************************************************
private function trim(matter:String):String {
    return ltrim(rtrim(matter));
} 
/****************************************************************************************/
private function result_muestra_motivos_fuc(event:ResultEvent):void
{
	dg_motivos.dataProvider = event.result;	
}
/****************************************************************************************/
private function result_cambia_vista_motivo(event:ResultEvent):void
{
	inicio()
}
/****************************************************************************************/
private function inicio():void
{
	ro.muestra_motivos_fuc(num_fuc);
}
/****************************************************************************************/
private function cambia_vista_motivo():void
{
	ro.cambia_vista_motivo(num_motivo);
}
/****************************************************************************************/
private function resolucion_motivo():void
{
	var popup97:frm_fuc_muestra_resolucion_motivo = frm_fuc_muestra_resolucion_motivo(PopUpManager.createPopUp( this, frm_fuc_muestra_resolucion_motivo , true));
	popup97.num_fuc  = this.num_fuc;
	popup97.num_motivo  = this.num_motivo;
	mx.managers.PopUpManager.centerPopUp(popup97);
	
//	var popup97 = mx.managers.PopUpManager.createPopUp(this, frm_fuc_muestra_resolucion_motivo, true);	
}
/****************************************************************************************/
private function getCellData():void
{
	this.num_motivo = ""
	
	estado = String(dg_motivos.selectedItem.campo_tres);
	
	if(trim(estado) != 'Resuelto')
	{
		mx.controls.Alert.show('No es posible ver la resolución del Motivo específico, ya que este no se encuentra resuelto');
	}
	else
	{
		this.num_motivo = String(dg_motivos.selectedItem.campo_uno);
		
		if(String(dg_motivos.selectedItem.campo_cinco) == 'No')
		{
			cambia_vista_motivo()
		}
		
		resolucion_motivo()
	}
}
/****************************************************************************************/
private function btn_cerrar_click():void
{
	PopUpManager.removePopUp(this)
}
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
