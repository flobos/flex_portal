import libreria.*;

import mx.controls.Alert;
import mx.managers.*;
import mx.rpc.events.*;

//***********************************************************************************************************
private function inicio():void
{	
//	mx.controls.Alert.show(Application.application.parameters.par_mat_idn);
	ro.muestra_fuc_web(this.parentApplication.mat_idn);
}
//***********************************************************************************************************
private function result_muestra_fuc_web(event:ResultEvent):void 
{
	dg_fuc.dataProvider = event.result;	
}

//***********************************************************************************************************
private function change_dg_fuc(event:Event):void
{
	lbl_num_fuc.text = String(dg_fuc.selectedItem.campo_uno);
	var popup98:frm_fuc_muestra_motivos = frm_fuc_muestra_motivos(PopUpManager.createPopUp( this, frm_fuc_muestra_motivos , true));
	popup98.num_fuc  = this.lbl_num_fuc.text;
	popup98.num_motivo  = this.lbl_num_motivo.text;
	mx.managers.PopUpManager.centerPopUp(popup98);
//	var popup98 = mx.managers.PopUpManager.createPopUp(this, frm_fuc_muestra_motivos, true);
}
//***********************************************************************************************************
private function nuevo_fuc():void
{
	//var popup99 = mx.managers.PopUpManager.createPopUp(this, frm_fuc_ingreso, true);
}
//***********************************************************************************************************
private function formatea_fecha(date:Date):String {
return dfconv.format(date);
}
private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
