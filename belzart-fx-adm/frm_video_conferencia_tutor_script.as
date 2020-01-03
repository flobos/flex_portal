import flash.events.*;
import flash.net.*;
import flash.utils.*;

import libreria.obj_dos_campos;

import mx.collections.ArrayCollection;
import mx.controls.*;
import mx.core.UIComponent;
import mx.events.*;
import mx.events.ListEvent;
import mx.managers.BrowserManager;
import mx.managers.IBrowserManager;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import mx.rpc.http.HTTPService;
import mx.utils.URLUtil;

private var transmision_online:Boolean = false;
private var xmlProperties:XML; 
private var servicePropReader:HTTPService; 
private var FMSUrl:String; 
[Bindable]
private var enviar_mensaje:Boolean = false;
[Bindable]
private var fuente_texto:int;
[Bindable]
private var lista_usuarios:Array = new Array;
NetConnection.defaultObjectEncoding = flash.net.ObjectEncoding.AMF0;
//NetStream.defaultObjectEncoding     = flash.net.ObjectEncoding.AMF0;
SharedObject.defaultObjectEncoding  = flash.net.ObjectEncoding.AMF0;

private var echoResponder:Responder = new Responder(echoResult, echoStatus);
private var nc:NetConnection;
public var ro:SharedObject;
private var netStream		:NetStream;
private var netStream_escritorio		:NetStream;
private var camara			:Camera;
private var camara_escritorio:Camera;
private var microfono		:Microphone;
public  var nick			:String;
public  var nick_escritorio	:String;
private var camera:Camera;
public var sala:String;
public var func_mod_fun_idn:String;
private var usuario:String;
public var conf_idn:String;
private var pix_x:int;
private var pix_y:int;

private var camara_tutor:int = -1;
private var camara_esc:int = -1;

private function init():void
{
	this.getProperties();
	
}
//***********************************************************************************************************
private function inicio():void 
{	
	
	this.getProperties();
	fuente_texto = 8;
	pix_x = 800;
	pix_y = 600;
//	sala = sala;
	ro_gestion_conferencias.obtiene_usuario(func_mod_fun_idn);
	this.txt_sala.text = "Sala: " + sala;
	f_escribe_monitor("Iniciando... Version Plash Player: " + flash.system.Capabilities.version + "\n");
	nc = new NetConnection();            	
	nc.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
	nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, netSecurityError);
	iniciar_conferencia();
} 


//***********************************************************************************************************
private function result_obtiene_usuario(event:ResultEvent):void
{
	if (event.result.length <1 )
	{
		mx.controls.Alert.show("No se pudo obtener el nombre de usuario. Intente nuevamente","ERROR");
		btn_cancelar_click();	
	}
	else
	{
	
		usuario = "*"  +event.result[0].label+"* " + event.result[0].data ;
		txt_usuario.text = "Usuario: " + usuario;
		
		Click_btn_conectar();
	}
}
//***********************************************************************************************************
private function iniciar_conferencia():void
{
	
	this.txt_estado.text = "Estado: Iniciada";
	this.btn_conecta.enabled = true;
	this.btn_finalizar_conferencia.enabled = true;
}
//******************************************************************************************************
private function finalizar_conferencia():void
{
	mx.controls.Alert.show("¿Realmente desea finalizar la Conferencia?", "Finalizar Conferencia", 3, this, finalizar_conferencia_handler);
}
//******************************************************************************************************
private function finalizar_conferencia_handler(event:CloseEvent):void
{
	if (event.detail==Alert.YES)
	{
		Click_btn_conectar();
//		ro_gestion_conferencias.finalizar_conferencia(sala);
//		this.parentApplication.inicio();
		btn_cancelar_click();	
		
	}
}
//******************************************************************************************************
private function btn_cancelar_click():void
{
	mx.controls.Alert.show("Seleccione la Conferencia correspondiente y presione el botón Finalizar para concluir la conferencia","Alerta");
	PopUpManager.removePopUp(this);	
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
private function conectar():void
{
	this.camara_tutor = this.cmb_camaras.selectedIndex;
	this.camara_esc = this.cmb_camaras_escritorio.selectedIndex;
	this.transmision_online = true;
	Click_btn_conectar()
	Click_btn_conectar()
	this.btn_comenzar.enabled = false;
	mx.controls.Alert.show("Seleccione nuevamente las cámaras para iniciar la transmisión online","Alerta");
	
}


private function Click_btn_conectar():void
{	
	
	switch(btn_conecta.label){
		case "Conectar":
			
			btn_conecta.label = "Conectando..";
			btn_conecta.enabled = false;
			nc.connect(FMSUrl+ sala, usuario);
			nc.client = this;
			
		break;
		case "Desconectar":
			
			btn_conecta.label = "Conectar";
			btn_conecta.enabled = true;
			if (netStream) netStream.close();
			nc.close();
			break;
		}
}	

private function netSecurityError(event:SecurityErrorEvent):void {
	mx.controls.Alert.show("netSecurityError");
	f_escribe_monitor("netSecurityError: " + event);
}


private function cambio_camara():void
{
	if (this.cmb_camaras.selectedIndex > 0)
	{
		netStream = new NetStream(nc);
		netStream.client = this;
		
		nick="Sala_"+String(pix_x)+ "_" + String(pix_y);
		camara = Camera.getCamera((cmb_camaras.selectedIndex - 1).toString());
		
		
		camara.setMode(pix_x, pix_y, 30);
	//	camara.setLoopback(true);
		camara.setQuality(0, 70);
		
		
		
		if(camara != null){
			netStream.attachCamera(camara);
			VD_tutor.attachCamera(camara);
		}
		
		if(this.transmision_online)
		{
			netStream.receiveAudio(true);
			netStream.publish(nick, "record");
			reiniciar_alumnos();
		}
		
		
		
		
		microfono = Microphone.getMicrophone();
		
		if(microfono != null){
			microfono.setLoopBack(false);
			netStream.attachAudio(microfono);
		}
		
		f_escribe_monitor("Publicando Video Conferencia y Obj. Comp. no-persistente ...\n");
	}
}	
private function cambio_camara_escritorio():void
{
	
	if (this.cmb_camaras_escritorio.selectedIndex > 0)
	{
		netStream_escritorio = new NetStream(nc);
		netStream_escritorio.client = this;
		
		nick_escritorio= "Escritorio_"+String(pix_x)+ "_" + String(pix_y);
		camara_escritorio =  Camera.getCamera((cmb_camaras_escritorio.selectedIndex - 1).toString());
		camara_escritorio.setMode(pix_x, pix_y, 12);
		//camara_escritorio.setLoopback(true);
		camara_escritorio.setQuality(0, 70);
		if(camara_escritorio != null){
			netStream_escritorio.attachCamera(camara_escritorio);
			VD_escritorio.attachCamera(camara_escritorio);
		}
		netStream_escritorio.receiveAudio(true);
		
		if (this.transmision_online)
		{
			netStream_escritorio.publish(nick_escritorio, "record");
			f_escribe_monitor("Publicando Video Escritorio y Obj. Comp. no-persistente ...\n");	
			reiniciar_alumnos();
		}
		
		
	}
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
			
			
			
			btn_conecta.label = "Desconectar";
			
			btn_conecta.enabled = true;
			this.enviar_mensaje = true;
			////////////////////////////////////
			
			nick="Sala";
			nick_escritorio= "Escritorio";
			
			
			
			var arreglo_camaras:ArrayCollection = new ArrayCollection;
			var n_camaras:Object = Camera.names;
			var i:int;
			
			
			var o_dos_campos:obj_dos_campos = new obj_dos_campos;
			o_dos_campos.data = "0";
			o_dos_campos.label = "-- Seleccione una Cámara --";
			
			arreglo_camaras.addItem(o_dos_campos);
			
			for (i=0; i<n_camaras.length; i++)
			{
				var ob_dos_campos:obj_dos_campos = new obj_dos_campos;
				ob_dos_campos.data = i.toString();
				ob_dos_campos.label = Camera.names[i].toString();
				
				arreglo_camaras.addItem(ob_dos_campos);
			}
			
			this.cmb_camaras.dataProvider = arreglo_camaras;
			this.cmb_camaras_escritorio.dataProvider = arreglo_camaras;
			
			
			
			ro = SharedObject.getRemote("ChatUsers", nc.uri);
			if(ro){
				ro.addEventListener(SyncEvent.SYNC, OnSync);
				ro.connect(nc);
				ro.client = this;
				
			}
			getServerTime();
			break;
		case "NetConnection.Connect.Closed" :
			btn_conecta.label = "Conectar";
			btn_conecta.enabled = true;
			btn_enviar.enabled = false;
			
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
	this.lista_usuarios = temp;
//	this.List_usuarios.dataProvider = temp; 
	
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
	this.txt_fecha_servidor.text = msg;
}


private function echoStatus(event:Event):void{
	f_escribe_monitor("echoStatus: " + event);
}


private function Click_btn_enviar():void{
	
	nc.call("msgFromClient", null, txt_mensaje.text);
	txt_mensaje.text = "";
}

private function reiniciar_alumnos():void{
	
	nc.call("msgFromClient", null, "comando:reiniciar_audiencia");
//	txt_mensaje.text = "";
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
	f_escribe_cuarto(msg);
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
}// ActionScript file

private function ns_fuente_texto_changeHandler(event:NumericStepperEvent):void
{
	// TODO Auto-generated method stub
	this.fuente_texto = this.ns_fuente_texto.value;
}

//******************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString, "Error");
}

//*****************************************************************************************************
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
}	
