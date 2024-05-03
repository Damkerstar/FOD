program untitled;
const
	dmf = 3;
	valorAlto = 9999;
type
	asistentes = record
		nro: integer;
		AyN: string;
		email: string;
		telefono: integer;
		DNI: integer;
	end;
	archivo = file of asistentes;
	vector = array [1..dmf] of archivo;


// INFORMACION OBTENIDA DESDE UN TXT (NO ES LO QUE PIDE PERO ES MAS FACIL DESDE LA COMPU)
procedure cargarV_con_TXT(var v: vector);
var
	txt: Text;
	a: asistentes;
	i: integer;
	num: string;
begin
	for i:= 1 to dmf do begin
		Str(i, num);
		assign(v[i], 'Asistentes'+num);
		assign(txt, 'Info_Asistentes'+num+'.txt');
		rewrite(v[i]);
		reset(txt);
		while(not eof(txt)) do begin
			with a do begin
				readln(txt, nro);
				readln(txt, AyN);
				readln(txt, email);
				readln(txt, telefono);
				readln(txt, DNI);
			end;
			write(v[i], a);
		end;
	end;
end;

// INFORMACION OBTENIDA DESDE TECLADO (LO QUE DICE LA CONSIGNA)
{
procedure cargarV_obt_TECLADO(var v: vector);
var
	a: asistentes;
	i: integer;
	num, userInput: string;
begin
	
	for i:= 1 to dmf do begin
		Str(i, num);
		assign(v[i], 'Asistentes'+num);
		rewrite(v[i]);
		userInput:= 'si';
		while(userInput = 'si') do begin
			with a do begin
				write('Nro de asistente: ');
				readln(a.nro);
				write('Apellido y Nombre: ');
				readln(a.AyN);
				write('Email: ');
				readln(a.email);
				write('Telefono: ');
				readln(a.telefono);
				write('DNI: ');
				readln(a.DNI);
			end;
			write(v[i], a);
			write('Quiere ingresar otro usuario en el mismo archivo: ');
			readln(userInput);
		end;
		close(v[i]);
	end;
end;
}


// ELIMANAR DATOS DEL ARCHIVO DE FORMA LOGICA
procedure leerArch(var arch: archivo; var a: asistentes);
begin
	if(not eof(arch)) then
		read(arch, a)
	else
		a.nro:= valorAlto;
end;

procedure Eliminar_Logico(var v: vector);
var
	a: asistentes;
	i: integer;
begin
	for i:= 1 to dmf do begin
		reset(v[i]);
		leerArch(v[i], a);
		while(a.nro <> valorAlto) do begin
			if(a.nro < 1000) then begin
				a.AyN:= '*'+a.AyN+'*';
				seek(v[i], filepos(v[i])-1);
				write(v[i], a);
			end;
			leerArch(v[i], a);
		end;
		close(v[i]);
	end;
end;


// CORROBORAR SI ESTA BIEN LA ELIMINACION
procedure Imprimir(var v: vector);
var
	a: asistentes;
	i: integer;
begin
	for i:= 1 to dmf do begin
		reset(v[i]);
		leerArch(v[i], a);
		while(a.nro <> valorAlto) do begin
			with a do begin
				writeln(nro);
				writeln(AyN);
				writeln(email);
				writeln(DNI);
				writeln;
			end;
			leerArch(v[i], a);
		end;
		close(v[i]);
	end;
end;

var
	v: vector;
BEGIN
	cargarV_con_TXT(v);
	//cargarV_obt_TECLADO(v);
	Eliminar_Logico(v);
	Imprimir(v);
END.

