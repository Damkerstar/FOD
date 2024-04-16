program untitled;
type
	comision = record
		codigo: integer;
		nombre: string;
		monto: integer;
	end;
	
	archivo = file of comision;


procedure Imprimir(var arch: archivo);
var
	com: comision;
begin
	reset(arch);					// Abrimos el archivo binario de lectura y escritura
	while(not eof(arch)) do begin	// Mientras no sea el final del archivo del archivo binario
		read(arch, com);			// Guardamos lo que apunta el puntero en nov y avanzamos el puntero
		with com do begin
			writeln('Los datos de la novela son: ');
			writeln('Nombre: ', nombre);
			writeln('Codigo: ', codigo);
			writeln('Monto: ', monto);
		end;
		writeln;
	end;
	writeln('No hay mas novelas por imprimir');
	writeln();
	close(arch);	// Cerramos el archivo binario
end;


var
	mae: archivo;		// Archivo binario
	det: Text;		// Archivo de texto
	regEm: comision;	// Registro de empleados
	regCom: comision;	// Registro de cada comision
BEGIN
	assign(det, 'empleados.txt');		// Le asignamos un nombre fisico al archivo logico
	reset(det);							// Lo abrimos de lectura y escritura

	assign(mae, 'comisiones');		// Le asignamos un nombre fisico al archivo logico
	rewrite(mae);						// Creamos un nuevo archivo binario
	if(not eof(det)) then
		readln(det, regEm.codigo, regEm.monto, regEm.nombre);			// Guardamos la informacion de lo que apunta el puntero del archivo y avanzamos el puntero
	
	while(not eof(det)) do begin
		regCom.monto:= 0;
		regCom.codigo:= regEm.codigo;
		regCom.nombre:= regEm.nombre;
		while((regEm.codigo = regCom.codigo) and (not eof(det))) do begin
			regCom.monto:= regCom.monto + regEm.monto;
			readln(det, regEm.codigo, regEm.monto, regEm.nombre);		// Guardamos la informacion de lo que apunta el puntero del archivo y avanzamos el puntero
		end;
		write(mae, regCom);				// Escribimos lo que tiene el registro en el archivo y avanzamos el puntero
	end;
	write(mae, regCom);			// Este ultimo write lo hacemos porque como avanzo el puntero estaba en eof, pero seguimos teniendo un dato que nos falto escribir;
	// Cerramos los archivos
	close(det);
	close(mae);
	Imprimir(mae);
END.

;
