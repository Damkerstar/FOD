program Ejer5;
type
	celulares=record
		codigo:integer;
		nombre:string;
		descripcion:string;
		marca:string;
		precio:real;
		stockMin:integer;
		stockDis:integer;
	end;

	arch_log= file of celulares;

var
	arch:arch_log;
	archText: Text;
	cel: celulares;
	userInput:string;
BEGIN
	write('Ingrese un nombre para el archivo binario');
	readln(userInput);
	assign(arch, userInput);
	rewrite(arch);
	
	write('Ahora ingrese un nombre para el archivo de texto');
	readln(userInput);
	assign(archText, userInput);
	rewrite(archText);
	
	while(not eof(archText)) do begin
		readln(archText, cel.codigo, cel.nombre, cel.descripcion, cel.marca, cel.precio, cel.stockMin, cel.stockDis);
		write(arch, cel);
	end;
	writeln('Archivo cargado');
	close(arch);
	close(archText);
	
END.

