// ActionScript file
// ActionScript file
import libreria.*;

import mx.controls.Alert;
import mx.events.*;
import mx.rpc.events.*;
import flash.net.FileReference;

private var par_func_mod_fun_idn:String;
public var func_mod_fun_idn:String;

//***********************************************************************************************************
private function inicio():void
{
//	mx.controls.Alert.show("hola");
}

//***********************************************************************************************************
private function key_pressed_ape():void
{
	ro_busca_datos_alumnos.busca_alumno_por_apellido(lbl_bus_apellido.text);
}

//***********************************************************************************************************
private function matriculas_click( e:ListEvent ):void {
//	mx.controls.Alert.show(this.dg_cursos.selectedItem.campo_dos);
	ro_busca_datos_alumnos.buscar_institucion(this.dg_matriculas.selectedItem.data);
	ro_busca_datos_alumnos.buscar_cursos(this.dg_matriculas.selectedItem.data);
	ro_busca_datos_alumnos.buscar_pago(this.dg_matriculas.selectedItem.data);
}

//***********************************************************************************************************
private function result_buscar_cursos(event:ResultEvent):void
{
	this.dg_cursos.dataProvider= event.result;
	limpiar_pruebas();
}
//***********************************************************************************************************
private function result_buscar_curso_por_toma(event:ResultEvent):void
{
	this.dg_cursos.dataProvider= event.result;
	this.dg_cursos.selectedIndex = 0;
	ro_busca_datos_alumnos.buscar_pruebas(event.result[0].campo_dos);
	
}
//***********************************************************************************************************
private function result_buscar_pruebas(event:ResultEvent):void
{
	this.dg_pruebas.dataProvider = event.result;
	this.lbl_promedio_final.text = event.result[0].campo_ocho;
}
private function result_buscar_respuestas(event:ResultEvent):void
{
	this.dg_respuestas.dataProvider = event.result;
}

//***********************************************************************************************************
private function result_busca_alumno_por_apellido(event:ResultEvent):void
{
	this.dg_alumnos.dataProvider= event.result;
}

//***********************************************************************************************************
private function result_busca_alumno_por_matricula(event:ResultEvent):void
{
	this.dg_alumnos.dataProvider= event.result;
	ro_busca_datos_alumnos.busca_ficha_personal(event.result[0].campo_uno);
	
}
//***********************************************************************************************************
private function result_buscar_matriculas(event:ResultEvent):void
{
	this.dg_matriculas.dataProvider = event.result;
	ro_busca_datos_alumnos.busca_ficha_personal(event.result[0].campo_uno);
	ro_busca_datos_alumnos.buscar_pago(event.result[0].campo_uno);
	limpiar_cursos();
}
//***********************************************************************************************************
private function result_buscar_matricula_por_toma(event:ResultEvent):void
{
	this.dg_matriculas.dataProvider = event.result;
	ro_busca_datos_alumnos.busca_alumno_por_matricula(event.result[0].data);
	ro_busca_datos_alumnos.buscar_pago(event.result[0].data);
}
//***********************************************************************************************************
private function result_buscar_curso_por_trabajo(event:ResultEvent):void
{
	this.dg_cursos.dataProvider = event.result;
	ro_busca_datos_alumnos.buscar_matricula_por_toma(event.result[0].campo_dos);
}

//***********************************************************************************************************
private function result_buscar_trabajo(event:ResultEvent):void
{
	this.dg_pruebas.dataProvider = event.result;
	this.dg_pruebas.selectedIndex = 0;
	ro_busca_datos_alumnos.buscar_curso_por_trabajo(event.result[0].campo_tres);
}

//***********************************************************************************************************
private function result_buscar_cuotas_pago(event:ResultEvent):void
{
	this.dg_cuotas.dataProvider = event.result;
}
//***********************************************************************************************************
private function result_buscar_info_matricula(event:ResultEvent):void
{
	this.dg_matriculas.dataProvider = event.result;
	this.dg_matriculas.selectedIndex = 0;
//	this.cmb_matriculas.dataProvider = event.result;
//	mx.controls.Alert.show(this.dg_alumnos.selectedItem.campo_uno);
}
//***********************************************************************************************************
private function result_busca_ficha_personal(event:ResultEvent):void
{
	this.lbl_alu_rut.text = event.result[0].campo_uno;
	this.lbl_alu_nombre.text = event.result[0].campo_dos;
	this.lbl_alu_direccion.text = event.result[0].campo_tres;
	this.lbl_alu_fono.text = event.result[0].campo_cuatro;
	this.lbl_alu_fecha_ingreso.text = event.result[0].campo_cinco;
	this.lbl_alu_clave_internet.text = event.result[0].campo_seis;
	this.lbl_alu_email.text = event.result[0].campo_siete;
	this.lbl_alu_ciudad_region.text = event.result[0].campo_ocho;
	this.lbl_alu_pais.text = event.result[0].campo_nueve;

}
//***********************************************************************************************************
private function result_buscar_pago(event:ResultEvent):void
{
	this.lbl_dat_pag_idn.text = event.result[0].campo_uno;
	this.lbl_valor_arancel.text = event.result[0].campo_dos;
	this.lbl_descuento.text = event.result[0].campo_tres;
	this.lbl_num_cuotas.text = event.result[0].campo_cuatro;
	this.lbl_medio_pago.text = event.result[0].campo_cinco;
	this.lbl_lugar_pago.text = event.result[0].campo_seis;
	this.lbl_tipo_pago.text = event.result[0].campo_siete;
	this.lbl_env_doc.text = event.result[0].campo_ocho;
	this.lbl_forma_pago.text = event.result[0].campo_nueve;
	this.lbl_concepto_pago.text = event.result[0].campo_diez;
	this.lbl_elemento_pago.text = event.result[0].campo_once;
	ro_busca_datos_alumnos.buscar_cuotas_pago(event.result[0].campo_uno);
}
//***********************************************************************************************************
private function result_buscar_institucion(event:ResultEvent):void
{	
	this.lbl_inst_educacion.text = event.result[0].campo_uno;
	this.lbl_facultad.text = event.result[0].campo_dos;
	this.lbl_escuela.text = event.result[0].campo_tres;
	this.lbl_depto_educacional.text = event.result[0].campo_cuatro;
}
//***********************************************************************************************************
private function alumnos_click( e:ListEvent ):void {
//	mx.controls.Alert.show(this.dg_alumnos.selectedItem.campo_uno);
	limpiar_pago();
	ro_busca_datos_alumnos.buscar_matriculas(this.dg_alumnos.selectedItem.campo_uno);
	ro_busca_datos_alumnos.busca_ficha_personal(this.dg_alumnos.selectedItem.campo_uno);

}


//***********************************************************************************************************
private function btn_descargar_prueba_click():void {
//	mx.controls.Alert.show(this.dg_cursos.selectedItem.campo_dos);
	if (this.dg_pruebas.selectedIndex < 0) {
		mx.controls.Alert.show("Debe seleccionar una prueba para recalcular la nota","Ayuda");
	}
	else
	{
		if(this.dg_pruebas.selectedItem.campo_seis == 'Selección múltiple en tiempo real' && this.dg_respuestas.dataProvider!= null){
			ro_busca_datos_alumnos.recalcular_nota(this.dg_pruebas.selectedItem.campo_tres);
		}
		else{
			mx.controls.Alert.show("Debe seleccionar una prueba objetiva con respuestas asociadas","Ayuda");
		}
	}
}
//***********************************************************************************************************
private function btn_buscar_trabajo_click():void {
//	mx.controls.Alert.show(this.dg_cursos.selectedItem.campo_dos);
	if (this.lbl_bus_trabajo.text == "") {
		mx.controls.Alert.show("Debe ingresar un trabajo para efectuar la búsqueda","Ayuda");
	}
	else
	{
		ro_busca_datos_alumnos.buscar_trabajo(this.lbl_bus_trabajo.text);
		
		limpiar_matriculas();
		limpiar_cursos();
		limpiar_ficha();
	}
}



//***********************************************************************************************************
private function btn_buscar_matricula_click():void {
//	mx.controls.Alert.show(this.dg_cursos.selectedItem.campo_dos);
	if (this.lbl_bus_matricula.text == "") {
		mx.controls.Alert.show("Debe ingresar una matricula para efectuar la búsqueda","Ayuda");
	}
	else
	{
		ro_busca_datos_alumnos.busca_alumno_por_matricula(this.lbl_bus_matricula.text);
		ro_busca_datos_alumnos.buscar_info_matricula(this.lbl_bus_matricula.text);
		ro_busca_datos_alumnos.buscar_pago(this.lbl_bus_matricula.text);
		limpiar_cursos();
		limpiar_ficha();
	}
}
//***********************************************************************************************************
private function btn_buscar_toma_curso_click():void {
//	mx.controls.Alert.show(this.dg_cursos.selectedItem.campo_dos);
	if (this.lbl_bus_toma_curso.text == "") {
		mx.controls.Alert.show("Debe ingresar una toma de curso para efectuar la búsqueda","Ayuda");
	}
	else
	{
		ro_busca_datos_alumnos.buscar_curso_por_toma(this.lbl_bus_toma_curso.text);
		ro_busca_datos_alumnos.buscar_matricula_por_toma(this.lbl_bus_toma_curso.text);
	}
}


//***********************************************************************************************************
private function cursos_click( e:ListEvent ):void {
//	mx.controls.Alert.show(this.dg_cursos.selectedItem.campo_dos);
	limpiar_pruebas();
	ro_busca_datos_alumnos.buscar_pruebas(this.dg_cursos.selectedItem.campo_dos);
	
}
//***********************************************************************************************************
private function trabajos_click( e:ListEvent ):void {
//	mx.controls.Alert.show(this.dg_cursos.selectedItem.campo_dos);
	this.dg_respuestas.dataProvider = undefined;
	ro_busca_datos_alumnos.buscar_respuestas(this.dg_pruebas.selectedItem.campo_tres);
	
}
//***********************************************************************************************************
private function btn_eliminar_trabajo_click(eventObj:CloseEvent):void {
	if (this.dg_pruebas.selectedIndex  >= 0){
		if (eventObj.detail==Alert.OK) {
			ro_busca_datos_alumnos.eliminar_trabajo(this.dg_pruebas.selectedItem.campo_tres);
            mx.controls.Alert.show("Trabajo "+this.dg_pruebas.selectedItem.campo_tres+ " Eliminado", "Alerta");
   		}
 	}
	else {
		mx.controls.Alert.show("Debe seleccionar un trabajo para ser eliminado", "Alerta");
	}
	
}

//***********************************************************************************************************
private function limpiar_matriculas( ):void {
//	mx.controls.Alert.show(this.dg_cursos.selectedItem.campo_dos);
	limpiar_cursos();
	this.dg_matriculas.dataProvider = undefined;
	this.lbl_inst_educacion.text = "";
	this.lbl_escuela.text = "";
	this.lbl_facultad.text = "";
	this.lbl_depto_educacional.text = "";
}
//***********************************************************************************************************
private function limpiar_pago():void {
	this.lbl_dat_pag_idn.text = "";
	this.lbl_valor_arancel.text = "";
	this.lbl_descuento.text = "";
	this.lbl_num_cuotas.text = "";
	this.lbl_medio_pago.text = "";
	this.lbl_lugar_pago.text = "";
	this.lbl_tipo_pago.text = "";
	this.lbl_env_doc.text = "";
	this.lbl_forma_pago.text = "";
	this.lbl_concepto_pago.text = "";
	this.lbl_elemento_pago.text = "";
	this.dg_cuotas.dataProvider = undefined;
}
//***********************************************************************************************************
private function limpiar_cursos( ):void {
//	mx.controls.Alert.show(this.dg_cursos.selectedItem.campo_dos);
	limpiar_pruebas();
	this.dg_cursos.dataProvider = undefined;
}
//***********************************************************************************************************
private function limpiar_pruebas( ):void {
//	mx.controls.Alert.show(this.dg_cursos.selectedItem.campo_dos);
	this.dg_pruebas.dataProvider = undefined;
	this.lbl_promedio_final.text = "";
	this.dg_respuestas.dataProvider = undefined;
}

private function limpiar_ficha( ):void {
	this.lbl_alu_rut.text = "";
	this.lbl_alu_nombre.text = "";
	this.lbl_alu_direccion.text = "";
	this.lbl_alu_fono.text = "";
	this.lbl_alu_fecha_ingreso.text = "";
	this.lbl_alu_clave_internet.text = "";
	this.lbl_alu_email.text = "";
	this.lbl_alu_ciudad_region.text = "";
	this.lbl_alu_pais.text = "";
}


//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}
