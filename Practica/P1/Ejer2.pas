program Ejer2;

type
	numero = file of integer;

procedure cant(var arch: numero; var cont: integer; var prom: real);
var
	nro,contador:integer;
begin
	reset(arch);					// Abro el archivo como lectura y escritura
	contador:= 0;
	while(not eof(arch)) do begin
		read(arch, nro);			// Guarda la informacion del archivo en nro y el puntero avanza
		if(nro<1500) then
			cont:= cont+1;
		contador:= contador+1;
		prom:= prom+nro;
		writeln('El numero es: ', nro);
	end;
	close(arch);					// Cierro el archivo	
	prom:= prom/contador;
end;
var
	arch_log: numero;
	arch_fis: string;
	nro,cont: integer;
	prom: real;
BEGIN
	prom:= 0; cont:= 0;
	write('Ingrese el nombre del archivo: ');
	read(arch_fis);								// Ingresamos un nombre fisico para el archivo
	Assign(arch_log, arch_fis);					// Le asignamos/establecemos correspondencia entre el nombre fisico y logico
	rewrite(arch_log);							// Creamos el archivo de solo escritura
	read(nro);
	while(nro <> 30000) do begin
		write(arch_log, nro);					// Escribimos en el archivo y avanza el puntero
		read(nro);
	end;
	close(arch_log);							// Cerramos el archivo
	cant(arch_log, cont, prom);
	writeln('Los numeros menores a 1500 son: ', cont, ' y el promedio es: ', prom);
END.


