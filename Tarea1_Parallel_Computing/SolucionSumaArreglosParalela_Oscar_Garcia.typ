// ---------- Page + language ----------
#set page(paper: "us-letter", margin: 1in)
#set text(lang: "es")
#show link: it => underline(text(fill: blue)[#it])
#set figure(numbering: "1")

// ---------- Global typography ----------
#let body-font  = ("Publico Text","Charter", "Georgia", "Times New Roman")
#let title-font = ("Didot","Baskerville", "Times New Roman")
#let sc-font    = ("Hoefler Text", "Libertinus Serif", "Times New Roman")

#set text(font: body-font, size: 12pt)
#set par(justify: true, leading: 1.2em, spacing: 1.7em, first-line-indent: 0pt)

// Heading fonts (pick from your list)
#let h1-font = ("Didot","Baskerville", "Times New Roman")
#let h2-font = h1-font
#let h3-font = h1-font

// Global heading tweaks (spacing)
#show heading: it => {
  set block(above: 1.5em, below: 1.5em)
  it
}

// Level-specific typography
#show heading.where(level: 1): it => {
  set block(above: 1.5em, below: 1.2em)
  set text(font: h1-font, size: 22pt, weight: "bold")
  it
}
#show heading.where(level: 2): it => {
  set block(above: 1.3em, below: 0.9em)
  set text(font: h2-font, size: 18pt, weight: "bold")
  it
}
#show heading.where(level: 3): it => {
  set block(above: 0.8em, below: 0.5em)
  set text(font: h3-font, size: 14pt, weight: "semibold")
  it
}

// ---------- Cover page (no page number) ----------
#set page(numbering: none)

#align(center)[
  #v(0.5cm)
  #image("images/logo.jpg", width: 70%)
  #v(1.2cm)

  // Institute line with small caps
  #text(font: sc-font, size: 14pt, tracking: 0.03em)[
    #smallcaps[Instituto Tecnológico y de Estudios Superiores de Monterrey]
  ]
  #v(0.5cm)

  // Title + subtitle
  #text(font: title-font, size: 26pt, weight: "bold")[Maestría en Inteligencia Artificial:]
  #v(0.2cm)
  #text(font: title-font, size: 18pt, weight: "bold")[_Tarea1: Programación de una solución paralela_]
  #v(2.5cm)

]

#align(left)[
  // Name + ID
  #text(font: body-font, size: 13pt, weight: "bold")[Alumno: Oscar Enrique García García - A01016093]
  #v(0.2cm)
]

// Professors (labels aligned to names)
#table(
  columns: (auto, 1fr),
  column-gutter: 0.8em,
  inset: 0pt,
  stroke: none,
  align: (left, left),
)[
  #text(weight: "bold")[Profesor Titular:] Gilberto Echeverría Furió

  #text(weight: "bold")[Profesor asistente:] Yetnalezi Quintas Ruiz
]

#v(1fr)

// Bottom-right: course + date
#align(right)[
  #text(size: 12pt)[Cómputo en la nube]

  #text(size: 11pt)[Enero, 2026]
]

#pagebreak()

// ---------- After cover: restart numbering at 1 ----------

#outline(title: [Índice],depth: 3)
#pagebreak()

#let running_title = "Computación en la nube: Programación de una solución paralela"
#counter(page).update(1)
#set page(
  header: context [
    #block(width: 100%)[
      #text(size: 10pt)[#running_title]
      #h(1fr)
      #text(size: 10pt)[#counter(page).display()]
    ]
    #line(length: 100%, stroke: 0.5pt)
    #v(6pt)
  ],
)

#set heading(numbering: "1.")
#set figure(numbering: "1")

= Introducción

Tradicionalmente, el software se ha escrito para el cómputo secuencial:
un programa recibe una instrucción, la ejecuta y, solo cuando termina,
pasa a la siguiente. Sin embargo, los procesadores modernos cuentan con múltiples núcleos (cores)
que pueden trabajar simultáneamente.

La programación en paralelo es el proceso de dividir un problema grande en partes más pequeñas
que pueden resolverse al mismo tiempo, aprovechando cada núcleo del procesador de forma concurrente
y, de esta forma, optimizar el tiempo de ejecución.

El uso de paralelismo es fundamental en el desarrollo actual por varias razones:

- Reducción de Tiempo: Tareas que tardarían horas en un solo hilo pueden completarse en minutos
  al distribuir la carga.
- Manejo de Big Data: Permite procesar volúmenes masivos de información que, de otro modo,
  saturarían un solo núcleo.
- Eficiencia Energética: A menudo es más eficiente realizar un trabajo rápido usando
  varios núcleos a una frecuencia moderada que forzar un solo núcleo a su máxima capacidad
  por mucho tiempo.

En este proyecto, utilizamos OpenMP (Open Multi-Processing), una interfaz de programación
de aplicaciones (API) que permite añadir paralelismo a códigos escritos en C++ mediante
"pragmas" o directivas de compilador. Es una de las herramientas más potentes
para cómputo de alto rendimiento debido a su facilidad de implementación en sistemas de memoria
compartida.

El código fuente del proyecto se encuentra disponible en el *repositorio de GitHub:*

#link("https://github.com/oscargarciatec/Cloud_Computing/blob/main/Tarea1_Parallel_Computing/Tarea1.cpp")

#pagebreak()

= Capturas de pantalla de los ejercicios realizados

#figure(
    image("images/Ejercicio1.png", width: 100%),
    caption: [Ejecución del proyecto con 1000 números generados, chunks de tamaño 100 e impresión de 10 resultados.]
  )

  #figure(
      image("images/Ejercicio1.png", width: 100%),
      caption: [Ejecución del proyecto con 100000 números generados, chunks de tamaño 1000 e impresión de 100 resultados.]
    )

#pagebreak()

= Explicación del código y los resultados

El código se divide en 4 secciones principales:

1. Importación de librerías, definición de variables y definición de funciones.
2. Generación de números aleatorios para los arreglos a y b.
3. Generación del arreglo c con la suma de los números generados en el paso anterior.
4. Impresión de resultados.

== Importación de librerías, definición de variables y definición de funciones.

Estas primeras líneas del código se centran en la importación
de las librerías que usamos para todo el código, incluyendo la librería
_random_ que nos servirá para generar los números aleatorios.

#raw(lang: "c++", "#include <iostream>
#include <omp.h>
#include <random>")

A continuación, se definen las variables "N" que es el tamaño de cada
uno de los arreglos (números que se generarán), "chunk" que corresponde
al tamaño de esos "pedazos" en los que se divide la tarea entre los hilos
y "mostrar" que hace referencia a cuántos números se mostrarán en la impresión
de resultados. De igual forma, se declara nuestra función "imprimeArreglo"
que recibirá un arreglo de números decimales como parámetro.

#raw(lang: "c++", "#define N 100000
#define chunk 1000
#define mostrar 100

void imprimeArreglo(float *d);")

Finalmente, se define el código de la función imprimeArreglo que
básicamente recorre el arreglo de números flotantes que recibe como
parámetro e imprime cada "posición" (cada número), separada por guiones
medios.

#raw(lang: "c++", "void imprimeArreglo(float* d)
{
	for (int x = 0; x < mostrar; x++)
		std::cout << d[x] << \" - \";
	std::cout << std::endl;
}")

== Generación de números aleatorios para los arreglos a y b.

En el siguiente bloque se inicializa la función main del código y se
crean los arreglos a, b y c, de tamaño N (la variable
que declaramos al inicio). De igual forma, se define la variable "i"
que nos servirá como apuntador en nuestro ciclo for que genera los
números aleatorios para cada arreglo y finalmente, se declara la variable
local "pedazos" que será del mismo valor que la variable "chunk" del inicio.

#raw(lang: "c++", "int main()
{
	std::cout << \"Sumando Arreglos en Paralelo!\\n\";
	float a[N], b[N], c[N];
	int i;
	int pedazos = chunk;")

Este bloque de código es el encargado de generar los números aleatorios.
En este bloque hay un par de cosas que vale la pena recalcar:

1. Se utiliza pragma omp parallel con el fin de repartir las tareas
  del bloque en diferentes hilos.
2. La variable "i" se define como privada para evitar "colisiones"
  o sobreescritura de la variable entre los diferentes hilos.
3. Se emplea el algoritmo mt19937 con una semilla única por hilo (tid)
  para asegurar que la generación de números sea independiente. Adicionalmente,
  se utiliza uniform_real_distribution para generar números entre 1 y 100.
4. Se utiliza pragma omp for schedule(static, pedazos) con el fin
  de repartir las n iteraciones del ciclo for entre todos los hilos disponibles.
  Con esto, finalmente se guarda cada número generado en cada una de las posiciones
  de los arreglos a y b.

#raw(lang: "c++", "#pragma omp parallel private(i)
	{
		int tid = omp_get_thread_num();
		std::mt19937 gen(std::random_device{}() ^ tid);
		std::uniform_real_distribution<float> dis(1.0, 100.0);

		#pragma omp for schedule(static, pedazos)
		for (i = 0; i < N; i++)
		{
			a[i] = dis(gen);
			b[i] = dis(gen);
		}
	}")

== Generación del arreglo c

Una vez generados los arreglos a y b, se crea un nuevo ciclo for
que, de igual forma, repartirá las n iteraciones del mismo entre
todos los hilos disponibles.

Como podemos ver, el ciclo for calcula la suma entre
el número en la posición "i" del arreglo "a" con el número en la misma
posición del arreglo "b" y guarda el resultado en el arreglo "c",
para cada una de las posiciones en los arreglos.

#raw(lang: "c++", "#pragma omp parallel for \\
	shared(a,b,c, pedazos) private(i) \\
	schedule(static, pedazos)

	for (i = 0; i < N; i++)
		c[i] = a[i] + b[i];")

== Impresión de resultados

Finalmente, se hace una impresión de resultados, utilizando
la función imprimeArreglo para imprimir lor primeros n resultados,
definidos por la variable "mostrar", para cada uno de los arreglos.

De esta forma, podemos verificar que los resultados son los correctos;
que, efectivamente, cada posición en "c" es el resultado de la suma
de los números en la misma posición de los arreglos "a" y "b".

#raw(lang: "c++", "std::cout << \"Imprimiendo los primeros \" << mostrar << \" valores del arreglo a: \" << std::endl;
	imprimeArreglo(a);
	std::cout << \"Imprimiendo los primeros \" << mostrar << \" valores del arreglo b: \" << std::endl;
	imprimeArreglo(b);
	std::cout << \"Imprimiendo los primeros \" << mostrar << \" valores del arreglo c: \" << std::endl;
	imprimeArreglo(c);
}")

#pagebreak()

== Código Completo

#raw(lang:"c++","
#include <iostream>
#include <omp.h>
#include <random>

#define N 100000
#define chunk 1000
#define mostrar 100

void imprimeArreglo(float *d);

void imprimeArreglo(float* d)
{
	for (int x = 0; x < mostrar; x++)
		std::cout << d[x] << \" - \";
	std::cout << std::endl;
}

int main()
{
	std::cout << \"Sumando Arreglos en Paralelo!\\n\";
	float a[N], b[N], c[N];
	int i;
	int pedazos = chunk;

	#pragma omp parallel private(i)
	{
		int tid = omp_get_thread_num();
		std::mt19937 gen(std::random_device{}() ^ tid);
		std::uniform_real_distribution<float> dis(1.0, 100.0);

		#pragma omp for schedule(static, pedazos)
		for (i = 0; i < N; i++)
		{
			a[i] = dis(gen);
			b[i] = dis(gen);
		}
	}

	#pragma omp parallel for \\
	shared(a,b,c, pedazos) private(i) \\
	schedule(static, pedazos)

	for (i = 0; i < N; i++)
		c[i] = a[i] + b[i];

	std::cout << \"Imprimiendo los primeros \" << mostrar << \" valores del arreglo a: \" << std::endl;
	imprimeArreglo(a);
	std::cout << \"Imprimiendo los primeros \" << mostrar << \" valores del arreglo b: \" << std::endl;
	imprimeArreglo(b);
	std::cout << \"Imprimiendo los primeros \" << mostrar << \" valores del arreglo c: \" << std::endl;
	imprimeArreglo(c);
}")

#pagebreak()

= Reflexión

La programación paralela, ejemplificada en este proyecto con OpenMP,
representa un cambio de paradigma respecto a la ejecución secuencial
tradicional. De este ejercicio se desprenden las siguientes conclusiones:

- *Eficiencia en Escala*: Para un arreglo de 1,000 elementos,
  la diferencia de tiempo es imperceptible,
  pero cuando escalamos a millones de datos o simulaciones físicas
  complejas, la capacidad de dividir el "bucle for" entre los núcleos
  disponibles del CPU reduce el tiempo de ejecución casi de forma lineal.

- *Gestión de Memoria*: El código utiliza la cláusula private(i)
  y shared(a,b,c). Esto es crítico: si el índice "i" no fuera privado,
  los hilos entrarían en una "condición de carrera" (race condition),
  intentando modificar la misma variable de control simultáneamente,
  lo que colapsaría el programa.

- *Abstracción de Complejidad*: OpenMP permite que el desarrollador
  se concentre en la lógica del algoritmo mientras la librería
  se encarga de la creación, sincronización
  y destrucción de los hilos (threads).

Finalmente, el ejercicio demuestra que la programación paralela
no es solo una técnica de optimización, sino una necesidad
arquitectónica. Al dominar herramientas como OpenMP, logramos que el
software sea capaz de aprovechar el hardware multincúcleo actual,
superando los límites físicos de la velocidad de procesamiento
de un solo núcleo y abriendo la puerta a procesamientos
de datos masivos con un control preciso sobre la memoria
y la sincronización.

#pagebreak()

= Referencias
#set text(lang: "es")
#bibliography("refs.bib", style: "ieee", full: true, title: none)
