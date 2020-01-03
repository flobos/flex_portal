// ActionScript file
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.media.Camera;
import flash.media.Video;

import mx.controls.Alert;
import mx.rpc.events.ResultEvent;

public var rut:String;		
private var imagen1:Bitmap;
private var imagen1Datos:BitmapData;
private var Camara:Video;	
//-----------------------------------------------------------------**********************
import mx.events.ValidationResultEvent;
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
import flash.events.KeyboardEvent;
import mx.containers.TitleWindow;
import mx.core.Application;
import flash.display.DisplayObject;
//****************************************


            import mx.managers.PopUpManager;
            
            import mx.core.Application;
            
       
       

//**********************************************************

            import mx.core.SoundAsset;
           
        
            import flash.media.Sound;
            import flash.media.SoundChannel;
            import mx.controls.Button;
            import flash.net.FileFilter;
//------------------------------------------------

import mx.controls.Alert;
import mx.rpc.events.ResultEvent;
import flash.media.Camera;
import flash.utils.ByteArray;
import flash.geom.Matrix;


	
private var imagen1nombre:String;

///--*********************************************************

   public function initApp():void{
            //****************
           //doInit()
   
}
//-------------------------------------------------
           
    private function doInit():void {
    	
    			
                // Center the TitleWindow container 
                // over the control that created it.
                PopUpManager.centerPopUp(this);
            	txt_conserva_alu_idn.text=(this.rut)
            		
            	txt_conserva_alu_foto.text= ("foto_entidad.jpg")
            		
;            }         
       
      
//*************************************************************************
private function Fault(event:FaultEvent):void{
	
  	Alert.show(event.fault.faultString, "Error");	
}


///**********************************************************************
//***********************************************************************


private function carga():void{
	imagen1Datos = new BitmapData(240,320);
            	
            	Camara = new Video(240,320);	            	
               
                uicVid.addChild(DisplayObject(Camara));
	                	            
            	imagen1 = new Bitmap(imagen1Datos);	            	                
                uicBmp.addChild(DisplayObject(imagen1));		
                
				var camera:Camera= Camera.getCamera();
				
				if(camera != null) {
	            	camera.setMode(240, 320,25,true);
	            	Camara.attachCamera(camera);	                
	            }
	            else {
	            	Alert.show("No se encontro camara", "Error");
	            	
	           
	            }	
	               
	            doInit()
	            

}
//-----------------------------------------------------------

private function btn_foto_click():void{

				
				var vidMtrx:Matrix = new Matrix();
				vidMtrx.scale(Camara.scaleX, Camara.scaleY);
				imagen1Datos.draw(Camara, vidMtrx);
				
          
}
//------------------------------------------------------------

//------------------------------------------------------------

private function btn_guarda_click():void{

    var Jpeg:JPEGEncoder = new JPEGEncoder(40)
	var ba:ByteArray = Jpeg.encode(imagen1Datos)
//    ro.doUpload(ba,txt_conserva_alu_idn.text,txt_conserva_alu_foto.text);
     this.parentApplication.set_foto(ba);
	 cerrar();	
}
//------------------------------------------------------------

  private function handleResult(event:ResultEvent):void
        {
        	if (event.result!=""){
        	txt_result.text=String(event.result)
        	
        //   Alert.show(event.result.toString())
        
        envia_nuevos_datos_alu_foto()
        
        	}else{
        	
        	Alert.show("Problemas de conexion , Inténtelo mas tarde")
        	cerrar()
        	}
        	
        	
        }

//----------------------------------------------------------------------
private function cerrar():void{
	//this.parentApplication.showPreviousStep(0)
	
	PopUpManager.removePopUp(this);	
	
}
//-----------------------------------------------------------------------
private function envia_nuevos_datos_alu_foto():void{

	ro_foto_alumno.foto_alumno_actualiza_alu_foto(txt_conserva_alu_idn.text,txt_result.text)

}
//------------------------------------------------------------------------
private function result_foto_alumno_actualiza_alu_foto(event:ResultEvent):void{

	 Alert.show("Se envió la foto satisfactoriamente")
	cerrar()
//Alert.show("Funciona")

}
//--------------------------------------------------------
private function borra_foto():void{

//	ro_foto_alumno.foto_alumno_borra_alu_foto(txt_conserva_alu_idn.text)
	btn_guarda_click()
}






