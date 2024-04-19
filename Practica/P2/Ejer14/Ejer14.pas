program untitled;
const
	valorAlto = 9999;
	N = 3;
type
	avances = record
		codigoP: integer;
		codigoL: integer;
		cantVL: integer;
		cantV: integer;
		cantVG: integer;
		cantVA: integer;
		cantS: integer;
	end;
	ONG = record
		info: avances;
		nombreP: string;
		nombreL: string;
	end;
	
	maestro = file of ONG;
	detalle = file of avances;
	
	vectorR = array[1..N] of avances;
	vector = array[1..N] of detalle;


// CARGAR MAESTRO Y DETALLE
procedure cargarMyD(var mae: maestro;var v:vector);
var
	txt: Text;
	regO: ONG;
	i: integer;
	num: string;
begin
	assign(txt, 'info_Maestro.txt');
	reset(txt);
	assign(mae, 'ONG');
	rewrite(mae);
	
	while(not eof(txt)) do begin
		with regO do begin
			readln(txt, info.codigoP, nombreP);
			readln(txt, info.codigoL, nombreL);
			readln(txt, info.cantVL, info.cantV, info.cantVG, info.cantVA, info.cantS);
		end;
		write(mae, regO);
	end;
	close(mae);
	close(txt);
	
	for i:= 1 to N do begin
		Str(i, num);
		assign(txt, 'info_Detalle'+num+'.txt');
		reset(txt);
		assign(v[i], 'Detalle'+num);
		rewrite(v[i]);
		while(not eof(txt)) do begin
			with regO do begin
				readln(txt, info.codigoP);
				readln(txt, info.codigoL);
				readln(txt, info.cantVL, info.cantV, info.cantVG, info.cantVA, info.cantS);
			end;
			write(v[i], regO.info);
		end;
		close(txt);
		close(v[i]);
	end;
end;


// ACTUALIZAR MAESTRO
procedure leer(var det:detalle; var regA: avances);
begin
	if(not eof(det)) then
		read(det, regA)
	else
		regA.codigoP:= valorAlto;
end;

procedure minimo(var v: vector; var vR: vectorR; var min: avances);
var
	i, pos: integer;
begin
	pos:= 0;
	min.codigoP:= valorAlto;
	min.codigoL:= valorAlto;
	for i:= 1 to N do begin
		if(vR[i].codigoP < min.codigoP) or ((vR[i].codigoP = min.codigoP) and (vR[i].codigoL < min.codigoL)) then begin
			min:= vR[i];
			pos:= i;
		end;
	end;
	if(min.codigoP <> valorAlto) then
		leer(v[pos], vR[pos]);
end;

procedure actualizarM(var mae:maestro; var v: vector);
var
	regO, ver: ONG;
	min: avances;
	vR: vectorR;
	i: integer;
begin
	reset(mae);
	for i:= 1 to N do begin
		reset(v[i]);
		leer(v[i], vR[i]);
	end;
	
	minimo(v, vR, min);
	while(min.codigoP <> valorAlto) do begin
		ver.info.codigoP:= min.codigoP;
		while(ver.info.codigoP = min.codigoP) do begin
			ver.info.codigoL:= min.codigoL;
			ver.info.cantVL:= 0;
			ver.info.cantVA:= 0;
			ver.info.cantVG:= 0;
			ver.info.cantS:= 0;
			ver.info.cantV:= 0;
			while(ver.info.codigoP = min.codigoP) and (ver.info.codigoL = min.codigoL) do begin
				ver.info.cantVL:= ver.info.cantVL + min.cantVL;
				ver.info.cantVA:= ver.info.cantVA + min.cantVA;
				ver.info.cantVG:= ver.info.cantVG + min.cantVG;
				ver.info.cantS:= ver.info.cantS + min.cantS;
				ver.info.cantV:= ver.info.cantV + min.cantV;
				minimo(v, vR, min);
			end;
			repeat
				read(mae, regO);
			until((regO.info.codigoP = ver.info.codigoP) and (regO.info.codigoL = ver.info.codigoL));
			regO.info.cantVL:= regO.info.cantVL - ver.info.cantVL;
			regO.info.cantVA:= regO.info.cantVA - ver.info.cantVA;
			regO.info.cantVG:= regO.info.cantVG - ver.info.cantVG;
			regO.info.cantS:= regO.info.cantS - ver.info.cantS;
			regO.info.cantV:= regO.info.cantV - ver.info.cantV;
			seek(mae, filepos(mae)-1);
			write(mae, regO);
		end;
	end;
	close(mae);
	for i:= 1 to N do
		close(v[i]);
end;


// INFORMACION EN PANTALLA
procedure reportar(var mae: maestro);
var
	regO: ONG;
	cant: integer;
begin
	reset(mae);
	cant:= 0;
	while(not eof(mae)) do begin
		read(mae, regO);
		if(regO.info.cantV = 0) then
			cant:= cant+1;
	end;
	writeln('La cantidad de viviendas sin chapa son ', cant);
end;


var
	v: vector;
	mae: maestro;
BEGIN
	cargarMyD(mae,v);
	
	actualizarM(mae, v);
	
	reportar(mae);
END.

