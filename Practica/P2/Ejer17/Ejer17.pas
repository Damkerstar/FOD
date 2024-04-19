program untitled;
const
	valorAlto = 999;
type
	informacion = record
		codigoL: integer;
		nombreL: string;
		codigoM: integer;
		nombreM: string;
		codigoH: integer;
		nombreH: string;
		fecha: string;
		cantCPD: integer;
	end;
	
	archivo = file of informacion;


// CARGAR ARCHIVO
procedure cargarA(var arch: archivo);
var
	txt: Text;
	regI: informacion;
begin
	assign(txt, 'info_Archivo.txt');
	assign(arch, 'Informacion');
	reset(txt);
	rewrite(arch);
	while(not eof(txt)) do begin
		with regI do begin
			readln(txt, codigoL, nombreL);
			readln(txt, codigoM, nombreM);
			readln(txt, codigoH, nombreH);
			readln(txt, fecha);
			readln(txt, cantCPD);
		end;
		write(arch, regI);
	end;
	close(txt);
	close(arch);
end;


// INFORMAR EN PANTALLA ARCHIVO
procedure leer(var arch: archivo; var regI: informacion);
begin
	if(not eof(arch))then
		read(arch, regI)
	else
		regI.codigoL:= valorAlto;
end;

procedure reportar(var arch: archivo);
var
	regI, ver: informacion;
	cantL, cantM, cantP: integer;
begin
	reset(arch);
	leer(arch, regI);
	
	cantP:= 0;
	
	while(regI.codigoL <> valorAlto) do begin
		ver.codigoL:= regI.codigoL;
		ver.nombreL:= regI.nombreL;
		cantL:= 0;
		writeln('Nombre: ', ver.nombreL ,' Localida ', ver.codigoL);
		while(ver.codigoL = regI.codigoL) and (ver.nombreL = regI.nombreL) do begin
			ver.codigoM:= regI.codigoM;
			ver.nombreM:= regI.nombreM;
			cantM:= 0;
			writeln('Nombre: ', ver.nombreM, ' Municipio ', ver.codigoM);
			while((ver.codigoL = regI.codigoL) and (ver.nombreL = regI.nombreL)) and ((ver.codigoM = regI.codigoM) and (ver.nombreM = regI.nombreM)) do begin
				ver.codigoH:= regI.codigoH;
				ver.nombreH:= regI.nombreH;
				while((ver.codigoL = regI.codigoL) and (ver.nombreL = regI.nombreL)) and ((ver.codigoM = regI.codigoM) and (ver.nombreM = regI.nombreM))and((ver.codigoH = regI.codigoH) and (ver.nombreH = regI.nombreH)) do begin
					write('Nombre: ', ver.nombreH, ' Hospital ', ver.codigoH);
					write('...........');
					writeln('Cantidad de casos ', regI.cantCPD, ' Hospital ', ver.codigoH);
					leer(arch, regI);
					cantM:= cantM + regI.cantCPD;
				end;
			end;
			writeln('Cantidad de casos del municipio ', ver.codigoM,' son: ', cantM);
			cantL:= cantL + cantM;
		end;
		writeln('Cantidad de casos de la Localidad ', ver.codigoL, ' son: ', cantL);
		cantP:= cantP + cantL;
	end;
	writeln('Cantidad de casos Totales en la Provincia son: ', cantP);
end;


var
	arch: archivo;
BEGIN
	cargarA(arch);
	
	reportar(arch);
END.

