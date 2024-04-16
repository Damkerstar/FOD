program untitled;
const
	N = 5;
	valorAlto= 9999;
type
	maquina = record
		cod_usuario: integer;
		fecha: string;
		tiempo_sesion: integer;
	end;
	detalle = file of maquina;
	vector_D = array [1.. N] of detalle;
	
	vector_Reg_M = array [1..N] of maquina;
	
	maestro = file of maquina;
	

// CREAR ARCHIVOS BINARIOS
procedure crearArchivosD(var v: vector_D);
var
	i: integer;
	regM: maquina;
	txt: Text;
	num: string;
begin
	for i:= 1 to N do begin
		Str(i, num);
		assign(txt, 'Info_Maquina_' + num + '.txt');
		reset(txt);
		rewrite(v[i]);
		while(not eof(txt)) do begin
			with regM do
				read(txt, cod_usuario, tiempo_sesion, fecha);
			write(v[i], regM);
		end;
		close(txt);
		close(v[i]);
	end;
end;


// IMPRIMIR
procedure imprimir(var mae: maestro);
var
	regM: maquina;
begin
	reset(mae);
	while(not eof(mae)) do begin
		read(mae, regM);
		with regM do
			writeln('Codigo: ', cod_usuario, ', fecha: ', fecha, ', total tiempo sesion: ', tiempo_sesion);
	end;
	close(mae);
end;


// GENERAR ARCHIVO MAESTRO CON EL ARCHIVO DETALLE
procedure leer(var det: detalle; var regM: maquina);
begin
	if(not eof(det)) then begin
		read(det, regM);
	end
	else begin
		regM.cod_usuario:= valorAlto;
	end;
	writeln('Codi:',regM.cod_usuario);
end;

procedure minimo(var vD: vector_D; var vReg: vector_Reg_M;var min: maquina);
var
	i, pos: integer;
begin
	pos:= 1;
	min.cod_usuario:= valorAlto;
	for i:= 1 to N do begin
		if(vReg[i].cod_usuario < min.cod_usuario) then begin
			min:= vReg[i];
			pos:= i;
			write('pos ',i, ', codigo: ',min.cod_usuario);
		end;
		writeln;
	end;
	if(min.cod_usuario <> valorAlto) then
		leer(vD[pos], vReg[pos]);
end;

procedure generarArchivoM(var mae: maestro; var vD: vector_D);
var
	i: integer;
	v_Ma: vector_Reg_M;
	regA, min: maquina;
begin
	rewrite(mae);
	for i:= 1 to N do begin
		reset(vD[i]);
		writeln(i);
		leer(vD[i],v_Ma[i]);
	end;
	
	minimo(vD, v_Ma, min);
	while(min.cod_usuario <> valorAlto) do begin
		regA:= min;
		while(min.cod_usuario = regA.cod_usuario) do begin
			minimo(vD, v_Ma, min);
			if(min.cod_usuario = regA.cod_usuario) then begin
				regA.tiempo_sesion:= regA.tiempo_sesion + min.tiempo_sesion;
			end;
		end;
		write(mae, regA);
	end;
	close(mae);
	for i:= 1 to N do
		close(vD[i]);
end;


var
	mae: maestro;
	vD: vector_D;
	i: integer;
	num: string;
BEGIN
	assign(mae, 'servidor_Central');
	
	for i:= 1 to N do begin
		Str(i, num);
		assign(vD[i], 'maquina_'+num);
	end;
	crearArchivosD(vD);
	
	generarArchivoM(mae, vD);
	
	imprimir(mae);
END.

