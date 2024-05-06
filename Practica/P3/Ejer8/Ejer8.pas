program untitled;
const
	valorAlto = 'ZZZ';
type
	distribucion = record
		nombre: string;
		anio: integer;
		version: integer;
		cantD: integer;
		descripcion: string;
	end;
	
	archivo = file of distribucion;


// CARGAR ARCHIVO QUE YA SE TIENE
procedure cargarArch(var arch: archivo);
var
	d: distribucion;
	txt: Text;
begin
	assign(txt, 'info_Distribucion.txt');
	reset(txt);
	assign(arch, 'Distribucion_Linux');
	rewrite(arch);
	
	// LA CABECERA
	d.nombre:= 'Cabecera';
	write(arch, d);
	
	while(not eof(txt)) do begin
		with d do begin
			readln(txt, nombre);
			readln(txt, anio);
			readln(txt, version);
			readln(txt, cantD);
			readln(txt, descripcion);
		end;
		write(arch, d);
	end;
	close(txt);
	close(arch);
end;


// VERIFICAR SI EXISTE UNA DISTRIBUCION
procedure leerArch(var arch: archivo; var d: distribucion);
begin
	if(not eof(arch)) then
		read(arch, d)
	else
		d.nombre:= valorAlto;
end;

function ExisteDistribucion(var arch: archivo; nom: string): boolean;
var
	d: distribucion;
begin
	reset(arch);
	leerArch(arch, d);
	
	while(d.nombre <> valorAlto) and (d.nombre <> nom) do begin
		leerArch(arch, d);
	end;
	close(arch);
	ExisteDistribucion:= d.nombre = nom;
end;


// DAR DE ALTA UNA DISTRIBUCION
procedure leerDistribucion(var d: distribucion);
begin
	writeln('Ingrese los siguientes datos de la nueva distribucion');
	write('Nombre: '); readln(d.nombre);
	write('Año: '); readln(d.anio);
	write('Version: '); readln(d.version);
	write('Cantidad de Desarrolladores: '); readln(d.cantD);
	write('Descripcion: '); readln(d.descripcion);
end;

procedure AltaDistribucion(var arch: archivo);
var
	dNue, cabe: distribucion;
begin
	leerDistribucion(dNue);
	
	if(not ExisteDistribucion(arch, dNue.nombre)) then begin
		reset(arch);			// Abro el archivo binario de lectura y escritura
		leerArch(arch, cabe);
		
		// Se pregunta si la cantidad de desarrolladores tenga un valor por debajo de 0
			// para saber si hay espacio
		if(cabe.cantD < 0) then begin
			seek(arch, abs(cabe.cantD));			// cabe.cantD tiene la ultima posicion que fue borrada en el archivo (lista invertida)
			read(arch, cabe);						// Leo la nueva cabecera (si es un registro borrado, cantD sera la posicion del archivo borrado)
			
			seek(arch, filepos(arch)-1);			// Me ubico en el registro borrado
			write(arch, dNue);						// Escribo el nuevo registro
			
			seek(arch, 0);							// Me ubico en la cabecera
			write(arch, cabe);						// Escribo la nueva cabecera
		end
		else
			writeln('No hay mas espacio en el archivo');
		close(arch);		// Cierro el archivo
	end
	else
		writeln('Ya existe la distribucion');
end;


// ELIMINAR UNA DISTRIBUCION
procedure BajaDistribucion(var arch: archivo);
var
	d, cabe: distribucion;
	nom: string;
	pos: integer;
begin
	write('Ingrese el nombre de la distribucion a eliminar '); readln(nom);
	
	// Busco si existe la distribucion a eliminar
	if(ExisteDistribucion(arch, nom)) then begin
		reset(arch);					// Abro el archivo binario de lectura y escritura
		leerArch(arch, cabe);			// Leo la cabecera
		
		// Busco la posicion del registro a eliminar
		leerArch(arch, d);
		while(d.nombre <> valorAlto) and (d.nombre <> nom) do
			leerArch(arch, d);
		
		seek(arch, filepos(arch)-1);	// Me posicion en el registro a sobreescribir con la cabecera
		pos:= filepos(arch)*-1;			// Agarro la posicion para que la cabecera nueva tenga la posicion a este registro eliminado (lista invertida)
		write(arch, cabe);				// Escribo lo que estaba en la cabecera en el registro eliminado
		
		seek(arch, 0);			// Llevo el puntero a la cabecera
		d.cantD:= pos;			// cantD lo escribo como la posicion de donde estaba el registro eliminado
		write(arch, d);			// Escribo el registro eliminado en la cabecera
		
		close(arch);		// Cierro el archivo
	end
	else
		writeln('No existe tal distribucion');
end;



// IMPRIMIR EL ARCHIVO
procedure imprimir (d: distribucion);
begin
	with d do begin
		writeln ('|NOMBRE: ',nombre);
		writeln('|ANIO: ',anio);
		writeln('|NUMERO VERSION: ',version);
		writeln('|CANTIDAD DE DESARROLLADORES: ',cantD);
		writeln(' |DESCRIPCION: ',descripcion);
		writeln;
	end;
end;

procedure mostrarPantalla (var arc_log: archivo);
var
	d:distribucion;
begin
	reset(arc_log);
	seek (arc_log,1);
	leerArch(arc_log,d);
	while (d.nombre <> valorAlto) do begin
		imprimir (d);
		leerArch(arc_log, d);
	end;
	close(arc_log);
end;


var
	arch: archivo;
BEGIN
	writeln('Creamos el archivo');
	cargarArch(arch);
	writeln;
	
	writeln('Damos debaja a una distribucion');
	BajaDistribucion(arch);
	BajaDistribucion(arch);
	writeln;
	
	writeln('Damos de alta a una distribucion nueva');
	AltaDistribucion(arch);
	writeln;
	
	writeln('Imprimimos el archivo, pa saber que miercoles tiene');
	mostrarPantalla(arch);
END.
