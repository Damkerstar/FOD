program ejer7;
const
	N = 10;
	valorAlto = 9999;
type
	municipios = record
		codigoL: integer;
		codigoC: integer;
		cantCA: integer;
		cantCN: integer;
		cantCR: integer;
		cantCF: integer;
	end;

	ministerio = record
		codigoL: integer;
		nombreL: string;
		codigoC: integer;
		nombreC: integer;
		cantCA: integer;
		cantCN: integer;
		cantCR: integer;
		cantCF: integer;
	end;

	detalle = file of municipios;
	vectorD = array [1..N] of detalle;
	vectorMuni = array [1..N] of municipios;
	
	maestro = file of ministerio;


// CARGAMOS LOS ARCHIVOS DETALLE Y MAESTRO CON ARCHIVOS DE TEXTO
procedure cargarMyD(var mae: maestro; var vD: vectorD);
var
	i: integer;
	num: string;
	regMu: municipios;
	regMi: ministerio;
	txt: Text;
begin
	assign(mae, 'arch_Maestro');
	assign(txt, 'info_Maestro');
	reset(txt);
	rewrite(mae);
	while(not eof(txt)) do begin
		with regMi do begin
			read(txt, codigoL); read(txt, nombreL); read(txt, codigoC); read(txt, nombreC); read(txt, cantCA); read(txt, cantCN); read(txt, cantCR); read(txt, cantCF);
		end;
		write(mae, regMi);
	end;
	close(mae);
	close(txt);
	
	for i:= 1 to N do begin
		Str(i, num);
		assign(txt, 'info_Detalle'+num+'.txt');
		reset(txt);
		assign(vD[i], 'arch_Detalle'+num);
		rewrite(vD[i]);
		while(not eof(txt)) do begin
			with regMu do begin
				read(txt, codigoL); read(txt, codigoC); read(txt, cantCA); read(txt, cantCN); read(txt, cantCR); read(txt, cantCF);
			end;
			write(vD[i], regMu);
		end;
		close(txt);
		close(vD[i]);
	end;
end;


// ACTUALIZAR ARCHIVOS
procedure leer(var d: detalle; var reg: municipios);
begin
	if(not eof(d)) then begin
		read(d, reg);
	end
	else begin
		reg.codigoL:= valorAlto;
		reg.codigoC:= valorAlto;
	end;
end;

procedure minimo(var vD: vectorD; var vR: vectorMuni; var min: municipios);
var
	i, pos: integer;
begin
	pos:= 0;
	min.codigoL:= valorAlto;
	min.codigoC:= valorAlto;
	for i:= 1 to N do begin
		if((vR[i].codigoL < min.codigoL) or (vR[i].codigoC < min.codigoC)) then begin
			min:= vR[i];
			pos:= i;
		end;
		{if (registro[i].cod < min.cod) then begin
				min:= registro[i];
				indiceMin:= i;
		end
		else
		if (registro[i].cod = min.cod)and (registro[i].cepa < min.cepa)then begin
			min:= registro[i];
			indiceMin:= i;
		end;}
	end;
	if((min.codigoL <> valorAlto) and (min.codigoC <> valorAlto)) then
		leer(vD[pos], vR[pos]);
end;

procedure actualizarM(var mae: maestro;var vD: vectorD);
var
	i: integer;
	vR: vectorMuni;
	regM: ministerio;
	min: municipios;
begin
	reset(mae);
	for i:= 1 to N do begin
		reset(vD[i]);
		leer(vD[i], vR[i]);
	end;
	minimo(vD, vR, min);
	while((min.codigoL <> valorAlto) or (min.codigoC <> valorAlto)) do begin
		read(mae, regM);
		while((regM.codigoL <> min.codigoL) and (regM.codigoC <> min.codigoC)) do
			read(mae, regM);
		while((regM.codigoL = min.codigoL) or (regM.codigoC = min.codigoC)) do begin
			regM.cantCF:= regM.cantCF + min.cantCF;
			regM.cantCR:= regM.cantCR + min.cantCR;
			regM.cantCA:= min.cantCA;
			regM.cantCN:= min.cantCN;
			seek(mae, filepos(mae)-1);
			write(mae, regM);
			minimo(vD, vR, min);
		end;
	end;
	close(mae);
	for i:= 1 to N do begin
		close(vD[i]);
	end;
end;


// IMPRIMIR LOCALIDADES CON MAS DE cantCA
procedure imprimir(var mae: maestro);
var
	reg: ministerio;
	cant: integer;
begin
	reset(mae);
	cant:= 0;
	while(not eof(mae)) do begin
		read(mae, reg);
		if(reg.cantCA > 50) then
			cant:= cant+1;
	end;
	write('La cantidad de localidades con mas de 50 casos activos son: ', cant);
	close(mae);
end;


var
	mae: maestro;
	vD: vectorD;
begin
	cargarMyD(mae, vD);
	actualizarM(mae, vD);
	imprimir(mae);
end.
