program untitled;
const
	valorAlto = 999;
	N = 10;
type
	motos = record
		codigo: integer;
		nombre: string;
		descripcion: string;
		modelo: string;
		marca: string;
		stockA: integer;
	end;
	
	ventas = record
		codigo: integer;
		precio: real;
		fecha: string;
	end;
	
	maestro = file of motos;
	detalle = file of ventas;
	
	vectorR = array[1..N] of ventas;
	vector = array[1..N] of detalle;


// CARGAR MAESTRO Y DETALLE
procedure cargarMyD(var mae: maestro; var v: vector);
var
	txt: Text;
	regM: motos;
	regV: ventas;
	i: integer;
	num: string;
begin
	assign(txt, 'info_Maestro.txt');
	reset(txt);
	assign(mae, 'Moto');
	rewrite(mae);
	while(not eof(txt)) do begin
		with regM do begin
			readln(txt, codigo);
			readln(txt, nombre);
			readln(txt, descripcion);
			readln(txt, modelo);
			readln(txt, marca);
			readln(txt, stockA);
		end;
		write(mae, regM);
	end;
	close(txt);
	close(mae);
	
	for i:= 1 to N do begin
		Str(i, num);
		assign(txt, 'info_Detalle'+num+'.txt');
		reset(txt);
		assign(v[i], 'Ventas_'+num);
		rewrite(v[i]);
		while(not eof(txt)) do begin
			with regV do begin
				readln(txt, codigo);
				readln(txt, precio);
				readln(txt, fecha);
			end;
			write(v[i], regV);
		end;
		close(txt);
		close(v[i]);
	end;
end;


// ACTUALIZAR EL MAESTRO Y REPORTAR LA MOTO MAS VENDIDA
procedure leer(var det: detalle; var regV: ventas);
begin
	if(not eof(det)) then
		read(det, regV)
	else
		regV.codigo:= valorAlto;
end;

procedure minimo(var v: vector; var vR: vectorR; var min: ventas);
var
	i, pos: integer;
begin
	pos:= 0;
	min.codigo:= valorAlto;
	for i:= 1 to N do begin
		if(min.codigo > vR[i].codigo) then begin
			min:= vR[i];
			pos:= i;
		end;
	end;
	if(min.codigo <> valorAlto) then
		leer(v[pos], vR[pos]);
end;

procedure maxMoto(cantV, codV: integer; var cMax: integer; var vMax: integer);
begin
	if(cantV > vMax) then begin
		cMax:= codV;
		vMax:= cantV;
	end;
end;

procedure actualizar_y_Reportar_M(var mae: maestro; var v: vector);
var
	regM, ver: motos;
	min: ventas;
	vR: vectorR;
	i, codigoMax, ventaMax: integer;
begin
	reset(mae);
	for i:= 1 to N do begin
		reset(v[i]);
		leer(v[i], vR[i]);
	end;
	
	ventaMax:= -1;
	
	minimo(v, vR, min);
	while(min.codigo <> valorAlto) do begin
		ver.codigo:= min.codigo;
		ver.stockA:= 0;
		while(min.codigo = ver.codigo) do begin
			ver.stockA:= ver.stockA +1;
			minimo(v, vR, min);
		end;
		
		repeat
			read(mae, regM);
		until(regM.codigo = ver.codigo);
		
		if((regM.stockA - ver.stockA) = 0) then begin
			while(regM.stockA > 0) do begin
				regM.stockA:= regM.stockA -1;
				ver.stockA:= ver.stockA -1;
			end;
			writeln('No se pudieron vender ', ver.stockA, ' motos, porque no hay mas stock disponible');
		end
		else begin
			regM.stockA:= regM.stockA - ver.stockA;
		end;
		maxMoto(ver.stockA, ver.codigo, ventaMax, codigoMax);
	end;
	writeln('La moto con mas ventas fue, ', codigoMax, ' con un total de ', ventaMax, ' ventas');
end;


var
	mae: maestro;
	v: vector;
BEGIN
	cargarMyD(mae, v);
	
	actualizar_y_Reportar_M(mae, v);
END.

