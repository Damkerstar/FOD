program untitled;
const
	valorAlto = 9999;
type
	clientes = record
		codigo: integer;
		nombre: string;
		apellido: string;
	end;
	
	formatoM = record
		cliente: clientes;
		ano: integer;
		mes: integer;
		dia: integer;
		monto: real;
	end;

	montosM = array [1..12] of real;
	montos = record
		montoTM: montosM;
		montoTA: real;
		montoT: real;
	end;
	
	maestro= file of formatoM;


// CARGAR MAESTRO CON TXT
procedure cargarM(var mae: maestro);
var
	txt: Text;
	reg: formatoM;
begin
	assign(mae, 'arch_Maestro');
	assign(txt, 'info_Maestro.txt');
	reset(txt);
	rewrite(mae);
	while(not eof(txt)) do begin
		with reg do begin
			readln(txt, cliente.codigo);
			readln(txt, cliente.nombre);
			readln(txt, cliente.apellido);
			readln(txt, ano);
			readln(txt, mes);
			readln(txt, dia);
			readln(txt, monto);
		end;
		write(mae, reg);
	end;
	close(mae);
	close(txt);
end;


// REPORTAR EN PANTALLA
procedure verificar(var mae: maestro; var reg: formatoM);
begin
	if(not eof(mae)) then begin
		read(mae, reg);
	end
	else
		reg.cliente.codigo:= valorAlto;
end; 

procedure reportar(var mae: maestro);
var
	i: integer;
	reg: formatoM;
	monto: montos;
	mes,codigo, ano: integer;
begin
	reset(mae);
	monto.montoT:= 0;

	verificar(mae, reg);
	while(reg.cliente.codigo <> valorAlto) do begin
		writeln('Codigo: ', reg.cliente.codigo);
		writeln('Nombre: ', reg.cliente.nombre);
		writeln('Apellido: ', reg.cliente.apellido);
		codigo:= reg.cliente.codigo;
		while(reg.cliente.codigo = codigo) do begin
			monto.montoTA:= 0;
			for i:= 1 to 12 do
				monto.montoTM[i]:= 0;
			ano:= reg.ano;
			while(codigo = reg.cliente.codigo) and (ano = reg.ano) do begin
				mes:= reg.mes;
				while(codigo = reg.cliente.codigo) and (ano = reg.ano) and (mes = reg.mes) do begin
					monto.montoTM[reg.mes]:= monto.montoTM[reg.mes] + reg.monto;
					verificar(mae, reg);
				end;
			end;
			for i:= 1 to 12 do begin
				if(monto.montoTM[i] <> 0) then begin
					writeln('En el mes ', i, ' tuvo un monto de: ', monto.montoTM[i]);	
					monto.montoTA:= monto.montoTA+monto.montoTM[i];	
				end;
			end;
			
			writeln('El monto total del ano ', ano,' fue: ', monto.montoTA);
			monto.montoTA:= monto.montoTA + monto.montoTA;
			monto.montoT:= monto.montoT + monto.montoTA;
		end;
		writeln;
	end;
	writeln('El monto total es: ', monto.montoT);
	close(mae);
end;


var
	mae: maestro;
BEGIN
	
	cargarM(mae);
	
	reportar(mae);
END.

