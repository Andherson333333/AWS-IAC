## Índice de contenidos
* [Que es IAC?](#item1)
* [Que es terraform?](#item2)
* [Estrucutura de archivos terraform](#item3)
* [Comandos terraform ](#item4)
* [Instalacion terrform](#item5)
* [Funciones Terrafomr](#item6)
* [Estrucutras de control](#item7)

<a name="item1"></a>
## Que es IAC?

  La Infraestructura como Código (IAC) es una metodología que trata la infraestructura informática como software, lo que permite gestionar y configurar de manera automatizada todos los recursos de una infraestructura tecnológica mediante código. En lugar de configurar manualmente servidores, redes y otros componentes, se utiliza código para describir la infraestructura deseada, lo que facilita su implementación, mantenimiento y escalabilidad. Terrafom tiene la capacidad de comunicarse a traves de api con AWS,GCPM,AKS entre otras plataformas de cloud para mas informacion https://registry.terraform.io/browse/providers

<a name="item2"></a>
## Que es terraform?

  Terraform es una herramienta de código abierto desarrollada por HashiCorp que se utiliza para implementar y gestionar infraestructuras de manera automatizada y declarativa. Permite definir la infraestructura como código en un lenguaje específico (HCL, HashiCorp Configuration Language), lo que facilita la creación, modificación y eliminación de recursos en diferentes proveedores de nube y entornos on-premise de manera coherente y reproducible.

<a name="item3"></a>
## Estrucutura de archivos terraform

  En Terraform, la estructura de archivos típicamente incluye:

- Archivos de configuración principal: como `main.tf`, donde se definen los recursos y configuraciones principales.
- Archivos de variables: como `variables.tf`, donde se declaran las variables utilizadas en el código.
- Archivos de salidas: como `outputs.tf`, donde se especifican las salidas de los recursos creados.
- Archivos de configuración de proveedores: como `providers.tf`, donde se configuran los proveedores de nube o servicios.
- Otros archivos de soporte: como `terraform.tfstate` (estado de la infraestructura) y terraform.tfvars (valores de variables).

<a name="item4"></a>
## Comandos terraform 

Algunos comandos comunes de Terraform incluyen:

- `terraform init:` Inicializa el directorio de trabajo y descarga los proveedores y módulos necesarios.
- `terraform plan:` Genera un plan de ejecución que muestra los cambios que se aplicarán en la infraestructura.
- `terraform apply:` Aplica los cambios definidos en el código de Terraform en la infraestructura.
- `terraform destroy:` Elimina todos los recursos gestionados por Terraform según la configuración.
- `terraform validate:` Verifica la sintaxis y la semántica de los archivos de configuración de Terraform.
- `terraform state:` Permite gestionar el estado de la infraestructura y realizar operaciones avanzadas.

<a name="item5"></a>
## Instalacion terrform

Para instalar terraform porfavor ir a la documentacion oficial https://developer.hashicorp.com/terraform/install


Para instalar terraform en un sistema linux (debian o ubuntu) se puede realizar con los siguientes comandos :

```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```
<a name="item6"></a>
## Funciones Terrafomr

Terraform proporciona una serie de funciones que pueden ser utilizadas dentro de los archivos de configuración para realizar operaciones y manipulaciones más avanzadas , estos son alguna funciones si quiere ver en detalle 

- `abs:` Devuelve el valor absoluto de un número.
- `ceil:` Redondea un número hacia arriba al entero más cercano.
- `cidrhost:` Obtiene la dirección IP de un host dentro de una subred CIDR.
- `coalesce:` Devuelve el primer valor no nulo de una lista de valores.
- `concat:` Concatena dos o más listas.
- `distinct:` Elimina elementos duplicados de una lista.
- `flatten:` Convierte una lista de listas en una lista plana.
- `keys:` Devuelve las claves de un mapa como una lista.
- `length:` Devuelve la longitud de una lista, conjunto o cadena de texto.
- `lower:` Convierte una cadena de texto a minúsculas.
- `map:` Crea un nuevo mapa a partir de otro aplicando una función a cada par clave-valor.
- `max:` Retorna el valor máximo de una lista de números.
- `merge:` Combina varios mapas en uno solo.
- `min:` Retorna el valor mínimo de una lista de números.
- `regex:` Realiza una búsqueda de expresiones regulares en una cadena de texto.
- `replace:` Reemplaza todas las ocurrencias de una subcadena en una cadena de texto.
- `reverse:` Invierte el orden de una lista.
- `sort:` Ordena una lista en orden ascendente o descendente.
- `timestamp:` Devuelve la marca de tiempo actual en formato RFC3339.
- `upper:` Convierte una cadena de texto a mayúsculas.

<a name="item7"></a>
## Estrucutras de control

estructuras de control son fundamentales en Terraform para realizar operaciones condicionales, iterativas y de manipulación de datos en el código de configuración, lo que permite una gestión más dinámica y flexible de la infraestructura como código. Estos son algunas estrucutras de control hay muchas mas en la documentacion

- `Estructura if y else`:Utilizada para realizar operaciones condicionales basadas en una expresión booleana.
- `Estructura for:`Permite realizar iteraciones o bucles para crear múltiples instancias de un recurso.
- `Estructura for_each:`Similar a for, pero permite crear instancias de recursos basadas en un conjunto de claves y valores.
- `Estructura dynamic:`Utilizada para generar recursos de forma dinámica, especialmente útil para aplicar configuraciones similares a múltiples recursos.
- `Estructura each:`Utilizada en combinación con for_each para acceder a las claves y valores de un mapa durante la creación de recursos.
- `Estructura count:`Permite crear un número específico de instancias de un recurso según un valor numérico.
- `Estructura depends_on:`Establece dependencias explícitas entre recursos, asegurando que ciertos recursos se creen antes que otros.
- `Estructura locals:`Permite definir variables locales dentro del bloque de configuración para reutilizar valores.
- `Estructura terraform:`Utilizada para configurar opciones generales de Terraform, como la versión requerida.
- `Estructura provider:`Especifica el proveedor de servicios en la nube que se utilizará en el proyecto.

## 

