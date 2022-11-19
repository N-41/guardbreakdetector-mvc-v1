a = 0xFF3000

--la dirección 0xFF3000 es la base inicial donde todos los datos básicos
--se guardan, como energia, posicion, etc, lo que se pueda guardar en
--números pequeños

--ff4000 game state 6 = just starting 8 = playing a = game over
--ff32a4 1pwin ff36a4 2pwin
--ff3000 validity bit
--ff304b orientation bit
--ff3060 animid dword
--ff300c xpos
--ff3010 ypos

--de esta pequeña guía podemos ver los datos que extraeremos en nuestra repetición:
--estado de juego
--validez
--orientación
--animación
--posición en x
--posición en y
--número de victorias que cada jugador tiene

v1 = memory.readbyte(0xff32a4)
v2 = memory.readbyte(0xff36a4)
r = v1 + v2 + 1;
--primero tomamos cuenta de la cantidad de victorias que tenemos, y el round en que
--nos encontramos. Como vimos unas cuantas lineas atrás, la cantidad de victorias
--de cada jugador se encuentra en 0xff32a4 para el jugador 1, y 0xff36a4 para el 2
c = true;
--al momento de grabar, podemos encontrarnos en varios estados de juego. Se explicarán
--esos estados pronto, pero para nuestra variable c, es importante el estado hexadecimal
--c, que sucede al terminar un round cuando ya se decidió la victoria de un jugador
--cuando pase, leemos el dato de quien ganó, y dejamos de escribir, pero como sólo tenemos
--que leer una vez, entonces buscamos la siguiente condición:
--cuando estemos en estado de juego c, y la variable c sea verdadera:
--escribimos quién ganó, y asignamos c = falso
--
--así, sólo se ejecutará una vez, porque en el siguiente fotograma, c será falso
--y mientras estamos en los otros estados de juego válidos, c será verdadero, para que
--cuando terminen y llegemos a estado de juego c, llegará como verdadero
b = 0;
--la forma en que marvel vs capcom registra los proyectiles es muy rara. Primero, se mueve
--a una dirección. A esa dirección la vamos a llamar x. Esta dirección contiene una direc-
--ción a otra parte de la memoria ram, la cual puede contener:
--un proyectil
--los personajes que estén activos
--
--si esa dirección te lleva al jugador, dejamos de procesar proyectiles, pero si te lleva
--a un proyectil, guardamos su posición x,y, y nos movemos 4 bits hacia atrás, porque las
--direcciones se guardan en números dobles
--
--seguimos moviendonos 4 bits hacia atrás hasta que encontremos un jugador. No hay un
--número que nos diga cuántos proyectiles hay en cada fotograma, sólo esta pila de
--direcciones que se detiene al encontrar a un jugador. Los proyectiles seguido tampoco
--se borran de la pila, lo único certero es que el jugador se encontrará en esa pila,
--por lo que tenemos que detenernos ahí
--
--la variable b, como la variable a, guarda la dirección inicial del directorio de pro-
--yectiles, pero hay dos directorios, uno para cada jugador, por eso b es igual a 0,
--porque no importará cuánto valga b hasta que sea momento de entrar a cada directorio
f = 1;
--f es el número de fotograma a leer
--este número es relativo al round en el que nos encontremos, por lo que si se acaba un
--round, el valor volvera a 1 antes de analizar el siguiente

file = io.open("list.txt", "a")
--en la variable file, abriremos un archivo de texto llamado "list.txt", en donde
--guardaremos la repetición
--
--la forma de lua de manejar archivos, llamado "a", o "append", es la más conveniente para
--este proyecto, porque si no existe el archivo list.txt en la misma dirección donde este
--lua está guardado, entonces creará uno y empezará a escribir ahí. Si  existe, sin embargo,
--abrirá ese archivo y empezará a escribir debajo de él, así que ni la repetición ni lo que
--incluía el archivo se perderán. Si este escenario pasa, se recomienda copiar toda la
--repetición, empezando desde la arroba característica de unas cuantas líneas después a este
--documento, hasta el final, y guardarlo en otro archivo. El programa no necesita que subas
--un archivo llamado "list.txt", sólo que empiece con la arroba
file:write("@\n"..v1.."\n"..v2.."\n"..memory.readbyte(0xff4000).."\n"..r.."\n");
--lo primero que vamos a escribir en nuestro archivo serán los siguientes datos:
--la arroba que necesitamos para determinar que una nueva repetición ha empezado
--(si alguna vez se puede acceder al archivo de repetición, se agregarán los nombres
--de cada jugador también)
--victorias del equipo 1
--victorias del equipo 2
--estado de juego
--round en el que nos encontramos
--
--estos datos son vitales para que sepamos dónde empezó la grabación, y la arroba
--para que sepamos esto es una repetición que podemos abrir con este html
--
--
--the at to determine this is a new match, the names of the players will be added here if access to them exists
--ammount of victories for player 1
--ammount of victories for player 2
--gamestate
--current round

while true do
	--este ciclo while continuará hasta que se cierre la repetición
	--
	--en el programa, en sus imágenes, se explica cómo grabar la repetición
	--(este paso no se explica dentro del programa, porque el proyecto asume que
	--todos saben cómo tener su repetición lista. Para ello, tienes que ir a
	--https://www.fightcade.com/id/nombre_del_jugador_1, y de ahí, hacemos click
	--en la columna "Replays", y en el cuadro de búsqueda, escribimos el nombre 
	--del jugador 2, y de todas las repeticiones que pasaron entre ambos jugadores,
	--hacemos click en "view replay" de la que queremos. Ahí se abrirá nuestra
	--repetición. Entonces, podemos seguir los pasos que nos dice el programa para
	--grabarla al archivo list.txt)
	--
	--cuando grabemos la repetición, estamos guardando los siguientes datos:
	--posición x
	--posición y
	--orientación
	--número de animación
	--cantidad de barra de super combo
	--
	--después, si hay un proyectil dentro del fotograma, entonces para cada uno,
	--guardamos:
	--a quién le pertenece
	--posición x
	--posición y
	--
	--no tuve tiempo para guardar todos los proyectiles como guarde algunos perso-
	--najes, así que no vamos a obtener el número identificador de proyectil
	if memory.readbyte(0xff4000) == 6 or memory.readbyte(0xff4000) == 8 or memory.readbyte(0xff4000 == 0xa then
	--si estamos en alguno de los siguientes estados de juego:
	--6 - el estado antes de empezar el round, donde ambos jugadores pueden caminar adelante
	--o atrás, para preparar qué posición quieren antes de que empiece el juego
	--8 - el juego en sí
	--a - cuando el juego haya acabado, y el último jugador haya sido noqueado
	--
	--tal vez estaría bien con sólo leer el estado 8, pero el estado 6 te dice en dónde empe-
	--zó cada jugador, y el estado a nomás para que se vea bien
		gui.text(2,8,"Currently reading match");
		--gui text es una función que nos permite mostrar texto dentro del emulador
		--y el texto que mostraremos le permite saber al usuario que se está grabando
		--una animación
		gui.text(2,16,"Frame: "..f);
		--también en qué fotograma nos encontramos
		gui.text(2,24,"Round: "..r);
		--en qué round
		gui.text(2,32,"State: "..memory.readbyte(0xff4000));
		--y en que estado de juego
		file:write("Frame\n"..f.."\n");
		--después de mostrarlo en pantalla, escribimos en el documento, la palabra
		--"Frame", y el número de fotograma en el que nos encontramos en la siguien-
		--te línea
		--
		--el programa leera el archivo línea por línea, para más facilidadç
		--
		--para saber que estamos leyendo los datos de un fotograma, tenemos que
		--encontrar la palabra "Frame" sola en una´línea, es como la llave que
		--nos ayuda a confirmarlas
		--
		--y cuando la encontramos, en la siguiente línea vemos el número de 
		--fotograma en el que nos encontramos
		file:write(memory.readbyte(0xff4000).."\n");
		--en la linea debajo de esa, escribimos el estado de juego
		--dejaré de escribir que cada nuevo elemento se escribe debajo del otro 
		--porque cada vez que agregemos uno, agregaremos un "\n" para cambiar
		--de línea. Todos los datos se leen línea por línea
		if f==1 then
		--si estamos en el primer fotograma del juego
			for i=0x0,0xC00,0x400 do
			--para cada personaje de ambos equipos
				file:write(memory.readbyte(a + i + 0x53).."\n"); --charid
				--escribimos su identificador, para saber qué personaje es
				--
				--los datos de cada personaje están guardados en las direc-
				--ciones 0xff3000 + (0x400 * x), donde x es el número de
				--personaje. Los personajes 0 y 2 le pertenecen al primer
				--jugador, y los 1 y 3 al segundo. Otros datos se encuentran
				--un poco más adelante dentro de esta dirección. Por ejemplo,
				--el id de cada personaje se encuentra en la dirección
				--0xff3000 + (0x400 * x) + 0x53, y es un bit
			end --terminamos el for
		end --terminamos el if
		
		c = true;
		--cada fotograma, c será igual a true como se explicó en la línea 30
		for i=0x0,0xC00,0x400 do
		--para cada personaje de ambos equipos, como se explicó en la línea 170
			file:write(memory.readbyte(a + i).."\n")
			--escribimos su bit de validez, que se encuentra en 0xff3000 + (0x400 * i)
			--este bit nos dice si ese personaje se encuentra en pantalla o no
			--
			--dejaré de escribir el número completo y usaré la variable a, el cual
			--es 0xff3000, la variable base de los datos
			if memory.readbyte(a + i) == 1 then
			--y si sí se encuentra en pantalla
				file:write(memory.readword(a + i + 0xc).."\n"); --xpos
				file:write(memory.readword(a + i + 0x10).."\n"); --ypos
				file:write(memory.readbyte(a + i + 0x4b).."\n"); --orientation
				file:write(memory.readword(a + i + 0x60).."\n"); --animid
				file:write(memory.readword(a + i + 0x273).."\n"); --meter
				--guardamos sus datos explicados en la línea 113, que se
				--encuentran en las direcciónes:
				--x: 0xc
				--y: 0x10
				--orientation: 0x4b
				--id de animación: 0x60
				--cantidad de barra de super combo: 0x273
				--
				--sólo la orientación es un bit. Los demás son palabras
			end
		end
		b = 0xffdf16;
		--escribimos la base de los proyectiles, para empezar a analizarlos
		--esta es la base de los proyectiles del jugador 1, que compensa
		--a los del personaje 0 y 2
		while memory.readdword(b) ~= 0xff3000 and memory.readdword(b) ~= 0xff3800 and memory.readdword(b) ~= 0x0 do
		--mientras lo que se diga en b no es la dirección del personaje 0, la del 2, o sea 0 de plano,
		--significa que hay un proyectil fuera
			if(memory.readdword(memory.readdword(b) + 84)) == 0xff3000 then
			--cuando vamos a la dirección que nos da, encontramos los datos
			--del proyectil, y aquí vemos a quién le pertenece, en la dirección
			--base + 0x54
			--
			--si en esa dirección, nos dice a + (0x400 * 0), entonces es del
			--personaje 0, agregamos que le pertenece a él
				file:write("0\n");
			else
			--en caso contrario, sólo puede pertenecerle al personaje 2
				file:write("2\n");
			end
			file:write(memory.readword(memory.readdword(b) + 12).."\n");
			--escribimos su posición x en el archivo
			file:write(memory.readword(memory.readdword(b) + 16).."\n");
			--y su posición y
			b = b - 0x4;
			--nos movemos 4 bits hacia atrás para leer el siguiente proyectil
		end
		--saldremos del while cuando se encuentre a uno de los personajes
		file:write("|".."\n");
		--y dejamos una llave en el archivo, que nos dice que no hay más
		--proyectiles para el jugador 1
		b = 0xffe06e;
		--ahora checamos para los proyectiles del jugador 2, y los personajes
		--1 y 3, con esta base. Por esto es que b se declara como 0 al principio,
		--porque sí o sí va a cambiar antes de que hagamos algo
		while memory.readdword(b) ~= 0xff3400 and memory.readdword(b) ~= 0xff3c00 and memory.readdword(b) ~= 0x0 do
			--checamos si no hay ningun personaje en la lista
			if(memory.readdword(memory.readdword(b) + 84)) == 0xff3400 then
			--checamos a quién le pertenece, y lo escribimos en el archivo
				file:write("1\n");
			else
				file:write("3\n");
			end
			file:write(memory.readword(memory.readdword(b) + 12).."\n");
			file:write(memory.readword(memory.readdword(b) + 16).."\n");
			--escribimos sus posiciones x,y
			b = b - 0x4;
			--y después nos movemos 4 bits atrás
		end
		file:write("|".."\n");
		--escribimos el identificador para saber que se acabaron los proyectiles del
		--jugador 2
		f = f + 1;
		--y agregamos 1 al número de fotogramas
	elseif memory.readbyte(0xff4000) == 0xc and c then
		--si en su lugar estamos en el estado c, y esta es la primera vez que entramos
		--al estado c, como lo comprobamos con el booleano c
		file:write("Frame\n"..f.."\n");
		--escribimos el número de fotograma en el que nos encontramos
		file:write(memory.readbyte(0xff4000).."\n"); --gamestate
		--el estado de juego
		file:write(r.."\n");
		--y el primer dato exclusivo de lo que escribimos en este estado de juego, el
		--número de round
		c = false;
		--colocamos c como falso para no volver a entrar a esta sección del código
		--hasta el siguiente round
		f = 1;
		--regresamos el número de fotogramas a 1
		if memory.readbyte(0xff32a4) > v1 then
			--y vemos quien ganó
			--si el número de victorias que guardamos en la variable v1 es menor a
			--el número de victorias que vemos en la dirección 0xff32a4, entonces
			--el jugador 1 ganó
			v1 = memory.readbyte(0xff32a4)
			--cambiamos el valor de v1 al de la cantidad de victorias que en verdad tenemos
			file:write("0".."\n");
			--y escribimos en nuestro archivo un 0, para demostrar que el jugador 1 fue
			--quien ganó este round
			
		elseif memory.readbyte(0xff36a4) > v2 then
			--caso contrario, comprobamos si fue el jugador 2 quien ganó
			--no podemos escribir un else aislado por la existencia de los empates
			v2 = memory.readbyte(0xff36a4)
			--actualizamos v2
			file:write("1".."\n");
			--e indicamos que ganó el jugador 1
		else --en caso de empate
			file:write("2".."\n"); --indicamos que fue empate con un 2
		end
		r = r + 1;
		--indicamos que vamos al siguiente round añadioendole 1 a la
		--cantidad de rounds que tenemos
	else
		gui.text(2,8,"Getting ready for round "..r,"yellow");
		--en caso de que no estemos en ninguno de los estados de juego válidos,
		--entonces le decimos al usuario que estamos esperando a que el round empiece
		--para poder grabar, y le decimos en qué round estamos
	end
	emu.frameadvance();
	--el programa se ejecuta después de cada fotograma. emu.frameadvance() le dice
	--al emulador que se vaya al siguiente fotograma, para que entonces podamos
	--leer los datos del siguiente.
	--un hola mundo en un archivo lua para un emulador luciría algo así
	--while true do
	--	gui.text(2,8,"Hola Mundo");
	--	emu.frameadvance();
	--end
	--
	--si no colocamos emu.frameadvance, el emulador se quedará atascado,
	--esperando a que acabe el programa, porque no se le dió indicación de que
	--puede continuar reproduciendose
end --terminamos el while infinito