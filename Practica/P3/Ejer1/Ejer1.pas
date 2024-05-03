program untitled;
type
	empleados = record
		num: integer;
		nombre: string;
		apellido: string;
		edad: integer;
		DNI: integer;
	end;
	arch = file of empleados;


//A
function BuscarEmpleadoA(var arch: arch; num: integer): boolean;
var
	emp: empleados;
	ok: boolean;
begin
	ok:= false;
	reset(arch);
	while(not eof(arch) and not ok) do begin
		read(arch, emp);
		if(emp.num = num) then
			ok:= true;
	end;
	close(arch);
	BuscarEmpleadoA:= not ok;
end;

procedure AgregarMasEmpleados(var arch:arch);
var
	emp: empleados;
	userInput: string;
begin
	reset(arch);
	write('Quiere agregar un nuevo empleado al archivo? ');
	readln(userInput);
	while(userInput = 'si') do begin
		writeln('Ingrese el numero de empleado: ');
		readln(emp.num);
		if(BuscarEmpleadoA(arch, emp.num)) then begin
			writeln('Ingrese el apellido: ');
			readln(emp.apellido);
			writeln('Ingrese el nombre: ');
			readln(emp.nombre);
			writeln('Ingrese la edad: ');
			readln(emp.edad);
			writeln('Ingrese el DNI: ');
			readln(emp.DNI);
			seek(arch, filesize(arch));			// Nos posicionamos al final del archivo
			write(arch, emp);					// Escribimos en el archivo cada empleado
		end
		else writeln('Ese empleado ya esta registrado en el archivo');
		write('Quiere agregar un nuevo empleado? ');
		readln(userInput);
	end;
	close(arch);								// Cerramos el archivo
end;


//B
procedure ModificarEdad(var arch: arch);
var
	num_emple: integer;
	emp: empleados;
	ok: boolean;
begin
	writeln('Ingrese el numero de empleado que quiera modificarle la edad: ');
	readln(num_emple);
	ok:= true;
	reset(arch);						// Abrimos el archivo de lectura y escritura
	while(not eof(arch) and ok) do begin
		read(arch, emp);				// Guardamos lo que apunta el puntero en emp y avanzamos el puntero
		if(emp.num = num_emple) then begin
			writeln('Dime la nueva edad del empleado');
			readln(emp.edad);
			write(arch, emp);					// Sobreescribimos lo que tenia guardado arch
			ok:= false;
		end;
	end;
	if(ok) then writeln('No encontre el empleado');
	close(arch);							// Cerramos el archivo
end;


//C
procedure exportarBinario_Texto(var arch:arch);
var
	emp: empleados;
	archText: Text;		// Creamos una variable de tipo txt es un archivo de Texto	(seria el nombre/archivo logico)
	st: string;
begin
	reset(arch);			// Abrimos el archivo binario arch
	read(st);
	assign(archText, st+'.txt');			// Le asignamos un nombre fisico al archivo de texto
	rewrite(archtext);		// Creamos un archivo de texto y lo abrimos para lectura y escritura
	while(not eof(arch)) do begin
		read(arch, emp);	// Guardamos la informacion de lo que apunta el puntero del archivo binario en emp y avanzamos el puntero
		writeln(archtext, ' ', emp.num, ' ', emp.nombre, ' ', emp.apellido, ' ', emp.edad, ' ', emp.DNI);
		// Escribimos en el archivo de texto, cada campo esta separado por el caracter blanco.
	end;
	close(arch);			// Cerramos el archivo binario
	close(archtext);		// Cerramos el archivo de texto
end;


//D
procedure agregarSinDNI(var arch:arch);
var
	emp: empleados;
	archText: Text;			// Creamos una variable de tipo txt que es un archivo de Texto (seria el nombre/archivo logico)
begin
	reset(arch);			// Abrimos el archivo binario
	assign(archText, 'faltaDNIEmpleado.txt');		// Asignamos un nombre fisico al archivo de texto
	rewrite(archText);		// Creamos el archivo de texto
	while(not eof(arch)) do begin
		read(arch, emp);	// Guardamos lo que apunta el puntero del archivo en emp y avanzamos el puntero
		if(emp.DNI = 00) then begin
			write(archText, 
			' ', emp.num,
			' ', emp.apellido,
			' ', emp.nombre,
			' ', emp.edad,
			' ', emp.DNI);			// Escribimos en el archivo de texto cada campo de los empleados (separados por ' ')
		end;
	end;
	close(arch);		// Cerramos el archivo binario
	close(archText);	// Cerramos el archivo de texto
end;

procedure leerEmpleado(var empleado:empleados);
begin 
    writeln;
    write('Ingrese apellido de empleado: ');
    readln(empleado.apellido);
    if (empleado.apellido<>'fin') then 
        begin
			write('Ingrese numero de empleado: ');
			readln(empleado.num);
            write('Ingrese nombre de empleado: ');
            readln(empleado.nombre);
            write('Ingrese edad de empleado: ');
            readln(empleado.edad);
            write('Ingrese dni de empleado: ');
            readln(empleado.dni);
        end;
end;



// DAR DEBAJA FISICA A UN ARCHIVO
procedure Truncar(var arch: arch);
var
	emp, aux: empleados;
	num: integer;
begin
	write('Dime el numero de empleado que deseas eliminar en el archivo: ');
	readln(num);

	reset(arch);					// Abrimos el archivo de lectura y escritura
	seek(arch, filesize(arch)-1);	// Movemos el puntero del archivo al ultimo
	read(arch, aux);				// Leemos esa posicion y termina el archivo
	seek(arch, 0);					// Acomodamos el puntero a la primera posicion del archivo
	read(arch, emp);				// Leemos la primera posicion del archivo y avanzamos el puntero
	
	while((not eof(arch)) and (emp.num <> num))do
		read(arch, emp);			// Buscamos el empleado a borrar y por cada lectura, avanzamos el puntero
	
	if(emp.num = num) then begin
		writeln('Se encontro el numero de empleado');	// Si se encuentra el empleado
		seek(arch, filepos(arch)-1);					// Nos movemos uno atras para tener el puntero en el que queremos borrar
		write(arch, aux);								// Escribimos en el archivo en la posicion a borrar el registro de la ultima posicion
		seek(arch, filesize(arch)-1);					// Movemos el puntero al ultimo registro
		truncate(arch);									// La posicion en la que estamos se convierte en el EOF (borrando el registro en esta posicion para que no haya repetidos)
	end
	else
		writeln('No se encontro ese numero de empleado');	// No se encuentra el empleado
	close(arch);			// Se cierra el archivo
end;


var
	arch_log: arch;
	arch_fis: string;
	emp: empleados;
BEGIN
	write('Ingrese el nombre del archivo: ');
	read(arch_fis);								// Ingresamos un nombre fisico para el archivo
	assign(arch_log, arch_fis);					// Asignamos una correspondencia entre el nombre fisico y logico del archivo
	rewrite(arch_log);							// Creamos el archivo para solo escritura
	leerEmpleado(emp);
	while(emp.apellido <> 'fin') do begin
		write(arch_log, emp);					// Escribimos en el archivo
		leerEmpleado(emp);
	end;
	write(filesize(arch_log));
	close(arch_log);							// Cerramos el archivo
	AgregarMasEmpleados(arch_log);
	exportarBinario_Texto(arch_log);
	Truncar(arch_log);
END.
