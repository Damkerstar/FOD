program untitled;
const
	valorAlto = 9999;
type
	prenda = record
		cod_prenda: integer;
		descripcion: string;
		colores: string;
		tipo_prenda: string;
		stock: integer;
		precio_unitario: real;
	end;
	
	archivo = file of prenda;
	absoleto = file of integer;


// CARGAR ARCHIVOS TANTO MAESTRO
procedure cargarArchivo(var arch: archivo);
var
	txt: Text;
	p: prenda;
begin
	assign(arch, 'Maestro');
	rewrite(arch);
	assign(txt, 'info_Maestro.txt');
	reset(txt);
	
	// LA CABECERA DEL MAESTRO
	p.cod_prenda:= 0;
	write(arch, p);
	
	while(not eof(txt)) do begin
		with p do begin
			readln(txt, cod_prenda);
			readln(txt, descripcion);
			readln(txt, colores);
			readln(txt, tipo_prenda);
			readln(txt, stock);
			readln(txt, precio_unitario);
		end;
		write(arch, p);
	end;
	
	close(txt);
	close(arch);
end;


// CARGAR ARCHIVO CON LAS PRENDAS ABSOLETAS
procedure cargarAbsoletas(var arch: absoleto);
var
	cod: integer;
begin
	assign(arch, 'prendas_Absoletas.txt');
	rewrite(arch);
	readln(cod);
	while(cod <> -1) do begin
		write(arch, cod);
		readln(cod);
	end;
	close(arch);
end;


// MODIFICAR MAESTRO CON LAS ROPAS ABSOLETAS
procedure leerArch(var arch: archivo; var p: prenda);
begin
	if(not eof(arch)) then
		read(arch, p)
	else
		p.cod_prenda:= valorAlto;
end;

procedure leerArchAbso(var arch: absoleto; var cod: integer);
begin
	if(not eof(arch)) then
		read(arch, cod)
	else
		cod:= valorAlto;
end;

procedure modificarMaestro(var mae: archivo; var pAbso: absoleto);
var
	pM, cabe: prenda;
	codA: integer;
begin
	reset(mae);
	reset(pAbso);
	leerArch(mae, cabe);
	leerArch(mae, pM);
	leerArchAbso(pAbso, codA);
	
	while(codA <> valorAlto) do begin
		// COMO NO ESTA ORDENADO EL ARCHIVO HAY QUE BUSCAR EL CODIGO
		while(pM.cod_prenda <> valorAlto) and (pM.cod_prenda <> codA) do
			leerArch(mae, pM);
		
		if(pM.cod_prenda = codA) then begin
			seek(mae, filepos(mae)-1);
			write(mae, cabe);
			seek(mae, 0);
			pM.cod_prenda:= pM.cod_prenda*-1;
			write(mae, pM);
		end
		else
			writeln('El codigo ', codA, ' no se encuentra en el archivo maestro');
		leerArchAbso(pAbso, codA);
	end;
	close(mae);
	close(pAbso);
end;


// CARGAR EL NUEVO MAESTRO CON LAS PRENDAS (sin las prendas absoletas);
procedure nuevoMaestro(var nMae: archivo; var mae: archivo);
var
	pM: prenda;
begin
	assign(nMae, 'Compactacion');
	rewrite(nMae);
	reset(mae);
	leerArch(mae, pM);
	
	while(pM.cod_prenda <> valorAlto) do begin
		if(pM.cod_prenda > 0) then
			write(nMae, pM);
		leerArch(mae, pM);
	end;
	close(mae);
	close(nMae);
	
	// Borrar el archivo binario maestro para que no haya confuncion de nombres
	erase(mae);
	
	// Asignarle un nuevo nombre al archivo binario
	Rename(nMae, 'maestro');
end;


var
	pAbsoletas: absoleto;
	mae, nueMaestro: archivo;
BEGIN
	writeln('Cargar maestro');
	cargarArchivo(mae);
	
	writeln('Cargar archivo con prendas absoletas');
	cargarAbsoletas(pAbsoletas);
	
	writeln('Modificar maestro con el archivo de prendas absoletas');
	modificarMaestro(mae, pAbsoletas);
	
	writeln('Guardar nuevo maestro sin las ropas absoletas');
	nuevoMaestro(nueMaestro, mae);
	// BORARR EL ARCHIVO BINARIO MAESTRO PARA PODER VER COMO CAMBIA
END.

