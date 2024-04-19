program aah;
const
	valorAlto = 9999;
type
	fecha = record
		anio: integer;
		mes: integer;
		dia: integer;
	end;
	
	informacion = record
		fec: fecha;
		idUsuario: integer;
		tiempo: integer;
	end;

	archivo = file of informacion;


// CARGAR EL ARCHIVO QUE YA SE TIENE
procedure cargarA(var arch: archivo);
var
	txt: Text;
	regI: informacion;
begin
	assign(txt, 'info_Archivo.txt');
	assign(arch, 'Archivo');
	reset(txt);
	rewrite(arch);
	while(not eof(txt)) do begin
		with regI do
			readln(txt, fec.anio, fec.mes, fec.dia, idUsuario, tiempo);
		write(arch, regI);
		writeln(regI.idUsuario);
	end;
	close(txt);
	close(arch);
end;


// INFORMAR EN PANTALLA EL AÑO TAL
procedure leer(var arch: archivo; var reg: informacion);
begin
	if(not eof(arch)) then
		read(arch, reg)
	else
		reg.fec.anio:= valorAlto;
end;

procedure buscar(var arch: archivo; var reg: informacion; anio: integer);
begin
	while(reg.fec.anio <> valorAlto) and (reg.fec.anio <> anio) do begin
		if(reg.fec.anio <> anio) then
			leer(arch, reg);
	end;
end;

procedure reportar(var arch: archivo);
var
	regI, ver: informacion;
	usuario, tiempoTD, tiempoTM, tiempoTA: integer;
begin
	reset(arch);
	write('Elija el año que desea mostrar: ');
	readln(usuario);
	
	buscar(arch, regI, usuario);
	if(regI.fec.anio = usuario) then begin
		ver.fec.anio:= regI.fec.anio;
		writeln('Año: ', regI.fec.anio);
		tiempoTA:= 0;
		while(regI.fec.anio = ver.fec.anio) do begin
			ver.fec.mes:= regI.fec.mes;
			writeln(' Mes: ', regI.fec.mes);
			tiempoTM:= 0;
			while(regI.fec.anio = ver.fec.anio) and (regI.fec.mes = ver.fec.mes) do begin
				ver.fec.dia:= regI.fec.dia;
				writeln('  Dia: ', regI.fec.dia);
				while(regI.fec.anio = ver.fec.anio) and (regI.fec.mes = ver.fec.mes) and (regI.fec.dia = ver.fec.dia) do begin
					ver.idUsuario:= regI.idUsuario;
					tiempoTD:= 0;
					while(regI.fec.anio = ver.fec.anio) and (regI.fec.mes = ver.fec.mes) and (regI.fec.dia = ver.fec.dia) and (regI.idUsuario = ver.idUsuario) do begin
						tiempoTD:= tiempoTD + regI.tiempo;
						leer(arch, regI);
					end;
					writeln('	idUsuario ',ver.idUsuario,'	 Tiempo total acceso dia ', ver.fec.dia, ' mes ', ver.fec.mes, ': ', tiempoTD);
					tiempoTM:= tiempoTM + tiempoTD;
				end;
			end;
			tiempoTA:= tiempoTA + tiempoTM;
			writeln('	Tiempo total de acceso mes ', ver.fec.mes, ': ', tiempoTM);
			writeln;
		end;
		writeln('	Total tiempo de acceso anio ', ver.fec.anio, ': ', tiempoTA);
	end
	else
		writeln('Anio no encontrado');
	close(arch);
end;


var
	arch: archivo;
begin
	cargarA(arch);
	
	reportar(arch);
end.
