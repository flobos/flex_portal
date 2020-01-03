// ActionScript Document
import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.utils.URLUtil;
public var url_informe:String

public var url_frame:URLRequest;
private function inicio():void{
	mx.controls.Alert.show(this.url_informe);
	url_frame = new URLRequest(url_informe);
	navigateToURL(url_frame, "_blank");
	PopUpManager.removePopUp(this);	
}
