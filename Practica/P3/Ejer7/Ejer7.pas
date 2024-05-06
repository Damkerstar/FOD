program untitled;
const
	valorAlto = 9999;
type
	especie = record
		codigo: integer;
		nombre: string;
		familia: string;
		descripcion: string;
		zona: string;
	end;
	
	archivo = file of especie;


// CARGAR ARCHIVO
procedure cargarArch(var arch: archivo);
var
	e: especie;
	txt: Text;
begin
	assign(arch, 'Aves_Extintas');
	rewrite(arch);
	assign(txt, 'info_Aves.txt');
	reset(txt);
	
	while(not eof(txt)) do begin
		with e do begin
			readln(txt, codigo);
			readln(txt, nombre);
			readln(txt, familia);
			readln(txt, descripcion);
			readln(txt, zona);
		end;
		write(arch, e);
	end;
	close(txt);
	close(arch);
end;


// MARCAR LOS ARCHIVOS PARA LUEGO ELIMINARLOS
procedure leerArch(var arch: archivo; var e: especie);
begin
	if(not eof(arch)) then
		read(arch, e)
	else
		e.codigo:= valorAlto;
end;

procedure marcarArch(var arch: archivo);
var
	cod: integer;
	e: especie;
	userInput: string;
begin
	reset(arch);
	leerArch(arch, e);
	
	userInput:= 'si';
	while(userInput <> 'si') do begin
	
		write('Ingrese un codigo para eliminar '); readln(cod);
			
		while (e.codigo <> valorAlto) and (e.codigo <> cod) do
			leerArch(arch, e);
		
		if(e.codigo = cod) then begin
			e.codigo:= e.codigo*-1;
			seek(arch, filepos(arch)-1);
			write(arch, e);
		end
		else
			writeln('El codigo no fue encontrado');
		
		seek(arch, 0);			// Si quiere ingresar otro codigo, entonces debemos buscar desde la pos 0
		
		write('Quiere ingresar otro codigo a eliminar, si/no'); readln(userInput);
		writeln;
	end;
	close(arch);
end;


// BORAR LOS REGISTROS TRUNCANDO EL ULTIMO
procedure borrarAves(var arch: archivo);
var
	pos: integer;
	e: especie;
begin
	reset(arch);
	leerArch(arch, e);
	
	while(e.codigo <> valorAlto) do begin
		if(e.codigo < 0) then begin
			pos:= filepos(arch)-1;				// Agarro la posicion donde esta el puntero del archivo
			seek(arch, filesize(arch)-1);		// Me ubico al final del archivo
			leerArch(arch, e);					// Leo la posicion y avanzo el puntero
			seek(arch, filesize(arch)-1);		// Tengo que volver al ultimo
			truncate(arch);
			seek(arch, pos);
			write(arch, e);
			seek(arch, filepos(arch)-1);		// Si el ultimo era uno borrado, lo tenemos que leer tambien
		end;
		leerArch(arch, e);
	end;
	close(arch);
end;


var
	arch: archivo;
BEGIN
	writeln('Tenemos un archivo que almacena informacion sobre especies de aves en via de extincion');
	cargarArch(arch);
	writeln;
	
	writeln('Marcar las aves extintas en el archivo');
	marcarArch(arch);
	writeln;
	
	writeln('Borrar del archivo los registros de aves marcadas');
	borrarAves(arch);
END.

