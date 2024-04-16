program untitled;
const
	valorAlto = 'ZZZ';
type
	alfabetizacion = record
		nombre: string;
		cant_A: integer;
		total_E: integer;
	end;
	
	agencias = record
		nombre: string;
		codigo: integer;
		cant_A: integer;
		cant_E: integer;
	end;

	maestro = file of alfabetizacion;
	detalle = file of agencias;


// Cargar el archivo maestro
procedure cargarM(var mae: maestro);
var
	regA: alfabetizacion;
	txt: Text;
begin
	rewrite(mae);
	assign(txt, 'info_Maestro.txt');
	reset(txt);
	while(not eof(txt)) do begin
		with regA do
			readln(txt, cant_A, total_E, nombre);
		write(mae, regA);
	end;
	close(txt);
	close(mae);
end;


// Cargar archivo detalle
procedure generarD(var d: detalle; num: integer);
var
	regA: agencias;
	txt: Text;
	nombre: string;
begin
	rewrite(d);
	if(num = 1) then
		nombre:= 'info_Detalle1.txt'
	else
		nombre:= 'info_Detalle2.txt';

	assign(txt, nombre);
	reset(txt);
	while(not eof(txt)) do begin
		with regA do begin
			readln(txt, codigo, cant_A, cant_E, nombre);
		end;
		write(d, regA);
	end;
	close(txt);
	close(d);
end;


// Verificaciones
// Verificacion de si no es el end of file
procedure leer(var d: detalle;var reg: agencias);
begin
	if(not eof(d)) then
		read(d, reg)
	else
		reg.nombre:= valorAlto;
end; 

// Verificacion de cual es mas chico, si los dos son iguales tira a m como el valor mas alto
procedure min(var d1: detalle; var d2: detalle;var regA1, regA2: agencias; var m: agencias);
begin
	if(regA1.nombre < regA2.nombre) then begin
		m:= regA1;
		leer(d1, regA1);
	end
	else if(regA2.nombre < regA1.nombre) then begin
		m:= regA2;
		leer(d2, regA2);
	end
	else
		m.nombre:= valorAlto;
end;


var
	d1, d2: detalle;
	mae: maestro;
	m, regA1, regA2: agencias;
	regA: alfabetizacion;
BEGIN
	assign(mae, 'alfabetizacion');
	assign(d1, 'agencia 1');
	assign(d2, 'agencia 2');
	
	cargarM(mae);
	reset(mae);
	
	generarD(d1, 1);
	generarD(d2, 2);
	reset(d1);
	reset(d2);
	
	leer(d1, regA1);
	leer(d2, regA2);
	min(d1, d2, regA1, regA2, m);
	
	while(m.nombre <> valorAlto) do begin
		read(mae, regA);
		while(regA.nombre <> m.nombre) do
			read(mae, regA);
		while(regA.nombre = m.nombre) do begin
			regA.cant_A:= regA.cant_A + m.cant_A;
			regA.total_E:= regA.total_E + m.cant_E;
			min(d1, d2, regA1, regA2, m);
		end;
		seek(mae, filepos(mae)-1);
		write(mae, regA);
	end;
END.

