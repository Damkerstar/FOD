program untitled;
const
	valorAlto= 9999;
type
	registrados = record
		codigoP: integer;
		codigoL: integer;
		numeroM: integer;
		cantV: integer;
	end;
	
	maestro = file of registrados;

// SE DISPONE EL ARCHIVO MAESTRO
procedure cargarM(var mae: maestro);
var
	regM: registrados;
	txt: Text;
begin
	assign(mae, 'arhc_Maestro');
	assign(txt, 'info_Maestro.txt');
	reset(txt);
	rewrite(mae);
	
	while(not eof(txt)) do begin
		with regM do begin
			readln(txt, codigoP);
			readln(txt, codigoL);
			readln(txt, numeroM);
			readln(txt, cantV);
		end;
		write(mae, regM);
	end;
	close(mae);
	close(txt);
end;


procedure leer(var mae: maestro; var regM: registrados);
begin
	if(not eof(mae)) then
		read(mae, regM)
	else
		regM.codigoP:= valorAlto;
end;

var
	mae: maestro;
	regM, ver: registrados;
	totalV, totalLocal: integer;
BEGIN
	cargarM(mae);
	reset(mae);
	totalV:= 0;
	
	leer(mae, regM);
	while(regM.codigoP <> valorAlto) do begin
		ver.codigoP:= regM.codigoP;
		ver.cantV:= 0;
		writeln('Codigo de Provincia: ',ver.codigoP);
		writeln('Codigo de Localidad 				Total de Votos');
		while(ver.codigoP = regM.codigoP) do begin
			ver.codigoL:= regM.codigoL;
			totalLocal:= 0;
			while(ver.codigoP = regM.codigoP) and (ver.codigoL = regM.codigoL) do begin
				totalLocal:= totalLocal + regM.cantV;
				leer(mae, regM);
			end;
			ver.cantV:= ver.cantV + totalLocal;
			writeln(ver.codigoL, '							', totalLocal);
		end;
		writeln('Total de Votos Provincia: ', ver.cantV);
		totalV:= totalV + ver.cantV;
		writeln;
	end;
	writeln('Total General de Votos: ', totalV);
END.

