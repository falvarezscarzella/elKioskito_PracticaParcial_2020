% Base de conocimiento

/*
dodain atiende lunes, miércoles y viernes de 9 a 15.
lucas atiende los martes de 10 a 20
juanC atiende los sábados y domingos de 18 a 22.
juanFdS atiende los jueves de 10 a 20 y los viernes de 12 a 20.
leoC atiende los lunes y los miércoles de 14 a 18.
martu atiende los miércoles de 23 a 24.
*/

%atiende(quien,dias,turno(horaInicial,horaFinal)).

atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).
atiende(lucas, martes, 10, 20).
atiende(juanC, sabados, 18, 22).
atiende(juanC, domingos, 18, 22).
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).
atiende(martu, miercoles, 23, 24).

% PUNTO 1
/*
vale atiende los mismos días y horarios que dodain y juanC.
nadie hace el mismo horario que leoC
maiu está pensando si hace el horario de 0 a 8 los martes y miércoles
*/

atiende(vale,Dia,HoraInicial,HoraFinal):- atiende(dodain,Dia,HoraInicial,HoraFinal).
atiende(vale,Dia,HoraInicial,HoraFinal):- atiende(juanC,Dia,HoraInicial,HoraFinal).

%Por universo cerrado no se agrega nada mas

% PUNTO 2

quienAtiende(Dia,Hora,Persona):-
    atiende(Persona,Dia,HoraInicial,HoraFinal),
    between(HoraInicial, HoraFinal, Hora).

% PUNTO 3

estaSola(Dia,Hora,Persona):-
    quienAtiende(Dia,Hora,Persona),
    atiende(OtraPersona,_,_,_),
    not(quienAtiende(Dia,Hora,OtraPersona)),
    Persona \= OtraPersona.

% PUNTO 4

esDia(Dia):- atiende(_,Dia,_,_).

quienesLaburan(Dia,Personas):-
    esDia(Dia),
    findall(Persona,atiende(Persona,Dia,_,_),Quienes),
    combinar(Quienes,Personas).

combinar([], []).
combinar([Posible|Posibles], [Posible|Personas]):-combinar(Posibles, Personas).
combinar([_|Posibles], Personas):-combinar(Posibles, Personas).

% PUNTO 5
/*
En el kiosko tenemos por el momento tres ventas posibles:
golosinas, en cuyo caso registramos el valor en plata
cigarrillos, de los cuales registramos todas las marcas de cigarrillos que se vendieron (ej: Marlboro y Particulares)
bebidas, en cuyo caso registramos si son alcohólicas y la cantidad
*/

% venta(quien,dia,que).
/*
dodain hizo las siguientes ventas el lunes 10 de agosto: golosinas por $ 1200, cigarrillos Jockey, golosinas por $ 50
dodain hizo las siguientes ventas el miércoles 12 de agosto: 8 bebidas alcohólicas, 1 bebida no-alcohólica, golosinas por $ 10
martu hizo las siguientes ventas el miercoles 12 de agosto: golosinas por $ 1000, cigarrillos Chesterfield, Colorado y Parisiennes.
lucas hizo las siguientes ventas el martes 11 de agosto: golosinas por $ 600.
lucas hizo las siguientes ventas el martes 18 de agosto: 2 bebidas no-alcohólicas y cigarrillos Derby.
*/

ventas(dodain, fecha(10,8), [golosinas(1200), cigarrillos([jockey]), golosinas(50)]).
ventas(dodain, fecha(12,8), [bebidas(true, 8), bebida(false, 1)]).
ventas(martu, fecha(12,8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
ventas(lucas, fecha(11,8), [golosinas(600)]).
ventas(lucas, fecha(18,8), [bebidas(false, 2), cigarrillos([derby])]).

/*
Una venta es importante:
en el caso de las golosinas, si supera los $ 100.
en el caso de los cigarrillos, si tiene más de dos marcas.
en el caso de las bebidas, si son alcohólicas o son más de 5}
*/

esImportante(golosinas(Plata)):-
    Plata > 100.
esImportante(cigarrillos(Marcas)):-
    length(Marcas,Cantidad),
    Cantidad > 2.
esImportante(bebida(true,_)).
esImportante(bebida(_,Cantidad)):-
    Cantidad > 5.

/*
Es suertuda si para todos los días en los que vendió, la primera venta que hizo fue importante.
*/

esSuertuda(Persona):-
    ventas(Persona,_,[PrimerVenta|_]),
    esImportante(PrimerVenta).    