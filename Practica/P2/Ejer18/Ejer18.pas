program untitled;
const
	valorAlto = 999;
	N = 50;
type
	informacion = record
		nroPN: integer;
		nombre: string;
		apellido: string;
		matriculaM: integer;
	end;
	
	direccion_D = record
		calle: integer;
		nro: integer;
		piso: integer;
		depto: integer;
		ciudad: string;
	end;
	
	falimiliar = record
		nombre: string;
		apellido: string;
		DNI: integer;
	end;
	
	nacimientos = record
		info: informacion;
		direccionD: direccion_D;
		padre: familiar;
		madre: familiar;
	end;
	
	fallecimientos = record
		info: informacion;
		fecha: string;
		hora: integer;
		lugar: string;
	end;
	
	maestros = record
		nacimiento: nacimientos;
		fallecimientos: fallecimientos
	end;
	
	maestro = file of maestros;
	detalleF = file of fallecimientos;
	detalleN = file of nacimietos;
	
	vectorN = array[1..N] of detalleN;
	vectorF = array[1..N] of detalleF;
	vectorRN = array[1..N] of fallecimientos;
	vectorRF = array[1..N] of nacimientos;


// CARGAR ARCHIVOS DETALLES
procedure cargarA(var vF: vectorF; var vN: vectorN);
var
	regN: nacimientos;
	regF: fallecimientos;
	txt: Text;
	i: integer;
	num: string;
begin
	for i:= 1 to N do begin
		Str(i, num);
		assign(txt, 'info_Fallecimiento'+num+'.txt');
		reset(txt);
		assign(vF[i], 'Fallecimiento'+num);
		rewrite(vF[i]);
		while(not eof(txt)) do begin
			with regF do begin
				readln(txt, info.nroPN);
				readln(txt, info.nombre);
				readln(txt, info.apellido);
				readln(txt, info.matriculaM);
				readln(txt, fecha);
				readln(txt, hora);
				readln(txt, lugar);
			end;
			write(vF[i], regF);
		end;
		close(vF[i]);
		close(txt);
		
		assign(txt, 'info_Nacimiento'+num+'.txt');
		reset(txt);
		assign(vN[i], 'Nacimiento'+num);
		rewrite(vN[i]);
		while(not eof(txt)) do begin
			with regN do begin
				readln(txt, info.nroPN);
				readln(txt, info.nombre);
				readln(txt, info.apellido);
				readln(txt, info.matriculaM);
				readln(txt, direccionD.calle);
				readln(txt, direccionD.nro);
				readln(txt, direccionD.piso);
				readln(txt, direccionD.depto);
				readln(txt, direccionD.ciudad);
				readln(txt, padre.nombre);
				readln(txt, padre.apellido);
				readln(txt, padre.DNI);
				readln(txt, madre.nombre);
				readln(txt, madre.apellido);
				readln(txt, madre.DNI);
			end;
			write(vN[i], regN);
		end;
		close(vN[i]);
		close(txt);
	end;
end;


BEGIN
	
	
END.

