program aaah;
const
	valorAlto = 9999;
type
	logs = record
		nro_Usuario: integer;
		nombre_Usuario: string;
		nombre: string;
		apellido: string;
		cantMailEnviados: integer;
	end;

	genera = record
		nro_Usuario: integer;
		cuentaDestino: string;
		cuerpoMensaje: string;
	end;

	detalle = file of genera;
	maestro = file of logs;


// CARGAR MAESTRO Y DETALLE
procedure cargarMyD(var mae: maestro; var det: detalle);
var
	txt: Text;
	regG: genera;
	regL: logs;
begin
	assign(txt, 'info_Maestro.txt');
	reset(txt);
	assign(mae, 'arch_Maestro');
	rewrite(mae);
	
	while(not eof(txt)) do begin
		with regL do begin
			readln(txt, nro_Usuario);
			readln(txt, nombre_Usuario);
			readln(txt, nombre);
			readln(txt, apellido);
			readln(txt, cantMailEnviados);
		end;
		write(mae, regL);
	end;
	close(txt);
	close(mae);
	
	assign(txt, 'info_Detalle.txt');
	reset(txt);
	assign(det, 'arch_Detalle');
	rewrite(det);
	
	while(not eof(txt)) do begin
		with regG do begin
			readln(txt, nro_Usuario);
			readln(txt, cuentaDestino);
			readln(txt, cuerpoMensaje);
		end;
		write(det, regG);
	end;
	close(txt);
	close(det);
end;


// EJER A, ACTUALIZAR
procedure leer(var det: detalle; var reg: genera);
begin
	if(not eof(det)) then
		read(det, reg)
	else
		reg.nro_Usuario:= valorAlto;
end;

procedure actualizarM(var mae: maestro; var det: detalle);
var
	regL: logs;
	regG: genera;
begin
	reset(mae);
	reset(det);
	
	leer(det, regG);
	while(regG.nro_Usuario <> valorAlto) do begin
		read(mae, regL);
		while(regG.nro_Usuario <> regL.nro_Usuario) do
			read(mae, regL);
		while(regG.nro_Usuario = regL.nro_Usuario) do begin
			regL.cantMailEnviados:= regL.cantMailEnviados + 1;
			leer(det, regG); 
		end;
		seek(mae, filepos(mae)-1);
		write(mae, regL);
	end;
	close(det);
	close(mae);
end;


// EJER B, GUARDAR EN TXT
procedure cargarINFORME(var det: detalle);
var
	txt: Text;
	regG: genera;
begin
	assign(txt, 'Cargar_Reporte.txt');
	reset(txt);
	assign(det, 'informe');
	rewrite(det);
	
	while(not eof(txt)) do begin
		with regG do begin
			readln(txt, nro_Usuario);
			readln(txt, cuentaDestino);
			readln(txt, cuerpoMensaje);
		end;
		write(det, regG);
	end;
	close(txt);
	close(det);
end;

procedure guardarTXT(var mae: maestro; var det: detalle);
var
	regG: genera;
	regL: logs;
	txt: Text;
begin
	assign(txt, 'reporte_TXT.txt');
	rewrite(txt);
	reset(mae);
	cargarINFORME(det);
	reset(det);
	
	leer(det, regG);
	while(regG.nro_Usuario <> valorAlto) do begin
		read(mae, regL);
		while(regL.nro_Usuario <> regG.nro_Usuario) do
			read(mae, regL);
		while(regL.nro_Usuario = regG.nro_Usuario) do begin
			with regL do
				writeln(txt, 'nro_Usuario ', nro_Usuario, ' ------ cantidadMensajesEnviados ', cantMailEnviados);
			leer(det, regG);
		end;
	end;
	close(det);
	close(mae);
	close(txt);
end;


var
	mae: maestro;
	det: detalle;
BEGIN
	cargarMyD(mae, det);
	
	actualizarM(mae, det);
	
	guardarTXT(mae, det);
END.
