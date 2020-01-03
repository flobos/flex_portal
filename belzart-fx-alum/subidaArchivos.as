// ActionScript file - by CMEDINA
import mx.controls.Alert;
[Bindable]
private var fileRef:FileReference;
[Bindable]
private var fileSelected:Boolean = false;
[Bindable]
private var status:String = "Select file";

private function onCreationComplete():void
{
	fileRef = new FileReference();
	fileRef.addEventListener(Event.SELECT, onFileSelected);
	fileRef.addEventListener(Event.COMPLETE, onUploadComplete);
	fileRef.addEventListener(ProgressEvent.PROGRESS, onUploadProgress);
	fileRef.addEventListener(IOErrorEvent.IO_ERROR, onUploadError);
	fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUploadError);
}




private function selectFile(event:MouseEvent):void
{
	fileRef.browse();
}

private function onFileSelected(event:Event):void
{
	fileSelected = true;
	fileInput.text = fileRef.name;
	status = "Ready";

}

private function uploadFile(event:MouseEvent):void
{
	if (!fileSelected || (urlInput.text.length == 0))
	{
		Alert.show("Insert a URL and select a file.");
		return;
	}
	fileRef.upload(new URLRequest(urlInput.text));
}

private function onUploadProgress(event:ProgressEvent):void
{
	status = ((event.bytesLoaded * 100) / event.bytesTotal).toString();
}


private function onUploadComplete(event:DataEvent):void
{
	status = "Complete";
}


private function onUploadError(event:Event):void
{
	if (event is IOErrorEvent)
	{
		Alert.show("io" + event.toString());
	}
	else if (event is SecurityErrorEvent)
	{
		Alert.show("seguridad" + event.toString());
	}
	else {
		Alert.show("ñldfksja");
	}
}
