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

procedure imprimir(emp: empleados);
begin
	writeln('Los datos del empleado son:');
	writeln('Nombre: ', emp.nombre);
	writeln('Apellido: ', emp.apellido);
	writeln('Edad: ', emp.edad);
	writeln('Numero de empleado: ', emp.num);
	writeln('DNI: ', emp.DNI);
end;

//A
procedure Listar1(var arch: arch);
var
	NoA: string;
	emp: empleados;
begin
	reset(arch);				// Abrimos el archivo de lectura y escritura
	write('Escriba un apellido o nombre para buscar entre los empleados ');
	readln(NoA);
	while(not eof(arch)) do begin
		read(arch,emp);				// Guarda el contenido en emp y avanza el puntero		
		if((emp.apellido = NoA) or (emp.nombre = NoA)) then
			imprimir(emp)
		end;
	close(arch);
end;

//B
procedure Listar2(var arch: arch);
var
	emp: empleados;
begin
	reset(arch);					// Abrimos el archivo de lectura y escritura
	while(not eof(arch)) do begin
		read(arch, emp);			// Guardamos los datos de donde apunta el puntero en emp y avanza el puntero
		imprimir(emp);
	end;
	close(arch);					// Cerramos el archivo
end;

//C
procedure Listar3(var arch: arch);
var
	emp: empleados;
begin
	reset(arch);					// Abrimos el archivo de lectura y escritura
	while(not eof(arch)) do begin
		read(arch, emp);			// Guardamos los datos de donde apunta el puntero en emp y avanza el puntero
		if(emp.edad > 70) then begin
			writeln('El empleado que esta proximo a jubilarse es:');
			imprimir(emp);
		end;
	end;
	close(arch);
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
	writeln('Ingrese el apellido: ');
	readln(emp.apellido);
	while(emp.apellido <> 'fin') do begin
		writeln('Ingrese el nombre: ');
		readln(emp.nombre);
		writeln('Ingrese el numero de empleado: ');
		readln(emp.num);
		writeln('Ingrese la edad: ');
		readln(emp.edad);
		writeln('Ingrese el DNI: ');
		readln(emp.DNI);
		write(arch_log, emp);					// Escribimos en el archivo
		writeln('Ingrese el apellido: ');
		readln(emp.apellido);
	end;
	close(arch_log);							// Cerramos el archivo
	writeln();
	writeln('Ejercicio 3bi');
	writeln();
	Listar1(arch_log);
	writeln();
	writeln('Ejercicio 3bii');
	Listar2(arch_log);
	writeln();
	writeln('Ejercicio 3biii');
	Listar3(arch_log);
END.

