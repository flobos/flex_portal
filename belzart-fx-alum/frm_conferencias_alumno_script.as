
import mx.controls.Alert;
import mx.managers.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
// ActionScript Document

public var tc_idn:String;
public var conf_idn:String;
private var hay_conferencias:String;
public var url_frame:URLRequest;


//***********************************************************************************************************

private function inicio():void{
	
	
//	this.dg_conferencias.dataProvider = null;
//	this.dg_conferencias_dia.dataProvider = null;
//	this.dg_conferencias_fin.dataProvider = null;
	hay_conferencias = "no";
	tc_idn = this.parentApplication.tc_idn;
//	tc_idn = '791352'
	ds.fill(conferencias_dia,"by_tc_dia",tc_idn);
	ds.fill(conferencias,"by_tc_nd",tc_idn);
	ds.fill(conferencias_dif,"by_tc_dif",tc_idn);
//	mx.controls.Alert.show(tc_idn);
//	this.ro_conferencias.muestra_conferencias_dia(tc_idn);
}

//***********************************************************************************************************
private function iniciar_conferencia():void
{
	if (this.dg_conferencias_dia.selectedItem != null)
	{
		this.parentApplication.conf_idn = this.dg_conferencias_dia.selectedItem.campo_uno;
		var popup:frm_video_conferencia_alumno = frm_video_conferencia_alumno(PopUpManager.createPopUp( this, frm_video_conferencia_alumno , true));
		popup.sala = this.dg_conferencias_dia.selectedItem.campo_uno;
		popup.usuario = this.parentApplication.lbl_nombre.text + "_" + tc_idn;
		this.parentApplication.levantar_popup(popup);
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar una conferencia disponible","Alerta");
	}
}

//***********************************************************************************************************
private function ver_conferencia():void
{
	if (this.dg_conferencias_fin.selectedItem != null)
	{
		var popup:frm_video_conferencia_alumno = frm_video_conferencia_alumno(PopUpManager.createPopUp( this, frm_video_conferencia_alumno , true));
		popup.sala = this.dg_conferencias_fin.selectedItem.campo_uno;
		popup.usuario = this.parentApplication.lbl_nombre.text + "_" + tc_idn;
		this.parentApplication.levantar_popup(popup);
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar una conferencia ya finalizada","Alerta");
	}
}

//***********************************************************************************************************
private function result_muestra_conferencias_dia(event:ResultEvent):void
{
	if (event.result.length >0 )
	{
		this.dg_conferencias_dia.dataProvider = event.result;
		hay_conferencias = "si";
	}
	this.ro_conferencias.muestra_conferencias(tc_idn);

}


//***********************************************************************************************************
private function result_muestra_conferencias(event:ResultEvent):void
{
	if (event.result.length >0 )
	{
		this.dg_conferencias.dataProvider = event.result;
		hay_conferencias = "si";
	}
	this.ro_conferencias.muestra_conferencias_fin(tc_idn);
}
//***********************************************************************************************************
private function result_muestra_conferencias_fin(event:ResultEvent):void
{
	if (event.result.length >0 )
	{
		this.dg_conferencias_fin.dataProvider = event.result;
	}
	else
	{
		if (hay_conferencias == "no")
		{
			mx.controls.Alert.show("No se encontraron conferencias asociadas","Alerta");
		}
	}
	
}

//***********************************************************************************************************

private function error_fx(event:FaultEvent):void
{
mx.controls.Alert.show(event.fault.faultString,"Error");
}
