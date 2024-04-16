program untitled;
const
	valorAlto = 9999;
type
	productos = record
		codigo: integer;
		nombre: string;
		precio: real;
		stockA: integer;
		stockM: integer;
	end;
	
	ventas = record
		codigo: integer;
		cant_V: integer;
	end;
	
	maestro = file of productos;
	detalle = file of ventas;


// Generacion del archivo maestro
procedure generarM(var mae: maestro);
var
	regM: productos;
	opcion: string;
begin
	rewrite(mae);
	opcion:= '';
	writeln;
	while(opcion <> 'n') do begin
		writeln('Ingrese los siguientes datos del producto');
		with regM do begin
			write('Codigo: ');		readln(codigo);
			write('Nombre: ');		readln(nombre);
			write('Precio: ');		readln(precio);
			write('Stock actual: ');		readln(stockA);
			write('Stock minimo: ');		readln(stockM);
		end;
		write(mae, regM);
		write('Quiere ingresar otro producto s/n? ');
		readln(opcion);
		writeln;
	end;
end;


//A
procedure generarD(var d: detalle);
var
	regV: ventas;
	opcion: string;
begin
	rewrite(d);
	opcion:= '';
	while(opcion <> 'n') do begin
		writeln('Ingrese los siguientes datos de la venta');
		with regV do begin
			write('Codigo: ');
			readln(codigo);
			write('Cantidad de ventas: ');
			readln(cant_V);
		end;
		write(d, regV);
		write('Quiere ingresar otra venta s/n? ');
		readln(opcion);
	end;
	close(d);
end;

procedure leerD(var det: detalle; var reg: ventas);
begin
	if(not eof(det)) then
		read(det, reg)
	else
		reg.codigo:= valorAlto;
end;

procedure actualizarM(var mae: maestro; var det: detalle);
var
	regV: ventas;
	regP: productos;
begin
	generarD(det);
	reset(mae);
	reset(det);
	write('a1');
	leerD(det, regV);
	writeln(regV.codigo);
	while(regV.codigo <> valorAlto) do begin
		write('a1');
		read(mae, regP);
		write('a');
		// El primer while verifica si el maestro tiene el mismo codigo con el detalle 
		while(regP.codigo <> regV.codigo) do
			read(mae, regP);
		write('a');
		// El segundo while verifica que mientras el archivo detalle tenga el mismo codigo que el archivo maestro, avanze
		while(regP.codigo = regV.codigo) do begin
			regP.stockA:= regP.stockA - regV.cant_V;
			leerD(det, regV);
		end;
		seek(mae, filepos(mae)-1);
		write(mae, regP);
	end;
	close(mae);
	close(det);
end;


// B
procedure listarTxt(var mae: maestro);
var
	regP: productos;
	txt: Text;
begin
	reset(mae);
	assign(txt, 'stock_minimo.txt');
	rewrite(txt);
	
	while(not eof(mae)) do begin
		read(mae, regP);
		if(regP.stockA >= regP.stockM) then
			with regP do
				writeln(txt, 'Codigo: ', codigo, ', Nombre:', nombre, ', Precio: ', precio, ', Stock minimo: ', stockM, ' y Stock Actual: ', stockA);
	end;
	close(txt);
	close(mae);
end;


var
	mae: maestro;
	det: detalle;
	opcion: integer;
BEGIN
	assign(mae, 'archivo_Maestro');
	assign(det, 'archivo_Detalle');
	
	// EN ESTE CASO NOS PIDEN "GENERAR" UN ARCHIVO MAESTRO
	
	opcion:= 0;
	while(opcion <> 4) do begin
		writeln('1) Generar archivo maestro');
		writeln('2) Actualizar el archivo maestro');
		writeln('3) Listar el archivo maestro en un txt');
		writeln('4) Salir');
		write('Elija una opcion: ');
		readln(opcion);
		case opcion of
			1: generarM(mae);
			2: actualizarM(mae, det);
			3: listarTxt(mae);
		end;
		writeln;
	end;
END.

