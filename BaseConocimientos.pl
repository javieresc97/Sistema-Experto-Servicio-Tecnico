/* BASE DE DATOS
 * Dominio: diagnóstico de servicio técnico de computadoras.
 * Modelo: conocimiento(Diagnostico, ListaSintomas).
*/

conocimiento('falla de la ram',
['el cpu da pitidos', 'la computadora se reinicia',
'muestra pantalla azul']).
conocimiento('falla de la tarjeta madre',
['la computadora no enciende', 'muestra pantalla azul',
 'el cpu da pitidos','la computadora se apaga']).
conocimiento('falla de la tarjeta de video',
['el monitor no da señal','el cpu da pitidos',
 'la imagen se ve borrosa en el monitor']).
conocimiento('virus',
['el cpu se reinicia', 'falta de informacion', 'lentitud en el uso de la computadora']).
