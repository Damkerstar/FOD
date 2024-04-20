program untitled;
const
	valorAlto = 999;
	N = 2;
type
	informacion = record
		nroPN: integer;
		nombre: string;
		apellido: string;
		matriculaM: integer;
	end;
	
	direccion_D = record
		calle: integer;
		nro: integer;
		piso: integer;
		depto: integer;
		ciudad: string;
	end;
	
	familiar = record
		nombre: string;
		apellido: string;
		DNI: integer;
	end;
	
	nacimientos = record
		info: informacion;
		direccionD: direccion_D;
		padre: familiar;
		madre: familiar;
	end;
	
	fallecimientos = record
		info: informacion;
		fecha: string;
		hora: integer;
		lugar: string;
	end;
	
	
	fallecimientosM = record
		fallecio: string;
		matriculaM: integer;
		fecha: string;
		hora: integer;
		lugar: string;
	end;
	
	maestros = record
		nacimiento: nacimientos;
		fallecimiento: fallecimientosM;
	end;
	
	
	maestro = file of maestros;
	detalleF = file of fallecimientos;
	detalleN = file of nacimientos;
	
	vectorN = array[1..N] of detalleN;
	vectorF = array[1..N] of detalleF;
	vectorRN = array[1..N] of nacimientos;
	vectorRF = array[1..N] of fallecimientos;


// CARGAR ARCHIVOS DETALLES
procedure cargarD(var vF: vectorF; var vN: vectorN);
var
	regN: nacimientos;
	regF: fallecimientos;
	txt: Text;
	i: integer;
	num: string;
begin
	for i:= 1 to N do begin
		Str(i, num);
		assign(txt, 'info_Fallecimiento'+num+'.txt');
		reset(txt);
		assign(vF[i], 'Fallecimiento'+num);
		rewrite(vF[i]);
		while(not eof(txt)) do begin
			with regF do begin
				readln(txt, info.nroPN);
				readln(txt, info.nombre);
				readln(txt, info.apellido);
				readln(txt, info.matriculaM);
				readln(txt, fecha);
				readln(txt, hora);
				readln(txt, lugar);
			end;
			write(vF[i], regF);
		end;
		close(vF[i]);
		close(txt);
		
		assign(txt, 'info_Nacimiento'+num+'.txt');
		reset(txt);
		assign(vN[i], 'Nacimiento'+num);
		rewrite(vN[i]);
		while(not eof(txt)) do begin
			with regN do begin
				readln(txt, info.nroPN);
				readln(txt, info.nombre);
				readln(txt, info.apellido);
				readln(txt, info.matriculaM);
				readln(txt, direccionD.calle);
				readln(txt, direccionD.nro);
				readln(txt, direccionD.piso);
				readln(txt, direccionD.depto);
				readln(txt, direccionD.ciudad);
				readln(txt, padre.nombre);
				readln(txt, padre.apellido);
				readln(txt, padre.DNI);
				readln(txt, madre.nombre);
				readln(txt, madre.apellido);
				readln(txt, madre.DNI);
			end;
			write(vN[i], regN);
		end;
		close(vN[i]);
		close(txt);
	end;
end;


// CREAR Y CARGAR MAESTRO
procedure leerN(var detN: detalleN; var regN: nacimientos);
begin
	if(not eof(detN)) then
		read(detN, regN)
	else
		regN.info.nroPN:= valorAlto;
end;

procedure leerF(var detF: detalleF; var regF: fallecimientos);
begin
	if(not eof(detF)) then begin
		read(detF, regF);
	end
	else
		regF.info.nroPN:= valorAlto;
end;

procedure minimo(var vN: vectorN;var vF: vectorF; var vRN: vectorRN; var vRF: vectorRF; var minN: nacimientos; var minF: fallecimientos);
var
	i, pos: integer;
begin
	pos:= 0;
	minN.info.nroPN:= valorAlto;
	minF.info.nroPN:= valorAlto;
	for i:= 1 to N do begin
		if(vRN[i].info.nroPN < minN.info.nroPN) then begin
			minN:= vRN[i];
			pos:= i;
		end;
	end;
	if(minN.info.nroPN <> valorAlto) then begin
		leerN(vN[pos], vRN[pos]);
		i:= 1;
		while({CONDICION QUE NO SE}) and(minN.info.nroPN <> vRF[i].info.nroPN) do begin
			if(minN.info.nroPN = vRF[i].info.nroPN) then begin
				minF:= vRF[i];
				leerF(vF[i], vRF[i]);
			end;
			writeln(vRF[i].info.nroPN);
			i:= i+1;
		end;
	end;
end;

procedure crearyCargarM(var mae: maestro;vF: vectorF; vN: vectorN);
var
	vRF: vectorRF;
	vRN: vectorRN;
	regM: maestros;
	minN: nacimientos;
	minF: fallecimientos;
	i, dml: integer;
begin
	dml:= 0;
	assign(mae, 'Maestro_FyN');
	rewrite(mae);
	for i:= 1 to N do begin
		reset(vF[i]);
		reset(vN[i]);
		leerN(vN[i], vRN[i]);
		leerF(vF[i], vRF[i]);
	end;
	
	minimo(vN, vF, vRN, vRF, minN, minF);
	while(minN.info.nroPN <> valorAlto) do begin
		regM.nacimiento:= minN;
		if(minN.info.nroPN = minF.info.nroPN) then begin
			regM.fallecimiento.fallecio:= 'Fallecio';
			regM.fallecimiento.fecha:= minF.fecha;
			regM.fallecimiento.hora:= minF.hora;
			regM.fallecimiento.matriculaM:= minF.info.matriculaM;
			regM.fallecimiento.lugar:= minF.lugar;
		end;
		write(mae, regM);
		minimo(vN, vF, vRN, vRF, minN, minF, dml);
	end;
	close(mae);
	for i:= 1 to N do begin
		close(vF[i]);
		close(vN[i]);
	end;
end;


// LISTAR EN UN TXT
procedure leerM(var mae: maestro; var regM: maestros);
begin
	if(not eof(mae)) then
		read(mae, regM)
	else
		regM.nacimiento.info.nroPN:= valorAlto;
end;
procedure listarTXT(var mae: maestro);
var
	txt: Text;
	regM: maestros;
begin
	reset(mae);
	assign(txt, 'info_Personas.txt');
	rewrite(txt);
	
	leerM(mae, regM);
	while(regM.nacimiento.info.nroPN <> valorAlto) do begin
		with regM.nacimiento do begin
			writeln(txt, info.nroPN);
			writeln(txt, info.nombre);
			writeln(txt, info.apellido);
			writeln(txt, info.matriculaM);
			writeln(txt, direccionD.calle,' ', direccionD.nro,' ', direccionD.piso,' ', direccionD.depto,' ', direccionD.ciudad);
			writeln(txt, padre.nombre);
			writeln(txt, padre.apellido);
			writeln(txt, padre.DNI);
			writeln(txt, madre.nombre);
			writeln(txt, madre.apellido);
			writeln(txt, madre.DNI);
		end;
		writeln(txt, '-----');
		if(regM.fallecimiento.fallecio <> 'Fallecio') then begin
			with regM.fallecimiento do begin
				writeln(txt, fallecio);
				writeln(txt, matriculaM);
				writeln(txt, fecha);
				writeln(txt, hora);
				writeln(txt, lugar);
			end;
		end
		else
			writeln(txt, 'No fallecio');
		writeln(txt, '-----');
		leerM(mae, regM);
	end;
	close(txt);
	close(mae);
end;


var
	mae: maestro;
	vN: vectorN;
	vF: vectorF;
BEGIN
	cargarD(vF, vN);
	
	crearyCargarM(mae, vF, vN);
	
	listarTXT(mae);
END.

