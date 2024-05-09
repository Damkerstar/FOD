// NO LO PROVE, ME IMAGINO QUE ESTA BIEN Y SINO BUENOOOO, ya fue xd (COMPILAR COMPILA)
// HAY MUCHAS MANERAS DE RESOLVERLO PERO NO TENIA GANAS DE ESCRIBARLAS NI PENSARLAS
program untitled;
const
	N = 5;
	valorAlto = 9999;
type
	maquina = record
		cod_usuario: integer;
		fecha: string;
		tiempo_sesion: integer;
	end;
	
	archivo = file of maquina;
	vector = array[1..N] of archivo;
	vector_Maquina = array[1..N] of maquina;
	vector_posicion = array[1..N] of integer;
	
	procesados = file of integer;		// Para los registros/cod_usuarios que ya estan procesados
											// podria utilizar el mismo archivo que arriba, si, pero se me canto hacerlo con otro archivo
// CARGAR ARCHIVOS DETALLE
procedure cargarDet(var v: vector);
var
	txt: Text;
	m: maquina;
	num: string;
	i: integer;
begin
	for i:= 1 to N do begin
		Str(i, num);
		assign(txt, 'info_Detalle'+num+'.txt');
		reset(txt);
		assign(v[i], 'Detalle'+num);
		rewrite(v[i]);
		while (not eof(txt)) do begin
			with m do begin
				readln(txt, cod_usuario);
				readln(txt, fecha);
				readln(txt, tiempo_sesion);
			end;
			write(v[i], m);
		end;
		close(txt);
		close(v[i]);
	end;
end;

// INICIALIZAR EL VECTOR
procedure inicializarV(var v: vector_posicion);
var
	i: integer;
begin
	for i:= 1 to N do
		v[i]:= 0;
end;

// LEER ARCHIVOS PROCESADOS
procedure leerArchProce(var proce: procesados; var cod: integer);
begin
	if(not eof(proce)) then
		read(proce, cod)
	else
		cod:= valorAlto;
end;

// LEER ARCHIVOS
procedure leerArch(var arch: archivo; var m: maquina);
begin
	if(not eof(arch)) then
		read(arch, m)
	else
		m.cod_usuario:= valorAlto;
end;

// BUSCA CON FIN EL MISMO CODIGO DE USUARIO PARA NO PROCESAROLO OTRA VEZ
procedure BuscarProcesado(var proc: procesados; cod: integer; var ok: boolean);
var
	codArch: integer;
begin
	// Busco en los procesados si ya se proceso o no el codigo de usuario
	leerArchProce(proc, codArch);
	while(codArch <> valorAlto) and (codArch <> cod) do begin
		leerArchProce(proc, codArch);
	end;
	ok:= codArch = cod;		// Si ya se proceso entonces no lo necesito (ok = true), sino si (ok = false)
end;

// BUSCAR EL MISMO CODIGO QUE EL DE fin ENTRE LOS ARCHIVOS
procedure BuscarIgualFin(var fin: maquina; var v: vector);
var
	m: maquina;
	i: integer;
begin
	for i:= 1 to N do begin
		reset(v[i]);		// Abrir el archivo para encontrar desde el principio un codigo igual
		read(v[i], m);		// Leo
		// Hasta el final del archivo, busco codigos similares y los sumo al tiempo de fin
		while(not eof(v[i])) do begin
			if(m.cod_usuario = fin.cod_usuario) then
				fin.tiempo_sesion:= fin.tiempo_sesion + m.tiempo_sesion;
			read(v[i], m);
		end;
		close(v[i]);	// Cierro el archivo
	end;
end;

// FIN (pasar por todos los archivos hasta que sea el final)
procedure FINN(var v: vector; var vMD: vector_Maquina; var fin: maquina; var vPos: vector_posicion);
var
	i: integer;
begin
	fin.cod_usuario:= -1;
	i:= 1;
	// i es para saber si procese a todos y fin.cod_usuario es para saber si encontre un codigo "nuevo"
	while(fin.cod_usuario = -1) and (i <= N) do begin
		// Si es distinto de valorAlto entonces me agarro el registro de ese archivo
			// sino avanzo hasta encontrar o no un registro
		if(vMD[i].cod_usuario <> valorAlto) then
			fin:= vMD[i]
		else
			i:= i+1;
	end;
	
	// Si esta entre 1..5 entonces tengo que avanzar en el archivo y guardame el registro de tal
		// sino, significa que termine de leer todos los archivos
	if(i <= N) then begin
		leerArch(v[i], vMD[i]);
		vPos[i]:= vPos[i]+1;		// Por cada posicion del archivo que avanza, debo avanzar la pos
										// porque en BuscarigualFin al abrir y cerrar el archivo o si lo posicionara en 0
										// tengo que saber donde me quede
	end
	else
		fin.cod_usuario:= valorAlto;	// Si no hay mas registros por leer (i = 6)
end;

// GENERAR ARCHIVO MAESTRO CON LOS ARCHIVOS DETALLE
procedure generarMae(var mae: archivo; v: vector; var proc: procesados);
var
	fin: maquina;
	vMD: vector_Maquina;
	i: integer;
	ok: boolean;
	vPos: vector_posicion;
begin
	inicializarV(vPos);		// Inicializar cada index del vector en 0
	assign(mae, 'Maestro');
	rewrite(mae);
	
	// Abrir y leer el primer dato de cada detalle
	for i:= 1 to N do begin
		reset(v[i]);
		leerArch(v[i], vMD[i]);
	end;
	
	// Buscar el primer codigo
	FINN(v, vMD, fin, vPos);
	while(fin.cod_usuario <>  valorAlto) do begin	// Condicion para que termine
	
		// Buscar si ya se proceso el codigo que esta teniendo el registro fin (abriendo y cerrando los archivos para tener la pos en 0)
		BuscarProcesado(proc, fin.cod_usuario, ok);
		if(not ok) then begin
			write(proc, fin.cod_usuario);	// Escribir el nuevo codigo en los procesados
			BuscarIgualFin(fin, v);		// Busca todos los codigos iguales para sumar en fin el tiempo total
			write(mae, fin);			// Lo escribimos en el maestro
		end;
		
		// Abrimos los archivos en la posicion en la que se quedaron luego del leerArch en FINN()
		for i:= 1 to N do begin
			reset(v[i]);
			seek(v[i], vPos[i]);
		end;
		FINN(v, vMD, fin, vPos);	// Buscamos el siguiente codigo o nos vamos a la mierda
		
	end;
	
	// Cerramiento de archivos xd
	for i:= 1 to N do begin
		close(v[i]);
		close(proc);
	end;
end;

var
	proc: procesados;
	mae: archivo;
	vD: vector;
BEGIN
	writeln('Cargar archivos detalle');
	cargarDet(vD);
	writeln;
	
	writeln('Generar maestro a partir de detalles');
	generarMae(mae, vD, proc);
END.
