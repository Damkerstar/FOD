program Ejers5y6;
type
	celulares = record
		codigo: integer;
		nombre: string;
		descripcion: string;
		marca: string;
		precio: real;
		stockMin: integer;
		stockDis: integer;
	end;
	
	arch_log= file of celulares;


// 6 - A
procedure LeerCelular(var cel: celulares);
begin
	with cel do begin
		write('Ingrese el codigo: ');
		readln(codigo);
		write('Ingrese el nombre: ');
		readln(nombre);
		write('Ingrese la descripcion: ');
		readln(descripcion);
		write('Ingrese la marca: ');
		readln(marca);
		write('Ingrese el precio: ');
		readln(precio);
		write('Ingrese el stock minimo: ');
		readln(stockMin);
		write('Ingrese el stock disponible');
		readln(stockDis);
	end;
	writeln;
end;

procedure agregar(var arch: arch_log);
var
	cel: celulares;
	userInput: string;
begin
	reset(arch);			// Abrir el archivo binario de lectura y escritura
	userInput:= 'si';
	while(userInput = 'si') do begin
		LeerCelular(cel);
		seek(arch, filesize(arch)+1);			// Posiciono el puntero del archivo al final del archvio
		write(arch, cel);						// Escribo en el archivo y muevo el puntero al siguiente
		write('Quiere ingresar otro celular nuevo?');
		readln(userInput);
		writeln;
	end;
	close(arch);			// Cierro el archivo
end;


// 6 - B
procedure modificarStock(var arch: arch_log);
var
	cel: celulares;
	nombre: string;
	ok: boolean;
begin
	reset(arch);				// Abrir el archivo binario de lectura y escritura
	ok:= false;
	write('Ingrese el nombre del celular que desee cambiarle el stock: ');
	readln(nombre);
	while((not eof(arch)) and (not ok)) do begin
		read(arch, cel);			// Guardamos lo que apunta el puntero en la variable cel y avanzamos el puntero
		if(nombre = cel.nombre) then
			ok:= true;
	end;
	if(ok) then begin
		write('Ingrese el nuevo stock disponible del celular: ');
		readln(cel.stockDis);
		seek(arch, filepos(arch)-1);		// Mandamos el puntero del archivo en la posicion que esta -1
		write(arch, cel);					// Escribimos en el archivo binario lo que tiene la variable cel
	end;
	close(arch);		// Cerramos el archivo binario
end;


// 6 - C
procedure exportarSinStock(var arch: arch_log);
var
	cel: celulares;
	archText: Text;
begin
	assign(archText, 'SinStock.txt');			// Asignamos un nombre fisico al nombre logico
	reset(archText);							// Abrimos el archivo de texto (que ya deberia estar creado)
	reset(arch);								// Abrimos el archivo binario
	while(not eof(arch)) do begin
		read(arch, cel);						// Guardamos lo que apunta el puntero del archivo binario en cel y avanzamos el puntero
		if(cel.stockDis = 0) then begin
			with cel do begin
				writeln(archText, 			// Escribimos en el archivo de texto todos los campos del celular
				' ', nombre, 
				' ', codigo, 
				' ', descripcion,
				' ', marca,
				' ', precio,
				' ', stockMin,
				' ', stockDis);
			end;
		end;
	end;
	close(arch);			// Cerramos el archivo binario
	close(archText);		// Cerramos el archivo de texto
	writeln;
end;



// 5 - B
procedure imprimir(cel: celulares);
begin
	with cel do begin
		writeln('Nombre: ', nombre);
		writeln('Codigo: ', codigo);
		writeln('Descripcion: ', descripcion);
		writeln('Marca: ', marca);
		writeln('Precio: ', precio);
		writeln('Stock minimo: ', stockMin);
		writeln('Stock disponible: ', stockDis);
	end;
	writeln;
end;

procedure ListarStockMenor(var arch: arch_log);
var
	cel: celulares;
begin
	writeln('El/los celular/es con menos stock al minimo es/son:');
	reset(arch);							// Abrimos el archivo binario
	while(not eof(arch)) do begin
		read(arch, cel);					// Guardamos lo que apunta el puntero del archivo binario en cel y avanzamos el puntero
		if(cel.stockDis < cel.stockMin) then
			imprimir(cel);
	end;
	writeln('No hay mas celulares con menos stock al minimo');
	close(arch);			// Cerramos el archivo binario
end;


// 5 - C
procedure ListarDescripcion(var arch: arch_log);
var
	cel: celulares;
	userInput: string;
begin
	reset(arch);			// Abrimos el archivo binario de lectura y escritura
	write('Escriba una descripcion para buscar entre los celulares: ');
	readln(userInput);
	userInput:= ' ' + userInput;	// Cuando leo la cadena de archivo de texto, le agrega un espacio al principio
	while(not eof(arch)) do begin
		read(arch, cel);				// 
		if(cel.descripcion = userInput) then
			imprimir(cel);
	end;
	close(arch);			// Cerrar el archivo binario
	writeln('No hay celulares con es descripcion');
end;


// 5 - D
procedure Exportar(var arch: arch_log);
var
	cel: celulares;
	archText2: Text;
begin
	reset(arch);				// Abrir el archivo binario de lectura y escritura
	assign(archText2, 'celulares2.txt');		// Asignamos el nombre fisico al arhivo binario que tiene un nombre logico
	reset(archText2);					// Abrimos el archivo de texto de lectura y escritura
	while(not eof(arch)) do begin
		read(arch, cel);			// Guardamos lo que apunta el puntero del archivo binario y avanzamos el puntero
		with cel do begin
			writeln(archText2,'Codigo: ', codigo, ', precio: ', precio, ', marca: ', marca);
			writeln(archText2, 'Stock disponible: ', stockDis, ', stock minimo: ', stockMin, ', descripcion: ', descripcion);
			writeln(archText2, 'Nombre: ', nombre);
			// Guardamos en el archivo de texto cada campo, pero con la diferencia de que estan en diferentes lineas
		end;
	end;
	close(arch);			// Cerramos el archivo binario
	close(archText2);		// Cerramos el archivo de texto
	writeln('Se exporto con exito');
end;


// Boludeses mias
procedure menu(var arch: arch_log);
var
	userInput: string;
begin
	writeln;
	writeln('Las opciones que tiene son');
	writeln('1) Listar los celulares que tengan un stock menor al stock minimo');
	writeln('2) Listar los celulares cuya descripcion contenga una cadena de caracteres');
	writeln('3) Exportar a un archivo de texto');
	writeln('4) Agregar un celular al archivo');
	writeln('5) Modificar el stock de un celular dado');
	writeln('6) Exportar aquellos celulares con stock disponible 0 a un archivo de texto');
	writeln('7) Salir');
	write('Elija una opcion: ');	readln(userInput);
	while(userInput <> '7') do begin
		case userInput of
			// Ejercicio 5
			'1': ListarStockMenor(arch);
			'2': ListarDescripcion(arch);
			'3': Exportar(arch);
			// Ejercicio 6
			'4': Agregar(arch);
			'5': modificarStock(arch);
			'6': exportarSinStock(arch);
		end;
		write();
		write('Ingrese otra opcion: ');
		readln(userInput);
		writeln;
	end;
end;


var
	arch: arch_log;
	archText: Text;
	nombreF: string;
	celular: celulares;
BEGIN
	// 5 - A
	write('Elija un nombre para el archivo binario: ');
	readln(nombreF);
	assign(arch, nombreF);
	rewrite(arch);
	
	assign(archText, 'celulares.txt');
	reset(archText);
	
	while(not eof(archText)) do begin
		with celular do begin
			readln(archText, codigo, precio, marca);
			readln(archText, stockDis, stockMin, descripcion);
			readln(archText, nombre); 
		end;
		write(arch, celular);
	end;
	
	close(arch);
	close(archText);
	menu(arch);
END.
