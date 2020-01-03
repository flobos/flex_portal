function carga_foros()
{
	ro_foro_alumno.foro_muestra_respuestas("10204");
}
//*********************************************************************************
function result_foro_muestra_respuestas(event)
{
	list.dataProvider = mx.utils.ArrayUtil.toArray(event.result);
}