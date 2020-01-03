// ActionScript file
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.*;
import mx.controls.Alert;
import mx.core.IFlexDisplayObject;
import mx.data.AccessPrivileges;
import mx.events.FlexEvent;
import mx.formatters.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import mx.utils.ArrayUtil;
import mx.validators.StringValidator;
import mx.binding.utils.*;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
//-----------------------------------------

   [Bindable]
            public var foto:String;         
//-----------------------------------------
//public  var foto:String = new String;

//*****************import para pop-up****************************************

			import mx.managers.PopUpManager;
            import mx.core.IFlexDisplayObject;


//****************************************************************************
private function Fault(event:FaultEvent):void{
	Alert.show(event.fault.faultString, "Error");	
}
//****************************************************************************
//si***********************************************************************
private function busca():void{
 if (txt_busca.text!= ""){
 	
	ro_foto_alumno.foto_alumno_busca_datos_alumno(txt_busca.text)
 
 }else{
 Alert.show("Debe ingresar datos");
 txt_busca.setFocus()
 
 }
}
//****************************************************************************
//si****************************************************************************
private function result_foto_alumno_busca_datos_alumno(event:ResultEvent):void{
   //grilla_datos.dataProvider = event.result
	//mx.controls.Alert.show(event.result[0].campo_uno);	
	txt_alu_idn.text = event.result[0].campo_uno
	txt_nombre.text = event.result[0].campo_dos
	txt_Matricula.text = event.result[0].campo_tres
	
	txt_alu_foto.text= event.result[0].campo_cinco
	
	initImage()
	
}
//**************************************************************************
//--------------------------------------------------------------------------
 import mx.managers.CursorManager;
        import flash.events.*;
        
        // Define a variable to hold the cursor ID.
        private var cursorID : Number = 0;

        // Embed the cursor symbol.
   //     [Embed(source="c://fotos_alumnos/12.522.240-4.jpg")] 
        private var waitCursorSymbol:Class; 
                
        // Define event listener to display the wait cursor 
        // and to load the image.
 /*       private function initImage(event:MouseEvent):void {
            // Set busy cursor.
            cursorID = CursorManager.setCursor(waitCursorSymbol);
            // Load large image.
            image1.load("http://localhost:8700/flex2/fotos_alumnos/"+txt_alu_idn.text+".jpg");
        }
*/
 
//------------------------------------------------
 private function initImage():void {
            // Set busy cursor.
 //           cursorID = CursorManager.setCursor(waitCursorSymbol);
            // Load large image.
            if (txt_alu_foto.text==""){
			Alert.show("No Tiene Fotografía");
				}else{
			foto=("http://164.77.193.131:8100/lcds/belzart-fx-adm/fotos_alumnos/"+txt_alu_idn.text+"/"+txt_alu_foto.text+".jpg");
           	//foto=("http://192.168.1.172:8700/flex2/fotos_alumnos/"+txt_alu_foto.text+".jpg");
			image1.load(foto);
			}
         
            
      
        }
        // Define an event listener to remove the wait cursor.
  //---------------------------------------------------  
        private function loadComplete(event:Event):void {
            CursorManager.removeCursor(cursorID);    
        }                

//----------------------------------------------------------------------------------------
 private function sacar_foto():void {
		if ((txt_alu_idn.text) != ""){
    		
	//	Alert.show("pop_up");
		var helpWindow:IFlexDisplayObject = PopUpManager.createPopUp(this, pop_up_foto, false);
		 
	}	else {
			Alert.show("Debe seleccionar un alumno");
	}
}
//----------------------------------------------------------------------------------------------
 private function nuevo():void {
 	txt_alu_idn.text="";
 	txt_busca.text='';
 //	txt_busca.setFocus()
 	txt_busca_matricula.text='';
 // txt_busca_matricula.setFocus()
 	
 	txt_nombre.text='';
 	txt_Matricula.text='';
 	txt_alu_foto.text='';
 	image1.source=null
 	
 	//image1.load("")
 }
 //**************RUT*************************
 //***********************************************************************************************************

private function cambia(event:KeyboardEvent):void{
 

		if (event.charCode >= 48 && event.charCode <= 57 || event.charCode == 75 || event.charCode == 107)
		{
			if (txt_busca.length == 3 || txt_busca.length == 7 || txt_busca.length == 11) 
			{
				txt_busca.setFocus();
				
			}
		}

}
//***********************************************************************************************************
private function lbl_busq_keypress(event:KeyboardEvent):void{
	
	//if (Key.getAscii()==13){
		
		if (event.charCode == 13){
							if (txt_busca.text != ""){
													valida_rut(txt_busca.text);
												
													}else{
														Alert.show('Ingrese datos.');
													}
			
							}else{		
									if (event.charCode >= 48 && event.charCode <= 57){
										puntos()
									}else{
										//	Key.BACKSPACE
										//Alert.show("Espacio");
											
									}
		
								}
}
//------------------------------------------------------------
private function puntos():void{
	
	var rut_temp:String;
	
	if (txt_busca.length == 2) {
		txt_busca.text = txt_busca.text + '.'
		
		txt_busca.setFocus();
   		txt_busca.setSelection(txt_busca.length,txt_busca.length);
   		
		rut_temp = txt_busca.text //+ '.'
		//Alert.show(rut_temp);
		
	}
	if (txt_busca.length == 6) {
		txt_busca.text = txt_busca.text + '.'
		txt_busca.setFocus();
   		txt_busca.setSelection(txt_busca.length,txt_busca.length);
		rut_temp = txt_busca.text// + '.'
		//Alert.show(rut_temp);
	}
	
	if (txt_busca.length == 10) {
		txt_busca.text = txt_busca.text + '-'
		txt_busca.setFocus();
   		txt_busca.setSelection(txt_busca.length,txt_busca.length);
		rut_temp = txt_busca.text// + '.'
		//Alert.show(rut_temp);
	}
	
}

//***********************************************************************************************************
private function valida_rut(rut_temp:String):void{
	txt_alu_foto.text=''
	image1.source=null
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
	
	if (txt_busca.length == 12)
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
			Alert.show('El R.U.T. ingresado no es valido.                  ');
	//		Selection.setFocus("lbl_busq");
	}
	
	if (is_ok == 1)
	{
	ro_foto_alumno.foto_alumno_busca_datos_alumno(txt_busca.text)
	//Alert.show('El R.U.T. ingresado Si es valido.                  ');
							
	}
		
}
//------------------------------------------------------------
////////////////////////////////////////////////////////////////////////-----------------------------------------------------------
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
///--------------BUSCAR POR MATRICULA 20 _06_2007 (YA NO SE BUSCA POR RUT EN LA PANTALLA)
//----------------------------------------------------------------------------------------
private function busca_datos_alumno_por_matricula():void{
if (txt_busca_matricula.text !=""){
   	ro_foto_alumno.foto_alumno_busca_datos_alumno_por_matricula(txt_busca_matricula.text)
}else{

Alert.show('Ingrese Matrícula.                  ');
}
}
//-------------------------------------------------------------
private function result_foto_alumno_busca_datos_alumno_por_matricula (event:ResultEvent):void{
txt_alu_idn.text = event.result[0].campo_uno
	txt_nombre.text = event.result[0].campo_dos
	txt_Matricula.text = event.result[0].campo_tres
	
	txt_alu_foto.text= event.result[0].campo_cinco
	
	initImage()

}

//--------------------------------------------------------------
private function lbl_busq_keypress_2(event:KeyboardEvent):void{
	
	//if (Key.getAscii()==13){
		
		if (event.charCode == 13){
							if (txt_busca_matricula.text != ""){
													
													busca_datos_alumno_por_matricula()
												
													}else{
														Alert.show('Ingrese Matrícula.');
													}
			
							
		
								}
}

//------------------------------------------------------------

private function opcion_matricula():void{
nuevo()
txt_busca_matricula.visible=true
txt_busca.visible=false

txt_busca_matricula.setFocus()

}

//------------------------------------------------------------

private function opcion_rut():void{
	nuevo()
txt_busca_matricula.visible=false
txt_busca.visible=true
txt_busca.setFocus()
}


