program untitled;
const
	valorAlto= 9999;
type
	informacion = record
		codigoL: integer;
		numero: integer;
		cantV: integer;
	end;
	
	archivo = file of informacion;


// CARGAR EL ARCHIVO QUE YA SE POSEIA
procedure cargarArch(var arch: archivo);
var
	txt: Text;
	i: informacion;
begin
	assign(arch, 'Mesas_Electorales');
	rewrite(arch);
	assign(txt, 'info_Archivo.txt');
	reset(txt);
	
	while(not eof(txt)) do begin
		with i do begin
			readln(txt, codigoL);
			readln(txt, numero);
			readln(txt, cantV);
		end;
		write(arch, i);
	end;
	
	close(txt);
	close(arch);
end;


// LEER ARCHIVO
procedure leerArch(var arch: archivo; var i: informacion);
begin
	if(not eof(arch)) then
		read(arch, i)
	else
		i.codigoL:= valorAlto;
end;

// BUSCAR EN EL ARCHIVO CONTROL PARA NO LEER LAS MISMAS
procedure Buscar_en_Control(var control: archivo; cod: integer; var ok: boolean);
var
	iC: informacion;
begin
	leerArch(control, iC);
	while(iC.codigoL <> valorAlto) and (iC.codigoL <> cod) do begin
		leerArch(control, iC);		// Tiene que ser leerArchivo porque sino ok puede tirar error
	end;
	ok:= iC.codigoL = cod;
end;

// PRESENTAR EN PANTALLA
procedure presentarPantalla(var arch: archivo);
var
	i: informacion;
	control: archivo;
	ok: boolean;
	pos, cantVotosM, cantVotosT, localidadAct: integer;
begin
	reset(arch);				// Abro el archivo binario para lectura y escritura
	assign(control, 'Control_Localidades');		// Asigno al archivo logico un nombre fisico
	rewrite(control);			// Creo un archivo llamado "control" y lo abro para lectura y escritura
	
	cantVotosT:= 0;
	pos:= 0;		// Es para ir avanzando en el archivo
	leerArch(arch, i);		// Leo el primer dato del archivo
	writeln('Codigo de Localidad		Total de Votos');
	while(i.codigoL <> valorAlto) do begin		// Mientras el codigo de localidad sea diferente de valorAlto
		cantVotosM:= 0;
		Buscar_en_Control(control, i.codigoL, ok);		// Busco en el archivo "control" si ya se proceso el codigo de localidad
		if(not ok) then begin		// Si no se proceso
			localidadAct:= i.codigoL;		// Agarro la localidad
			seek(control, filesize(control)-1);		// Me voy al final del archivo control
			write(control, i);		// Escribo en el archivo "control" el registro para tener su localidad
			while(not eof(arch)) do begin		// Leo hasta el ultimo del archivo para encontrar los codigos de localidad igual
				if(i.codigoL = localidadAct) then		// Codigo de localidad igual
					cantVotosM:= cantVotosM + i.cantV;		// sumo la cantidad de votos
				read(arch, i);		// Leo donde apunta el puntero y lo avanzo
			end;
			writeln(localidadAct,'			', cantVotosM);		// Imprimimos el codigo de localidad y la cantidad de votos de esa localidad
			cantVotosT:= cantVotosT + cantVotosM;
		end;
		pos:= pos+1;		// Sumo uno a la posicion para seguir con el siguiente registro del archivo
		seek(arch, pos);	// Lo muevo a esa posicion
		leerArch(arch, i);	// Leemos el archivo, si la posicion movida es el eof, entonces el codigo de localidad del registro
								// va a ser valorAlto y termina este while
		writeln;
	end;
	writeln('Total General de Votos: ', cantVotosT);
	
	close(control);
	close(arch);
end;

var
	arch: archivo;
BEGIN
	writeln('Cargando archivo');
	cargarArch(arch);
	writeln('Archivo cargado');
	writeln;
	
	writeln('Imprimiendo en pantalla un listado con las diferentes mesas electorales');
	presentarPantalla(arch);
END.

