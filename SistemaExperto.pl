/* SISTEMA EXPERTO
 * Trata los síntomas como una lista.
 * Utiliza assert/1 para cambiar dinámicamente la base de conocimientos.
 * Determina la verdad y falsedad de los síntomas conocidos.
 * Puede contestar a las preguntas 'porque' e incluye capacidad de
   explicación.
 * Elimina dinámicamente las aseveraciones agregadas
   después de cada consulta.
*/

/* Almacenador de respuestas */
:- dynamic conocido/1.

/* Ejecución del programa */
consulta:-
haz_diagnostico(X),
escribe_diagnostico(X),
ofrece_explicacion_diagnostico(X),
clean_scratchpad.
consulta:-
write('No hay suficiente conocimiento para elaborar un diagnostico.'),
clean_scratchpad.

/* Lógica de diagnóstico */
haz_diagnostico(Resultado):-
	obten_hipotesis_y_sintomas(Resultado, ListaDeSintomas),
	prueba_presencia_de(Resultado, ListaDeSintomas).
obten_hipotesis_y_sintomas(Resultado, ListaDeSintomas):-
	conocimiento(Resultado, ListaDeSintomas).
prueba_presencia_de(_, []).
prueba_presencia_de(Resultado, [Head | Tail]):-
	prueba_verdad_de(Resultado, Head),
	prueba_presencia_de(Resultado, Tail).
prueba_verdad_de(Resultado, Sintoma):-
	conocido(Sintoma).
prueba_verdad_de(Resultado, Sintoma):-
	not(conocido(is_false(Sintoma))),
	pregunta_sobre(Resultado, Sintoma, Reply),
	Reply = si.

/* Pregunta sobre los síntomas */
pregunta_sobre(Resultado, Sintoma, Reply):-
	write('Es verdad que '), write(Sintoma), write('? '),
	read(Respuesta),
	process(Resultado, Sintoma, Respuesta, Reply).

/* Maneja los eventos de si, no y porque */
process(Resultado, Sintoma, si, si):-
	asserta(conocido(Sintoma)).
process(Resultado, Sintoma, no, no):-
	asserta(conocido(is_false(Sintoma))).
process(Resultado, Sintoma, porque, Reply):- nl,
	write('Estoy investigando la hipotesis siguiente: '),
	write(Resultado), write('.'), nl,
	write('Para esto necesito saber si '),
	write(Sintoma), write('.'), nl,
	pregunta_sobre(Resultado, Sintoma, Reply).

/* Valida que las respuestas sean si, no o porque */
process(Resultado, Sintoma, Respuesta, Reply):-
	Respuesta \== no,
	Respuesta \== si,
	Respuesta \== porque, nl,
	write('Debes contestar si, no o porque.'), nl,
	pregunta_sobre(Resultado, Sintoma, Reply).

/* Muestra el diagnóstico */
escribe_diagnostico(Resultado):-
	write('El diagnostico es '),
	write(Resultado), write('.'), nl.

/* Consulta si necesita explicación del porqué de la pregunta */
ofrece_explicacion_diagnostico(Resultado):-
	pregunta_si_necesita_explicacion(Respuesta),
	actua_consecuentemente(Resultado, Respuesta).
pregunta_si_necesita_explicacion(Respuesta):-
	write('Quieres que justifique este diagnostico? '),
	read(RespuestaUsuario),
	asegura_respuesta_si_o_no(RespuestaUsuario, Respuesta).
asegura_respuesta_si_o_no(si, si).
asegura_respuesta_si_o_no(no, no).
asegura_respuesta_si_o_no(_, Respuesta):-
	write('Debes contestar si o no.'),
	pregunta_si_necesita_explicacion(Respuesta).

/* Maneja los eventos de si o no al preguntar porque */
actua_consecuentemente(Resultado, no).
actua_consecuentemente(Resultado, si):-
	conocimiento(Resultado, ListaDeSintomas),
	write('Se determino este diagnostico porque se encontraron los siguentes
sintomas: '), nl,
escribe_lista_de_sintomas(ListaDeSintomas).
escribe_lista_de_sintomas([]).
escribe_lista_de_sintomas([Head | Tail]):-
	write(Head), nl, escribe_lista_de_sintomas(Tail).

/* Elimina dinámicamente aseveraciones */
clean_scratchpad:-
	retract(conocido(X)), fail.
clean_scratchpad.

conocido(_):- fail.
not(X):- X,!,fail.
not(_).








