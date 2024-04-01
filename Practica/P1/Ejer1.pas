program untitled;

type
	numero = file of integer;

var
	arch_log: numero;
	arch_fis: string;
	nro: integer;
BEGIN
	write('Ingrese el nombre del archivo: ');
	read(arch_fis);								// Ingresamos un nombbre fisico para el archivo
	Assign(arch_log, arch_fis);					// Le asignamos correspondencia entre el nombre fisico y logico
	rewrite(arch_log);							// Creacion del archivo de solo escritura
	read(nro);
	while(nro <> 30000) do begin
		write(arch_log, nro);					// Escribimos en el archivo y avanza el puntero a la siguiente posicion
		read(nro);
	end;
	close(arch_log);							// Cerramos el archivo
END.

