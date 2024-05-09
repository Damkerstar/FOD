program untitled;
const
	valorAlto = 9999;
type
	novela = record
		codigo: integer;
		genero: string;
		nombre: string;
		duracion: integer;
		director: string;
		precio: real;
	end;
	
	archivo = file of novela;


// EJER A
// LEER Y CARGAR NOVELAS

procedure leerNovela(var n: novela);
begin
	with n do begin
		write('Codigo: '); readln(codigo);
		if(codigo <> -1) then begin
			write('Genero: '); readln(genero);
			write('Nombre: '); readln(nombre);
			write('Duracion: '); readln(duracion);
			write('Director: '); readln(director);
			write('Precio: '); readln(precio);
		end;
	end;
end;
{
procedure cargarA(var arch: archivo);
var
	n: novela;
	nom: string;
	
begin
	write('Ingrese el nombre del archivo '); readln(nom);
	assign(arch, nom);		// Le asigno un nombre fisico al archivo logico
	rewrite(arch);					// Creo el archivo de lectura y escritura
	n.codigo:= 0;					// El codigo 0 va a ser mi cabecera

	while(n.codigo <> -1) do begin
		writeln;
		write(arch, n);				// Lo escribo en el archivo (es decir que el primero va a ser un registro cabecera)
										// y avanzo el puntero
		leerNovela(n);
	end;
	close(arch);
end;
}

procedure cargarArch(var arch: archivo);
var
	txt: Text;
	n: novela;
begin
	assign(txt, 'info_Detalle.txt');
	reset(txt);
	readln(txt, n.codigo);
	assign(arch, 'a');
	rewrite(arch);
	write(arch, n);
	
	while(not eof(txt)) do begin
		with n do begin
			readln(txt, codigo);
			readln(txt, genero);
			readln(txt, nombre);
			readln(txt, duracion);
			readln(txt, director);
			readln(txt, precio);
		end;
		write(arch, n);
	end;
	close(txt);
	close(arch);
end;



// EJER B
// HACER BAJA AL ARCHIVO
procedure leerArch(var arch: archivo; var n: novela);
begin
	if(not eof(arch)) then
		read(arch, n)
	else
		n.codigo:= valorAlto;
end;

procedure bajaNovela(var arch: archivo);
var
	n, cabe: novela;
	cod: integer;
begin
	reset(arch);
	write('Ingrese el codigo a eliminar '); readln(cod);
	leerArch(arch, cabe);			// Leo la cabecera
	writeln(cabe.codigo);
	
	leerArch(arch, n);			// Leo el siguiente registro para verificar si es el mismo codigo
	
	// Busco el codigo si esta en el archivo (si esta eliminado es lo mismo que no este)
	while((n.codigo <> valorAlto) and (n.codigo <> cod)) do begin
		leerArch(arch, n);			// Leemos en el archivo y avanzamos el puntero
	end;
	
	// Si esta en el archivo y no esta borrado
	if(n.codigo = cod) then begin
		seek(arch, filepos(arch)-1);	// Nos ubicamos en el anterior al puntero
		write(arch, cabe);				// Escribimos la cabecera en el lugar que se va a eliminar el registro
		seek(arch, 0);					// Nos movemos a la cabecera
		n.codigo:= n.codigo*-1;			// Escribimos el codigo de tal manera que se sepa que esta eliminado
		write(arch, n);					// Escribimos el registro eliminado en la cabecera
	end
	else
		writeln('No se encontro el codigo que se estaba buscando o ya esta borrado');
	writeln;
	close(arch);
end;


// MODIFICAR UNA NOVELA
procedure modificarNovela(var arch: archivo);
var
	n: novela;
	cod: integer;
begin
	reset(arch);
	write('Ingrese el codigo de novela'); readln(cod);
	leerArch(arch, n);
	while(n.codigo <> valorAlto) and (n.codigo <> cod) do
		leerArch(arch, n);
	if(n.codigo = cod) then begin
		seek(arch, filepos(arch)-1);
		with n do begin
			write('Genero: '); readln(genero);
			write('Nombre: '); readln(nombre);
			write('Duracion: '); readln(duracion);
			write('Director: '); readln(director);
			write('Precio: '); readln(precio);
		end;
		write(arch, n);
	end;
	writeln;
	close(arch);
end;


// HACER ALTA AL ARCHIVO
procedure altaNovela(var arch: archivo);
var
	n, aux: novela;
begin
	reset(arch);
	// Suponemos que las novelas estan ordenadas, 
		// entonces cada codigo va a tener la posicion y el registro de la novela
	leerArch(arch, aux);		// Tomamos la cabezera
	
	// TIENE QUE SER SI O SI MENOR A 0 porque si es un registro que no esta eliminado
		// quedara con un codigo mayor a 0
		// Si esta eliminado, entonces hay espacio y se debe hacer un cambio del registro nuevo con el eliminado y el eliminado con la cabecera
	if(aux.codigo < 0) then begin
		// abs() toma el valor absoluto del valor pasado
		seek(arch, abs(aux.codigo));		// Nos movemos a la posicion del codigo que se elimino
		read(arch, aux);					// Leemos el archivo en esa posicion y avanzamos el puntero
		seek(arch, filepos(arch)-1);		// Nos movemos a la posicion para modificarlo
		leerNovela(n);						// Leemos la novela a escribir en el archivo
		write(arch, n);						// Escribimos en el archivo la nueva novela
		seek(arch, 0);						// Nos movemos a la cabecera para escribir la anterior novela
		write(arch, aux);					// Escribimos la anterior novela y avanzamos el puntero
	end
	else
		writeln('No hay mas espacio libre en el archivo');
	writeln;
	close(arch);
end;


// EJER C
procedure listarTexto(var arch: archivo);
var
	txt: Text;
	n: novela;
begin
	reset(arch);
	assign(txt, 'novelas.txt');
	rewrite(txt);
	leerArch(arch, n);
	while(n.codigo <> valorAlto) do begin
		if(n.codigo <> 0) then begin
			with n do begin
				writeln(txt, codigo);
				writeln(txt, genero);
				writeln(txt, nombre);
				writeln(txt, duracion);
				writeln(txt, director);
				writeln(txt, precio);
			end;
		end;
		leerArch(arch, n);
	end;
	close(arch);
	close(txt);
	writeln;
end;


// EJERS B y C
// MANTENIMIENTO DEL ARCHIVO
procedure mantenimiento(var arch: archivo);
var
	user: integer;
begin
	writeln;
	writeln('Que desea realizar con el archivo de novelas');
	user:= 0;
	while(user <> 5) do begin
		writeln('1) Dar de alta una novela');
		writeln('2) Dar de baja una novela');
		writeln('3) Modificar una novela');
		writeln('4) Listar en un txt llamado novela');
		writeln('5) Salir');
		write('Opcion '); readln(user);
		case user of
			1: altaNovela(arch);
			2: bajaNovela(arch); 
			3: modificarNovela(arch);
			4: listarTexto(arch);
		end;
	end;
end;


var
	arch: archivo;
BEGIN
	cargarArch(arch);
	mantenimiento(arch);
END.

