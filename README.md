# Gym

App local de entrenamiento para Android. La interfaz está en inglés o en español. Los datos se quedan en el teléfono, en SQLite. No hay cuenta ni suscripción: es una alternativa a las apps de gimnasio de pago.

Puedes tener varias rutinas y marcar una como actual. Home muestra esa rutina y el día de hoy: descanso, el entrenamiento que toca, o que el plan no tiene sesión. El menú lateral, en Home, Exercises y Routines, lleva a esas pantallas, cambia el tema entre system, light y dark, y el idioma entre system, English y Spanish. System sigue el idioma del teléfono cuando es español, y usa inglés en cualquier otro caso.

## Una rutina

Al crear una rutina eliges si es static o dynamic. También puedes partir de la plantilla de 12 semanas, o importar un JSON que otra persona te haya pasado. Desde la rutina, Export copia ese JSON.

Una rutina static sigue la semana. Una dynamic no: tienes varios entrenamientos y cada día eliges cuál hacer, aunque no sea el siguiente. Una static se puede pasar a dynamic. No al revés.

Al entrar hay cuatro pestañas. Se abre en Summary.

**Summary.** Lo que toca hoy en esta rutina. En una dynamic, si aún no has registrado el día, puedes cambiar el entrenamiento.

**Plan.** En una static, la semana, y en la plantilla de 12 semanas también la cuadrícula. Cualquier día se abre para ver los objetivos. El de hoy se registra con Log session, o se corrige con Edit log. En una dynamic, Plan es la lista de entrenamientos y el que toca hoy.

**Workouts.** En una static, el planteamiento de la semana, Rest o Workout, y el editor de cada entrenamiento. En una dynamic no hay semana: solo los entrenamientos. En fuerza hacen falta series, repeticiones y peso. El peso y las repeticiones son de ese entrenamiento, no uno solo para todo el ejercicio. En jogging, minutos y km/h. En sprint, cada intervalo con su velocidad y su duración.

**Progress.** Arriba de la barra inferior se alterna entre Charts y Calendar. Las gráficas van por ejercicio y, si el mismo ejercicio tiene objetivos de repeticiones distintos, cada uno tiene la suya. El calendario marca los días con un entrenamiento registrado. Otra rutina no se mezcla.

Weight increments, en la cabecera, enciende o apaga la subida de 2,5 kg. Rest between sets es el descanso de la rutina, en segundos, y cada ejercicio de fuerza puede poner el suyo.

Al registrar el día, cada serie sale con el objetivo en gris. El lápiz cambia el peso y las repeticiones de esa serie. La casilla la marca hecha y la guarda sola; si no has cambiado nada, se guarda el objetivo. Change exercise cambia un ejercicio solo en esa sesión, por ejemplo si falta una máquina. El entrenamiento no cambia.

Autopilot recorre las series de fuerza. Al terminar una, Next abre el descanso, con +5, +10 y +30. Ahí puedes corregir la serie anterior y marcarla. Los intervalos de sprint siguen con su cronómetro, sin ese descanso.

## Plantilla de 12 semanas

Al crear una rutina puedes partir de una plantilla al estilo StrongLifts. Eliges un lunes de inicio y el peso de salida de cada básico. Son 12 semanas, lunes, miércoles y viernes, alternando Workout A y Workout B. El peso muerto va a 5×5, igual que el resto.

- A: squat, bench press, barbell row.
- B: squat, overhead press, deadlift.

La sentadilla es una sola progresión, aunque aparezca en A y en B, porque las dos van a 5 repeticiones. Si el mismo ejercicio tiene otro número de repeticiones, esa progresión va aparte. Si la sesión anterior de esa progresión suma más de 24 repeticiones, la siguiente sube 2,5 kg. Si no, el peso se queda. No hay descargas. Fuera de esas 12 semanas, el plan no tiene sesión.

## Catálogo y cardio

Al añadir un ejercicio se filtra por grupo muscular: All, Chest, Back, Shoulders, Arms, Legs, Core y Cardio. El catálogo son levantamientos de barra y de mancuernas, más jogging y sprinting.

Jogging se anota con minutos y km/h. Sprinting se anota con el cronómetro, no con campos sueltos. Al pulsar Start hay 5 segundos de gracia y después empieza el primer intervalo, que siempre es el calentamiento. El cronómetro muestra la velocidad a la que hay que ir y el número de intervalo, por ejemplo 2/8. Un círculo vacío se va llenando en el sentido de las agujas del reloj.

## Cómo ejecutarla

Flutter no está en el PATH por defecto. El Makefile usa estas rutas:

- `PATH=$HOME/sdks/flutter/bin`
- `ANDROID_HOME=$HOME/Android/Sdk`
- `JAVA_HOME=$HOME/sdks/jdk-21`

```bash
make mobile-flutter
make mobile-flutter-apk
```

`make mobile-flutter` instala dependencias y lanza la app. Sin un teléfono conectado abre una ventana de escritorio en Linux. Para un dispositivo o un emulador: `make mobile-flutter ARGS="-d <id>"`.

`make mobile-flutter-apk` genera la APK de release, firmada con la clave de debug para poder instalarla en el teléfono:

`build/app/outputs/flutter-apk/app-release.apk`
