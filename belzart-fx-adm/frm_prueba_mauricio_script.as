// ActionScript file


import libreria.*;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.rpc.events.*;


private function tw_prueba_creationComplete():void{
ro_prueba.obtiene_funcionario('12.157.071-8')
}


private function result_obtiene_funcionario(event:ResultEvent):void{
this.txt_nombre.text = event.result[0].label
}