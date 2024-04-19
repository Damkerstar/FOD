program a;
const
	N = 3;
	valorAlto = 'ZZZ';
type
	informacion = record
		fecha: string;
		codigo: integer;
		totalEV: integer;
	end;
	
	registroM = record
		info: informacion;
		nombre: string;
		descripcion: string;
		precio: real;
		totalE: integer;
	end;
	
	maestro = file of registroM;
	detalle = file of informacion;
	
	vectorR = array [1..N] of informacion;
	vector = array [1..N] of detalle;
	
//CARGAR MAESTRO Y DETALLE
procedure cargarMyD(var mae: maestro; var v: vector);
var
	txt: Text;
	regM: registroM;
	i: integer;
	num: string;
begin
	assign(txt, 'info_Maestro.txt');
	reset(txt);
	assign(mae, 'Emisiones');
	rewrite(mae);
	
	while(not eof(txt)) do begin
		with regM do begin
			readln(txt, regM.info.fecha);
			readln(txt, regM.info.codigo);
			readln(txt, regM.info.totalEV);
			readln(txt, regM.nombre);
			readln(txt, regM.descripcion);
			readln(txt, regM.precio);
			readln(txt, regM.totalE);
		end;
		write(mae, regM);
	end;
	close(txt);
	close(mae);
	
	for i:= 1 to N do begin
		Str(i,num);
		assign(txt, 'info_Detalle'+num+'.txt');
		reset(txt);
		assign(v[i], 'Detalle'+num);
		rewrite(v[i]);
		while(not eof(txt)) do begin
			with regM do begin
				readln(txt, regM.info.fecha);
				readln(txt, regM.info.codigo);
				readln(txt, regM.info.totalEV);
			end;
			write(v[i], regM.info);
		end;
		close(txt);
		close(v[i]);
	end;
end;


//ACTUALIZAR MAESTRO
procedure leer(var det:detalle; var regD: informacion);
begin
	if(not eof(det)) then
		read(det, regD)
	else
		regD.fecha:= valorAlto;
end;

procedure minimo(var v: vector; var vR: vectorR; var min: informacion);
var
	i,pos: integer;
begin
	pos:= 0;
	min.fecha:= valorAlto;
	min.codigo:= 999;
	for i:= 1 to N do begin
		if(vR[i].fecha < min.fecha) or((vR[i].fecha = min.fecha) and (vR[i].codigo < min.codigo)) then begin
			min:= vR[i];
			pos:= i;
		end;
	end;
	if(min.fecha <> valorAlto) then
		leer(v[pos], vR[pos]);
end;

procedure actualizarM(var mae: maestro; var v: vector);
var
	regM, ver: registroM;
	vR: vectorR;
	min: informacion;
	i: integer;
begin
	reset(mae);
	for i:= 1 to N do begin
		reset(v[i]);
		leer(v[i], vR[i]);
	end;
	
	minimo(v, vR, min);
	while(min.fecha <> valorAlto) do begin
		ver.info.fecha:= min.fecha;
		while(ver.info.fecha = min.fecha) do begin
			ver.info.codigo:= min.codigo;
			ver.info.totalEV:= 0;
			while(ver.info.fecha = min.fecha)and(ver.info.codigo = min.codigo) do begin
				ver.info.totalEV:= ver.info.totalEV + min.totalEV;
				minimo(v, vR, min);
			end;
			read(mae, regM);
			while((regM.info.fecha <> ver.info.fecha)and(regM.info.codigo <> ver.info.codigo))do begin
				read(mae, regM);
			end;
			
			if((regM.totalE-ver.info.totalEV) < 0) then begin
				regM.info.totalEV:= regM.info.totalEV + regM.totalE;
				while(regM.totalE > 0) do begin
					regM.totalE:= regM.totalE - 1;
					ver.info.totalEV:= ver.info.totalEV -1;
				end;
			writeln('No se pudieron vender ', ver.info.totalEV, ' seminarios, porque no hay mas ejemplares');
			end
			else begin
				regM.totalE:= regM.totalE - ver.info.totalEV;
				regM.info.totalEV:= regM.info.totalEV + ver.info.totalEV;
			end;
			seek(mae, filepos(mae)-1);
			write(mae, regM);
		end;
	end;
	close(mae);
	for i:= 1 to N do
		close(v[i]);
end;


// REPORTAR MAESTRO
procedure reportarM(var mae: maestro);
var
	regM: registroM;
	mini, max: informacion;
begin
	reset(mae);
	while(not eof(mae)) do begin
		read(mae, regM);
		if(regM.totalE < regM.info.totalEV) then begin
			max.codigo:= regM.info.codigo;
			max.fecha:= regM.info.fecha;
			max.totalEV:= regM.info.totalEV;
		end;
		if(regM.totalE > regM.info.totalEV) then begin
			mini.codigo:= regM.info.codigo;
			mini.fecha:= regM.info.fecha;
			mini.totalEV:= regM.info.totalEV;
		end;
	end;
	writeln('La fecha del seminario con mas ventas es: ', max.fecha, ' con un total de ', max.totalEV, ' de ventas');
	writeln('La fecha del seminario con menos ventas es: ', mini.fecha,' con un total de ', mini.totalEV, ' de ventas');
	close(mae);
end;


var
	mae: maestro;
	v: vector;
BEGIN
	cargarMyD(mae, v);
	
	actualizarM(mae, v);
	
	reportarM(mae);
END.
