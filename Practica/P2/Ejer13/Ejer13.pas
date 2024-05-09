program untitled;
const
	valorAlto = 'ZZZ';
type

	vuelos = record
		destino: string;
		fecha: string;
		hora: integer;
		cantD: integer;
	end;
	
	infoD = record
		destino: string;
		fecha: string;
		hora: integer;
		cantAC: integer;
	end;
	
	vueloL = record
		destino: string;
		fecha: string;
		hora: integer;
	end;
	
	lista= ^nodo;
	nodo = record
		dato: vueloL;
		sig:lista;
	end;
	
	maestro = file of vuelos;
	detalle = file of  infoD;
	

// CARGAR MAESTRO
procedure cargarM(var mae: maestro);
var
	txt: Text;
	regV: vuelos;
begin
	assign(txt, 'info_Maestro.txt');
	assign(mae, 'Vuelos');
	reset(txt);
	rewrite(mae);
	while(not eof(txt)) do begin
		with regV do begin
			readln(txt, destino);
			readln(txt, fecha);
			readln(txt, hora);
			readln(txt, cantD);
		end;
		write(mae, regV);
	end;
	close(txt);
	close(mae);
end;

// CARGAR ARCHVIO DETALLE
procedure cargarD(var det: detalle);
var
	i: integer;
	st: string;
	txt: Text;
	regI: infoD;
begin
	for i:= 1 to 2 do begin
		Str(i, st);
		assign(txt, 'info_Detalle'+st+'.txt');
		reset(txt);
		assign(det, 'info_Vuelo'+st);
		rewrite(det);
		while(not eof(txt)) do begin
			with regI do begin
				readln(txt, destino);
				readln(txt, fecha);
				readln(txt, hora);
				readln(txt, cantAC);
			end;
			write(det, regI);
		end;
		close(txt);
		close(det);
	end;
end;


// EJER B, GENERAR LISTA CON VUELOS
procedure cargarL(var L: lista; reg: vuelos);
var
	nue: lista;
begin
	new(nue);
	nue^.dato.destino:= reg.destino;
	nue^.dato.fecha:= reg.fecha;
	nue^.dato.hora:= reg.hora;
	nue^.sig:= L;
	L:= nue;
end;

procedure generarLconM(regV: vuelos; var L: lista; cantU: integer);
begin
	if(regV.cantD < cantU) then
		cargarL(L, regV);
end;



// EJER A, ACTUALIZAR EL MAESTRO CON LOS DETALLES
procedure leer(var det: detalle; var regI: infoD);
begin
	if(not eof(det)) then
		read(det, regI)
	else
		regI.destino:= valorAlto;
end;

procedure minimo(var det1, det2: detalle;var regI1: infoD;var regI2: infoD; var min: infoD);
begin
	if((regI1.destino < regI2.destino) or ((regI1.destino = regI2.destino) and (regI1.fecha < regI2.fecha)) or ((regI1.destino = regI2.destino) and(regI1.fecha = regI2.fecha) and (regI1.hora <regI2.hora))) then begin
		min:= regI1;
		leer(det1, regI1);
	end
	else begin
		min:= regI2;
		leer(det2, regI2);
	end;
end;

procedure actualizarM(var mae: maestro; var det1, det2: detalle; var L: lista);
var
	regI1, regI2, ver, min: infoD;
	regV: vuelos;
	cantU: integer;
begin
	reset(mae);
	assign(det1, 'info_Vuelo1');
	reset(det1);
	assign(det2, 'info_Vuelo2');
	reset(det2);
	leer(det1, regI1);
	leer(det2, regI2);
	
	// EJERCICIO B
	write('Ingrese la cantidad de asientos disponibles que desea guardar en una lista');
	readln(cantU);
	
	minimo(det1, det2, regI1, regI2, min);
	while(min.destino <> valorAlto) do begin
		// GUARDAMOS EN VER TODO LO DE MIN PARA LUEGO PODER ACTUALIZAR EL MAESTRO CON VER
		// YA QUE HAY CONDICIONES DE ORDENACION DEBEMOS UTILIZAR UNA VARIABLE DE VERIFICACION
		ver.destino:= min.destino;
		while(ver.destino = min.destino) do begin
			ver.fecha:= min.fecha;
			while(ver.destino = min.destino) and (ver.fecha = min.fecha) do begin
				ver.hora:= min.hora;
				ver.cantAC:= 0;
				while(ver.destino = min.destino) and (ver.fecha = min.fecha) and (ver.hora = min.hora) do begin
					ver.cantAC:= ver.cantAC + min.cantAC;
					minimo(det1, det2, regI1, regI2, min);
				end;
				
				// LEEMOS EL MAESTRO ACA PARA BUSCAR EL MISMO
				read(mae, regV);
				while(regV.destino <> ver.destino) and (regV.fecha <> ver.fecha) and (ver.hora <> regV.hora) do begin
					generarLconM(regV, L, cantU);
					read(mae, regV);
				end;
					
				// BOLUDES MIA PARA QUE NO HAYA UN NUMERO MENOR A MENOS DE LOS ASIENTOS DISPONIBLES
				regV.cantD:= regV.cantD - ver.cantAC;
				writeln(regV.cantD);
				if(regV.cantD < 0) then begin
					regV.cantD:= regV.cantD + min.cantAC;
					while(regV.cantD > 0) do begin
						regV.cantD:= regV.cantD-1;
						ver.cantAC:= ver.cantAC-1;
					end;
					writeln('La gente que no pudo entrar en el avion porque no hay mas asientos disponibles es: ', min.cantAC);
				end;
				
				seek(mae, filepos(mae)-1);
				write(mae, regV);
			end;
		end;
	end;
	
	// POR SI EN EL ARCHIVO MAESTRO NO SE TERMINO DE LEER
	while(not eof(mae)) do begin
		generarLconM(regV, L, cantU);
		read(mae, regV);
	end;
	
	close(mae);
	close(det1);
	close(det2);
end;


var
	L: lista;
	mae: maestro;
	det1, det2: detalle;
BEGIN
	cargarM(mae);
	
	cargarD(det1);
	
	L:= nil;
	actualizarM(mae, det1, det2, L);
END.

