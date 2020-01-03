private var sed_idn:String
private var fun_rut:String


private function tw_recaudacion_creationComplete():void
{
	tw_recaudacion.enabled = true
//ro_recaudacion.muestra_tipo_plazo()
}





private function btn_informe_click():void{

//if (cmb_plazo.selectedItem.data == '0' || df_fecha.text.length == 0){
if (txt_eje_aca.text.length == 0){

	mx.controls.Alert.show("Debe ingresar código ejecución académica para el informe .....", "ERROR");
	}else{
		
	//getURL("javascript: void(window.open('http://192.168.1.10/reportes_flex_net/frm_funcionarios_marcaje_incompleto.aspx?fecha_inicio=" + String(df_fecha_inicial.text) +  "&fecha_final="  + String(df_fecha_final.text) + "','Boleta','scrollbars=no,menubar=yes,height=650,width=700,resizable=yes,toolbar=no,location=no,status=no'))");
	var request:URLRequest = new URLRequest("http://192.168.1.10/reportes_flex_net/frm_reporte_acta_rendimiento_academico.aspx?eje_aca_idn=" + String(txt_eje_aca.text ));
    navigateToURL(request, "_self");

//	getURL("javascript: void(window.open('http://192.168.1.10/reportes_flex_net/frm_reporte_resumen_cuadratura_cajas_sedes.aspx?fecha=" + String(df_fecha.text)         +  "&plazo="        + cmb_plazo.selectedItem.data + "','Boleta'
		
	}
}


//function muestra_tipo_plazo_return(event){
//cmb_plazo.dataProvider = event.result
//tw_recaudacion.enabled = true
//}

private function formatea_fecha(date:Date):String{

   //return date.getUTCDate() + "/" + ( date.getUTCMonth() + 1 ) + "/" + date.getUTCFullYear();
	return (date.getDate()) + "-" + ( date.getMonth() + 1 ) + "-" + date.getUTCFullYear();
	 
 } 