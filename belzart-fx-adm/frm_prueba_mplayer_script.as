
//*******************************************************************************************************
private function inicio():void
{	
	this.hs_volumen.value = 0.75
	this.vd_video.source = "assets/video/video1.flv";
	this.lbl_url.text = this.vd_video.source.toString();
	
}

private function btn_play_click():void
{
	this.vd_video.play();
}


private function btn_stop_click():void
{
	this.vd_video.stop();
}

private function btn_pausa_click():void
{
	this.vd_video.pause();
}

private function ajustar_volumen():void
{
	this.vd_video.volume = this.hs_volumen.value;
}