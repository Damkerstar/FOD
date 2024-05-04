program untitled;
const
	valorAlto = 9999;
type
	reg_flor = record
		nombre: string[45];
		codigo: integer;
	end;
	
	tArchFlores = file of reg_flor;


// CREAR EL ARCHIVO
procedure leerFlor(var reg: reg_flor);
begin
	writeln('Ingrese los siguientes datos');
	with reg do begin
		write('Codigo: ');	readln(codigo);
		if(codigo <> -1) then begin
			write('Nombre: ');	readln(nombre);
		end;
	end;
end;

procedure crearArch(var arch: tArchFlores);
var
	reg: reg_flor;
begin
	assign(arch, 'flores');
	rewrite(arch);
	reg.codigo:= 0;
	reg.nombre:= '';
	while(reg.codigo <> -1) do begin
		write(arch, reg);
		leerFlor(reg);
	end;
	close(arch);
end;


// ALTAS DE REGISTROS DEL ARCHIVO
procedure agregarFlor(var arch: tArchFlores; nombre: string; codigo: integer);
var
	cabe, reg: reg_flor;
begin
	reset(arch);
	read(arch, cabe);		// Leo el registro la cabecera
	if(cabe.codigo < 0) then begin		// Si es menor a 0 significa que hay espacio
		seek(arch, abs(cabe.codigo));	// Voy al campo del registro donde se ubicca el registro borrado
		read(arch, cabe);				// Leo la nueva cabecera que puede tener 0 o otro registro borrado
		seek(arch, filepos(arch)-1);	// Voy a la posicion del anterior registro
		reg.codigo:= codigo;			// Agarro en un registro el codigo
		reg.nombre:= nombre;				// y el nombre
		write(arch, reg);				// Lo sobreescribo con el nuevo registro
		seek(arch, 0);					// Vuelvo a la cabecera
		write(arch, cabe);				// Sobreescribo la cabecera
	end
	else
		writeln('No hay espacio en el archivo');
	close(arch);
end;


// EJER B
// LISTAR EL CONTENIDO DEL ARCHIVO
procedure leerArch(var arch: tArchFlores; var reg: reg_flor);
begin
	if(not eof(arch)) then
		read(arch, reg)
	else
		reg.codigo:= valorAlto;
end;

procedure listarArch(var arch: tArchFlores);
var
	reg: reg_flor;
begin
	reset(arch);
	leerArch(arch, reg);
	while(reg.codigo <> valorAlto) do begin
		if(reg.codigo > 0) then begin
			writeln('Codigo: ', reg.codigo);
			writeln('Nombre: ', reg.nombre);
		end;
		leerArch(arch, reg);
	end;
end;



// EJERCICIO 5
// ELIMINAR ALGUN REGISTRO DEL ARCHIVO
procedure eliminarReg(var arch: tArchFlores);
var
	reg, cabe: reg_flor;
	cod: integer;
begin
	reset(arch);
	leerArch(arch, cabe);		// Leo la cabecera
	leerArch(arch, reg);		// Leo el primer registro
	write('Ingrese el codigo del registro a borrar ');	readln(cod);
	while(reg.codigo <> valorAlto) and (reg.codigo <> cod) do
		leerArch(arch, reg);	// Busco el codigo a eliminar
		
	// Lo encontre entonces:
	if(reg.codigo = cod) then begin
		seek(arch, filepos(arch)-1);	// Me posiciono en la posicon del codigo a eliminar
		write(arch, cabe);				// Lo sobreescribo por lo que hay en la cabecera
		seek(arch, 0);					// Me voy a la cabecera
		reg.codigo:= reg.codigo*-1;		// Escribo el codigo al que tengo que eliminar con menos
		write(arch, reg);				// Sobreescribo lo que esta en la cabecera por el registro eliminado
	end
	else
		writeln('No existe el codigo a borrar');
	close(arch);
end;



var
	arch: tArchFlores;
	reg: reg_flor;
BEGIN
	writeln('CREAR ARCHIVO: ');
	crearArch(arch);
	writeln;
	
	writeln('ELIMINAR REG DEL ARCHIVO');
	eliminarReg(arch);
	writeln;
	
	writeln('AGREGAR REG AL ARCHIVO');
	leerFlor(reg);
	agregarFlor(arch, reg.nombre, reg.codigo);
	writeln;
	
	writeln('Lista del archivo sin archivos eliminados');
	listarArch(arch);
END.
