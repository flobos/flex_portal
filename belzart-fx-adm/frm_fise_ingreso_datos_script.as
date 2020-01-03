import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.*;
import mx.rpc.events.*;
private var posicion:Number= new Number;
public var arreglo:ArrayCollection = new ArrayCollection;
public var arreglobien:ArrayCollection = new ArrayCollection;
public var arreglofamiliar:ArrayCollection = new ArrayCollection;
public	var valido:Boolean
//***********************************************************************************************************
private function inicio():void
{
vbx_todo.height=flash.system.Capabilities.screenResolutionY-200;
		
limpia();
}

private function result_llena_combo_becas(event:ResultEvent):void
{	this.cmb_becas.dataProvider = event.result;
}
private function result_llena_combo_tipo_propiedad(event:ResultEvent):void
{   this.cmb_tipo_propiedad.dataProvider = event.result  
	ro_buscar.llena_combo_tipo_construccion();
}
private function result_llena_combo_tipo_construccion(event:ResultEvent):void
{	this.cmb_tipo_construccion.dataProvider = event.result  
	ro_buscar.llena_combo_tenencia_propiedad();
}
private function result_llena_combo_tenencia_propiedad(event:ResultEvent):void
{	this.cmb_tenencia_propiedad.dataProvider = event.result 
	ro_buscar.llena_combo_estado_conservacion();
}
private function result_llena_combo_estado_conservacion(event:ResultEvent):void
{	this.cmb_estado_conservacion.dataProvider = event.result  
	ro_buscar.llena_combo_uso();	
}
private function result_llena_combo_uso(event:ResultEvent):void
{	this.cmb_uso.dataProvider = event.result  
	ro_buscar.llena_combo_servicios_basicos();
}
private function result_llena_combo_servicios_basicos(event:ResultEvent):void
{	this.cmb_servicios_basicos.dataProvider = event.result  
}


private function result_llena_combo_estado_civil(event:ResultEvent):void
{   this.cmb_estado_civil.dataProvider = event.result  
	ro_buscar.llena_combo_sexo();
}
private function result_llena_combo_sexo(event:ResultEvent):void
{   this.cmb_sexo.dataProvider = event.result  
	ro_buscar.llena_combo_parentesco();
}
private function result_llena_combo_parentesco(event:ResultEvent):void
{   this.cmb_parentesco.dataProvider = event.result  
	ro_buscar.llena_combo_nivel_estudios();
}
private function result_llena_combo_nivel_estudios(event:ResultEvent):void
{   this.cmb_nivel_estudios.dataProvider = event.result  
	ro_buscar.llena_combo_prevision_social();
}
private function result_llena_combo_prevision_social(event:ResultEvent):void
{   this.cmb_prevision_social.dataProvider = event.result  
	ro_buscar.llena_combo_prevision_salud();
}
private function result_llena_combo_prevision_salud(event:ResultEvent):void
{   this.cmb_prevision_salud.dataProvider = event.result ;
    ro_buscar.llena_combo_actividad(); 
}
private function result_llena_combo_actividad(event:ResultEvent):void
{   this.cmb_actividad.dataProvider = event.result  
    ro_buscar.llena_combo_enfermedad_grave();
}
private function result_llena_combo_enfermedad_grave(event:ResultEvent):void
{   this.cmb_enfermedad_grave.dataProvider = event.result  
    ro_buscar.llena_combo_jefe_hogar();
}
private function result_llena_combo_jefe_hogar(event:ResultEvent):void
{   this.cmb_jefe_hogar.dataProvider = event.result  
    ro_buscar.llena_combo_tipo_familia();
}
private function result_llena_combo_tipo_familia(event:ResultEvent):void
{   this.cmb_tipo_familia.dataProvider = event.result  
    cmb_tipo_familia.selectedIndex = posicion ;
}

//***********************************************************************************************************
private function lbl_rut_click():void
{  
   limpia();
}
//***********************************************************************************************************
private function btn_buscar_click():void 
{
    this.btn_buscar.visible=false;

		if (formatea_rut(this.lbl_rut.text)== ""){
			mx.controls.Alert.show("Debe ingresar un rut valido para efectuar la búsqueda","Ayuda");
			limpia();
			}
		else
		{
		this.lbl_rut.text=formatea_rut(this.lbl_rut.text)
        valida_rut(this.lbl_rut.text);
                if (valido==true){
	                ro_buscar.buscar_por_rut(String(lbl_rut.text));
	                
	                }
                else{
	                mx.controls.Alert.show("rut invalido","");
		            lbl_rut.text="";
	            }
        }
}


//***********************************************************************************************************
private function formatea_rut(rut:String):String 
{
var rut_temporal:String;
var rut_temporal_creado:String;
var ceros:String;

	if (rut == "" || rut.length<8) {
		rut_temporal_creado="";
	}
	else
	{
			var largo_rut:Number= new Number;
			largo_rut= rut.length;
			rut_temporal=rut;
			ceros="000000000000";
			
			if (largo_rut<9)
			   rut_temporal= ceros.substr(0,(9-largo_rut))+rut_temporal;
				   
				rut_temporal_creado= rut_temporal.substr(0,2) + "." + rut_temporal.substr(2,3) + "." + rut_temporal.substr(5,3)  + "-" + rut_temporal.substr(8,1)
	}
return rut_temporal_creado;
}

//***********************************************************************************************************
private function result_buscar(event:ResultEvent):void
{
	    posicion=0;
		if (event.result.length >=1 ){
			this.lbl_nombre.visible=true;
			lbl_nombre.text= event.result[0].label;
			
			ro_buscar.trae_datos_bienes(String(lbl_rut.text));
			
		    activar();

		}
		else
		{
			mx.controls.Alert.show("No existen datos","");
		}
}

//***********************************************************************************************************
private function result_trae_datos_bienes(event:ResultEvent):void
{

	var x:int;

   if (event.result.length ==0 ) 
	{  // Alert.show('No se encontraron dats de bienes para el rut ingresado','Belzart FX') 
	}
   else
	{
		for( x = 0; x < event.result.length ; x++ )
		{
			var o_dieciseis_campos:obj_dieciseis_campos = new obj_dieciseis_campos;
			o_dieciseis_campos.campo_uno = event.result[x].campo_uno
			o_dieciseis_campos.campo_dos = event.result[x].campo_dos
			o_dieciseis_campos.campo_tres = event.result[x].campo_tres
			o_dieciseis_campos.campo_cuatro = event.result[x].campo_cuatro
			o_dieciseis_campos.campo_cinco = event.result[x].campo_cinco
			o_dieciseis_campos.campo_seis = event.result[x].campo_seis
			o_dieciseis_campos.campo_siete = event.result[x].campo_siete
			o_dieciseis_campos.campo_ocho = event.result[x].campo_ocho
			o_dieciseis_campos.campo_nueve = event.result[x].campo_nueve
			o_dieciseis_campos.campo_diez = event.result[x].campo_diez
			o_dieciseis_campos.campo_once = event.result[x].campo_once
			o_dieciseis_campos.campo_doce = event.result[x].campo_doce
			o_dieciseis_campos.campo_trece = event.result[x].campo_trece
			o_dieciseis_campos.campo_catorce = event.result[x].campo_catorce
			o_dieciseis_campos.campo_quince = event.result[x].campo_quince
			o_dieciseis_campos.campo_dieciseis = event.result[x].campo_dieciseis

			arreglobien.addItem(o_dieciseis_campos);	
			
		}
		
           rp_bienes.dataProvider=arreglobien;

	
    }
    ro_buscar.trae_datos_ingresos(String(lbl_rut.text));	
}
//******************************************************************************************************

private function formatea_fecha(date:Date):String {
     return dfconv.format(date);
 } 
//***********************************************************************************************************
private function result_trae_datos_ingresos(event:ResultEvent):void
{

	var x:int;

   if (event.result.length ==0 ) 
	{   //	Alert.show('No se encontraron dats de ingresos para el rut ingresado','Belzart FX')
	 }
   else
	{
		for( x = 0; x < event.result.length ; x++ )
		{
			var o_nueve_campos:obj_nueve_campos = new obj_nueve_campos;
			o_nueve_campos.campo_uno = event.result[x].campo_uno
			o_nueve_campos.campo_dos = event.result[x].campo_dos
			o_nueve_campos.campo_tres = event.result[x].campo_tres
			o_nueve_campos.campo_cuatro = event.result[x].campo_cuatro
			o_nueve_campos.campo_cinco = event.result[x].campo_cinco
			o_nueve_campos.campo_seis = event.result[x].campo_seis
			o_nueve_campos.campo_siete = event.result[x].campo_siete
			o_nueve_campos.campo_ocho = event.result[x].campo_ocho
			o_nueve_campos.campo_nueve = event.result[x].campo_nueve
			arreglo.addItem(o_nueve_campos);	
			
		}
        rp_ingresos.dataProvider=arreglo; 

//ro_buscar.trae_datos_egresos(String(lbl_rut.text));	

		
    }
    ro_buscar.trae_datos_familia(String(lbl_rut.text));	
}



//***********************************************************************************************************
private function result_trae_datos_correlativo(event:ResultEvent):void
{

		if (event.result.length >=1 ){
			lbl_correlativo.text= event.result[0].campo_uno;
			
		}
		else
		{
			//mx.controls.Alert.show("No existen datos","");
		}

}

//***********************************************************************************************************
private function result_trae_datos_familia(event:ResultEvent):void
{

	var x:int;

   if (event.result.length ==0 ) 
	{   //Alert.show('No se encontraron dats de bienes para el rut ingresado','Belzart FX') 
	}
   else
	{
		for( x = 0; x < event.result.length ; x++ )
		{
			var o_veintitres_campos:obj_veintitres_campos = new obj_veintitres_campos;
			o_veintitres_campos.campo_uno = event.result[x].campo_uno
			//mx.controls.Alert.show("1;", event.result[x].campo_uno);
			o_veintitres_campos.campo_dos = event.result[x].campo_dos
			//mx.controls.Alert.show("2;", event.result[x].campo_dos);
			o_veintitres_campos.campo_tres = event.result[x].campo_tres
			//mx.controls.Alert.show("3;", event.result[x].campo_tres);
			o_veintitres_campos.campo_cuatro = event.result[x].campo_cuatro
			//mx.controls.Alert.show("4", event.result[x].campo_cuatro);
			o_veintitres_campos.campo_cinco = event.result[x].campo_cinco
			//mx.controls.Alert.show("5;", event.result[x].campo_cinco);
			o_veintitres_campos.campo_seis = event.result[x].campo_seis
			//mx.controls.Alert.show("6;", event.result[x].campo_seis);
			o_veintitres_campos.campo_siete = event.result[x].campo_siete
			//mx.controls.Alert.show("7;", event.result[x].campo_siete);
			o_veintitres_campos.campo_ocho = event.result[x].campo_ocho
			//mx.controls.Alert.show("8;", event.result[x].campo_ocho);
			o_veintitres_campos.campo_nueve = event.result[x].campo_nueve
			//mx.controls.Alert.show("9;", event.result[x].campo_nueve);
			o_veintitres_campos.campo_diez = event.result[x].campo_diez
			//mx.controls.Alert.show("10;", event.result[x].campo_diez);
			o_veintitres_campos.campo_once = event.result[x].campo_once
			//mx.controls.Alert.show("11;", event.result[x].campo_once);
			o_veintitres_campos.campo_doce = event.result[x].campo_doce
			//mx.controls.Alert.show("12;", event.result[x].campo_doce);
			o_veintitres_campos.campo_trece = event.result[x].campo_trece
			//mx.controls.Alert.show("13;", event.result[x].campo_trece);
			o_veintitres_campos.campo_catorce = event.result[x].campo_catorce
			//mx.controls.Alert.show("14;", event.result[x].campo_catorce);
			o_veintitres_campos.campo_quince = event.result[x].campo_quince
			//mx.controls.Alert.show("15;", event.result[x].campo_quince);
			o_veintitres_campos.campo_dieciseis = event.result[x].campo_dieciseis
			//mx.controls.Alert.show("16;", event.result[x].campo_dieciseis);
			o_veintitres_campos.campo_diecisiete = event.result[x].campo_diecisiete
			//mx.controls.Alert.show("17", event.result[x].campo_diecisiete);
			o_veintitres_campos.campo_dieciocho = event.result[x].campo_dieciocho
			//mx.controls.Alert.show("18", event.result[x].campo_dieciocho);
			o_veintitres_campos.campo_diecinueve = event.result[x].campo_diecinueve
			//mx.controls.Alert.show("19", event.result[x].campo_diecinueve);
			o_veintitres_campos.campo_veinte = event.result[x].campo_veinte
			//mx.controls.Alert.show("20;", event.result[x].campo_veinte);
			o_veintitres_campos.campo_veintiuno = event.result[x].campo_veintiuno
			//mx.controls.Alert.show("21", event.result[x].campo_veintiuno);
			o_veintitres_campos.campo_veintidos = event.result[x].campo_veintidos
			//mx.controls.Alert.show("22;", event.result[x].campo_veintidos);
			o_veintitres_campos.campo_veintitres = event.result[x].campo_veintitres
			//mx.controls.Alert.show("23;", event.result[x].campo_veintitres);
		
			arreglofamiliar.addItem(o_veintitres_campos);		
		}
		stp_integrantes_familia.value=x;
		rp_familiar.dataProvider=arreglofamiliar; 
        
    }
    ro_buscar.trae_datos_fise(String(lbl_rut.text));	
}

//***********************************************************************************************************
private function result_trae_datos_fise(event:ResultEvent):void
{
        posicion=0;
		if (event.result.length >=1 ){
			//lbl_egresos_basicos.text= event.result[0].data;
			posicion=event.result[0].campo_uno;
			cmb_tipo_familia.selectedIndex = posicion ;
			
		}
		else
		{
			//mx.controls.Alert.show("No existen datos","");
		}
	ro_buscar.trae_datos_egresos(String(lbl_rut.text));		

}

//***********************************************************************************************************
private function result_trae_datos_egresos(event:ResultEvent):void
{

		if (event.result.length >=1 ){
			lbl_alimentacion.text= event.result[0].campo_uno;
			lbl_vestuario.text= event.result[0].campo_dos;
			lbl_estudios.text= event.result[0].campo_tres;
			lbl_vivienda.text= event.result[0].campo_cuatro;
			lbl_transporte.text	= event.result[0].campo_cinco;
			lbl_medicamentos.text= event.result[0].campo_seis;
			lbl_serv_basicos.text= event.result[0].campo_siete;
		}
		else
		{
			//mx.controls.Alert.show("No existen datos","");
		}
		

}
//***********************************************************************************************************
private function valida_rut_ingreso():Boolean 
{
		if (formatea_rut(this.txt_rut_ingreso.text)== ""){
            this.txt_rut_ingreso.text="";
            valido=false;
            return valido
			}
		else
		{
		this.txt_rut_ingreso.text=formatea_rut(this.txt_rut_ingreso.text)
        valida_rut(this.txt_rut_ingreso.text);
                if (valido==true){
	                valido=true;}
                else{
		            txt_rut_ingreso.text="";
		            valido=false;
	            }
        }
        return valido
}
//***********************************************************************************************************
private function valida_rut_familiar():Boolean 
{
		if (formatea_rut(this.txt_rut_familiar.text)== ""){
            this.txt_rut_familiar.text="";
            valido=false;
            return valido
			}
		else
		{
		this.txt_rut_familiar.text=formatea_rut(this.txt_rut_familiar.text)
        valida_rut(this.txt_rut_familiar.text);
                if (valido==true){
	                valido=true;}
                else{
		            txt_rut_familiar.text="";
		            valido=false;
	            }
        }
        return valido
}
//*******************************************************************************************************
private function btn_agregar_click():void
{
	

	
	var controlarut:int;
	controlarut=0;
	
		var ciclo:int;
		
		if (rp_ingresos.dataProvider != null)
		{
			for(x = 0; x < rp_ingresos.dataProvider.length; x++) 
			{
				
				//mx.controls.Alert.show("lbl_rut_ingreso[x].text",lbl_rut_ingreso[x].text);
				//mx.controls.Alert.show("txt_rut_ingreso.text",formatea_rut(txt_rut_ingreso.text));
				if (lbl_rut_ingreso[x].text == formatea_rut(txt_rut_ingreso.text) )
				{
				    controlarut=1;
				    mx.controls.Alert.show("el rut actual ya esta ingresado","");
				}
			}
		}
	
	
	
	
	
	
	
	
	
	
		if( controlarut==0 && txt_rut_ingreso.text != '0' && txt_rut_ingreso.text != '' )
		{
			
			    if (valida_rut_ingreso())
				{
					var o_nueve_campos:obj_nueve_campos = new obj_nueve_campos;
					o_nueve_campos.campo_uno = String(txt_rut_ingreso.text);
					o_nueve_campos.campo_dos = String(txt_remuneracion_contrato.text);
					o_nueve_campos.campo_tres = String(txt_honorario.text);
					o_nueve_campos.campo_cuatro = String(txt_arriendo_bienes_muebles.text);
					o_nueve_campos.campo_cinco = String(txt_arriendo_bienes_inmuebles.text );
					o_nueve_campos.campo_seis = String(txt_pension.text );
					o_nueve_campos.campo_siete = String(txt_becas.text);				
					o_nueve_campos.campo_ocho = String(cmb_becas.selectedItem.label);
					o_nueve_campos.campo_nueve = String(cmb_becas.selectedItem.data);
	
	
					arreglo.addItem(o_nueve_campos);	
				    rp_ingresos.dataProvider=arreglo;
				    limpiadora_ingresos()
				}
				else{
					mx.controls.Alert.show("Rut invalido", "Ayuda");
				    this.txt_rut_ingreso.text="" ;
				    this.txt_rut_ingreso.setFocus();
				}
			    
		}
		else
		{   mx.controls.Alert.show("Faltan datos necesarios para poder efectuar la operación de 'Agregar Ingreso'", "Ayuda");
		  	//limpiadora_ingresos()
		  	
		  	if (controlarut==0)
		  	{   mx.controls.Alert.show("El rut para ingresos no fue ingresado como familiar", "Ayuda");
		  	}
		}
}

private function limpiadora_ingresos():void
{
	        
			txt_rut_ingreso.text="";
			txt_remuneracion_contrato.text="0";
			txt_honorario.text="0";
			txt_arriendo_bienes_muebles.text="0";
			txt_arriendo_bienes_inmuebles.text="0";
			txt_pension.text="0";
			txt_becas.text="0";
			
			ro_buscar.llena_combo_becas();
}


//*******************************************************************************************************
private function btn_agregar_familiar_click():void
{
	var controla:int;
	controla=0;
	
		var ciclo:int;
		
		if (rp_familiar.dataProvider != null)
		{
			for(x = 0; x < rp_familiar.dataProvider.length; x++) 
			{
				if (lbl_jefe_hogar[x].text=="1" && cmb_jefe_hogar.selectedItem.data=="1" )
				{
				    controla=1;
				    mx.controls.Alert.show("ya ha ingresado a un jefe de hogar","");
				}
				if (lbl_rut_familiar[x].text == formatea_rut(txt_rut_familiar.text) )
				{
				    controla=1;
				    mx.controls.Alert.show("el rut actual ya esta ingresado","");
				}
				
				
				
			}
		}
	

	
	
	
	
		if( (controla==0 ) && txt_fecha_nacimiento_familiar.text!= '' && txt_nombre_familiar.text!= '' && txt_apellido_paterno_familiar.text!= '' && txt_apellido_materno_familiar.text!= '' && txt_rut_familiar.text != '0' && txt_rut_familiar.text != '' && cmb_estado_civil.selectedIndex > 0 && cmb_sexo.selectedIndex > 0 && cmb_parentesco.selectedIndex > 0 && cmb_nivel_estudios.selectedIndex > 0 && cmb_prevision_social.selectedIndex > 0 && cmb_prevision_salud.selectedIndex > 0 && cmb_enfermedad_grave.selectedIndex > 0 && cmb_actividad.selectedIndex > 0 && cmb_jefe_hogar.selectedIndex > 0 )
		{
			    if (valida_rut_familiar())
				{
					var o_veintitres_campos:obj_veintitres_campos = new obj_veintitres_campos;
					
					o_veintitres_campos.campo_uno = String(txt_nombre_familiar.text);
					o_veintitres_campos.campo_dos = String(txt_apellido_paterno_familiar.text);
					o_veintitres_campos.campo_tres = String(txt_apellido_materno_familiar.text);
					o_veintitres_campos.campo_cuatro = String(txt_rut_familiar.text);
					o_veintitres_campos.campo_cinco = String(txt_fecha_nacimiento_familiar.text );
					o_veintitres_campos.campo_seis = String(cmb_estado_civil.selectedItem.label);
					o_veintitres_campos.campo_siete = String(cmb_estado_civil.selectedItem.data);
					o_veintitres_campos.campo_ocho = String(cmb_sexo.selectedItem.label);
					o_veintitres_campos.campo_nueve = String(cmb_sexo.selectedItem.data);
					o_veintitres_campos.campo_diez =String(cmb_parentesco.selectedItem.label);
					o_veintitres_campos.campo_once =	String(cmb_parentesco.selectedItem.data);
                    o_veintitres_campos.campo_doce = String(cmb_nivel_estudios.selectedItem.label);
                    o_veintitres_campos.campo_trece =String(cmb_nivel_estudios.selectedItem.data);
					o_veintitres_campos.campo_catorce = String(cmb_prevision_social.selectedItem.label);
					o_veintitres_campos.campo_quince = String(cmb_prevision_social.selectedItem.data);
					o_veintitres_campos.campo_dieciseis = String(cmb_prevision_salud.selectedItem.label);	
					o_veintitres_campos.campo_diecisiete = String(cmb_prevision_salud.selectedItem.data);
					o_veintitres_campos.campo_dieciocho = String(cmb_actividad.selectedItem.label);	
					o_veintitres_campos.campo_diecinueve = String(cmb_actividad.selectedItem.data);	
					o_veintitres_campos.campo_veinte = String(cmb_enfermedad_grave.selectedItem.label);
					o_veintitres_campos.campo_veintiuno = String(cmb_enfermedad_grave.selectedItem.data);	
					o_veintitres_campos.campo_veintidos = String(cmb_jefe_hogar.selectedItem.label);
					o_veintitres_campos.campo_veintitres = String(cmb_jefe_hogar.selectedItem.data);		
	
					arreglofamiliar.addItem(o_veintitres_campos);	
				    rp_familiar.dataProvider=arreglofamiliar;
				    stp_integrantes_familia.value++;
				    limpiadora_familiar()
				}
				else{
					mx.controls.Alert.show("Rut invalido", "Ayuda");
				    this.txt_rut_familiar.text="" ;
				    this.txt_rut_familiar.setFocus();
				}
		}
		else
		{   mx.controls.Alert.show("Faltan datos necesarios para poder efectuar la operación de 'Agregar Familiar'", "Ayuda");
		  	//limpiadora_familiar()
		}
}

private function limpiadora_familiar():void
{   
			txt_rut_familiar.text="";
			txt_nombre_familiar.text="";
			txt_apellido_paterno_familiar.text="";
			txt_apellido_materno_familiar.text="";
			txt_fecha_nacimiento_familiar.text="";
			
			
			
			ro_buscar.llena_combo_estado_civil();
			
}
//*******************************************************************************************************
private function btn_agregar_bien_click():void
{
		//if(cmb_uso.selectedIndex > 0 && cmb_servicios_basicos.selectedIndex > 0 && cmb_estado_conservacion.selectedIndex > 0 && cmb_tenencia_propiedad.selectedIndex > 0 && cmb_tipo_propiedad.selectedIndex > 0 && cmb_tipo_construccion.selectedIndex > 0 && txt_metros_construidos.text != '' && txt_superficie.text != '' && txt_avaluo.text != '0' )
		//{
				var o_dieciseis_campos:obj_dieciseis_campos = new obj_dieciseis_campos;
				o_dieciseis_campos.campo_uno = String(cmb_tipo_propiedad.selectedItem.label);
				o_dieciseis_campos.campo_dos = String(cmb_tipo_construccion.selectedItem.label);
				o_dieciseis_campos.campo_tres = String(cmb_tenencia_propiedad.selectedItem.label);
				o_dieciseis_campos.campo_cuatro = String(cmb_estado_conservacion.selectedItem.label);
				o_dieciseis_campos.campo_cinco = String(cmb_servicios_basicos.selectedItem.label);
				o_dieciseis_campos.campo_seis = String(txt_metros_construidos.text );
				o_dieciseis_campos.campo_siete = String(txt_superficie.text);				
				o_dieciseis_campos.campo_ocho = String(cmb_uso.selectedItem.label);
				o_dieciseis_campos.campo_nueve = String(stp_habitaciones.value);
				o_dieciseis_campos.campo_diez = String(txt_avaluo.text);
			
				o_dieciseis_campos.campo_once = String(cmb_tipo_propiedad.selectedItem.data);
				o_dieciseis_campos.campo_doce = String(cmb_tipo_construccion.selectedItem.data);
				o_dieciseis_campos.campo_trece = String(cmb_tenencia_propiedad.selectedItem.data);
				o_dieciseis_campos.campo_catorce = String(cmb_estado_conservacion.selectedItem.data);
				o_dieciseis_campos.campo_quince = String(cmb_servicios_basicos.selectedItem.data);
				o_dieciseis_campos.campo_dieciseis = String(cmb_uso.selectedItem.data);

				
				

				arreglobien.addItem(o_dieciseis_campos);	
			    rp_bienes.dataProvider=arreglobien;
		//}
		//else
		  	//mx.controls.Alert.show("Faltan datos necesarios para poder efectuar la operación de 'Agregar Bien'", "Ayuda");
        
			txt_metros_construidos.text="0";
			txt_superficie.text="0";
			txt_avaluo.text="0";
			ro_buscar.llena_combo_tipo_propiedad();
	
}


private function limpiadora_bienes():void
{    
			txt_rut_ingreso.text="";
			txt_remuneracion_contrato.text="0";
			txt_honorario.text="0";
			txt_arriendo_bienes_muebles.text="0";
			txt_arriendo_bienes_inmuebles.text="0";
			txt_pension.text="0";
			txt_becas.text="0";
			
			ro_buscar.llena_combo_becas();
}



//******************************************************************************************************
private function btn_elimina_selec_click(evento:Event):void
{
	var item:Object=evento.currentTarget.getRepeaterItem();
	var obj:Object = rp_ingresos.dataProvider;
	var i:int;
	var arre_nuevo:ArrayCollection = new ArrayCollection;
	var sw:int = 0;
	
	for(i = 0; i < rp_ingresos.dataProvider.length; i++) 
	{
		if (item.campo_uno!=obj[i].campo_uno)
		{
			var o_nueve_campos:obj_nueve_campos = new obj_nueve_campos;
			o_nueve_campos.campo_uno = obj[i].campo_uno;
			o_nueve_campos.campo_dos = obj[i].campo_dos;
			o_nueve_campos.campo_tres = obj[i].campo_tres;
			o_nueve_campos.campo_cuatro = obj[i].campo_cuatro;
			o_nueve_campos.campo_cinco = obj[i].campo_cinco;
			o_nueve_campos.campo_seis = obj[i].campo_seis;
			o_nueve_campos.campo_siete = obj[i].campo_siete;
			o_nueve_campos.campo_ocho = obj[i].campo_ocho;
			o_nueve_campos.campo_nueve = obj[i].campo_nueve;
	
			arre_nuevo.addItem(o_nueve_campos);	
		}
	}
	arreglo = new ArrayCollection;
	rp_ingresos.dataProvider=undefined;
	rp_ingresos.dataProvider=arre_nuevo;
	arreglo = arre_nuevo;
}

//******************************************************************************************************
private function btn_elimina_bien_click(evento:Event):void
{
	var item:Object=evento.currentTarget.getRepeaterItem();
	var obj:Object = rp_bienes.dataProvider;
	var i:int;
	var arre_nuevo:ArrayCollection = new ArrayCollection;
	var sw:int = 0;
	
	for(i = 0; i < rp_bienes.dataProvider.length; i++) 
	{
		if (item.campo_uno!=obj[i].campo_uno)
		{
			var o_dieciseis_campos:obj_dieciseis_campos = new obj_dieciseis_campos;
			o_dieciseis_campos.campo_uno = obj[i].campo_uno;
			o_dieciseis_campos.campo_dos = obj[i].campo_dos;
			o_dieciseis_campos.campo_tres = obj[i].campo_tres;
			o_dieciseis_campos.campo_cuatro = obj[i].campo_cuatro;
			o_dieciseis_campos.campo_cinco = obj[i].campo_cinco;
			o_dieciseis_campos.campo_seis = obj[i].campo_seis;
			o_dieciseis_campos.campo_siete = obj[i].campo_siete;
			o_dieciseis_campos.campo_ocho = obj[i].campo_ocho;
			o_dieciseis_campos.campo_nueve = obj[i].campo_nueve;
			o_dieciseis_campos.campo_diez = obj[i].campo_diez;
			o_dieciseis_campos.campo_once = obj[i].campo_once;
			o_dieciseis_campos.campo_doce = obj[i].campo_doce;
			o_dieciseis_campos.campo_trece = obj[i].campo_trece;
			o_dieciseis_campos.campo_catorce = obj[i].campo_catorce;
			o_dieciseis_campos.campo_quince = obj[i].campo_quince;
			o_dieciseis_campos.campo_dieciseis = obj[i].campo_dieciseis;
		
			arre_nuevo.addItem(o_dieciseis_campos);	
		}
		
	}
	arreglobien = new ArrayCollection;
	rp_bienes.dataProvider=undefined;
	rp_bienes.dataProvider=arre_nuevo;
	arreglobien = arre_nuevo;
	
}

//******************************************************************************************************
private function btn_elimina_familiar_click(evento:Event):void
{
	var item:Object=evento.currentTarget.getRepeaterItem();
	var obj:Object = rp_familiar.dataProvider;
	var i:int;
	var arre_nuevo:ArrayCollection = new ArrayCollection;
	var sw:int = 0;
	
	for(i = 0; i < rp_familiar.dataProvider.length; i++) 
	{
		if (item.campo_uno!=obj[i].campo_uno)
		{
			var o_veintitres_campos:obj_veintitres_campos = new obj_veintitres_campos;
			o_veintitres_campos.campo_uno = obj[i].campo_uno;
			o_veintitres_campos.campo_dos = obj[i].campo_dos;
			o_veintitres_campos.campo_tres = obj[i].campo_tres;
			o_veintitres_campos.campo_cuatro = obj[i].campo_cuatro;
			o_veintitres_campos.campo_cinco = obj[i].campo_cinco;
			o_veintitres_campos.campo_seis = obj[i].campo_seis;
			o_veintitres_campos.campo_siete = obj[i].campo_siete;
			o_veintitres_campos.campo_ocho = obj[i].campo_ocho;
			o_veintitres_campos.campo_nueve = obj[i].campo_nueve;
			o_veintitres_campos.campo_diez = obj[i].campo_diez;
			o_veintitres_campos.campo_once = obj[i].campo_once;
			o_veintitres_campos.campo_doce = obj[i].campo_doce;
			o_veintitres_campos.campo_trece = obj[i].campo_trece;
			o_veintitres_campos.campo_catorce = obj[i].campo_catorce;
			o_veintitres_campos.campo_quince = obj[i].campo_quince;
			o_veintitres_campos.campo_dieciseis = obj[i].campo_dieciseis;
			o_veintitres_campos.campo_diecisiete = obj[i].campo_diecisiete;
			o_veintitres_campos.campo_dieciocho = obj[i].campo_dieciocho;
			o_veintitres_campos.campo_diecinueve = obj[i].campo_diecinueve;
			o_veintitres_campos.campo_veinte = obj[i].campo_veinte;
			o_veintitres_campos.campo_veintiuno = obj[i].campo_veintiuno;
			o_veintitres_campos.campo_veintidos = obj[i].campo_veintidos;
			o_veintitres_campos.campo_veintitres = obj[i].campo_veintitres;
		
			arre_nuevo.addItem(o_veintitres_campos);	
		}
		
	}
	arreglofamiliar = new ArrayCollection;
	rp_familiar.dataProvider=undefined;
	rp_familiar.dataProvider=arre_nuevo;
	arreglofamiliar = arre_nuevo;

	this.stp_integrantes_familia.value=rp_familiar.dataProvider.length;
	
}

//***********************************************************************************************************
private function limpia():void
{	cmd_guardar.visible=false;
	this.cmd_agrega_ingreso.visible=false;
	this.cmd_agrega_bienes.visible=false;
	this.lbl_nombre.text="";
	this.lbl_rut.text="";
	this.lbl_rut.setFocus();
	this.btn_buscar.enabled=true;
    this.btn_buscar.visible=true;
	
	        this.lbl_nombre.visible=false;
			this.txt_rut_ingreso.enabled=false;
			this.txt_remuneracion_contrato.enabled=false;
			this.txt_honorario.enabled=false;
			this.txt_arriendo_bienes_muebles.enabled=false;
			this.txt_arriendo_bienes_inmuebles.enabled=false;
			this.txt_pension.enabled=false;
			this.txt_becas.enabled=false;				
			this.cmb_becas.enabled=false;
		    
		    
		    this.cmb_tipo_propiedad.enabled=false;
		    this.cmb_tipo_construccion.enabled=false;
		    this.cmb_tenencia_propiedad.enabled=false;
		    this.cmb_estado_conservacion.enabled=false;
		    this.cmb_servicios_basicos.enabled=false;		    
			this.cmb_uso.enabled=false;
			this.txt_metros_construidos.enabled=false;
			this.txt_superficie.enabled=false;
			this.txt_avaluo.enabled=false;
			this.stp_habitaciones.value=1;
			this.stp_habitaciones.enabled=false;
			
			this.txt_nombre_familiar.text="";
			this.txt_nombre_familiar.enabled=false;
			this.txt_apellido_paterno_familiar.text="";
			this.txt_apellido_paterno_familiar.enabled=false;
			this.txt_apellido_materno_familiar.text="";
			this.txt_apellido_materno_familiar.enabled=false;
			this.txt_rut_familiar.text="";
			this.txt_rut_familiar.enabled=false;
			this.txt_fecha_nacimiento_familiar.text="";
			this.txt_fecha_nacimiento_familiar.enabled=false;
			this.cmb_estado_civil.enabled=false;
			this.cmb_sexo.enabled=false;
			this.cmb_parentesco.enabled=false;
			this.cmb_nivel_estudios.enabled=false;
			this.cmb_prevision_social.enabled=false;
			this.cmb_prevision_salud.enabled=false;
			this.cmb_enfermedad_grave.enabled=false;
			this.cmb_actividad.enabled=false;
			this.cmd_agrega_grupo_familiar.enabled=false;
			this.cmb_tipo_familia.enabled=false;
			this.stp_integrantes_familia.value=0;
			this.stp_integrantes_familia.enabled=false;
			this.cmb_tipo_familia.enabled=false;
			this.cmb_jefe_hogar.enabled=false;
			
			this.lbl_alimentacion.enabled=false;
			this.lbl_vestuario.enabled=false;
			this.lbl_estudios.enabled=false;
			this.lbl_vivienda.enabled=false;
			this.lbl_transporte.enabled=false;
			this.lbl_medicamentos.enabled=false;
			this.lbl_serv_basicos.enabled=false;
			
			
			
			
	rp_ingresos.dataProvider=null;
	rp_bienes.dataProvider=null;
	rp_familiar.dataProvider=null;
	

	arreglo.removeAll();
    arreglobien.removeAll();
    arreglofamiliar.removeAll();

    rp_bienes.dataProvider=arreglobien;
    rp_ingresos.dataProvider=arreglo;
    rp_familiar.dataProvider=arreglofamiliar;
}

//***********************************************************************************************************
private function activar( ):void {
	this.cmd_guardar.visible=true;
	this.cmd_agrega_ingreso.visible=true;
	this.cmd_agrega_bienes.visible=true;
	ro_buscar.llena_combo_becas();
	ro_buscar.llena_combo_tipo_propiedad();
	ro_buscar.llena_combo_estado_civil();


		txt_rut_ingreso.enabled=true;
		txt_remuneracion_contrato.enabled=true;
		txt_honorario.enabled=true;
		txt_arriendo_bienes_muebles.enabled=true;
		txt_arriendo_bienes_inmuebles.enabled=true;
		txt_pension.enabled=true;
		txt_becas.enabled=true;				
		cmb_becas.enabled=true;

			
		txt_rut_ingreso.text="";
		txt_remuneracion_contrato.text="0";
		txt_honorario.text="0";
		txt_arriendo_bienes_muebles.text="0";
		txt_arriendo_bienes_inmuebles.text="0";
		txt_pension.text="0";
		txt_becas.text="0";
			

		this.cmb_tipo_propiedad.enabled=true;
	    this.cmb_tipo_construccion.enabled=true;
	    this.cmb_tenencia_propiedad.enabled=true;
	    this.cmb_estado_conservacion.enabled=true;
	    this.cmb_servicios_basicos.enabled=true;		    
		this.cmb_uso.enabled=true;
		this.txt_metros_construidos.enabled=true;
		this.txt_superficie.enabled=true;
		this.txt_avaluo.enabled=true;
	    this.stp_habitaciones.enabled=true;
		this.txt_metros_construidos.text="0";
		this.txt_superficie.text="0";
		this.txt_avaluo.text="0";
		
		this.txt_nombre_familiar.enabled=true;
		this.txt_apellido_paterno_familiar.enabled=true;
		this.txt_apellido_materno_familiar.enabled=true;
		this.txt_rut_familiar.enabled=true;
		this.txt_fecha_nacimiento_familiar.enabled=true;
		this.cmb_estado_civil.enabled=true;
		this.cmb_sexo.enabled=true;
		this.cmb_parentesco.enabled=true;
		this.cmb_nivel_estudios.enabled=true;
		this.cmb_prevision_social.enabled=true;
		this.cmb_prevision_salud.enabled=true;
		this.cmb_enfermedad_grave.enabled=true;
		this.cmb_actividad.enabled=true;
		this.cmd_agrega_grupo_familiar.enabled=true;
		this.cmb_tipo_familia.enabled=true;
		this.cmb_tipo_familia.enabled=true;
		this.cmb_jefe_hogar.enabled=true;
		
		this.lbl_alimentacion.enabled=true;
		this.lbl_vestuario.enabled=true;
		this.lbl_estudios.enabled=true;
		this.lbl_vivienda.enabled=true;
		this.lbl_transporte.enabled=true;
		this.lbl_medicamentos.enabled=true;
		this.lbl_serv_basicos.enabled=true;
		this.lbl_alimentacion.text="0";	
		this.lbl_vestuario.text="0";	
		this.lbl_estudios.text="0";	
		this.lbl_vivienda.text="0";	
		this.lbl_transporte.text="0";	
		this.lbl_medicamentos.text="0";	
		this.lbl_serv_basicos.text="0";	
		this.lbl_alimentacion.text="0";	
		
		ro_buscar.trae_datos_correlativo();

}


 
private function btn_guardar_click():void
{

	if (lbl_alimentacion.text=="0" || lbl_alimentacion.text=="" || lbl_serv_basicos.text=="0" || lbl_serv_basicos.text==""|| cmb_tipo_familia.selectedIndex ==0)
	{ 
			 if (cmb_tipo_familia.selectedIndex == 0)
			 { 
			  mx.controls.Alert.show("Debe seleccionar tipo de familia", "Verifique");
			  cmb_tipo_familia.setFocus()
			 }
			 if (lbl_alimentacion.text=="0" || lbl_alimentacion.text=="")
			 { 
			  mx.controls.Alert.show("Debe ingresar gasto alimentacion", "Verifique");
			  lbl_alimentacion.setFocus()
			 }
			 if (lbl_serv_basicos.text=="0" || lbl_serv_basicos.text=="")
			 { 
			  mx.controls.Alert.show("Debe ingresar gasto servicios basicos", "Verifique");
			  lbl_serv_basicos.setFocus()
			 }
	}
	else
	{
            

	
mx.controls.Alert.show(rp_bienes.dataProvider.length,rp_bienes.dataProvider.length);
    
			var x:int;
			var arre_guarda:ArrayCollection = new ArrayCollection;
			arre_guarda.removeAll();
			
			if (rp_ingresos.dataProvider != null)
			{
				for(x = 0; x < rp_ingresos.dataProvider.length; x++) 
				{
					mx.controls.Alert.show("-------------- ",x.toString());
					var o_nueve_campos_obj:obj_nueve_campos = new obj_nueve_campos;
					o_nueve_campos_obj.campo_uno = lbl_rut_ingreso[x].text;
					o_nueve_campos_obj.campo_dos = lbl_remuneracion_contrato[x].text;
					o_nueve_campos_obj.campo_tres = lbl_honorario[x].text;
					o_nueve_campos_obj.campo_cuatro = lbl_arriendo_bienes_muebles[x].text;
					o_nueve_campos_obj.campo_cinco = lbl_arriendo_bienes_inmuebles[x].text;
					o_nueve_campos_obj.campo_seis = lbl_pension[x].text;
					o_nueve_campos_obj.campo_siete = lbl_becas[x].text;
					o_nueve_campos_obj.campo_ocho = lbl_tipo_beca[x].text;
					o_nueve_campos_obj.campo_nueve = lbl_codigo_beca[x].text;
					arre_guarda.addItem(o_nueve_campos_obj);
					
				}
			}
			

			
			
			var xx:int;
			var arre_guarda_2:ArrayCollection = new ArrayCollection;
			arre_guarda_2.removeAll();
			
			mx.controls.Alert.show("rp_bienes.dataProvider.length", rp_bienes.dataProvider.length);
			
			if (rp_bienes.dataProvider != null)
			{ 
				for(xx = 0; xx < rp_bienes.dataProvider.length; xx++) 
				{
					var o_diez_campos_obj:obj_diez_campos = new obj_diez_campos;
					o_diez_campos_obj.campo_uno = lbl_codigo_tipo_propiedad[xx].text;
					mx.controls.Alert.show("lbl_codigo_tipo_propiedad[xx].text", lbl_codigo_tipo_propiedad[xx].text);
					o_diez_campos_obj.campo_dos = lbl_codigo_tipo_construccion[xx].text;
					mx.controls.Alert.show("lbl_codigo_tipo_construccion[xx].text;", lbl_codigo_tipo_construccion[xx].text);
					o_diez_campos_obj.campo_tres = lbl_codigo_tenencia_propiedad[xx].text;
					mx.controls.Alert.show("lbl_codigo_tenencia_propiedad[xx].text;", lbl_codigo_tenencia_propiedad[xx].text);
					o_diez_campos_obj.campo_cuatro = lbl_codigo_estado_conservacion[xx].text;
					mx.controls.Alert.show("lbl_codigo_estado_conservacion[xx].text;", lbl_codigo_estado_conservacion[xx].text);
					o_diez_campos_obj.campo_cinco = lbl_metros_construidos[xx].text;
					mx.controls.Alert.show("lbl_metros_construidos[xx].text;", lbl_metros_construidos[xx].text);
					o_diez_campos_obj.campo_seis = lbl_superficie[xx].text;
					mx.controls.Alert.show("lbl_superficie[xx].text;", lbl_superficie[xx].text);
					o_diez_campos_obj.campo_siete = lbl_codigo_uso[xx].text;
					mx.controls.Alert.show("lbl_codigo_uso[xx].text;", lbl_codigo_uso[xx].text);
					o_diez_campos_obj.campo_ocho = lbl_habitaciones[xx].text;
					mx.controls.Alert.show("lbl_habitaciones[xx].text;", lbl_habitaciones[xx].text);
					o_diez_campos_obj.campo_nueve = lbl_codigo_servicios_basicos[xx].text;
					mx.controls.Alert.show("lbl_codigo_servicios_basicos[xx].text;", lbl_codigo_servicios_basicos[xx].text);
					o_diez_campos_obj.campo_diez = lbl_avaluo[xx].text;
					mx.controls.Alert.show("lbl_avaluo[xx].text;", lbl_avaluo[xx].text);
					arre_guarda_2.addItem(o_diez_campos_obj);	
				}
			}


            
			var xxx:int;
			var arre_guarda_3:ArrayCollection = new ArrayCollection;
			arre_guarda_3.removeAll();
			
			if (rp_familiar.dataProvider != null)
			{
				for(xxx = 0; xxx < rp_familiar.dataProvider.length; xxx++) 
				{
					var o_quince_campos_obj:obj_quince_campos = new obj_quince_campos;
					o_quince_campos_obj.campo_uno = lbl_nombre_familiar[xxx].text;
					o_quince_campos_obj.campo_dos = lbl_apellido_paterno_familiar[xxx].text;
					o_quince_campos_obj.campo_tres = lbl_apellido_materno_familiar[xxx].text;
					o_quince_campos_obj.campo_cuatro = lbl_rut_familiar[xxx].text;
					o_quince_campos_obj.campo_cinco = lbl_fecha_nacimiento_familiar[xxx].text;
					o_quince_campos_obj.campo_seis = lbl_tipo_estado_civil[xxx].text;
					o_quince_campos_obj.campo_siete = lbl_tipo_sexo[xxx].text;
					o_quince_campos_obj.campo_ocho = lbl_tipo_parentesco[xxx].text;
					o_quince_campos_obj.campo_nueve = lbl_tipo_nivel_estudios[xxx].text;
					o_quince_campos_obj.campo_diez = lbl_tipo_prevision_social[xxx].text;
					o_quince_campos_obj.campo_once = lbl_tipo_prevision_salud[xxx].text;
					o_quince_campos_obj.campo_doce = lbl_tipo_actividad[xxx].text;
					o_quince_campos_obj.campo_trece = lbl_tipo_enfermedad_grave[xxx].text;
					o_quince_campos_obj.campo_catorce = lbl_rut.text;
					o_quince_campos_obj.campo_quince = lbl_jefe_hogar[xxx].text;
					arre_guarda_3.addItem(o_quince_campos_obj);	
				}
			}
			
		mx.controls.Alert.show("arre_guarda",arre_guarda.length.toString());	
		 if (arre_guarda.length>0)
		 // if (rp_ingresos.dataProvider != null)
		 { mx.controls.Alert.show("1","1");
	  		ro_buscar.guarda_datos_ingresos(arre_guarda, this.lbl_correlativo.text);
		 }
		
		mx.controls.Alert.show("arre_guarda_2",arre_guarda_2.length.toString());
		 if (arre_guarda_2.length>0)
		 //if (rp_bienes.dataProvider != null)
		 {
		    	ro_buscar.guarda_datos_bienes(arre_guarda_2, lbl_rut.text, this.lbl_correlativo.text);	
          }
          mx.controls.Alert.show("arre_guarda_3",arre_guarda_2.length.toString());
          if (arre_guarda_3.length>0)
        // if (rp_familiar.dataProvider != null)
         {  mx.controls.Alert.show("3","3");
			ro_buscar.guarda_datos_grupo_familiar(arre_guarda_3,this.lbl_correlativo.text);
	     }
		
	     ro_buscar.guarda_datos_fise( lbl_rut.text, cmb_tipo_familia.selectedItem.data, this.lbl_correlativo.text);
	     ro_buscar.guarda_datos_egresos( this.lbl_correlativo.text, this.lbl_alimentacion.text, this.lbl_vestuario.text, this.lbl_estudios.text, this.lbl_vivienda.text, this.lbl_transporte.text, this.lbl_medicamentos.text, this.lbl_serv_basicos.text );
	     limpia();
 
	}		
			
	
}


//******************************************************************************************************
private function muestra_datos_ok():void
{
//mx.controls.Alert.show("ok", "datos almacenados");
}

//******************************************************************************************************
private function result_guarda_datos_ingresos():void
{
//mx.controls.Alert.show("ok", "datos almacenados");
}
//******************************************************************************************************
private function result_guarda_datos_bienes():void
{
//mx.controls.Alert.show("ok", "datos almacenados");
}
//******************************************************************************************************
private function result_guarda_datos_egresos():void
{
//mx.controls.Alert.show("ok", "datos almacenados");
}
//******************************************************************************************************
private function result_guarda_datos_grupo_familiar():void
{
//mx.controls.Alert.show("ok", "datos almacenados");
}
//******************************************************************************************************
private function result_guarda_datos_fise():void
{
//mx.controls.Alert.show("ok", "datos almacenados");
}

//***********************************************************************************************************
//function lbl_rut_presskey(){

//		var rut_temp:String = this.lbl_rut.text
//		rut_temp = rut_temp.toUpperCase()
			
//			if (Key.getAscii()==13){
//				valida_rut(rut_temp);
//			}else{
//				if (Key.getAscii() >= 48 && Key.getAscii() <= 57){
//					puntos()
//				}else{
//					Key.BACKSPACE
//				}
//			}

//	if (Key.getAscii()==13){
//				btn_buscar_cuotas_mora.setFocus();
//	}
//}
//******************************************************************************************************
 private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}

//***********************************************************************************************************
 private function puntos():void {
	var rut_temp:String;
	
	if (this.lbl_rut.length == 2) {
		this.lbl_rut.text = this.lbl_rut.text + '.'
		rut_temp = this.lbl_rut.text + '.'
	}
	if (this.lbl_rut.length == 6) {
		this.lbl_rut.text = this.lbl_rut.text + '.'
		rut_temp = this.lbl_rut.text + '.'
	}
	
	if (this.lbl_rut.length == 10) {
		this.lbl_rut.text = this.lbl_rut.text + '-'
		rut_temp = this.lbl_rut.text + '.'
	}
}
//***********************************************************************************************************
 private function valida_rut(rut_temp:String):Boolean{
	

	var dt:Number= new Number;
	var dt2:String= new String;
 	var resto:Number= new Number;
 	var i:Number= new Number;
 	var suma:Number= new Number;
	var j:Number= new Number;
    var is_ok:Number= new Number;
	var us_rut:String= new String; 
	var largo:Number= new Number;
	
	us_rut = rut_temp
	
	is_ok = 0
	

	
	if (rut_temp.length == 12)
	{
		j = 2
      	suma = 0
		largo = us_rut.length
		
		i = us_rut.length - 2
		
		while(i>0){
		
		
		if (us_rut.substr(i-1, 1) != '.')
			
			{	
				if (j > 7)
				{
					j = 2
				}
				suma = suma + Number(us_rut.substr(i-1, 1)) * j
				j = j + 1
			}
		
		i--
		
		
		
		}
		
		resto = suma % 11
		dt = 11 - resto
		dt2 = dt.toString()
		
		//-------------
		if (dt2 == '10')
		{
			if (us_rut.substr(largo-1, 1) == 'K' || us_rut.substr(largo-1, 1) == 'k')
			{
				is_ok = 1
			}
		}

		if (dt2 == '11')
		{
			if (us_rut.substr(largo - 1, 1) == '0')
			{
				is_ok = 1
			}
		}
		
		if (dt2.substr(0, 1) == us_rut.substr(largo - 1, 1))
		{
			is_ok = 1
		}
	}
	
	if (is_ok == 0)
	{  
			valido = false
			//mx.controls.Alert.show("rut invalido","");
	       //lbl_rut.text="";
	}
	
	if (is_ok == 1)
	{
		//paso( );
		valido = true
		//ro_buscar.buscar_por_rut(String(lbl_rut.text));

	}
	
	if (is_ok == 1)
	{
			valido = true

	}
		return valido		
}