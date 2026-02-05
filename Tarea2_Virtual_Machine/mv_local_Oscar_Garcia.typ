// ---------- Page + language ----------
#set page(paper: "us-letter", margin: 1in)
#set text(lang: "es")
#show link: it => underline(text(fill: blue)[#it])
#set figure(numbering: "1")
#set figure(gap: 1em)
#show figure: set block(below: 1cm)

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
  #text(font: title-font, size: 18pt, weight: "bold")[_Tarea 2: Crear una máquina virtual de manera local_]
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

  #text(size: 11pt)[8 de febrero de 2026]
]

#pagebreak()

// ---------- After cover: restart numbering at 1 ----------

#outline(title: [Índice],depth: 3)
#pagebreak()

#let running_title = "Computación en la nube: Crear una máquina virtual de manera local"
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

Actualmente, la capacidad de abstraer recursos físicos para optimizar el desarrollo y despliegue de software es fundamental.
Este reporte documenta el proceso técnico de configuración de un servidor web utilizando tecnologías de virtualización local (Oracle VirtualBox), así
como el despliegue de una aplicación web dentro de la misma.

El objetivo principal es demostrar la viabilidad de crear entornos aislados y controlados que emulen infraestructuras reales de ambientes de producción
sin la necesidad de hardware físico adicional y apegándose lo más posible a los retos u obstáculos que pudieran aparecer.

A través de este ejercicio, se detalla la instalación de un hipervisor, la creación de una máquina virtual (MV) con el sistema operativo Debian
y la posterior configuración de servicios esenciales para el alojamiento web, así como el despliegue de una página web.
Este flujo de trabajo no solo es vital para el aprendizaje académico, sino que representa una práctica estándar en la industria
para el desarrollo de soluciones de computación en la nube, permitiendo realizar pruebas seguras y replicables.

#pagebreak()

= Capturas de pantalla de los ejercicios realizados

En esta sección se irá demostrando paso a paso el proceso para descargar e instalar VirtualBox en nuestras computadoras personales, crear una máquina virtual
con una imagen de Debian, instalar los servicios necesarios para desplegar una página web en nuestra máquina virtual y para crear y cargar nuestra página web a
la máquina virtual creada.

== Descarga e instalación de Oracle VirtualBox

A continuación, se muestran los pasos que se siguieron para descargar e instalar el programa VirtualBox, que nos permitirá crear máquinas virtuales de manera fácil y rápida.

Primero, se tiene que acceder a la página oficial de VirtualBox (Oracle) y descargar el archivo correspondiente al sistema operativo donde se instalará. En mi caso,
se trata de un sistema operativo MacOs (Apple Sillicon), por lo que corresponde el link seleccionado en la imagen.

#figure(
    image("images/Descarga_VirtualBox.png", width: 100%),
    caption: [Página de descarga de VirtualBox.]
  )

Una vez descargado el archivo correspondiente, se procede a ejecutarlo y seguir los pasos del asistente, para completar la instalación.

#figure(
    image("images/Virtual_Box_Install.png", width: 100%),
    caption: [Asistente de instalación de Virtual Box.]
  )

Después de completar la instalación, procedemos a abrir la aplicación, desde nuestra carpeta de Aplicaciones.

#figure(
    image("images/Open_VirtualBox.png", width: 100%),
    caption: [VirtualBox dentro de la carpeta de aplicaciones.]
  )

Como podemos ver, la página principal de VirtualBox tiene diferentes botones para crear una máquina virtual nueva, abrir una máquina ya existente, cambiar
las configuraciones de la aplicación, etc. Al ver la siguiente página, podemos concluir que la descarga e instalación fue exitosa.

#figure(
    image("images/Home_VirtualBox.png", width: 100%),
    caption: [Página inicial de VirtualBox.]
  )

== Descarga y creación de la máquina virtual Debian

Después de que nuestra instalación fue exitosa, procedemos a descargar la imagen que utilizaremos dentro de nuestra máquina virtual, por lo que a continuación,
se mostrarán los pasos necesarios para lograr la creación de nuestra máquina virtual, con una imagen predefinida (en este caso, se demostrará con una imagen
del sistema operativo Debian).

Primero, necesitamos ir a la página oficial de Debian y descargar la imagen que corresponda para nuestro sistema operativo base; en mi caso, la imagen que corresponde
es la etiquetada como "arm64", que se muestra en la imagen.

#figure(
    image("images/Descarga_imagen.png", width: 100%),
    caption: [Página oficial de Debian para descarga de imágenes.]
  )

#figure(
    image("images/imagen_descargada.png", width: 100%),
    caption: [Archivo ISO correspondiente a imagen descargada.]
  )

Una vez que se descargó la imagen, tenemos que crear una nueva máquina virtual en VirtualBox, a partir de esta imagen descargada. El primer paso, entonces, es
abrir nuevamente nuestra aplicación de VirtualBox, y dar clic en "Nueva", para crear una máquina virtual nueva.

#figure(
    image("images/New_VM.png", width: 100%),
    caption: [Menú de Virtual Box.]
  )

#v(.5cm)

Después de dar clic en "Nueva", nos aparece una serie de ventas y opciones como las que se muestran a continuación, donde podremos definir diferentes cosas
de nuestra máquina virtual, tales imagen base del SO, memoria y CPUs asignados, disco duro asignado, etc.

#figure(
    image("images/Config_VM.png", width: 100%),
    caption: [Configuración inicial de nuestra máquina virtual: Sistema operativo.]
  )

#figure(
    image("images/Memoria_VM.png", width: 100%),
    caption: [Configuración inicial de nuestra máquina virtual: Memoria y CPUs asignados.]
  )

#figure(
    image("images/SSD_VM.png", width: 100%),
    caption: [Configuración inicial de nuestra máquina virtual: Disco Duro asignado.]
  )

Una vez definida la configuración general de nuestra máquina virtual, podemos dar clic en "Terminar" y así estará creado nuestro entorno para nuestra
máquina virtual.

#figure(
    image("images/VM_Creada.png", width: 100%),
    caption: [Pantalla de la creación de nuestra máquina virtual.]
  )

Después de crear nuestro entorno para nuestra máquina virtual, tenemos que iniciar nuestra máquina virtual (con el botón "Iniciar" dentro de VirtualBox) y,
al ser la primera vez que la iniciamos, se iniciará el proceso de instalación del sistema operativo y configuración inicial del mismo.

Al inicio, se mostrará una pantalla como la siguiente, en la que tenemos que seleccionar la opción Graphical Install para realizar la instalación de una
manera gráfica. De esta forma, la instalación es más fácil e intuitiva para el usuario.

#figure(
    image("images/Config_Inicial_VM.png", width: 100%),
    caption: [Pantalla inicial para la instalación del SO.]
  )

Posteriormente se presentará una serie de ventanas para seleccionar el idioma, la región, zona horaria, etc.

#figure(
    image("images/Config_inicial_VM_lang.png", width: 100%),
    caption: [Pantalla de configuración regional.]
  )

Después, se definirá el nombre de la máquina, el dominio, el _super usuario_, el usuario inicial, así como sus respectivas contraseñas.

#figure(
    image("images/VM_machine_name.png", width: 100%),
    caption: [Pantalla para definir el nombre de la máquina virtual.]
  )

#figure(
    image("images/VM_domain.png", width: 100%),
    caption: [Pantalla para definir el dominio.]
  )

#figure(
    image("images/VM_su.png", width: 100%),
    caption: [Pantalla para definir el _super usuario_ y su contraseña.]
  )

#figure(
    image("images/VM_webmaster.png", width: 100%),
    caption: [Pantalla para definir un nuevo usuario.]
  )

#figure(
    image("images/VM_pass_wm.png", width: 100%),
    caption: [Pantalla para definir la contraseña del nuevo usuario.]
  )

Una vez definidos los usuarios de la máquina virtual, se procede a definir las particiones del disco duro (anteriormente creado):

#figure(
    image("images/VM_partitioning.png", width: 100%),
    caption: [Pantalla de selección de tipo de particionado.]
  )

#figure(
    image("images/VM_partitioning_2.png", width: 100%),
    caption: [Pantalla de selección de disco a particionar.]
  )

#figure(
    image("images/VM_partitioning_3.png", width: 100%),
    caption: [Pantalla de resumen de particionado.]
  )

#figure(
    image("images/VM_partitioning_confirm.png", width: 100%),
    caption: [Pantalla de confirmación de particionado.]
  )

Al finalizar este proceso de instalación del sistema base, se procede con la configuración del gestor de paquetes. En nuestro caso, no tenemos
otro medio adicional de la instalación de paquetes, por lo que seleccionamos "No" y damos clic en "Continuar".

#figure(
    image("images/VM_packages.png", width: 100%),
    caption: [Configuración de gestor de paquetes - Medio de instalación adicional.]
  )

Posteriormente, necesitamos de un repositorio cercano a nuestro país de residencia, al cual conectarnos y poder instalar nuevas aplicaciones/paquetes,
por lo que seleccionamos la región de México y la réplica a utilizar (en nuestro caso seleccionamos deb.debian.org).

#figure(
    image("images/VM_packages_2.png", width: 100%),
    caption: [Selección de región para configuración de gestor de paquetes.]
  )

#figure(
    image("images/VM_replica.png", width: 100%),
    caption: [Selección de replica a utilizar para nuestro gestor de paquetes.]
  )

== Instalación y configuración de los servicios

Después de realizar los pasos anteriores, cabe mencionar que solo se ha realizado la instalación del sistema base; es decir, que no tenemos ni un entorno gráfico
ni servicios instalados, por lo que se procede a hacer la instalación de estos últimos. Ya que es un servidor web, no instalamos ninguna interfaz gráfica, pero
es importante seleccionar la casilla de web server (que es el servidor para páginas web), SSH Server (para poder conectar a nuestra máquina virtual) y utilidades
estándar del sistema.

#figure(
    image("images/VM_additional_packages.png", width: 100%),
    caption: [Selección de replica a utilizar para nuestro gestor de paquetes.]
  )

Al realizar el paso anterior, también se instala algo conocido como GRUB que básicamente es un programa adicional que se encarga de que al encender
este entorno virtual también se cargue el sistema operativo de manera automático. Esto se conoce como cargador de arranque.

Una vez configurada nuestra máquina virtual, con los servicios necesarios instalados, podemos volver a iniciarla. Nos solicitará nuestras credenciales
(usuario root/_super usuario_ y contraseña) para poder acceder a la máquina virtual.

#figure(
    image("images/VM_login.png", width: 100%),
    caption: [Pantalla de login de nuestra máquina virtual.]
  )

Después de entrar correctamente a nuestra máquina virtual, debemos instalar nuestras herramientas de red. Esto nos servirá posteriormente para
obtener nuestra dirección IP, donde vivirá nuestra página web.

#figure(
    image("images/VM_install_net_tools.png", width: 100%),
    caption: [Instalación de net-tools.]
  )

Podemos hacer una prueba para verificar la instalación de nuestras herramientas de red, aunque los datos son irrelevantes, por ahora, ya que después se
hará una pequeña modificación, para desplegar nuestra página web.

#figure(
    image("images/VM_ifconfig_test.png", width: 100%),
    caption: [Prueba del comando ifconfig para obtener nuestra dirección IP.]
  )

== Personalización del sitio web

Ya que tenemos creada y 100% configurada nuestra máquina virtual, podemos centrarnos en nuestra página web. El primer paso es descargar nuestro _template_
a utilizar para nuestra página web.

#figure(
    image("images/web_template_download.png", width: 100%),
    caption: [Template de página web, recuperado desde: https://htmltemplates.co/free-website-templates/minimal-personal-portfolio-free-portfolio-html-template.]
  )

Después de descargar el archivo ZIP y guardarlo en nuestra computadora, podemos descomprimirlo. Ahí, podemos notar un archivo llamado "index.html"
que es el archivo que contiene toda la estructura de nuestra página. Podemos abrir este archivo en nuestro navegador preferido para ver el estado actual; sin embargo,
después es necesario abrirlo en un editor de texto (en nuestro caso fue en Antigravity) y una vez identificados los bloques de nuestra página,
podemos hacer las modificaciones pertinentes sobre nombres, descripciones, imágenes, etc.

#figure(
    image("images/web_template_start.png", width: 100%),
    caption: [Estado inicial de nuestra página web.]
  )

#figure(
    image("images/web_template_first_change.png", width: 100%),
    caption: [Archivo HTML modificado en nuestro editor de texto.]
  )

#figure(
    image("images/web_template_local_changes.png", width: 100%),
    caption: [Cambios en el nombre, descripción e imagen inicial.]
  )

#figure(
    image("images/web_template_local_changes_2.png", width: 100%),
    caption: [Cambios en la descipción e imagen en sección About.]
  )

#figure(
    image("images/web_template_local_changes_3.png", width: 100%),
    caption: [Cambios en textos de sección My Services.]
  )

#figure(
    image("images/web_template_local_changes_4.png", width: 100%),
    caption: [Cambios en Testimonials y Blog.]
  )

#figure(
    image("images/web_template_local_changes_5.png", width: 100%),
    caption: [Cambios en Contact.]
  )

== Carga del sitio web a la máquina virtual

Ya que customizamos nuestro template a nuestro gusto y que tenemos una versión preliminar, podemos proceder a cargar nuestro sitio web
a nuestra máquina virtual. Para ello, necesitamos un gestor de archivos para sitios remotos; en nuestro caso, utilizamos FileZilla, que es un gestor
gratuito y fácil de utilizar.

El primer paso, entonces, es ingresar a la página oficial de Filezilla y descargar el archivo de instalación correspondiente con nuestro sistema operativo. *Nota*:
aunque el instalador decía que era para Mac Intel, funcionó perfectamente en nuestra computadora Mac Apple Silicon.

#figure(
    image("images/download_filezilla.png", width: 100%),
    caption: [Página oficial de FileZilla.]
  )

Una vez descargado e instalado nuestro gestor de archivos, debemos hacer un cambio en nuestro entorno virtual, que permite la conexión
entre nuestra computadora y nuestra máquina virtual. De esta forma, podemos conectarnos a través de nuestro gestor de archivos y podemos hacer
la transferencia de todos los archivos necesarios para nuestra página web. A continuación, se listan los pasos necesarios para lograr esto:

1. Abrir VirtualBox.
2. Seleccionar nuestro entorno virtual.
3. Hacer clic en Configuración.
4. Ir a la sección de Red.
5. En la pestaña Adaptador 1:
  - En la opción "Conectar a", seleccionar Adaptador puente.
  - En la opción "Nombre", seleccionar nuestra tarjeta de red. El texto dependerá de nuestra computadora y configuración.
6. Dejar las demás opciones como están por default y dar clic en "Aceptar".

  #figure(
      image("images/change_network_config.png", width: 100%),
      caption: [Configuración de red en nuestro entorno virtual.]
    )

Una vez hecha esta configuración, podemos volver a iniciar nuestra máquina virtual e ingresar con nuestras credenciales, ya que necesitamos nuestra nueva
dirección IP (que cambió al hacer los ajustes anteriores).

#figure(
    image("images/ifconfig.png", width: 100%),
    caption: [Obtención de dirección IP de nuestra máquina virtual.]
  )

Después de haber obtenido la dirección IP de nuestra máquina virtual, procedemos a abrir FileZilla y conectarnos con la dirección obtenida y
nuestras credenciales previamente predefinidas (usuario nuevo: webmaster).

#figure(
    image("images/connect_to_vm.png", width: 100%),
    caption: [Conexión a la máquina virtual desde FileZilla.]
  )

#figure(
    image("images/connect_to_vm_2.png", width: 100%),
    caption: [Despliegue de directorios dentro de la máquina virtual desde FileZilla.]
  )

Antes de cargar los archivos correspondientes a nuestra página web es posible que necesitemos cambiar los permisos de escritura para nuestra
carpeta html dentro de nuestra máquina virtual. A continuación se muestra cómo lograr esto.

#figure(
    image("images/change_permissions.png", width: 100%),
    caption: [Se ejecuta el comando chmod 777 para dar permisos totales sobre la carpeta html.]
  )

Después de haber realizado este cambio de permisos, ahora sí podemos copiar todo nuestro directorio correspondiente a nuestra página web hacia nuestra
máquina virtual, dentro de la carpeta html.

#figure(
    image("images/copy_files.png", width: 100%),
    caption: [Copia de archivos hacia nuestra máquina virtual.]
  )

#pagebreak()

= Resultados obtenidos

Ahora sí, finalmente, podemos revisar cómo se ve nuestra página web dentro de nuestra máquina virtual (que funciona como servidor web),
a través de la misma dirección IP con la que nos conectamos por medio de FileZilla.

#figure(
    image("images/see_results_in_ip_2.png", width: 65%),
    caption: [Página web corriendo dentro de nuestra máquina virtual.]
  )

Al finalizar este proceso, podemos concluir que se lograron los siguientes resultados de forma satisfactoria:

1. Se consolidó una máquina virtual estable, basada en la arquitectura ARM64, optimizada para el sistema operativo "anfitrión" (macOS Apple Sillicon),
    con una asignación eficiente de recursos.
2. Mediante la configuración del adaptador puente, la máquina virtual obtuvo una dirección IP única dentro de la red local, lo que permitió una
    comunicación bidireccional satisfactoria entre la máquina y el cliente gestor de archivos (FileZilla).
3. Se verificó la correcta instalación del servidor Apache (servidor Web) y las utilidades estándar de red (net-tools). De esta forma, se logró que nuestra
    máquina virtual estuviera disponible para servir peticiones HTTP.
4. El uso de FileZilla como cliente gestor de archivos, facilitó la transferencia exitosa de nuestra página web, haciéndola accesible desde cualquier
    navegador dentro de la red local, simplemente ingresando la IP de la máquina virtual, confirmando que el entorno funciona como un servidor
    real, en ambientes de producción.

#pagebreak()

= Reflexión

La realización de esta práctica permite comprender la importancia de la virtualización, que es la tecnología que permite crear representaciones
basadas en software (virtuales) de recursos físicos, como servidores, almacenamiento o redes.

En este caso, el uso de Oracle VirtualBox fue clave; este es un hipervisor de tipo 2 que permite ejecutar múltiples sistemas operativos de
forma simultánea en una sola computadora física.

Como todo en la vida, la virtualización tiene sus ventajas y desventajas, que listaré a continuación:

Ventajas:
- Ahorro de costos al no requerir hardware físico.
- Portabilidad de las máquinas creadas y la seguridad de poder experimentar en un entorno "sandbox" sin poner en riesgo el sistema operativo principal.

Desventajas:
- Consumo de recursos (RAM y CPU) del equipo anfitrión, lo que puede degradar el rendimiento si no se cuenta con suficiente capacidad,
  además de la ligera pérdida de desempeño comparado con una instalación nativa.

En conclusión, dominar la creación de máquinas virtuales de manera local es el primer paso crítico para cualquier profesional en computación en la nube.
Facilita el despliegue de arquitecturas complejas y asegura que el entorno de desarrollo sea idéntico al de producción, reduciendo errores y
optimizando los tiempos de entrega de proyectos tecnológicos.

#pagebreak()

= Referencias
#set text(lang: "es")
#bibliography("refs.bib", style: "ieee", full: true, title: none)
