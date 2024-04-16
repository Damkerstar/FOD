program untitled;
const
	valorAlto= 9999;
	N = 3;
type
	alimentos = record
		codigo: integer;
		nombre: string;
		descripcion: string;
		stockD: integer;
		stockM: integer;
		precio: real;
	end;
	maestro = file of alimentos;
	
	sucursales = record
		 codigo: integer;
		 cant_V: integer;
	end;
	detalle = file of sucursales;
	
	vector = array [1..N] of detalle;
	vector_S = array [1..N] of sucursales;
	

// GENERAR MAESTRO
procedure generarM(var mae: maestro);
var
	regA: alimentos;
	txt: Text;
begin
	assign(txt, 'info_Maestro.txt');
	reset(txt);
	rewrite(mae);
	while(not eof(txt)) do begin
		with regA do
			readln(txt, codigo, stockD, stockM, precio, nombre, descripcion);
		write(mae, regA);
	end;
	close(txt);
	close(mae);
end;


// GENERAR DETALLE
procedure generarD(var v: vector);
var
	regS: sucursales;
	txt: Text;
	i: integer;
begin
	assign(txt, 'info_Detalle.txt');
	reset(txt);
	for i:= 1 to N do begin
		rewrite(v[i]);
		while(not eof(txt)) do begin
			with regS do
				readln(txt, codigo, cant_V);
			write(v[i], regS);
		end;
		close(v[i]);
	end;
	close(txt);
end;


// Actualizar el maestro y informar en un archivo de texto
procedure leer(var det: detalle ; var S: sucursales);
begin
	if(not eof(det)) then begin
		read(det, S);
	end
	else
		S.codigo:= valorAlto;
end;

procedure minimo(var v : vector;var vS: vector_S; var min: sucursales);
var
	i, pos: integer;
begin
	pos:= 1;
	min.codigo:= valorAlto;
	for i:= 1 to N do begin
		if(vS[i].codigo < min.codigo) then begin
			min:= vS[i];
			pos:= i;
		end;
	end;
	if(min.codigo <> valorAlto) then
		leer(v[pos], vS[pos]);
end;

procedure procesar(var mae: maestro; var v: vector);
var
	regA: alimentos;
	vS: vector_S;
	i: integer;
	min: sucursales;
begin
	reset(mae);
	
	for i:= 1 to N do begin
		reset(v[i]);			// ACORDARSE DE ESCRIBIR ESTE RESET, porque me abre cada archivo para que en el procedimiento en el que estoy, el puntero avanze
									// Si abris en un nuevo procedimiento el archivo y luego lo cerras, acordarse que el puntero se pierde
		leer(v[i], vS[i]);
	end;
	
	minimo(v, vS, min);
	while(min.codigo <> valorAlto) do begin
		read(mae, regA);
		while(min.codigo <> regA.codigo) do
			read(mae, regA);
		while(min.codigo = regA.codigo) do begin
			regA.stockD:= regA.stockD - min.cant_V;
			minimo(v, vS, min);
		end;
		seek(mae, filepos(mae)-1);
		write(mae, regA);
	end;
	close(mae);
	for i:= 1 to N do begin
		close(v[i]);
	end;
end;


{
 LA FORMA DE HACERLO EN UN MISMO PROCEDIMIENTO, ACTUALIZAR Y ESCRIBIR LA INFO EN UN TXT
 No creo que sea lo mejor porque tendrias que escribir doble una instruccion

while(min.codigo <> valorAlto) do begin
		read(mae, regA);
		if(min.codigo = regA.codigo) then begin
			with regA do
				write(txt,'Nombre:', nombre, ', Descripcion:', descripcion, ', stock disponible: ', stockD, ' y precio: ', precio);
		end
		else begin
			while(min.codigo <> regA.codigo) do begin
				read(mae, regA);
				with regA do
					write(txt,'Nombre:', nombre, ', Descripcion:', descripcion, ', stock disponible: ', stockD, ' y precio: ', precio);
			end;
		end;
		while(min.codigo = regA.codigo) do begin
			regA.stockD:= regA.stockD - min.cant_V;
			minimo(v, vS, min);
		end;
end;
}


// Crear e informar en un archivo de texto
procedure Imprimir(var txt: Text);
var
	regA: alimentos;
begin
	reset(txt);
	while(not eof(txt)) do begin
		readln(txt, regA.descripcion);
		with regA do
			writeln(nombre, descripcion, stockD, precio);
	end;
	close(txt);
end;

procedure infoTXT(var mae: maestro);
var
	txt: Text;
	regA: alimentos;
	nombre: string;
begin
	write('Elija un nombre para el archivo de texto: ');
	readln(nombre);
	nombre:= nombre + '.txt';
	assign(txt, nombre);
	rewrite(txt);
	
	reset(mae);
	
	while(not eof(mae)) do begin
		read(mae, regA);
		with regA do begin
			writeln(txt, 'Nombre:', nombre, ', descripcion:', descripcion, ', stock disponible: ', stockD, ' y precio: ', precio);
		end;
	end;
	close(mae);
	close(txt);
	Imprimir(txt);
end;


var
	mae: maestro;
	v: vector;
	num: String;
	i: integer;
BEGIN
	assign(mae, 'arch_Maestro');
	generarM(mae);
	
	for i:= 1 to N do begin
		Str(i,num);				// Str es para pasar de un integer a string, del lado izquierdo el num y del lado derecho la variable
		assign(v[i], 'arch_Detalle'+num);
	end;
	generarD(v);
	
	procesar(mae, v);
	infoTXT(mae);
END.

