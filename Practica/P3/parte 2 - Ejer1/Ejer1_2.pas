program untitled;
const
	valorAlto = 9999;
type
	producto = record
		codigo: integer;
		nombre: string;
		precio: real;
		stockAct: integer;
		stockMin: integer;
	end;
	
	maestro = file of producto;
	
	venta = record
		codigo: integer;
		cantV: integer;
	end;
	
	detalle = file of venta;
	

// GENERAR EL ARCHIVO
procedure leerProductos(var p: producto);
begin
	writeln('Ingresar los siguientes datos del producto');
	with p do begin
		write('Codigo: '); readln(codigo);
		write('Nombre: '); readln(nombre);
		write('Precio: '); readln(precio);
		write('Stock actual: '); readln(stockAct);
		write('Stock minimo: '); readln(stockMin);
	end;
	writeln;
end;

procedure cargarArch(var mae: maestro; var det: detalle);
var
	txt: Text;
	v: venta;
	p: producto;
begin
	writeln('Generando archivo maestro');
	assign(mae, 'Maestro');
	rewrite(mae);
		
	leerProductos(p);
	while(p.codigo <> -1) do begin
		write(mae, p);
		leerProductos(p);
	end;
	close(mae);
	writeln('Se termino de generar maestro');
	
	writeln;
	
	writeln('Generando archivo detalle');
	assign(txt, 'info_Detalle.txt');
	reset(txt);
	assign(det, 'Detalle');
	rewrite(det);
	
	while(not eof(txt)) do begin
		with v do begin
			readln(txt, codigo);
			readln(txt, cantV);
		end;
		write(det, v);
	end;
	close(txt);
	close(det);
	
	writeln('Se termino de generar el detalle');
end;


// LEER EL DETALLE
procedure leerDet(var det: detalle; var v: venta);
begin
	if(not eof(det)) then
		read(det, v)
	else
		v.codigo:= valorAlto;
end;

// LEER EL MAESTRO
procedure leerMae(var mae: maestro; var p: producto);
begin
	if(not eof(mae)) then
		read(mae, p)
	else
		p.codigo:= valorAlto;
end;

// ACTUALIZAR ARCHIVO MAESTRO CON DETALLE
procedure actualizarMae(var mae: maestro; var det: detalle);
var
	p: producto;
	v: venta;
	cantVendidas: integer;
begin
	// BUSCAR POR CADA CODIGO DEL MAESTRO EL CODIGO DEL DETALLE
	reset(mae);						// Abro el archivo maestro para lectura y escritura
	reset(det);
	read(mae, p);			// Leo el maestro para encontrar el codigo y avanzo el puntero
	while(not eof(mae))do begin
		leerDet(det, v);
		cantVendidas:= 0;
		while(v.codigo <> valorAlto) do begin		// Si o si va a estar porque los archivos detalle tienen lo que tiene el maestro
			if(v.codigo = p.codigo) then			// Si es el mismo codigo
				cantVendidas:= cantVendidas + v.cantV;	// Sumo todas las cantidades vendidas del mimo codigo
			leerDet(det, v);		// Leo el detalle para encontrar el codigo del mismo que el maestro y avanzo el puntero
		end;
		
		seek(mae, filepos(mae)-1);				// Me muevo a la anterior posicion para modificar ese registro
		p.stockAct:= p.stockAct - cantVendidas;	// Modifico el stock Actual con las cantidades vendidas
		write(mae, p);					// Escribo en donde apunta el puntero y avanzo el puntero
		seek(det, 0);					// Me muevo a la posicion 0 del archivo detalle
		
	end;
	close(mae);		// Cierro el archivo maestro
end;


// EJERCICIO B
// Al haber 0 o un registro igual entonces no es necesario hacer una lista o un archivo auxiliar
	// para juntar todos los codigos/registros iguales
	// ya que va a ocurrir una sola vez o nunca
	// (aunque haya mas de un registro igual, se pueden leer a la vez el archivo maestro y el detalle, a la par)
{
procedure actualizarMae_EJER_B(var mae: maestro; var det: detalle);
var
	p: producto;
	v: venta;
begin
	reset(mae);
	reset(det);
	leerDet(det, v);
	while(v.codigo <> valorAlto)do begin
		leerMae(mae, p);
		while(p.codigo <> v.codigo) do begin
			leerMae(mae, p);
		end;
		p.stockAct:= p.stockAct + v.cantV;
		seek(mae, filepos(mae)-1);
		write(mae, p);
		seek(mae, 0);
		leerDet(det, v);
	end;
	close(mae);
	close(det);
end;
}


// IMPRIMIR ARCHIVO DETALLE
procedure imprimirD(var det: detalle);
var
	v: venta;
begin
	reset(det);
	leerDet(det, v);
	while(v.codigo <> valorAlto) do begin
		with v do begin
			writeln('Codigo: ', codigo);
			writeln('Cantidad de ventas: ', cantV);
			writeln;
		end;
		leerDet(det, v);
	end;
	close(det);
end;

// IMPRIMIR ARCHIVO MAESTRO
procedure imprimir(var mae: maestro);
var
	p: producto;
begin
	reset(mae);
	leerMae(mae, p);
	while(p.codigo <> valorAlto) do begin
		with p do begin
			writeln('Codigo: ', codigo);
			writeln('Nombre: ', nombre);
			writeln('Precio: ', precio);
			writeln('Stock Actual: ', stockAct);
			writeln('Stock Minimo: ', stockMin);
			writeln;
		end;
		leerMae(mae, p);
	end;
	close(mae);
end;


var
	mae: maestro;
	det: detalle;
BEGIN
	writeln('Cargar archivos');
	cargarArch(mae, det);
	writeln;
	
	writeln('Actualizar archivo maestro con archivo detalle');
	imprimirD(det);
	actualizarMae(mae, det);
	writeln;
	
	writeln('Imprimiendo archivo maestro, para comprobar que carajos tiene');
	imprimir(mae);
END.

