program ah;
const
	valorAlto = 'ZZZ';
type
	empleados = record
		departamento: string;
		division: integer;
		numE: integer;
		categoria: integer;
		cantH: integer;
	end;

	archivo = file of empleados;
	
	valore = record
		numC: integer;
		valorHora: real;
	end;

	vector = array [1..15] of real;
	// Este vector es para el valor de la hora (monto)


// CARGAR ARCHIVO Y VECTOR
procedure cargarArchyVec(var arch: archivo; var v: vector);
var
	regE: empleados;
	regV: valore;
	txt: Text;
begin
	assign(txt, 'info_Archivo.txt');
	assign(arch, 'arch_Empleados');
	reset(txt);
	rewrite(arch);
	while(not eof(txt)) do begin
		with regE do begin
			read(txt, departamento);
			read(txt, division);
			readln(txt, numE, categoria, cantH);
		end;
		write(arch, regE);
	end;
	close(txt);
	close(arch);
	
	assign(txt, 'info_Vector.txt');
	reset(txt);
	while(not eof(txt)) do begin
		readln(txt, regV.numC, regV.valorHora);
		v[regV.numC]:= regV.valorHora;
	end;
	close(txt);
end;

// INFORMAR EN PANTALLA
procedure leer(var arch: archivo; var regE: empleados);
begin
	if(not eof(arch)) then
		read(arch, regE)
	else
		regE.departamento:= valorAlto;
end;

procedure reportar(var arch: archivo; v: vector);
var
	regE, ver: empleados;
	importTE, importTDi, importTDe: real;
	horasTE, horasTDi, horasTDe: integer;
begin
	reset(arch);
	
	leer(arch, regE);
	while(regE.departamento <> valorAlto) do begin
		ver.departamento:= regE.departamento;
		writeln('Departamento ', regE.departamento);
		importTDe:= 0;
		horasTDe:= 0;
		while(regE.departamento = ver.departamento) do begin
			writeln('Division ', regE.division);
			ver.division:= regE.division;
			horasTDi:= 0;
			importTDi:= 0;
			while(regE.departamento = ver.departamento) and (regE.division = ver.division) do begin
				ver.numE:= regE.numE;
				importTE:= 0;
				horasTE:= 0;
				writeln('Numero de Empleado				Total de Hs.			Importe a cobrar');
				while(regE.departamento = ver.departamento) and (regE.division = ver.division) and (regE.numE = ver.numE) do begin
					importTE:= importTE + v[regE.categoria] * regE.cantH;
					horasTE:= horasTE + regE.cantH;
					leer(arch, regE);
				end;
				writeln(ver.numE,'						', horasTE,'				',importTE);
				importTDi:= importTDi + importTE;
				horasTDi:= horasTDi + horasTE;
			end;
			writeln('Total de horas division: ', horasTDi);
			writeln('Monto total por division: ', importTDi);
			writeln;
			importTDe:= importTDe + importTDi;
			horasTDe:= horasTDe + horasTDi;
		end;
		writeln('Total horas departamento: ', horasTDe);
		writeln('Monto total departamento: ', importTDe);
		writeln;
		writeln;
	end;
end;

var
	arch: archivo;
	v: vector;
BEGIN
	cargarArchyVec(arch, v);
	
	reportar(arch, v);
END.
