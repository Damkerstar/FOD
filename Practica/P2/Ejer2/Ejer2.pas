program untitled;
const
	valorAlto = 9999;
type
	rango = 0..1;
	
	alumnos = record
		codigo: integer;
		AyN: string;
		cant_F: integer;
		cant_SF: integer;
	end;
	
	info = record
		codigo: integer;
		fin: rango;
		cursada: rango;
	end;
	
	detalle = file of info;
	maestro = file of alumnos;

// SE DISPONE EL ARCHIVO MAESTRO Y EL DETALLE
// CREACION DEL ARCHIVO MAESTRO Y DETALLE QUE SE SABEN DE ANTEMANO
procedure creacion_MyD(var mae: maestro; var det: detalle);
var
	txt_Det, txt_Mae: Text;
	regD: info;
	regM: alumnos;
begin
	assign(txt_Mae, 'informacion_Maestro.txt');
	reset(txt_Mae);
	rewrite(mae);
	while(not eof(txt_Mae)) do begin
		readln(txt_Mae, regM.codigo, regM.cant_SF, regM.cant_F, regM.AyN);
		write(mae, regM);
	end;
	close(txt_Mae);
	close(mae);
	
	assign(txt_Det, 'informacion_Detalle.txt');
	reset(txt_Det);
	rewrite(det);
	while(not eof(txt_Det)) do begin
		readln(txt_Det, regD.codigo, regD.fin, regD.cursada);
		write(det, regD);
	end;
	close(txt_Det);
	close(det);
end;


// A
procedure leer(var det: detalle; var registro: info);
begin
	if(not eof(det)) then
		read(det, registro)
	else
		registro.codigo:= valorAlto;
end;

procedure actualizarArch(var mae: maestro; var det: detalle);
var
	regA: alumnos;
	regI: info;
begin
	reset(det);
	reset(mae);
	while(not eof(det)) do begin
		leer(det, regI);
		read(mae, regA);
		while(regA.codigo <> regI.codigo) do
			read(mae, regA);
		while(regA.codigo = regI.codigo)  do begin
			// NO TIENE SENTIDO QUE LE RESTES LA CANT DE MATERIAS SIN FINAL APROBADO
			regA.cant_F:= regA.cant_F + regI.fin;
			regA.cant_SF:= regA.cant_SF + regI.cursada;
			leer(det, regI);
		end;
		seek(mae, filepos(mae)-1);
		write(mae, regA);
	end;
	close(mae);
	close(det);
end;


// B
procedure ListarAlum(var mae: maestro);
var
	regM: alumnos;
	txt: Text;
	nom: string;
begin
	reset(mae);
	write('Escriba un nombre para el archivo de texto');
	readln(nom);
	nom:= nom + '.txt';
	assign(txt, nom);
	rewrite(txt);
	
	while(not eof(mae)) do begin
		read(mae, regM);
		if(regM.cant_F > regM.cant_SF) then
			writeln(txt, 'Codigo: ', regM.codigo, ' Nombre:', regM.AyN, ' maetrias sin final: ', regM.cant_SF, ' materias con final: ', regM.cant_F);
	end;
	close(mae);
	close(txt);
end;


var
	mae: maestro;
	det: detalle;
	opcion: string;
BEGIN
	assign(mae, 'arch_Maestro');
	assign(det, 'info_Alumnos');
	creacion_MyD(mae, det);

	
	opcion:= '';
	while(opcion <> '3') do begin
		writeln('1) Actualizar archivo maestro');
		writeln('2) Listar aquellos alumnos que tengan mas materias con finales aprobados');
		writeln('3) Salir');
		write('Elije una opcion: ');
		readln(opcion);
		case opcion of
			'1': actualizarArch(mae, det);
			'2': ListarAlum(mae);
		end;
		writeln;
	end;
END.

