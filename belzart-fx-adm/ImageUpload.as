package  {
    import flash.events.*;
    import flash.net.FileReference;
    import flash.net.URLRequest;
    
    import mx.controls.Alert;
    import mx.controls.Label;
    import mx.controls.ProgressBar;
    import mx.core.UIComponent;

    public class ImageUpload extends UIComponent {
        private var fr:FileReference;
        private var pb:ProgressBar;
        private var lbl_peso_total:Label;
        private var lbl_peso_archivo:Label;
        private var txt_imagen:Label;
        
        public function init(pb:ProgressBar, txt_imagen:Label):void {
            this.pb = pb;
            this.txt_imagen = txt_imagen;
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
    		if (fr.type != ".jpg") {
				mx.controls.Alert.show('El archivo debe ser JPG(.jpg)', 'Ingreso')
			}
			else{
				if(fr.size > 308223) {
					mx.controls.Alert.show('El tamaño del archivo debe ser inferior a 300kB','Ingreso');
				}
				else {
					pb.label = fr.name;
					txt_imagen.text = fr.name;
				}
				

			}
					
					
		}
	
        public function iniciarSubida(url:String):void {
        	fr.upload(new URLRequest(url));
        }
        
        private function ioerrorHandler(event:IOErrorEvent):void {
            	mx.controls.Alert.show("Ha ocurrido un error al subir la imagen adjunta.\n" + event.toString());
            	pb.label = "Error al adjuntar imagen";
        }

 		private function securityHandler(event:SecurityErrorEvent):void {
            	mx.controls.Alert.show("Ha ocurrido un error al subir la imagen adjunta.\n" + event.toString());
            	pb.label = "Error al adjuntar imagen";
        }

        public function openHandler(event:Event):void {
        	pb.label = "Adjuntando imagen";
        }

        
        public function completeHandler(event:Event):void {
				pb.label = "Imagen Adjuntada Exitosamente";
	            pb.setProgress(0, 100);
        }
    }
}