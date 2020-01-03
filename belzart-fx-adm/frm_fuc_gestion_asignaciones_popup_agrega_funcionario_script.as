// ActionScript file
import libreria.*;

import mx.controls.Alert;
import mx.events.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;

private var func_mod_fun_idn:String;
private var mod_cam_idn:String;
public var indice_motivo:int;

//*******************************************************************************************************
private function inicio():void
{
	func_mod_fun_idn = this.parentApplication.func_mod_fun_idn;
	ro_fuc_gestion_asignaciones.buscar_funciones();
	ro_ingreso_conferencia.buscar_modalidad_campus(func_mod_fun_idn);
}
//*******************************************************************************************************
private function cmb_funcion_change():void
{
	if (this.cmb_funcion.selectedIndex > 0)
	{
		if (this.lbl_apellido_paterno.text != "")
		{
			ro_ingreso_conferencia.busca_funcionarios_por_apellido_funcion(this.lbl_apellido_paterno.text, mod_cam_idn, this.cmb_funcion.selectedItem.data);
		}
		else
		{
			if(this.lbl_funcionario.text != "")
			{
				ro_ingreso_conferencia.busca_funcionarios_funcion(this.lbl_funcionario.text, mod_cam_idn, this.cmb_funcion.selectedItem.data);
			}
		}	
	}
	else
	{
		if (this.lbl_apellido_paterno.text != "")
		{
			ro_ingreso_conferencia.busca_funcionarios_por_apellido(this.lbl_apellido_paterno.text, mod_cam_idn);
		}
		else
		{
			if(this.lbl_funcionario.text != "")
			{
				ro_ingreso_conferencia.busca_funcionarios(this.lbl_funcionario.text, mod_cam_idn);
			}
		}
		
	}
	
}

//*******************************************************************************************************
private function result_buscar_funciones(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No se encontraron funciones","ERROR");
		btn_cancelar_click();
	}
	else
	{
		this.cmb_funcion.dataProvider = event.result;
	}
}

//*******************************************************************************************************
private function result_buscar_modalidad_campus(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No se encontró la modalidad del campus","ERROR");
		btn_cancelar_click();
	}
	else
	{
		mod_cam_idn = event.result[0].campo_uno;
	}
}
//*******************************************************************************************************
private function lbl_apellido_change():void{
	if (this.lbl_apellido_paterno.text != ""){
		if (this.cmb_funcion.selectedIndex > 0 )
		{
			ro_ingreso_conferencia.busca_funcionarios_por_apellido_funcion(this.lbl_apellido_paterno.text, mod_cam_idn, this.cmb_funcion.selectedItem.data);
		}
		else
		{
			ro_ingreso_conferencia.busca_funcionarios_por_apellido(this.lbl_apellido_paterno.text, mod_cam_idn);
		}
	}
	else
	{
		this.dg_funcionarios.dataProvider = null;
	}
}

private function chk_click():void
{
	if (this.chk_asociar_todos.selected == true)
	{
		this.chk_asociar_seleccionados.selected = false;
	}
}

private function chk_selec_click():void
{
	if (this.chk_asociar_seleccionados.selected == true)
	{
		this.chk_asociar_todos.selected = false;
	}
}

//*******************************************************************************************************
private function btn_seleccionar_click():void{
	var i:int = 0;
	if (this.dg_funcionarios.selectedItem != null)
	{
		if (this.chk_asociar_todos.selected == false && this.chk_asociar_seleccionados.selected == false)
		{
			this.parentApplication.rp_motivos.dataProvider[indice_motivo].campo_cuatro = this.dg_funcionarios.selectedItem.campo_uno;
			this.parentApplication.rp_motivos.dataProvider[indice_motivo].campo_cinco = this.dg_funcionarios.selectedItem.campo_tres;
			this.parentApplication.arreglo_modificaciones.push(indice_motivo);
		}
		else
		{
			if (chk_asociar_seleccionados.selected == true)
			{
				this.parentApplication.arreglo_modificaciones = new Array;
				for (i = 0; i < this.parentApplication.rp_motivos.dataProvider.length; i++)
				{
					if (this.parentApplication.chk_motivos_selected[i].selected == true)
					{
					this.parentApplication.rp_motivos.dataProvider[i].campo_cuatro = this.dg_funcionarios.selectedItem.campo_uno;
					this.parentApplication.rp_motivos.dataProvider[i].campo_cinco = this.dg_funcionarios.selectedItem.campo_tres;
					
					this.parentApplication.arreglo_modificaciones.push(i);
					}
				}
			}
			else
			{
				this.parentApplication.arreglo_modificaciones = new Array;
				for (i = 0; i < this.parentApplication.rp_motivos.dataProvider.length; i++)
				{
					this.parentApplication.rp_motivos.dataProvider[i].campo_cuatro = this.dg_funcionarios.selectedItem.campo_uno;
					this.parentApplication.rp_motivos.dataProvider[i].campo_cinco = this.dg_funcionarios.selectedItem.campo_tres;
					
					this.parentApplication.arreglo_modificaciones.push(i);
				}
			}
			
		}
		
//		this.parentApplication.modificar_botones(indice_motivo);

		this.parentApplication.rp_motivos.dataProvider.refresh();
		btn_cancelar_click();
	}
	else
	{
		mx.controls.Alert.show("Debe seleccionar un funcionario", "Alerta");
	}
}
//*******************************************************************************************************
private function btn_buscar_click():void{
	if (this.lbl_funcionario.text != ""){
		ro_ingreso_conferencia.busca_funcionarios(this.lbl_funcionario.text, mod_cam_idn);
	}
	else
	{
		this.dg_funcionarios.dataProvider = null;
	}
}
//***********************************************************************************************************
private function result_busca_funcionarios(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		this.dg_funcionarios.dataProvider = null;
		mx.controls.Alert.show("No se han encontrado funcionarios con el parámetro indicado","Alerta");
	}
	else
	{
		this.dg_funcionarios.dataProvider = event.result;
	}
}

//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}

//*******************************************************************************************************
private function btn_cancelar_click():void
{
	PopUpManager.removePopUp(this);	
}
