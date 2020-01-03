// ActionScript file
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.ByteArray;

import mx.binding.utils.*;
import mx.collections.*;
import mx.controls.Alert;
import mx.core.IFlexDisplayObject;
import mx.data.AccessPrivileges;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
import mx.formatters.*;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import mx.utils.ArrayUtil;
import mx.validators.StringValidator;

public var pantalla:String;
public var rut:String;
public var id_entidad:String;
public var foto_entidad:ByteArray;
public var tiene_foto:Boolean;
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
private function inicio():void{
	
	if (foto_entidad != null)
	{
		this.image1.source = foto_entidad;
	}
	else if (tiene_foto == true)
	{
		mx.controls.Alert.show(rut);
		foto=("http://192.168.1.127:8400/lcds/belzart-fx-adm/foto_entidades/"+id_entidad+"/"+rut+".jpg");
		image1.load(foto);
	}
}
//****************************************************************************
//si****************************************************************************
private function result_foto_alumno_busca_datos_alumno(event:ResultEvent):void{
   //grilla_datos.dataProvider = event.result
	//mx.controls.Alert.show(event.result[0].campo_uno);	
	
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
			foto=("http://192.168.1.127:8400/lcds/belzart-fx-adm/foto_entidades/"+rut+"/foto_entidad.jpg");
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
		if ((rut) != ""){
    		
	//	Alert.show("pop_up");
	//	var helpWindow:IFlexDisplayObject = PopUpManager.createPopUp(this, pop_up_foto_entidad, false);
		 
		var popup1:pop_up_foto_entidad = pop_up_foto_entidad(PopUpManager.createPopUp( this, pop_up_foto_entidad , true));
		popup1.rut = rut;
		mx.managers.PopUpManager.centerPopUp(popup1)
		cerrar();
		
	}	else {
			Alert.show("Debe seleccionar un alumno");
	}
}

private function cerrar():void
{
	PopUpManager.removePopUp(this);	
}

//----------------------------------------------------------------------------------------------
 private function nuevo():void {
 	txt_alu_idn.text="";
 //	txt_busca.setFocus()
 // txt_busca_matricula.setFocus()
 	
 	txt_nombre.text='';
 	txt_Matricula.text='';
 	txt_alu_foto.text='';
 	image1.source=null
 	
 	//image1.load("")
 }
 //**************RUT*************************
 //***********************************************************************************************************


//------------------------------------------------------------


