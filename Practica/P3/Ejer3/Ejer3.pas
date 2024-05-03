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

procedure cargarA(var arch: archivo);
var
	n: novela;
	nom: string;
begin
	write('Ingrese el nombre del archivo'); readln(nom);
	assign(arch, nom);		// Le asigno un nombre fisico al archivo logico
	rewrite(arch);					// Creo el archivo de lectura y escritura
	n.codigo:= 0;					// El codigo 0 va a ser mi cabecera
	
	while(n.codigo <> -1) do begin
		write(arch, n);				// Lo escribo en el archivo (es decir que el primero va a ser un registro cabecera)
										// y avanzo el puntero
		leerNovela(n);
	end;
	close(arch);
end;


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
	write('Ingrese el codigo a eliminar'); readln(cod);
	leerArch(arch, cabe);			// Leo la cabecera
	leerArch(arch, n);			// Leo el siguiente registro para verificar si es el mismo codigo
	
	// Busco el codigo si esta en el archivo (si esta eliminado es lo mismo que no este)
	while((n.codigo <> valorAlto) and (n.codigo <> cod)) do
		leerArch(arch, n);			// Leemos en el archivo y avanzamos el puntero
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
end;


procedure modificarNovela(var arch: archivo);
var
	n: novela;
begin
	
end;


// HACER ALTA AL ARCHIVO
procedure altaNovela(var arch: archivo);
var
	n, aux: novela;
begin
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
end;



// HACER ALTAS Y BAJAS DEL ARCHIVO
procedure mantenimiento(var arch: archivo);
var
	user: integer;
begin
	writeln('Que desea realizar con el archivo de novelas');
	user:= 0;
	reset(arch);
	while(user <> 4) do begin
		writeln('1) Dar de alta una novela');
		writeln('2) Dar de baja una novela');
		writeln('3) Modificar una novela');
		write('Opcion '); readln(user);
		case user of
			1: altaNovela(arch);
			2: bajaNovela(arch); 
			3: modificarNovela(arch);
		end;
	end;
	close(arch);
end;

BEGIN
	
	
END.

