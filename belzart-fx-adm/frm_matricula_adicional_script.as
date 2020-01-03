import flash.net.URLRequest;
import libreria.*;
import mx.controls.Alert;
import mx.core.Application;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.validators.Validator;
import mx.events.ValidationResultEvent;
import mx.managers.*;
import mx.rpc.events.*;

private var func_mod_fun_idn:String; 

[Bindable]
private var v_arreglo_valida:Array;

//*******************************************************************************************************
public function asigna_matricula (matricula:String):void {
	ro_frm_matricula_adicional.busca_matriculas_por_matriculas(matricula)}

//*******************************************************************************************************
private function inicio():void{
	v_arreglo_valida = new Array();
	v_arreglo_valida.push(this.cmb_sexo);
	v_arreglo_valida.push(this.txt_fecha_nacimiento);
	v_arreglo_valida.push(this.cmb_pais_estudios);
	v_arreglo_valida.push(this.txt_num_contrato);
	v_arreglo_valida.push(this.txt_celular_aval);
	v_arreglo_valida.push(this.txt_num_pasaporte);
	v_arreglo_valida.push(this.cmb_residencia);
	func_mod_fun_idn = Application.application.parameters.func_mod_fun_idn;
	this.txt_rut.restrict = "0-9\K-k"
	this.txt_rut.setFocus();
	this.txt_matric.setFocus();
	limpia()} 


private function error_fx(event:FaultEvent):void{
	Alert.show(event.fault.faultString,"Error");}

private function f_valida_formulario(event:MouseEvent):void {
	ro_frm_matricula_adicional.guarda_datos(this.txt_matric.text, this.txt_fecha_nacimiento.text, this.txt_num_contrato.text, this.txt_celular_aval.text, this.cmb_sexo.selectedItem.data, this.cmb_pais_estudios.selectedItem.data,this.cmb_residencia.selectedItem.data, this.txt_num_pasaporte.text);}

//*******************************************************************************************************
private function btn_grava_datos(event:MouseEvent):void{
	f_valida_formulario(event);}	

//*******************************************************************************************************
private function result_guarda_datos(event:ResultEvent):void{
	if (event.result.length > 0 ){
		mx.controls.Alert.show("Datos Guardados.","Alerta");}	
	else {
		mx.controls.Alert.show("Error al Guardar los Datos.","Alerta");}}

//*******************************************************************************************************
private function limpia():void{
	this.txt_matric.text = "";
	this.txt_nombre.text = "";
	this.txt_rut.text = "";
	this.txt_fecha_nacimiento.text = "";
	this.txt_num_contrato.text = "";
	this.txt_celular_aval.text = "";
	this.txt_num_pasaporte.text = "";
	this.txt_carrera.text = "";
	this.btn_Guardar.enabled = false;
	this.txt_matric.enabled = true;
	this.txt_rut.enabled = true;
	this.txt_nombre.enabled = true;
	this.cmb_sexo.enabled = false;
	this.txt_fecha_nacimiento.enabled = false;
	this.cmb_pais_estudios.enabled = false;
	this.txt_num_contrato.enabled = false;
	this.txt_celular_aval.enabled = false;
	this.btn_busca_matricula.enabled = true;
	this.btn_busca_rut.enabled = true;
	this.txt_num_pasaporte.enabled = false;
	this.cmb_residencia.enabled = false;
	consulta_pais();
	consulta_residencia();
	consulta_sexo();}

//*******************************************************************************************************
private function consulta_residencia():void{
	ro_frm_matricula_adicional.rellena_combo_residencia(func_mod_fun_idn);}

//*******************************************************************************************************
private function result_rellena_combo_residencia(event:ResultEvent):void{
	this.cmb_residencia.dataProvider =  event.result;}

//*******************************************************************************************************
private function consulta_pais():void{
	ro_frm_matricula_adicional.rellena_combo_pais(func_mod_fun_idn);}

//*******************************************************************************************************
private function result_rellena_combo_pais(event:ResultEvent):void{
	this.cmb_pais_estudios.dataProvider =  event.result;}

//*******************************************************************************************************
private function consulta_sexo():void{
	ro_frm_matricula_adicional.rellena_combo_sexo(func_mod_fun_idn);}

//*******************************************************************************************************
private function result_rellena_combo_sexo(event:ResultEvent):void{
	this.cmb_sexo.dataProvider =  event.result;}

//*******************************************************************************************************
private function result_busca_matriculas_por_rut(event:ResultEvent):void{
	if (event.result.length >0 ){
		if (event.result.length ==1){
			this.txt_matric.text = event.result[0].campo_uno;
			this.txt_rut.text = event.result[0].campo_dos;
			this.txt_nombre.text = event.result[0].campo_tres;
			var i: int = 0;
			var indice:int = 0;
			for (i=0;i<cmb_sexo.dataProvider.length;i++){
				if (this.cmb_sexo.dataProvider[i].data == event.result[0].campo_cuatro){
					indice = i;}}
			this.cmb_sexo.selectedIndex = indice;
			var i1: int = 0;
			var indice1:int = 0;
			for (i1=0;i1<cmb_pais_estudios.dataProvider.length;i1++){
				if (this.cmb_pais_estudios.dataProvider[i1].data == event.result[0].campo_seis){
					indice1 = i1;}}
			this.cmb_pais_estudios.selectedIndex = indice1;
			this.txt_fecha_nacimiento.text = event.result[0].campo_cinco;
			this.txt_num_contrato.text = event.result[0].campo_siete;
			this.txt_celular_aval.text = event.result[0].campo_ocho;
			this.txt_num_pasaporte.text = event.result[0].campo_nueve;
			var i2: int = 0;
			var indice2:int = 0;
			for (i2=0;i2<cmb_residencia.dataProvider.length;i2++){
				if (this.cmb_residencia.dataProvider[i2].data == event.result[0].campo_diez){
					indice2 = i2;}}
			this.cmb_residencia.selectedIndex = indice2;
			if (event.result[0].campo_doce == true){
				this.cmb_residencia.visible = false;
				this.txt_num_pasaporte.visible = false;
				this.xx.visible = false;
				this.xx1.visible = false;}
			else{
				this.cmb_residencia.visible = true;
				this.txt_num_pasaporte.visible = true;
				this.xx.visible = true;
				this.xx1.visible = true;}
			this.cmb_residencia.enabled = true;
			this.txt_num_pasaporte.enabled = true;
			this.btn_Guardar.enabled = true;
			this.txt_matric.enabled = false;
			this.txt_rut.enabled = false;
			this.txt_nombre.enabled = false;
			this.cmb_sexo.enabled = true;
			this.txt_fecha_nacimiento.enabled = true;
			this.cmb_pais_estudios.enabled = true;
			this.txt_num_contrato.enabled = true;
			this.btn_busca_matricula.enabled = false;
			this.btn_busca_rut.enabled = false;
			this.txt_celular_aval.enabled = true;}
		else {
			var popup1:frm_matricula_adicional_popup = frm_matricula_adicional_popup(PopUpManager.createPopUp( this, frm_matricula_adicional_popup , true));
			popup1.resultado=event;
			mx.managers.PopUpManager.centerPopUp(popup1)}}
	else {
		mx.controls.Alert.show("No se encontraron matrículas para el rut ingresado","Alerta");}}

//*******************************************************************************************************
private function result_busca_matriculas_por_matriculas(event:ResultEvent):void{
	if (event.result.length >0 ){
		if (event.result.length == 1){
			this.txt_matric.text = event.result[0].campo_uno;
			this.txt_rut.text = event.result[0].campo_dos;
			this.txt_nombre.text = event.result[0].campo_tres;
			var i: int = 0;
			var indice:int = 0;
			for (i=0;i<cmb_sexo.dataProvider.length;i++){
				if (this.cmb_sexo.dataProvider[i].data == event.result[0].campo_cuatro){
				indice = i;}}
			this.cmb_sexo.selectedIndex = indice;
			var i1: int = 0;
			var indice1:int = 0;
			for (i1=0;i1<cmb_pais_estudios.dataProvider.length;i1++){
				if (this.cmb_pais_estudios.dataProvider[i1].data == event.result[0].campo_seis){
					indice1 = i1;}}
			this.cmb_pais_estudios.selectedIndex = indice1;
			this.txt_fecha_nacimiento.text = event.result[0].campo_cinco;
			this.txt_carrera.text = event.result[0].campo_doce;
			this.txt_num_contrato.text = event.result[0].campo_siete;
			this.txt_celular_aval.text = event.result[0].campo_ocho;
			this.txt_num_pasaporte.text = event.result[0].campo_nueve;
			var i2: int = 0;
			var indice2:int = 0;
			for (i2=0;i2<cmb_residencia.dataProvider.length;i2++){
				if (this.cmb_residencia.dataProvider[i2].data == event.result[0].campo_diez){
					indice2 = i2;}}
			this.cmb_residencia.selectedIndex = indice2;
			if (event.result[0].campo_once == true){
				this.cmb_residencia.visible = false;
				this.txt_num_pasaporte.visible = false;
				this.xx.visible = false;
				
				this.xx1.visible = false;}
			else{
				this.cmb_residencia.visible = true;
				this.txt_num_pasaporte.visible = true;
				this.xx.visible = true;
				this.xx1.visible = true;}
			this.cmb_residencia.enabled = true;
			this.txt_num_pasaporte.enabled = true;
			this.btn_Guardar.enabled = true;
			this.txt_matric.enabled = false;
			this.txt_rut.enabled = false;
			this.txt_carrera.enabled = false;
			this.txt_nombre.enabled = false;
			this.cmb_sexo.enabled = true;
			this.txt_fecha_nacimiento.enabled = true;
			this.cmb_pais_estudios.enabled = true;
			this.txt_num_contrato.enabled = true;
			this.txt_celular_aval.enabled = true;
			this.btn_busca_matricula.enabled = false;
			this.btn_busca_rut.enabled = false;}
		else {
			mx.controls.Alert.show("pop","Alerta");}}
	else {
		mx.controls.Alert.show("No se encontraron matrículas para la matrícula ingresada","Alerta");}}

//*******************************************************************************************************
private function result(event:ResultEvent):void{
	if (event.result.length >0 ){
		if (event.result.length ==1){
			this.txt_rut.text=event.result[0].campo_uno;}}
	else {
		mx.controls.Alert.show("");}}
//*******************************************************************************************************
private function valida_rut(rut_temp:String):void{
	var dt:Number
	var dt2:String
	var resto:Number
	var i:Number
	var suma:Number
	var j:Number
	var is_ok:Number
	var us_rut:String 
	var largo:Number
	us_rut = rut_temp
	is_ok = 0
	if (this.txt_rut.length == 12){
		j = 2;
		suma = 0;
		largo = us_rut.length;
		i = us_rut.length - 2;
		while(i>0){
			if (us_rut.substr(i-1, 1) != '.'){
				if (j > 7){
					j = 2;}
				suma = suma + Number(us_rut.substr(i-1, 1)) * j;
				j = j + 1;}
			i--}
		resto = suma % 11;
		dt = 11 - resto;
		dt2 = dt.toString();
		if (dt2 == '10'){
			if (us_rut.substr(largo-1, 1) == 'K'){
				is_ok = 1;}}
		if (dt2 == '11'){
			if (us_rut.substr(largo - 1, 1) == '0'){
				is_ok = 1}}
		if (dt2.substr(0, 1) == us_rut.substr(largo - 1, 1)){
			is_ok = 1}}
	if (is_ok == 0){
		mx.controls.Alert.show('El R.U.T. ingresado no es valido.', 'Ingreso')
		focusManager.setFocus(this.txt_rut);}
	if (is_ok == 1){
		ro_frm_matricula_adicional.busca_matriculas_por_rut(this.txt_rut.text)}}

//*******************************************************************************************************
private function valida_matricula(matric_temp:String):void{
	var dt:Number
	var dt2:String
	var resto:Number
	var i:Number
	var suma:Number
	var j:Number
	var is_ok:Number
	var us_matric:String 
	var largo:Number
	us_matric = matric_temp
	is_ok = 0
	if (this.txt_matric.length == 12){
		j = 2
		suma = 0
		largo = us_matric.length
		i = us_matric.length - 2
		while(i>0){
			if (us_matric.substr(i-1, 1) != '.'){
				if (j > 7){
					j = 2}
				suma = suma + Number(us_matric.substr(i-1, 1)) * j
				j = j + 1}
			i--	}
		resto = suma % 11
		dt = 11 - resto
		dt2 = dt.toString()
		if (dt2 == '10'){
			if (us_matric.substr(largo-1, 1) == 'K'){
				is_ok = 1}}
		if (dt2 == '11'){
			if (us_matric.substr(largo - 1, 1) == '0'){
				is_ok = 1}}
		if (dt2.substr(0, 1) == us_matric.substr(largo - 1, 1)){
			is_ok = 1}}
	if (is_ok == 0)	{
		mx.controls.Alert.show('La matrícula ingresada no es valida.', 'Ingreso')
		focusManager.setFocus(this.txt_matric);}
	if (is_ok == 1)	{
		ro_frm_matricula_adicional.busca_matriculas_por_matriculas(txt_matric.text)}}

//*******************************************************************************************************
private function puntos():void {
	var rut_temp:String;
	if (this.txt_rut.length == 2) {
		this.txt_rut.text = this.txt_rut.text + '.'
		rut_temp = this.txt_rut.text + '.'
		focusManager.setFocus(this.txt_rut);
		this.txt_rut.setSelection(this.txt_rut.length,this.txt_rut.length);}
	if (this.txt_rut.length == 6) {
		this.txt_rut.text = this.txt_rut.text + '.'
		rut_temp = this.txt_rut.text + '.'
		focusManager.setFocus(this.txt_rut);
		this.txt_rut.setSelection(this.txt_rut.length,this.txt_rut.length);}
	if (this.txt_rut.length == 10) {
		this.txt_rut.text = this.txt_rut.text + '-'
		rut_temp = this.txt_rut.text + '.'
		focusManager.setFocus(this.txt_rut);
		this.txt_rut.setSelection(this.txt_rut.length,this.txt_rut.length);}}



//*******************************************************************************************************
private function buscar_rut():void{
	var rut_temp:String = this.txt_rut.text;
	rut_temp = rut_temp.toUpperCase();
	valida_rut(rut_temp);}

//*******************************************************************************************************
private function buscar_matricula():void{
	if (this.txt_matric.length != 11){
		mx.controls.Alert.show("Debe ingresar una matrícula válida", 'Ingreso');}
	else{
		ro_frm_matricula_adicional.busca_matriculas_por_matriculas(this.txt_matric.text)}}

//*******************************************************************************************************
private function txt_rut_presskey(event:KeyboardEvent):void{
	var rut_temp:String = this.txt_rut.text
	rut_temp = rut_temp.toUpperCase()
	if (event.charCode==13){
		valida_rut(rut_temp);}
	else{
		if (event.charCode >= 48 && event.charCode <= 57){
			puntos()}
		else{
			Keyboard.BACKSPACE;}}}

//*******************************************************************************************************
private function txt_matric_presskey(event:KeyboardEvent):void{
	var txt_matric_temp:String = this.txt_matric.text
	txt_matric_temp = txt_matric_temp.toUpperCase()
	if (event.charCode==13){
		buscar_matricula();}}
	
//*******************************************************************************************************
public function btn_nueva_busqueda_click():void{
	limpia();}