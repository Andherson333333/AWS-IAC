# Aplicación de Consultas en Lenguaje Natural a SQL con Claude y MCP

Este proyecto permite realizar consultas en lenguaje natural a una base de datos PostgreSQL a través del Protocolo de Contexto de Modelo (MCP). Los usuarios pueden hacer preguntas en español simple, y la aplicación generará la consulta SQL apropiada, la ejecutará y mostrará los resultados.

## Características

- **Interfaz en Lenguaje Natural**: Haz preguntas sobre tu base de datos en español simple
- **Generación de Consultas SQL**: Traducción automática del lenguaje natural a SQL usando Claude
- **Interfaz Web Interactiva**: Aplicación Streamlit fácil de usar
- **Ejemplos de Consultas**: Ejemplos predefinidos para ayudarte a comenzar
- **Exportación de Resultados**: Descarga tus resultados de consulta como archivos CSV
- **Modelos Configurables**: Elige entre diferentes modelos de Claude según tus necesidades

## ¿Qué es el Protocolo de Contexto de Modelo (MCP)?

El Protocolo de Contexto de Modelo (MCP) es un estándar para conectar modelos de lenguaje grandes (LLMs) como Claude con fuentes de datos externas y herramientas. MCP permite a los LLMs interactuar directamente con bases de datos, lo que posibilita consultas en lenguaje natural a datos estructurados sin necesidad de escribir SQL manualmente.

### Características clave de MCP:

- **Conexión Directa**: Proporciona a los LLMs acceso directo a datos estructurados
- **Seguridad**: Los modelos pueden consultar datos sin necesidad de exponer el contenido completo de la base de datos
- **Flexibilidad**: Compatible con diferentes motores de bases de datos como PostgreSQL
- **Interpretación de Esquemas**: El modelo interpreta automáticamente la estructura de la base de datos

## Arquitectura y Flujo de Conexión

La aplicación implementa una arquitectura cliente-servidor que conecta interfaces de usuario con un LLM y una base de datos PostgreSQL. A continuación se detalla cómo funciona el flujo de conexión:

### Componentes Principales:

1. **Interfaz de Usuario (Streamlit)**: Interfaz web donde los usuarios ingresan consultas en lenguaje natural
2. **Cliente MCP (Python)**: Gestiona la comunicación entre la UI, Claude y PostgreSQL
3. **Servidor MCP**: Facilita la conexión entre Claude y la base de datos PostgreSQL
4. **Modelo Claude**: Procesa el lenguaje natural y genera consultas SQL
5. **Base de Datos PostgreSQL**: Almacena y gestiona los datos estructurados


## Beneficios de esta Arquitectura

1. **Separación de Responsabilidades**: Cada componente tiene una función claramente definida
2. **Escalabilidad**: Los componentes pueden escalar de forma independiente
3. **Flexibilidad**: Fácil de adaptar a diferentes motores de bases de datos o modelos de IA
4. **Experiencia de Usuario Mejorada**: Los usuarios no necesitan conocer SQL para consultar datos
5. **Seguridad**: Control de acceso a la base de datos a través del servidor MCP

## Instalación

### Requisitos Previos

- Python 3.7+
- Node.js y npm
- PostgreSQL
- EC2
- AWS CLI

### Paso 1: Actualizar el Sistema e Instalar Node.js

```bash
sudo apt update
sudo apt install -y nodejs npm
```

### Paso 2: Instalar el Servidor MCP para PostgreSQL

```bash
sudo npm install -g @modelcontextprotocol/server-postgres
npm list -g @modelcontextprotocol/server-postgres  # Verificar instalación
```

# Crear un entorno virtual

```
sudo apt install -y python3-venv
python3 -m venv mcp_env
```
# Activar el entorno virtual
source mcp_env/bin/activate
```
pip install anthropic
pip install psycopg2-binary
pip install streamlit
pip install pandas
```
### Paso 4: Instalar PostgreSQL

```bash
sudo apt install -y postgresql postgresql-contrib
```

### Paso 5: Configurar PostgreSQL

```bash
# Acceder a PostgreSQL como usuario postgres
sudo -i -u postgres
psql

# Crear un usuario para la aplicación
CREATE USER mcp_user WITH PASSWORD '123456';
\du  # Verificar creación del usuario

# Crear una base de datos y otorgar privilegios
CREATE DATABASE mcp_db OWNER mcp_user;
GRANT ALL PRIVILEGES ON DATABASE mcp_db TO mcp_user;
\l  # Listar bases de datos
\q  # Salir de psql
```

### Paso 6: Crear Esquema de Base de Datos y Datos de Ejemplo

```bash
# Conectarse a la base de datos como mcp_user
PGPASSWORD=123456 psql -U mcp_user -d mcp_db
```

#### Crear Tablas

```sql
-- Crear tabla de departamentos
CREATE TABLE departamentos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(100) NOT NULL
);

-- Crear tabla de empleados
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    fecha_contratacion DATE NOT NULL,
    salario NUMERIC(10,2) NOT NULL,
    departamento_id INTEGER REFERENCES departamentos(id)
);

-- Crear tabla de proyectos
CREATE TABLE proyectos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    presupuesto NUMERIC(12,2) NOT NULL,
    estado VARCHAR(20) NOT NULL
);

-- Crear tabla de asignaciones
CREATE TABLE asignaciones (
    empleado_id INTEGER REFERENCES empleados(id),
    proyecto_id INTEGER REFERENCES proyectos(id),
    fecha_asignacion DATE NOT NULL,
    rol VARCHAR(100) NOT NULL,
    PRIMARY KEY (empleado_id, proyecto_id)
);
```

#### Insertar Datos de Ejemplo

```sql
-- Insertar datos en departamentos
INSERT INTO departamentos (nombre, ubicacion) VALUES
('Tecnología', 'Piso 3'),
('Recursos Humanos', 'Piso 1'),
('Ventas', 'Piso 2'),
('Marketing', 'Piso 2'),
('Finanzas', 'Piso 4');

-- Insertar datos en empleados
INSERT INTO empleados (nombre, apellido, email, fecha_contratacion, salario, departamento_id) VALUES
('Juan', 'Pérez', 'juan.perez@empresa.com', '2020-03-15', 75000.00, 1),
('María', 'González', 'maria.gonzalez@empresa.com', '2019-07-10', 68000.00, 2),
('Carlos', 'Rodríguez', 'carlos.rodriguez@empresa.com', '2021-01-20', 82000.00, 3),
('Ana', 'Martínez', 'ana.martinez@empresa.com', '2020-11-05', 79000.00, 1),
('Roberto', 'López', 'roberto.lopez@empresa.com', '2018-05-12', 90000.00, 5),
('Laura', 'Sánchez', 'laura.sanchez@empresa.com', '2022-02-28', 65000.00, 4),
('Miguel', 'Torres', 'miguel.torres@empresa.com', '2021-08-15', 71000.00, 3);

-- Insertar datos en proyectos
INSERT INTO proyectos (nombre, fecha_inicio, fecha_fin, presupuesto, estado) VALUES
('Implementación ERP', '2022-02-01', '2022-11-30', 250000.00, 'Completado'),
('Desarrollo App Móvil', '2022-04-15', '2023-02-15', 180000.00, 'En progreso'),
('Migración Cloud', '2022-06-01', NULL, 350000.00, 'En progreso'),
('Rediseño Web', '2022-03-10', '2022-07-30', 95000.00, 'Completado'),
('Automatización Procesos', '2022-08-01', NULL, 120000.00, 'Planificación');

-- Insertar datos en asignaciones
INSERT INTO asignaciones (empleado_id, proyecto_id, fecha_asignacion, rol) VALUES
(1, 1, '2022-02-01', 'Desarrollador Backend'),
(1, 3, '2022-06-01', 'DevOps Engineer'),
(2, 1, '2022-02-15', 'Coordinador'),
(3, 2, '2022-04-15', 'Gerente de Proyecto'),
(4, 2, '2022-04-20', 'Diseñador UX'),
(4, 4, '2022-03-10', 'Diseñador UI'),
(5, 3, '2022-06-15', 'Analista Financiero'),
(5, 5, '2022-08-01', 'Coordinador'),
(6, 4, '2022-03-15', 'Especialista SEO'),
(7, 2, '2022-05-01', 'Desarrollador Frontend');

-- Verificar los datos
SELECT * FROM departamentos;
SELECT * FROM empleados;
SELECT * FROM proyectos;
SELECT * FROM asignaciones;

-- Salir de psql
\q
```

## Ejecutar la Aplicación

### Paso 1: Configurar Variables de Entorno (Opcional)

```bash
export ANTHROPIC_API_KEY="tu_clave_api_aquí"
export PG_CONNECTION="postgresql://mcp_user:123456@localhost:5432/mcp_db"
```

### Paso 2: Ejecutar la Aplicación Streamlit

```bash
streamlit run streamlit_app.py
```

La aplicación estará disponible en http://localhost:8501 por defecto.

## Uso

1. Ingresa tu clave API de Anthropic en la barra lateral (si no está configurada mediante variables de entorno)
2. Verifica la cadena de conexión de PostgreSQL
3. Ingresa una pregunta en lenguaje natural sobre la base de datos (por ejemplo, "¿Cuántos empleados hay en cada departamento?")
4. Haz clic en "Ejecutar consulta" para procesar tu solicitud
5. Ve los resultados, la consulta SQL y la respuesta completa de Claude en las pestañas
6. Descarga los resultados como CSV si es necesario

## Ejemplos de Consultas

- ¿Cuántos empleados hay en el departamento de Tecnología?
- ¿Cuál es el salario promedio por departamento?
- ¿Qué proyectos están actualmente en progreso?
- ¿Quién es el empleado con mayor salario?
- ¿En qué proyectos participa Juan Pérez?

## Archivos en este Proyecto

- **mcp_client.py**: Funcionalidad principal para conectar Claude con PostgreSQL
- **streamlit_app.py**: Interfaz web para la aplicación

## Requisitos

- Clave API de Anthropic (acceso a Claude)
- Base de datos PostgreSQL
- Node.js y npm
- Python 3.7+
- Paquetes de Python requeridos: anthropic, psycopg2-binary, streamlit, pandas

## Solución de Problemas

- Si encuentras problemas de conexión, verifica que PostgreSQL esté en ejecución
- Comprueba que el servidor del Protocolo de Contexto de Modelo esté instalado correctamente
- Verifica tu clave API y la cadena de conexión de PostgreSQL
- Si las consultas se agotan por tiempo, considera usar un modelo de Claude más rápido

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - consulta el archivo LICENSE para más detalles.
