
import flash.display.StageDisplayState;
import flash.events.*;
import flash.net.*;
import flash.utils.*;

import mx.controls.*;
import mx.core.UIComponent;
import mx.events.*;
import mx.managers.IBrowserManager;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import mx.rpc.http.HTTPService;
private var xmlProperties:XML; 
private var servicePropReader:HTTPService; 
private var FMSUrl:String; 
private var pt_completa:Boolean;

NetConnection.defaultObjectEncoding = flash.net.ObjectEncoding.AMF0;
//NetStream.defaultObjectEncoding     = flash.net.ObjectEncoding.AMF0;
SharedObject.defaultObjectEncoding  = flash.net.ObjectEncoding.AMF0;


private var echoResponder:Responder = new Responder(echoResult, echoStatus);
private var nc:NetConnection;
public var ro:SharedObject;
private var inStream:NetStream = null;
private var inStream_escritorio:NetStream = null;
private var V_video_conferencia:Video;
private var V_video_escritorio:Video;
public var sala:String;
public var usuario:String;
private var pix_x:int;
private var pix_y:int;
private var dispState:String;
private var ancho_fs:int;
private var alto_fs:int;
private var full_screen:String;
private var bm:IBrowserManager;


private function fullScreen(event:Event) : void{ 
   this.videoHBox.width = cvn_videoconferencia.width; 
   this.videoHBox.height = cvn_videoconferencia.height; 
} 


private function init():void
{
	
/*	bm = BrowserManager.getInstance();                
	bm.init("", "Aula Virtual de Videoconferencias");
	/* The following code will parse a URL that passes firstName and lastName as
	query string parameters after the "#" sign; for example:
	http://www.mydomain.com/MyApp.html#firstName=Nick&lastName=Danger
	var o:Object = URLUtil.stringToObject(bm.fragment, "&");                
	sala = o.view;
	bm.setTitle("Aula Virtual IPXFlex v2.0 - Portal de Videoconferencias");
	mx.controls.Alert.show(sala);
	bm.setFragment("");*/
	pt_completa = false;
	
	this.width = this.parentApplication.pl_principal.width - 50;
	this.height = this.parentApplication.pl_principal.height - 30;
	
	this.videoHBox.x = this.width * 10 / 930;
	this.videoHBox.y = this.height * 15 / 630;
	this.videoHBox.width = this.width * 335 / 930;
	this.videoHBox.height = this.height * 284 / 630;
	
	
	this.videoHBox_escritorio.x = this.width * 390 / 930;
	this.videoHBox_escritorio.y = this.height * 15 / 630;
	this.videoHBox_escritorio.width = (this.width * 511 / 930) - 20;
	this.videoHBox_escritorio.height = (this.height * 433 / 630) - 20;
	
	
	this.txt_cuarto.x = this.width * 10 / 930;
	this.txt_cuarto.y = this.height * 333 / 630;
	this.txt_cuarto.width = this.width * 335 / 930;
	this.txt_cuarto.height = this.height * 124 / 630;
	
	this.txt_mensaje.x = this.width * 10 / 930;
	this.txt_mensaje.y = this.height * 480 / 630;
	this.txt_mensaje.width = this.width * 552 / 930;
	this.txt_mensaje.height = this.height * 52 / 630;

	this.List_usuarios.x = this.width * 611 / 930;
	this.List_usuarios.y = this.height * 477 / 630;
	this.List_usuarios.width = this.width * 280 / 930;
	this.List_usuarios.height = this.height * 65 / 630;
	
	this.lbl_sala.x = this.width * 10 / 930;
	this.lbl_sala.y = this.height * 316 / 630;
	
	this.lbl_usuarios.x = this.width * 611 / 930;
	this.lbl_usuarios.y = this.height * 461 / 630;
	
	this.lbl_mensaje.x = this.width * 10 / 930;
	this.lbl_mensaje.y = this.height * 465 / 630;
	
	this.btn_enviar.x = this.width * 500 / 930;
	this.btn_enviar.y = this.height * 540 / 630;
	
	this.btn_fullscreen.x = this.width * 293 / 930;
	this.btn_fullscreen.y = this.height * 306 / 630;
	
	this.btn_fullscreen_esc.x = this.width * 830 / 930;
	this.btn_fullscreen_esc.y = this.height * 450 / 630;
	
	this.btn_cerrar.x = this.width * 830 / 930;
	this.btn_cerrar.y = this.height * 545 / 630;
	
	
	getProperties();
}
private function inicio():void 
{ 

	this.x = 0;
	this.y = 0;
	
	systemManager.stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenHandler);
	dispState = systemManager.stage.displayState;
	
	pix_x = 800;
	pix_y = 600;

	f_escribe_monitor("Iniciando... Version Plash Player: " + flash.system.Capabilities.version + "\n");
	
	nc = new NetConnection();            	
	nc.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
	nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, netSecurityError);
	
	
	var V_componente:UIComponent = new UIComponent();
	V_video_conferencia = new Video(this.videoHBox.width-30, this.videoHBox.height-50);
	V_componente.addChild(V_video_conferencia);
	videoHBox.addChild(V_componente);

	
	
	var V_componente_escritorio:UIComponent = new UIComponent();
	V_video_escritorio = new Video(this.videoHBox_escritorio.width - 30,  this.videoHBox_escritorio.height -50);
	V_componente_escritorio.addChild(V_video_escritorio);
	videoHBox_escritorio.addChild(V_componente_escritorio);
	
	Click_btn_conectar()
}
//***********************************************************************************************************

private function fullScreenTutor():void {
	full_screen = "tutor";
	fullScreenHandler();
}

//***********************************************************************************************************

private function fullScreenEscritorio():void {
	full_screen = "escritorio";
	fullScreenHandler();
}

private function fullScreenHandler():void {
	
	ocultar_todo();

		if (full_screen == "tutor")
		{
			if (pt_completa == false)
			{
				ampliar_tutor();
				pt_completa = true;
			}
			else
			{
				reducir_tutor();
				pt_completa = false;
			}
			
		}
		else if (full_screen == "escritorio")
		{
			if (pt_completa == false)
			{
				ampliar_escritorio();
				pt_completa = true;
			}
			else
			{
				reducir_escritorio();
				pt_completa = false;
			}
		
		} 
}
//***********************************************************************************************************
private function reducir_escritorio():void
{
	this.videoHBox_escritorio.x = this.width * 390 / 930;
	this.videoHBox_escritorio.y = this.height * 15 / 630;
	this.videoHBox_escritorio.width = this.width * 511 / 930;
	this.videoHBox_escritorio.height = this.height * 433 / 630;
	
	this.btn_fullscreen_esc.x = this.width * 830 / 930;
	this.btn_fullscreen_esc.y = this.height * 456 / 630;
	this.btn_fullscreen_esc.label = "Ampliar";
	
	mostrar_todo();
	
	V_video_escritorio.width = this.videoHBox_escritorio.width - 30;
	V_video_escritorio.height = this.videoHBox_escritorio.height - 50;
}
//***********************************************************************************************************
private function reducir_tutor():void
{
	this.videoHBox.x = this.width * 10 / 930;
	this.videoHBox.y = this.height * 15 / 630;
	this.videoHBox.width = this.width * 335 / 930;
	this.videoHBox.height = this.height * 284 / 630;
	
	
	this.btn_fullscreen.x = this.width * 296 / 930;
	this.btn_fullscreen.y = this.height * 306 / 630;
	this.btn_fullscreen.label = "Ampliar";
	
	mostrar_todo();
	
	V_video_conferencia.width = this.videoHBox.width - 30;
	V_video_conferencia.height = this.videoHBox.height - 50;
}
//***********************************************************************************************************
private function ampliar_escritorio():void
{
	this.btn_fullscreen_esc.visible = true;
	this.btn_fullscreen_esc.label = "Salir de Pantalla Completa";
	this.btn_fullscreen_esc.x = this.width-230;
	this.btn_fullscreen_esc.y = 6;
	
	this.videoHBox_escritorio.visible = true;
	this.videoHBox_escritorio.x = 0;
	this.videoHBox_escritorio.y = 0;
	this.ancho_fs = this.videoHBox_escritorio.width;
	this.alto_fs = this.videoHBox_escritorio.height;
	this.videoHBox_escritorio.width = this.width-20;
	this.videoHBox_escritorio.height = this.height-40;
	
	V_video_escritorio.width = this.videoHBox_escritorio.width - 30;
	V_video_escritorio.height = this.videoHBox_escritorio.height - 50;
}

//***********************************************************************************************************
private function ampliar_tutor():void
{
	this.btn_fullscreen.visible = true;
	this.btn_fullscreen.label = "Salir de Pantalla Completa";
	this.btn_fullscreen.x = this.width-230;
	this.btn_fullscreen.y = 6;
	this.videoHBox.visible = true;
	this.videoHBox.x = 0;
	this.videoHBox.y = 0;
	this.ancho_fs = this.videoHBox.width;
	this.alto_fs = this.videoHBox.height;
	this.videoHBox.width = this.width-20;
	this.videoHBox.height = this.height-40;
	
	V_video_conferencia.width = this.videoHBox.width - 30;
	V_video_conferencia.height = this.videoHBox.height - 50;
}
//***********************************************************************************************************
private function ocultar_todo():void
{
	this.btn_cerrar.visible = false;
	this.videoHBox.visible= false;
	this.videoHBox_escritorio.visible = false;
	this.btn_fullscreen.visible = false;
	this.lbl_sala.visible = false;
	this.lbl_mensaje.visible = false;
	this.lbl_monitor.visible = false;
	this.btn_enviar.visible = false;
	this.txt_cuarto.visible = false;
	this.txt_mensaje.visible = false;
	this.txt_monitor.visible = false;
	this.lbl_usuarios.visible = false;
	this.List_usuarios.visible = false;
	this.btn_fullscreen_esc.visible = false;
}
//***********************************************************************************************************
private function mostrar_todo():void
{
	this.btn_cerrar.visible = true;
	this.videoHBox.visible= true;
	this.videoHBox_escritorio.visible = true;
	this.btn_fullscreen.visible = true;
	this.lbl_sala.visible = true;
	this.lbl_mensaje.visible = true;
	this.btn_enviar.visible = true;
	this.txt_cuarto.visible = true;
	this.txt_mensaje.visible = true;
	this.lbl_usuarios.visible = true;
	this.List_usuarios.visible = true;
	this.btn_fullscreen_esc.visible = true;
}
//***********************************************************************************************************
private function txt_msg_keypress(event:KeyboardEvent):void
{
	if (event.charCode == 13)
	{
		Click_btn_enviar();
	}
}
//***********************************************************************************************************

private function Click_btn_conectar():void
{
	switch(btn_conectar.label){
		case "Conectar":
			btn_conectar.label = "Conectando...";
			btn_conectar.enabled = false;
		//	nc.connect("rtmp://192.168.1.127:1935/chat_test/"+ sala, usuario);
			nc.connect(FMSUrl+ sala, usuario);
			
			nc.client = this;
			
			break;
		case "Desconectar":
			btn_conectar.label = "Conectar";
			btn_conectar.enabled = true;
			nc.close();
			break;
	}
}

private function netSecurityError(event:SecurityErrorEvent):void {
	f_escribe_monitor("netSecurityError: " + event);
}


private function netStatus(event:NetStatusEvent):void 
{
	
	f_escribe_monitor("netStatus: " + event);
	var info:Object = event.info;
	for(var p:String in info) {
		f_escribe_monitor(p + " : " + info[p]);
	}
	f_escribe_monitor("");
	
	switch (info.code) 
	{
		case "NetConnection.Connect.Success" :
			btn_conectar.label = "Desconectar";
			btn_conectar.enabled = true;
			btn_enviar.enabled = true; 
			
			//	this.VD_tutor.source = "rtmp:/chat_test/hola/Sala";
			if (inStream) inStream.close();
			inStream = new NetStream(nc);       
			inStream.play("Sala_"+String(pix_x)+ "_" + String(pix_y));
			inStream.client = this;
			
			V_video_conferencia.attachNetStream(inStream);
			
			
			f_escribe_monitor("Conectando a Obj. Compartido no-persistente ...\n");
			
			if (inStream_escritorio) inStream_escritorio.close();
			inStream_escritorio = new NetStream(nc);       
			inStream_escritorio.play("Escritorio_"+String(pix_x)+ "_" + String(pix_y));
			inStream_escritorio.client = this;
			
			V_video_escritorio.attachNetStream(inStream_escritorio);
			V_video_escritorio.width = this.videoHBox_escritorio.width - 30;
			V_video_escritorio.height = this.videoHBox_escritorio.height - 50;
			
			f_escribe_monitor("Conectando a Obj. Escritorio Compartido no-persistente ...\n");
			
			ro = SharedObject.getRemote("ChatUsers", nc.uri);
			
			
			if(ro){
				ro.addEventListener(SyncEvent.SYNC, OnSync);
				ro.connect(nc);
				ro.client = this;
			}
			getServerTime();
			break;
		case "NetConnection.Connect.Closed" :
			btn_conectar.label = "Conectar";
			btn_conectar.enabled = true;
			btn_enviar.enabled = false;  
			if (inStream) inStream.close();
			break;
		case "NetConnection.Connect.Failed" :
			break;
		case "NetConnection.Connect.Rejected" :
			break;
		default :
			break;
	}
}

private function OnSync(event:SyncEvent):void 
{
	
	var info:Object;
	var currentIndex:Number;
	var currentNode:Object;
	var changeList:Array = event.changeList;
	var temp:Array = new Array();
	
	f_escribe_monitor("---- Obj. Compartido -----");
	for(var p:String in ro.data){ 
		f_escribe_monitor("Sincronicacion> RO: " + p + ": " + ro.data[p]);
		temp.push(ro.data[p]);
	}
	this.List_usuarios.dataProvider = temp; 
	for (var i:Number=0; i < changeList.length; i++) 
	{
		info =  changeList[i];
		for (var k:String in info){
			f_escribe_monitor("Sincronicacion> Lista[" + i + "]." + k + ": " + info[k]);
		}
	}
}


private function echoResult(msg:String):void{
	f_escribe_monitor("echoResult: " + msg + "\n");
	this.txt_hora.text = msg;
}


private function echoStatus(event:Event):void{
	f_escribe_monitor("echoStatus: " + event);
}


private function Click_btn_enviar():void{
	
	nc.call("msgFromClient", null, txt_mensaje.text);
	txt_mensaje.text = "";
}

private function getServerTime():void{
	nc.call("getServerTime", echoResponder,  txt_mensaje.text);
}

public function showMessage(msg:String):void{
	f_escribe_monitor("showMessage: " + msg + "\n");
}

public function setUserID(msg:Number):void{
	f_escribe_monitor("showMessage: " + msg + "\n");
}

public function setHistory(msg:String):void{
	f_escribe_monitor("showHistory: " + msg + "\n");
}

public function msgFromSrvr(msg:String):void{
	if (msg.indexOf("comando:reiniciar_audiencia", 0) > -1) 
	{
		Click_btn_conectar();
		Click_btn_conectar();
	}
	else
	{
		f_escribe_cuarto(msg);	
	}
	
}	


public function f_escribe_monitor(msg:String):void{
	txt_monitor.text += msg + "\n";
	txt_monitor.validateNow();
	txt_monitor.verticalScrollPosition = txt_monitor.maxVerticalScrollPosition;
}

public function f_escribe_cuarto(msg:String):void{
	txt_cuarto.text += msg + "\n";
	txt_cuarto.validateNow();
	txt_cuarto.verticalScrollPosition = txt_cuarto.maxVerticalScrollPosition;
}
//******************************************************************************************************
private function btn_cancelar_click():void
{
	Click_btn_conectar();
	
	PopUpManager.removePopUp(this);	
	
}


private function getProperties():void {
	servicePropReader = new HTTPService();
	servicePropReader.url = "assets/properties.xml";		
	servicePropReader.resultFormat = "e4x";					
	servicePropReader.contentType = "application/xml";
	
	servicePropReader.addEventListener(ResultEvent.RESULT, propertyReaderResultHandler);
	servicePropReader.send();								
}
//*****************************************************************************************************
private function propertyReaderResultHandler(event:ResultEvent):void {
	xmlProperties = XML(event.result);
	FMSUrl = xmlProperties.property.(name=="FMSURL").value;
	inicio();
}

