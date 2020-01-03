//import libreria_alm.*;
import flash.events.Event;
import flash.utils.Timer;
import flash.xml.*;

import libreria.*;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.MenuEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.*;
import mx.rpc.http.HTTPService;


private var chatURL:String;
private var iplacexURL:String;
private var xmlProperties:XML; 
private var servicePropReader:HTTPService; 

private var menuTimer:Timer;
private var fastMenuTimer:Timer;
private var menuVisible:Boolean;
[Bindable]
private var showMenuButton:Boolean;



public var tc_idn:String;
public var tipo_prueba:String;
public var pro_eva_idn:String;
public var eje_aca_idn:String;
public var alu_idn:String;
public var mat_idn:String;
public var mal_idn:String;
public var tip_idn:String;
public var trabajo:String;
public var nota:String;
public var archivo:String;	
public var encargado:String;
public var mal_nombre:String;
public var cur_nombre:String;
public var tiempo_prueba:String;
public var conf_idn:String;


public var url_frame:URLRequest;
[Bindable]
public var moduloSeleccionado:String;


[Embed(source="imagenes/mostrarmenu.jpg")]
private var mostrarMenu:Class

[Embed(source="imagenes/mostrarmenu2.jpg")]
private var mostrarMenu2:Class

[Embed(source="imagenes/ocultarmenu.jpg")]
private var ocultarMenu:Class

[Embed(source="imagenes/ocultarmenu2.jpg")]
private var ocultarMenu2:Class

//***********************************************************************************************************
public function carga():void
{   getProperties();
	showMenu();
	tree_menu.enabled=false;
	pl_principal.visible = false;
	
	
	//  efecto de menu	
	//	hideMenu();
	//	initMenuMoveOn.play();
	//	
	
	var popup1:frm_pop_seguridad = frm_pop_seguridad(PopUpManager.createPopUp( this, frm_pop_seguridad , true));
	mx.managers.PopUpManager.centerPopUp(popup1)
	
	var x:Number = flash.system.Capabilities.screenResolutionX/2;
	var y:Number = flash.system.Capabilities.screenResolutionY/2;
	
	var x_less:Number = popup1.width/2;
	var y_less:Number = popup1.height;
	
	popup1.x = x-x_less;
	popup1.y = y-y_less;
	
}

//***********************************************************************************************************
private function pop_up_mensaje(modal:Event) :void
{	
	
	var popup2:frm_mensaje = frm_mensaje(PopUpManager.createPopUp( this, frm_mensaje , true));
	mx.managers.PopUpManager.centerPopUp(popup2)
	//	var popup2:frm_mensaje = new frm_mensaje(mx.managers.PopUpManager.addPopUp(frm_mensaje, this, true));
	//	var popup2 = mx.managers.PopUpManager.createPopUp(this, frm_mensaje, true);
	
	var x:Number = flash.system.Capabilities.screenResolutionX/2;
	var y:Number = flash.system.Capabilities.screenResolutionY/2;
	
	var x_less:Number = popup2.width/2;
	var y_less:Number = popup2.height;
	
	popup2.x = x-x_less;
	popup2.y = y-y_less;
	
	
}

//***********************************************************************************************************

private function pop_up_frm_matriculas(modal:Event) :void
{
	pl_principal.visible = false;
	
	this.ro_alumnos_main.registro_login(this.alu_idn);
	
	var popup2:frm_matriculas = frm_matriculas(PopUpManager.createPopUp( this, frm_matriculas , true));
	mx.managers.PopUpManager.centerPopUp(popup2)
	
	var x:Number = flash.system.Capabilities.screenResolutionX/2;
	var y:Number = flash.system.Capabilities.screenResolutionY/2;
	
	var x_less:Number = popup2.width/2;
	var y_less:Number = popup2.height;
	
	popup2.x = x-x_less;
	popup2.y = y-y_less;
	
}
//***********************************************************************************************************
private function result_muestra_menus_aula_virtual(event:ResultEvent):void
{
	//	var arreglo1:ArrayCollection;
	
	//--------------------------   ASIGNA RESULTADO A ARREGLO   -----------------------------	
	
	var arreglo_menu:ArrayCollection = new ArrayCollection;
	var x:int;
	
	for( x = 0; x < event.result.length ; x++ )
	{
		var o_tres_campos:obj_tres_campos = new obj_tres_campos;
		o_tres_campos.campo_uno = event.result[x].campo_uno
		o_tres_campos.campo_dos = event.result[x].campo_dos
		o_tres_campos.campo_tres = event.result[x].campo_tres
		arreglo_menu.addItem(o_tres_campos);
	}
	
	tree_menu.dataProvider = devuelve_xml(arreglo_menu);
	tree_menu.enabled =  true;
	
	
	moduloSeleccionado="frm_mensajeria_alumno.swf"
	
	this.ro_alumnos_main.verifica_email_alumno(this.alu_idn);
	
	
	
	//	moduloSeleccionado= "frm_mensajeria_alumno.swf";
	//	moduloSeleccionado="frm_mensajeria_alumno.swf";
	
	//	mx.controls.Alert.show(devuelve_xml(arreglo_menu));
	
	//	tree_menu.dataProvider = resutado_a_xml(arreglo1);
	//	mx.controls.Alert.show(resutado_a_xml(arreglo1));
}

private function result_verifica_email_alumno(event:ResultEvent):void
{
	if ((event.result[0].campo_uno == null)||(event.result[0].campo_uno.length < 3))
	{
		var popup2:frm_ingreso_email = frm_ingreso_email(PopUpManager.createPopUp( this, frm_ingreso_email , true));
		popup2.alu_idn = this.alu_idn;
		mx.managers.PopUpManager.centerPopUp(popup2)
		
		var x:Number = flash.system.Capabilities.screenResolutionX/2;
		var y:Number = flash.system.Capabilities.screenResolutionY/2;
		
		var x_less:Number = popup2.width/2;
		var y_less:Number = popup2.height;
		
		popup2.x = x-x_less;
		popup2.y = y-y_less;
	}
	
}
//***********************************************************************************************************
//***********************************************************************************************************
private function devuelve_xml(arreglo:ArrayCollection):XMLList
{
	var i:int;
	var menu_p:String="";
	
	var s_lista:String="<?xml version='1.0' encoding='utf-8'?>" + "\n";
	
	if(arreglo.length > 0)
	{	for(i=0;i<arreglo.length;i++)
	{
		s_lista = s_lista + "<node data='" + arreglo[i].campo_uno + "' url='" + arreglo[i].campo_tres +"' label='" + arreglo[i].campo_dos + "'/>" + "\n"
		
	}
	}
	return XMLList(s_lista);
}

//***********************************************************************************************************


private function mb_principal_change(event:MenuEvent) :void
{
	
	
	if(String(event.item.@data) == 'frm_despacho')
	{
		moduloSeleccionado="frm_despacho.swf";
	}
	else if(String(event.item.@data) == 'frm_pagos')
	{
		moduloSeleccionado="frm_pagos.swf";
	}	
	else if(String(event.item.@data) == 'frm_calendarios')
	{
		moduloSeleccionado="frm_calendarios.swf";
	}
	else if(String(event.item.@data) == 'frm_fuc_muestra')
	{
		moduloSeleccionado="frm_fuc_muestra.swf";
	}
		/*//*************
		else if(String(event.attributes.data) == 'frm_Preguntas')
		{
		loader_pantalla.contentPath = librerias.f_trim('frm_ver_preguntas_frec3.swf') + ".swf"
		}	
		//************
		*/
		
	else if(String(event.item.@data) == 'frm_fuc_ingreso')
	{
		moduloSeleccionado="frm_fuc_ingreso.swf";
	}
	else if(String(event.item.@data) == 'frm_cuestionario2')
	{
		moduloSeleccionado="frm_cuestionario2.swf"
	}	
		
	else if(String(event.item.@data) == 'frm_ver_preguntas_frec3')
	{
		moduloSeleccionado="frm_ver_preguntas_frec3.swf";
	}	
		
	else if (String(event.item.@data) == chatURL)
	{
		url_frame = new URLRequest(chatURL);
		navigateToURL(url_frame , "_blank");
		
	}
	else if (String(event.item.@data) == 'reglamento_general.pdf')
	{
		url_frame = new URLRequest(iplacexURL  + event.item.@data);
		navigateToURL(url_frame, "_blank");
	}
	else if (String(event.item.@data) == 'certificados')
	{
		url_frame = new URLRequest("docs/PG_7_5_1_IT03_ANEXO07_Req_Valor_Certif_Car_2011.pdf");
		navigateToURL(url_frame, "_blank");
	}
	else if (String(event.item.@data) == 'info_pruebas')
	{	
		if (event.item.@eje_idn == '366'){
			url_frame = new URLRequest("docs/InfoGeneral_CalendarioPruebas_PRO JUNIO2010_CED.pdf");
			navigateToURL(url_frame, "_blank");
		}
		else if (event.item.@eje_idn == '367'){
			url_frame = new URLRequest("docs/InfoGeneral_CalendarioPruebas_PRO AGOSTO2010_CED.pdf");
			navigateToURL(url_frame, "_blank");
		}
		else if (event.item.@eje_idn == '368'){
			url_frame = new URLRequest("docs/InfoGeneral_CalendarioPruebas_PRO OCTUBRE2010_CED.pdf");
			navigateToURL(url_frame, "_blank");
		}
		else if (event.item.@eje_idn == '369'){
			url_frame = new URLRequest("docs/InfoGeneral_CalendarioPruebas_PRO_DICIEMBRE2010_CED.pdf");
			navigateToURL(url_frame, "_blank");
		}
		else if (event.item.@eje_idn == '310'){
			url_frame = new URLRequest("docs/InfoGeneral_CalendarioPruebas_PRIMAVERA_2010_CED.pdf");
			navigateToURL(url_frame, "_blank");
		}
		else if (event.item.@eje_idn == '406'){
			url_frame = new URLRequest("docs/InfoGeneral_CalendarioPruebas_Otono_2011_CED.pdf");
			navigateToURL(url_frame, "_blank");
		}
		else if (event.item.@eje_idn == '370'){
			url_frame = new URLRequest("docs/InfoGeneral_CalendarioPruebas_PRO_ABRIL_2011_CED.pdf");
			navigateToURL(url_frame, "_blank");
		}
			
		else if (event.item.@eje_idn == '371'){
			url_frame = new URLRequest("docs/InfoGeneral_CalendarioPruebas_PRO_JUNIO_2011_CED.pdf");
			navigateToURL(url_frame, "_blank");
		}
		else if (event.item.@eje_idn == '373'){
			url_frame = new URLRequest("docs/InfoGeneral_CalendarioPruebas_PRO_OCTUBRE_2011_CED.pdf");
			navigateToURL(url_frame, "_blank");
		}
		else if (event.item.@eje_idn == '372'){
			url_frame = new URLRequest("docs/InfoGeneral_CalendarioPruebas_PRO_AGOSTO2011_CED.pdf");
			navigateToURL(url_frame, "_blank");
		}
		else if (event.item.@eje_idn == '472'){
			url_frame = new URLRequest("docs/InfoGeneral_CalendarioPruebas_Otoño_2012_CED.pdf");
			navigateToURL(url_frame, "_blank");
		}
		else if (event.item.@eje_idn != null){
			url_frame = new URLRequest("docs/InfoGeneral_CalendarioPruebas_PRO_ABRIL2010_CED.pdf");
			navigateToURL(url_frame, "_blank");
		}
	}	 
	else if (String(event.item.@data) == 'calen_master')
	{
		url_frame = new URLRequest("docs/InfoGeneral_CalendarioPruebas_Master.pdf");
		navigateToURL(url_frame, "_blank");
	}	
	else if (String(event.item.@data) == 'regla_master')
	{
		url_frame = new URLRequest("docs/Reglamento_General_Master.pdf");
		navigateToURL(url_frame, "_blank");
	}		
	else if (String(event.item.@data) == 'mandato.pdf')
	{
		url_frame = new URLRequest("docs/mandato.pdf");
		navigateToURL(url_frame, "_blank");
	}		
	else if (String(event.item.@data) == 'acreditacion.pdf')
	{
		url_frame = new URLRequest("docs/Info_Acreditacion_Sedes.pdf");
		navigateToURL(url_frame, "_blank");
	}
	else if (String(event.item.@data) == 'frm_pretoma_alumno')
	{
		moduloSeleccionado="frm_pretoma_alumno.swf";
	}	
	else
	{
		//		moduloSeleccionado = undefined;
		
		tc_idn = event.item.@data;
		
		eje_aca_idn = event.item.@eje_aca_idn;
		
		lbl_ramo.text  = event.item.@label;
		
		
		
	}
}


//***********************************************************************************************************
private function formatea_xml_menu(src:Object):XMLDocument
{
	var tree:XMLDocument = new XMLDocument();
	var i:int;
	var node_a:XMLNode=tree.createElement("menuitem");
	node_a.attributes['label']='Ramos';
	node_a.attributes['data']="";
	tree.appendChild(node_a);
	
	
	if (src.length == 0)
	{
		var nodea:XMLNode=tree.createElement("menuitem");
		nodea.attributes['label']="No tiene tomas de curso activas";
		nodea.attributes['data']="";
		nodea.attributes['eje_aca_idn'] = "";
		node_a.appendChild(nodea);
	}
	else
	{
		for(i = 0; i < src.length; i++ ) 
		{
			nodea=tree.createElement("menuitem");
			nodea.attributes['label']=src[i].campo_dos;
			nodea.attributes['data']=src[i].campo_tres;
			nodea.attributes['eje_aca_idn'] = src[i].campo_cuatro;
			node_a.appendChild(nodea);
			
		}
	}
	
	var node_b:XMLNode=tree.createElement("menuitem");
	node_b.attributes['label']='Toma Ramos';
	node_b.attributes['data']="";
	tree.appendChild(node_b); 
	
	var node_toma:XMLNode=tree.createElement("menuitem");
	node_toma.attributes['label']='1Âº- Seleccione Ramos';
	node_toma.attributes['data']='frm_pretoma_alumno';
	node_b.appendChild(node_toma);
	
	var node_d:XMLNode=tree.createElement('menuitem');
	node_d.attributes['label']='Despacho';
	node_d.attributes['data']='frm_despacho';
	tree.appendChild(node_d) 
	
	var nodeb:XMLNode=tree.createElement('menuitem');
	nodeb.attributes['label']='Ver Despacho';
	nodeb.attributes['data']='frm_despacho';
	node_d.appendChild(nodeb);
	
	var node_c:XMLNode=tree.createElement('menuitem');
	node_c.attributes['label']='Pagos';
	node_c.attributes['data']='frm_pagos';
	tree.appendChild(node_c);
	
	var nodec:XMLNode=tree.createElement('menuitem');
	nodec.attributes['label']='Ver Pagos';
	nodec.attributes['data']='frm_pagos';
	node_c.appendChild(nodec);
	
	 var node_calen:XMLNode=tree.createElement('menuitem');
	node_calen.attributes['label']='Calendario';
	node_calen.attributes['data']='';
	
	tree.appendChild(node_calen);
	
	var nodecalen:XMLNode=tree.createElement('menuitem');
	nodecalen.attributes['label']='Calendario Acadamico';
	nodecalen.attributes['data']='frm_calendarios';
	nodecalen.attributes['tipo']='calen';
	node_calen.appendChild(nodecalen);
	
	/*if (lbl_tip_prod_idn.text == '100' && src.length > 0)
	{	
		var nodecalen2:XMLNode=tree.createElement('menuitem');
		nodecalen2.attributes['label']='Info. General Calendario Pruebas';
		nodecalen2.attributes['data']='info_pruebas';
		nodecalen2.attributes['tipo']='calen';
		nodecalen2.attributes['eje_idn'] = src[0].campo_cinco;
		node_calen.appendChild(nodecalen2);
	} */
	
	if (lbl_tip_prod_idn.text != '107')
	{		
		/*	var node_RA:XMLNode=tree.createElement('Reglamento Acadï¿½mico');
		node_RA.attributes['label']='Reglamento Acadï¿½mico';
		node_RA.attributes['data']='reglamento_academico.pdf';
		
		tree.appendChild(node_RA) 
		
		var nodeRA:XMLNode=tree.createElement('Reglamento General');	
		nodeRA.attributes['label']='Reglamento General';
		nodeRA.attributes['data']='reglamento_general.pdf';
		node_RA.appendChild(nodeRA);*/
	}
	else
	{
		var node_RA:XMLNode=tree.createElement('menuitem');
		node_RA.attributes['label']='Documentos';
		node_RA.attributes['data']='0';
		
		tree.appendChild(node_RA) 
		/*
		var nodeRA:XMLNode=tree.createElement('Reglamento General');	
		nodeRA.attributes['label']='Reglamento General';
		nodeRA.attributes['data']='regla_master';
		node_RA.appendChild(nodeRA);		
		*/
		
		/*    var nodeRB:XMLNode=tree.createElement('Calendarios');	
		nodeRB.attributes['label']='Calendario';
		nodeRB.attributes['data']='calen_master';
		node_RA.appendChild(nodeRB);			
		*/
	}
	
	var node_PAC:XMLNode=tree.createElement('menuitem');
	node_PAC.attributes['label']='Documentos';
	node_PAC.attributes['data']='documentos';
	tree.appendChild(node_PAC);
	
	var nodePAC:XMLNode=tree.createElement('menuitem');	
	nodePAC.attributes['label']='Mandato P.A.C.';
	nodePAC.attributes['data']='mandato.pdf';
	node_PAC.appendChild(nodePAC);	
	
	var nodePAC2:XMLNode=tree.createElement('menuitem');	
	nodePAC2.attributes['label']='AcreditaciÃ³n Sedes';
	nodePAC2.attributes['data']='acreditacion.pdf';
	node_PAC.appendChild(nodePAC2);	
	
	var nodePAC3:XMLNode=tree.createElement('menuitem');	
	nodePAC3.attributes['label']='Certificados';
	nodePAC3.attributes['data']='certificados';
	node_PAC.appendChild(nodePAC3);
	
	var node_f:XMLNode=tree.createElement('menuitem');
	node_f.attributes['label']='Consultas';
	node_f.attributes['data']='Consultas';
	tree.appendChild(node_f);
	
	var nodef:XMLNode=tree.createElement('menuitem');
	nodef.attributes['label']='Ingresar Consulta';
	nodef.attributes['data']='frm_fuc_ingreso';
	node_f.appendChild(nodef);
	
	var nodeg:XMLNode=tree.createElement('menuitem');
	nodeg.attributes['label']='Estado Consultas';
	nodeg.attributes['data']='frm_fuc_muestra';
	node_f.appendChild(nodeg);		
	
	
	/* //................
	var nodeg:XMLNode=tree.createElement('Preguntas_Frecuentes');
	nodeg.attributes['label']='Preguntas Frecuentes';
	nodeg.attributes['data']='frm_Preguntas';
	node_f.appendChild(nodeg);	
	
	//................
	*/
	
	
	if (lbl_tip_prod_idn.text == '100')
	{
		var node_chat:XMLNode=tree.createElement('menuitem');
		node_chat.attributes['label']='Chat';
		node_chat.attributes['data']='';
		
		tree.appendChild(node_chat);
		
		var nodechat:XMLNode=tree.createElement('menuitem');
		nodechat.attributes['label']='Ingresar Chat';
		nodechat.attributes['data']=chatURL;
		node_chat.appendChild(nodechat);		
	}
	
	/*  var node_enc:XMLNode=tree.createElement('Encuestas');
	node_enc.attributes['label']='Encuestas';
	node_enc.attributes['data']='';
	
	tree.appendChild(node_enc);
	
	var nodeenc:XMLNode=tree.createElement('Ver Encuestas');
	nodeenc.attributes['label']='Ver Encuestas';
	nodeenc.attributes['data']='frm_cuestionario2';
	node_enc.appendChild(nodeenc);*/
	
	
	
	
	var node_enc:XMLNode=tree.createElement('menuitem');
	node_enc.attributes['label']='Preguntas';
	node_enc.attributes['data']='';
	
	tree.appendChild(node_enc);
	
	var nodeenc:XMLNode=tree.createElement('menuitem');
	nodeenc.attributes['label']='Ver Preguntas ';
	nodeenc.attributes['data']='frm_ver_preguntas_frec3';
	node_enc.appendChild(nodeenc);
	
	return tree;
}
//***********************************************************************************************************
private function result_muestra_toma_cursos_principal(event:ResultEvent):void
{
	var obj_menu:Object;
	var arreglo_menu:ArrayCollection = new ArrayCollection;
	obj_menu = event.result;
	//	for( x = 0; x < event.result.length ; x++ )
	//	{
	//		var o_cuatro_campos:obj_cuatro_campos = new obj_cuatro_campos;
	//		o_cuatro_campos.campo_uno = obj_menu[x].campo_uno
	//		o_cuatro_campos.campo_dos = obj_menu[x].campo_dos
	//		o_cuatro_campos.campo_tres = obj_menu[x].campo_tres
	//		o_cuatro_campos.campo_cuatro = obj_menu[x].campo_cuatro
	//		arreglo_menu.addItem(o_cuatro_campos);
	//	}
	var tree:XMLDocument = formatea_xml_menu(obj_menu);
	var tree_list:XMLList = XMLList(tree.toString())
	mb_principal.dataProvider = tree_list;
	
	ro_alumnos_main.pretoma_valida_pretoma_abierta(lbl_mat_idn.text)
	
	

	//parentApplication.pop_up_mensaje(true)
}
//***********************************************************************************************************
//***********************************************************************************************************
[Bindable]
public var selectedNode:Object;

private function click_tree_menu(event:Event):void
{
	var url:String;
	var tip_menu:String;
	selectedNode = Tree(event.target).selectedItem;
	url=String(selectedNode.@url);
	tip_menu=String(selectedNode.@data);
	
//	this.ro_alumnos_main.registro_acceso_menu(this.tc_idn, tip_menu);
	if(lbl_ramo.text != "") {
		//	if(lbl_tip_prod_idn.text == '107' || lbl_tip_prod_idn.text == '100'){
		if(librerias.f_trim(url) == "frm_notas.swf") {
			ro_alumnos_main.verifica_deuda_notas(librerias.f_trim(lbl_mat_idn.text));
		}
		else{
			
			moduloSeleccionado = "" + librerias.f_trim(url) + ".swf";
			
			
		}
		
		
		//	}
		//	else {
		//		if (url != "")
		//		{
		//			moduloSeleccionado="" + String(url)+ ".swf";
		//			
		//		}	
		//	}
		
	}
	else
	{	
		mx.controls.Alert.show("Seleccione un ramo antes de continuar", "InformaciÃ³n");
	}	
}

//***********************************************************************************************************
private function result_verifica_deuda_notas(event:ResultEvent):void
{
	
	var arreglo1:Object;
	arreglo1 = event.result;
	if (arreglo1.length > 0){
		if (lbl_tip_prod_idn.text == '107')
		{	
			if(Number(arreglo1[0].campo_tres) > 2)
			{
				mx.controls.Alert.show('Estimado(a) Alumno(a):' + '\n\n' + 'Se informa a Usted que si se encuentra moroso, deberÃ¡ poner al dÃ­a sus cuotas, pues al figurar con cuotas impagas no podrÃ¡ visualizar las notas de sus exÃ¡menes.  Para regularizar su situaciÃ³n debe comunicarse al fono 071-613110' + '\n\n' + 'Atentamente,' + '\n\n' + 'IP Iplacex', 'InformaciÃ³n');
			}
			else
			{
				moduloSeleccionado="frm_notas.swf";
				
			}
		}
		else if(lbl_tip_prod_idn.text == '100')
		{
			if(Number(arreglo1[0].campo_tres) > 1)
			{
				mx.controls.Alert.show('Estimado(a) Alumno(a):' + '\n\n' + 'Se informa a Usted que si se encuentra moroso, deberÃ¡ poner al dÃ­a sus cuotas, pues al figurar con cuotas impagas no podrÃ¡ visualizar sus notas.', 'InformaciÃ³n');
			}
			else
			{
				moduloSeleccionado="frm_notas.swf";
				//				
			}			
		}
		else 
		{
			moduloSeleccionado="frm_notas.swf";
			//			
		}
	}
	else{
		moduloSeleccionado="frm_notas.swf";
		//		
	}
}


private function result_pretoma_valida_pretoma_abierta(event:ResultEvent):void{

 var arreglo100:Object;
	arreglo100 = event.result
	
	if (arreglo100.length < 1){
	
	moduloSeleccionado="frm_mensajeria_alumno.swf"	
		
		
	}
	else{
		
	moduloSeleccionado="frm_pretoma_alumno.swf";
		
	} 

}

//***********************************************************************************************************
private function result_muestra_tipo_prod(event:Event):void
{
	
}
//***********************************************************************************************************
private function btn_matriculas_click():void
{
	
	
	var popup1:frm_matriculas = frm_matriculas(PopUpManager.createPopUp( this, frm_matriculas , true));
	mx.managers.PopUpManager.centerPopUp(popup1)
	
}
//***********************************************************************************************************
private function btn_cerrar_click(event:Event):void
{
	//	this.loader_pantalla.contentPath = undefined;
}
//***********************************************************************************************************
private function mouseAction(event:Event):void{
	showMenu();
}                           
//***********************************************************************************************************
private function showMenu():void{
	if(!menuVisible){
		initMenuMoveOn.play();
		menuVisible = true;
		this.btnShowMenu.setStyle("icon",ocultarMenu);
		this.btnShowMenu.setStyle("overIcon",ocultarMenu2);
	} else{
		initMenuMoveOff.play();
		menuVisible = false;
		this.btnShowMenu.setStyle("icon",mostrarMenu);
		this.btnShowMenu.setStyle("overIcon",mostrarMenu2);
	}
}

//***********************************************************************************************************            
private function result_carga_documentos_producto(event:Event):void
{
	
}

//***********************************************************************************************************            
private function formatea_fecha(date:Date):String {
	return dfconv.format(date);
}
//***********************************************************************************************************
private function error_fx(event:FaultEvent):void
{
	mx.controls.Alert.show(event.fault.faultString,"Error");
}
//***********************************************************************************************************

public function levantar_popup(popup:frm_video_conferencia_alumno):void
{
	mx.managers.PopUpManager.centerPopUp(popup);
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
//******************************************************************************************F***********
private function propertyReaderResultHandler(event:ResultEvent):void {
	xmlProperties = XML(event.result);
	chatURL = xmlProperties.property.(name=="chatURL").value;
	iplacexURL = xmlProperties.property.(name=="iplacexURL").value;

}	

