package {
    import flash.events.*;
    import flash.net.FileReference;
    import flash.net.URLRequest;
    import mx.controls.Button;
    import mx.controls.Alert;
    import mx.controls.ProgressBar;
    import mx.core.UIComponent;

    public class FileDownload extends UIComponent {
        private var fr:FileReference;
        private var pb:ProgressBar;
        private var btn:Button;

        public function init(pb:ProgressBar, btn:Button):void{
            this.pb = pb;
            this.btn = btn;

            fr = new FileReference();
//            fr.addEventListener(Event.CANCEL, marcaEvento);
            fr.addEventListener(Event.COMPLETE, completeHandler);
//            fr.addEventListener(Event.OPEN, marcaEvento);
//            fr.addEventListener(Event.SELECT, marcaEvento);
//            fr.addEventListener(HTTPStatusEvent.HTTP_STATUS, marcaEvento);
            fr.addEventListener(IOErrorEvent.IO_ERROR, ioerrorHandler);
//            fr.addEventListener(ProgressEvent.PROGRESS, marcaEvento);
            fr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityHandler);
        }

  		private function completeHandler(event:Event):void {
            mx.controls.Alert.show("Descarga Exitosa");
            pb.label = "Descarga Exitosa";
            btn.enabled = false;
        }
        private function ioerrorHandler(event:Event):void {
            	mx.controls.Alert.show("Ha ocurrido un error. \nContáctese con el Departamento de Informática de IPLACEX \nDescripción: " + event.toString());
            	pb.label = "Error en la Descarga";
        }
        private function securityHandler(event:Event):void {
            	mx.controls.Alert.show("Ha ocurrido un error de Seguridad. \nContáctese con el Departamento de Informática de IPLACEX \nDescripción: " + event.toString());
            	pb.label = "Error en la Descarga";
        }
         
       public function iniciarDescarga(url:String):void{
            var request:URLRequest = new URLRequest(url);
            fr.download(request);
        }

    }
}