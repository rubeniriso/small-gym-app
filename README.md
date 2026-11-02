# Gym

App local de entrenamiento para Android. La interfaz está en inglés. Los datos se quedan en el teléfono, en SQLite. No hay cuenta ni suscripción: es una alternativa a las apps de gimnasio de pago.

Puedes tener varias rutinas y marcar una como actual. Home muestra esa rutina y el día de hoy: descanso, el entrenamiento que toca, o que el plan no tiene sesión. El menú lateral, en Home y en la lista de rutinas, lleva a Home y a Routines, y cambia el tema entre system, light y dark.

## Una rutina

Al entrar en una rutina hay tres pestañas. Se abre en Plan.

**Plan.** La semana, y en la plantilla de 12 semanas también la cuadrícula. Cualquier día se abre para ver los objetivos. El de hoy se registra con Log session, o se corrige con Edit log.

**Workouts.** El planteamiento de la semana, Rest o Workout, y el editor de cada entrenamiento: ejercicios y objetivos. En fuerza hacen falta series, repeticiones y peso. En jogging, minutos y km/h. En sprint, cada intervalo con su velocidad y su duración.

**Progress.** Una gráfica por ejercicio de esa rutina. El peso en los levantamientos, la velocidad y los minutos en jogging, y la velocidad punta en los sprints. Otra rutina no se mezcla.

## Plantilla de 12 semanas

Al crear una rutina puedes partir de una plantilla al estilo StrongLifts. Eliges un lunes de inicio y el peso de salida de cada básico. Son 12 semanas, lunes, miércoles y viernes, alternando Workout A y Workout B. El peso muerto va a 5×5, igual que el resto.

- A: squat, bench press, barbell row.
- B: squat, overhead press, deadlift.

La sentadilla es una sola progresión, aunque aparezca en A y en B. Si la sesión anterior de ese levantamiento suma más de 24 repeticiones, la siguiente sube 2,5 kg. Si no, el peso se queda. No hay descargas. Fuera de esas 12 semanas, el plan no tiene sesión.

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
