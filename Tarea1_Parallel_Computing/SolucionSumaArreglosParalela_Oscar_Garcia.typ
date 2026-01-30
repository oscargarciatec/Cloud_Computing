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

#let running_title = "Spin Voyager & Spin Compass: Propuesta de Proyecto"
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
compartida. El código fuente del proyecto se encuentra disponible en el repositorio de GitHub:

#link("https://github.com/oscar-garcia-g/SumaArreglosParalela")

#pagebreak()

= Antecedentes
Spin es una organización que opera en el sector financiero y que man-
tiene una estructura de comunicación interna altamente dependiente de he-
rramientas digitales, particularmente Slack. Dentro de este entorno, el área
de Finanzas es responsable de la gestión, análisis y validación de los gas-
tos de viaje realizados por los colaboradores, conocidos internamente como
_Spinners_.

Actualmente, dicho proceso se realiza de forma mayormente manual,
lo que implica la revisión individual de cada registro con el fin de ve-
rificar el cumplimiento de las políticas internas. Paralelamente, las consultas
relacionadas con políticas internas de viajes, viáticos, equipos de cómputo y telefonía, etc.
se atienden a través de múltiples canales, como mensajes directos, correos
electrónicos y llamadas, sin contar con un punto centralizado de referencia.

La información oficial de la organización se encuentra distribuida en dis-
tintas plataformas y formatos, tales como Google Drive, Slack, Canvas y La
Órbita (plataforma werb interna), lo que provoca confusión, versiones contradictorias
y consumo de información desactualizada. Este contexto genera fricción operativa,
reprocesos y una limitada capacidad de escalamiento conforme la organización crece.

Ante estas condiciones, surge la iniciativa de desarrollar una solución
integral que centralice la información institucional, automatice la gestión
de gastos de viaje y provea un asistente conversacional capaz de resolver
dudas frecuentes de manera consistente, confiable y alineada con las políticas
oficiales de Spin.

#pagebreak()

= Entendimiento del negocio

== Formulación del problema

El problema central que se busca resolver es la ineficiencia operativa derivada
de la gestión manual de los gastos de viaje y de la atención descentralizada
de consultas sobre políticas internas. Esta situación genera altos costos
de tiempo, errores humanos, respuestas inconsistentes y una dependencia
excesiva del criterio individual del personal del área de Finanzas.

== Contexto

El crecimiento de la organización ha incrementado tanto el volumen de
gastos de viaje como la cantidad de consultas internas. Sin embargo, los
procesos y herramientas actuales no escalan al mismo ritmo, lo que provoca
saturación operativa y afecta negativamente la experiencia de los colaboradores.
La ausencia de un sistema centralizado limita la trazabilidad y dificulta
la estandarización de la información.

Resolver este problema es fundamental para mejorar la eficiencia del área
de Finanzas, garantizar coherencia institucional y ofrecer una experiencia
más ágil y clara a los _Spinners_ dentro de su flujo de trabajo habitual.

La Figura 1 presenta la arquitectura general de la solución propuesta, en
la cual se integran los canales de interacción de los usuarios, el asistente con-
versacional, los procesos de validación de gastos de viaje y la infraestructura
que soporta el uso de modelos de aprendizaje automático.

#figure(
    image("images/Arquitectura_Voyager.png", width: 100%),
    caption: [Arquitectura general de la solución Spin Voyager.]
  )

== Objetivos

El objetivo del proyecto es diseñar e implementar una plataforma inteligente
que permita automatizar la gestión y validación de los gastos de viaje,
así como un asistente conversacional integrado en Slack que centralice las
consultas sobre políticas internas. De manera específica, se busca reducir la
carga operativa, mejorar la precisión de las respuestas y optimizar la expe-
riencia del colaborador.

Como se muestra enla Figura2, el proceso de gestión de gastos deviaje se
automatiza mediante validaciones basadas en políticas internas,reduciendo el
trabajo manual del área de Finanzas y mejorando la trazabilidad del proceso.

== Alcance del Proyecto Integrador

Este proyecto se centrará en el desarrollo del agente conversacional
embebido en la herramienta _core_ de comunicación dentro de Spin: Slack
, así como de una plataforma web, ejecutada por un equipo de operaciones,
que será capaz de gestionar la seguridad y acceso,monitorear el desempeño
del bot, analizar las conversaciones de los _Spinners_ y
obtener métricas de analítica. Todo lo anterior involucra el diseño,
desarrollo e implementación de los siguientes puntos:

1. Diseño de un modelo de datos con metodología Data Vault.
2. Desarrollo de código del agente conversacional con Gemini.
3. Implementación del código core en soluciones escalables y en la nube: Cloud Run.
4. Integración del agente conversacional con Slack, a través de su API para desarrolladores.
5. Creación de una base de datos PostgreSQL (idealmente en AlloyDB)
que fungirá como repositorio central del modelo del punto 1.
6. Desarrollo e implementación de la plataforma web para gestión, monitoreo y analítica
    en React.

== Preguntas clave

Entre las preguntas que guían el desarrollo del proyecto se encuentran:
¿cómo automatizar la validación de gastos respetando las políticas internas?,
¿cómo garantizar respuestas consistentes y confiables?, ¿qué impacto tendrá
la solución en la eficiencia operativa del área de Finanzas?,
¿cómo ajustar el agente conversacional con el fin de mejorar su precisión y velocidad?,
y ¿cómo medir la adopción y precisión del asistente conversacional?

== Involucrados

El proyecto involucra a distintos actores dentro de la organización. El
sponsor del proyecto es el área de Finanzas dentro de Spin. El desarrollo e
implementación están a cargo del Chapter de AI Products, liderado por Homero Merino que fungirá como nuestro patrocinador del proyecto
, mientras que todos los _Spinners_ fungirán como usuarios finales de la solución.

Adicionalmente, como se mencionó en la sección 3.4, también se considera
un área de Operaciones que estará a cargo de la plataforma web
de gestión de seguridad y accesos, monitoreo y mejora del agente, analítica avanzada, etc.

#pagebreak()

= Entendimiento de los datos

== Descripción de los datos

El proyecto se centra principalmente en datos no estructurados
que incluyen documentos de políticas internas, lineamientos, FAQs y
otros archivos oficiales almacenados en Google Drive.

Adicionalmente, se consideran las consultas realizadas por los usuarios en
Slack, las cuales permiten analizar patrones de uso, temas recurrentes y áreas
de oportunidad en la cobertura del conocimiento institucional.

== Técnica de Machine Learning

La solución emplea una combinación de técnicas de aprendizaje automático.
Se utiliza aprendizaje supervisado para la clasificación de intención de
las consultas, aprendizaje no supervisado mediante embeddings para la re-
cuperación de información relevante y modelos de lenguaje profundo para la
generación de respuestas naturales. Todo ello se integra bajo un enfoque de
Retrieval-Augmented Generation (RAG), asegurando que las respuestas se
basen exclusivamente en fuentes oficiales.

== Identificación de variables

Las variables de entrada incluyen el texto de las consultas de los usuarios,
los documentos de políticas internas así como los
metadatos del usuario, tales como rol y área. Las variables de salida consisten
en la clasificación de intención, respuestas conversacionales alineadas con las
políticas, alertas de posibles incumplimientos y métricas de uso y adopción
del sistema.

Asimismo, se pretende que el agente sea capaz de detectar información personal
de los usuarios (PII) y les dé un tratamiento diferente para _enmascararlos_
a nivel de base de datos, mejorando la seguridad del mismo.


#figure(
    image("images/Flujo_Asistente.png", width: 50%),
    caption: [Flujo de operación del asistente conversacional Spin Compass.]
  )

  La Figura anterior ilustra el flujo de operación del asistente conversacional,desde
la recepción de la consulta en Slack hasta la generación de una respuesta
alineada con las políticas internas o el escalamiento al equipo de soporte
cuando no existe información documentada.

#pagebreak()

= Referencias
#set text(lang: "es")
#bibliography("refs.bib", style: "ieee", full: true, title: none)
