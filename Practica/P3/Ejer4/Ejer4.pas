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

procedure crearArch(var a: tArchFlores);
var
	reg: reg_flor;
begin
	assign(a, 'flores');
	rewrite(a);
	reg.codigo:= 0;
	reg.nombre:= '';
	while(codigo <> -1) do begin
		write(a, reg);
		leerFlor(reg);
	end;
	close(arch);
end;


// ELIMINAR ALGUN REGISTRO DEL ARCHIVO
procedure leerArch(var arch: tArchFlores; var reg: reg_flor);
begin
	if(not eof(arch)) then
		read(arch, reg)
	else
		reg.codigo:= valorAlto;
end

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
	end;
	close(arch);
end;


// ALTAS DE REGISTROS DEL ARCHIVO
procedure altaReg(var arch: tArchFlores);
var
	
begin
	
end;


var
	arch: archivo;
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
	agregarFlor(arch, reg.codigo, reg.nombre);
END.

