package  {
    import flash.events.*;
    import flash.net.FileReference;
    import flash.net.URLRequest;
    
    import mx.controls.Alert;
    import mx.controls.Button;
    import mx.controls.CheckBox;
    import mx.controls.Label;
    import mx.controls.ProgressBar;
    import mx.core.UIComponent;

    public class FileUpload extends UIComponent {
        private var fr:FileReference;
        private var pb:ProgressBar;
        private var btn:Button;
        private var btn_ex:Button;
        private var lbl:Label;
        private var test:Label;
        private var generar_grupos:Function;
        private var lbl_peso_total:Label;
        private var lbl_peso_archivo:Label;
        private var UPLOAD_URL:String;

        public function init(pb:ProgressBar, btn:Button, btn_ex:Button, lbl:Label, test:Label, lbl_peso_total:Label, lbl_peso_archivo:Label, generar_grupos:Function):void {
            this.pb = pb;
            this.btn = btn;
            this.btn_ex = btn_ex;
            this.lbl = lbl;
            this.test = test;
            this.lbl_peso_archivo = lbl_peso_archivo;
            this.lbl_peso_total = lbl_peso_total;
            this.generar_grupos = generar_grupos;
            
            fr = new FileReference();
            fr.addEventListener(Event.SELECT, archivoSeleccionado);
    //        fr.addEventListener(Event.OPEN, iniciarSubida);
            fr.addEventListener(Event.COMPLETE, completeHandler);
            fr.addEventListener(IOErrorEvent.IO_ERROR, ioerrorHandler);
            fr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityHandler);
            fr.addEventListener(ProgressEvent.PROGRESS, progressEvent);
     //       fr.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
            
             
            
        }
        
        private function progressEvent(event:ProgressEvent):void {
			
			pb.setProgress(event.bytesLoaded, event.bytesTotal);
			lbl_peso_total.text = event.bytesTotal.toString()
			
			lbl_peso_archivo.text = event.bytesLoaded.toString()
			
			pb.label = 'Subiendo: ' +  event.bytesLoaded + '. De : ' + event.bytesTotal + ' bytes'  
			
		}

        /**
         * Immediately cancel the upload in progress and disable the cancel button.
         */
        public function cancelUpload():void {
            fr.cancel();
            pb.label = "Operación Cancelada por el Usuario";
        }
        
        public function examinar():void {
            fr.browse();
        }

		public function archivoSeleccionado(event:Event):void {
			
			var p:String;
			if (fr.name.indexOf("ñ",0) != -1 || fr.name.indexOf("á",0) != -1 || fr.name.indexOf("é",0) != -1 || fr.name.indexOf("í",0) != -1 || fr.name.indexOf("ó",0) != -1 || fr.name.indexOf("ú",0) != -1 || fr.name.indexOf(" ",0) != -1 || fr.name.indexOf("à",0) != -1 || fr.name.indexOf("è",0) != -1 || fr.name.indexOf("ì",0) != -1 || fr.name.indexOf("ò",0) != -1 || fr.name.indexOf("ù",0) != -1){
				mx.controls.Alert.show('El nombre del archivo no puede contener acentos, espacios ni la letra ñ.','Alerta');
			}
			else
			{
				if (fr.type == ".doc" || fr.type == ".docx" || fr.type == ".xls" || fr.type == ".xlsx" || fr.type == ".pdf" || fr.type == ".ppt") {
					pb.label = "Ha seleccionado el archivo: " + fr.name;
					btn.enabled = true;
					btn_ex.enabled = false;
					lbl.visible = true;
					test.text = fr.name;
					
				}
				else
				{
					mx.controls.Alert.show('El archivo debe ser Word(.doc,.docx), Pdf(.pdf), PowerPoint(.ppt) o Excel(.xls,.xlsx)', 'Ingreso')
					btn.enabled = false;
				}
			}
			
    		
					
					
		}
	
        public function iniciarSubida(url:String):void {
        	fr.upload(new URLRequest(url));
        }
        
        private function ioerrorHandler(event:IOErrorEvent):void {
            	mx.controls.Alert.show("Ha ocurrido un error. \nContáctese con el Departamento de Informática de IPLACEX \nDescripción: " + event.toString());
            	pb.label = "Error en el envío";
        }

 		private function securityHandler(event:SecurityErrorEvent):void {
            	mx.controls.Alert.show("Ha ocurrido un error de Seguridad. \nContáctese con el Departamento de Informática de IPLACEX \nDescripción: " + event.toString());
            	pb.label = "Error en el envío";
        }

        public function openHandler(event:Event):void {
            pb.label = "Enviando Prueba";
        }

        
        public function completeHandler(event:Event):void {
        	if (lbl_peso_total.text == lbl_peso_archivo.text){
	            pb.label = "Prueba Enviada";
	            btn.enabled = false
	            pb.setProgress(0, 100);
	            generar_grupos();
	        }
        }
    }
}