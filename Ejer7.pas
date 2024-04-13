program Ejer7;
type
	novelas= record
		codigo: integer;
		nombre: string;
		genero: string;
		precio: real;
	end;
	
	arch_log= file of novelas;


// B parte 1
procedure LeerNovela(var nov: novelas);
begin
	writeln();
	writeln('Proporcione los siguientes datos de la novela');
	write('Nombre: ');	readln(nov.nombre);
	write('Genero: ');	readln(nov.genero);
	write('Codigo: ');	readln(nov.codigo);
	write('Precio: ');	readln(nov.precio);
end;

procedure AgregarNovela(var arch: arch_log);
var
	nov: novelas;
begin
	reset(arch);				// Abrimos el archivo binario de lectura y escritura
	LeerNovela(nov);
	seek(arch, filepos(arch)+1);	// Apuntamos con el puntero a la ultimo
	write(arch, nov);			// Escribimos lo que tiene nov en el archivo binario
	close(arch);		// Cerramos el archivo binario
end;


// B parte 2
procedure ModificarNovela(var arch: arch_log);
var
	nov: novelas;
	num: integer;
begin
	reset(arch);		// Abrimos el archivo binario de lectura y escritura
	write('Digame el codigo de novela que desea modificar: ');
	readln(num);
	while(not eof(arch)) do begin		// Mientras no sea el final del archivo del archivo binario
		read(arch, nov);				// Guardamos lo que apunta el puntero en nov y avanzamos el puntero
		if(nov.codigo = num) then begin
			LeerNovela(nov);
			seek(arch, filepos(arch)-1);		// Posicionamos el archivo binario, en donde esta ahora mismo el archivo -1
			write(arch, nov);			// Escribimos lo que tiene nov en el archivo binario
		end;
	end;
	close(arch);		// Cerramos el archivo binario
end;


// Boludeses mias
procedure Imprimir(var arch: arch_log);
var
	nov: novelas;
begin
	reset(arch);					// Abrimos el archivo binario de lectura y escritura
	while(not eof(arch)) do begin	// Mientras no sea el final del archivo del archivo binario
		read(arch, nov);			// Guardamos lo que apunta el puntero en nov y avanzamos el puntero
		with nov do begin
			writeln('Los datos de la novela son: ');
			writeln('Nombre: ', nombre);
			writeln('Codigo: ', codigo);
			writeln('Genero: ', genero);
			writeln('Precio: ', precio);
		end;
	end;
	writeln('No hay mas novelas por imprimir');
	writeln();
	close(arch);	// Cerramos el archivo binario
end;

procedure menu(var arch: arch_log);
var
	userInput: string;
begin
	writeln('Elija una opcion');
	writeln('1) Agregar una nueva novela');
	writeln('2) Modificar una novela');
	writeln('3) Imprimir todas las novelas');
	writeln('4) Salir');
	write('Opcion: ');	readln(userInput);
	while(userInput <> '4') do begin
		case userInput of
			'1': AgregarNovela(arch);
			'2': ModificarNovela(arch);
			'3': Imprimir(arch);
		end;
		write('Elija otra opcion');
		readln(userInput);
	end;
end;


var
	arch: arch_log;
	archText: Text;
	novela: novelas;
	userInput: string;
BEGIN
	write('Dime el nombre del archivo: ');
	readln(userInput);
	assign(arch, userInput);		// Le asignamos un nombre fisico al archivo binario
	rewrite(arch);					// Creamos un archivo binario y lo abrimos de lectura y escritura
	
	assign(archText, 'novelas.txt');	// Asignamos un nombre fisico al archivo de texto
	reset(archText);					// Abrimos el archivo de texto (que ya deberia estar creado) de lectura y escritura
	
	while(not eof(archText)) do begin	// Mientras no sea el final del archivo del archivo de texto
		// escribir readln, no read (tira error) preguntar porque?
		// Guardamos la informacion que tiene el archivo de texto en novela
		readln(archText, novela.codigo, novela.precio, novela.genero);
		// Como esta en la segunda linea entonces debemos leer despues el nombre;
		readln(archText, novela.nombre);
		write(arch, novela);		// Escribimos la novela en el archivo binario
	end;
	close(arch);					// Cerramos el archivo binario
	close(archText);				// Cerramos el archivo de texto
	menu(arch);
END.
