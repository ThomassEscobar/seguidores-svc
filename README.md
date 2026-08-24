# Seguidores — Microservicio de riesgo seguidores

Microservicio correspondiente al **caso caso12 — DevConnect** (Red social de comunidad profesional) de la Evaluación Parcial N°1.

| Campo | Detalle |
| --- | --- |
| **Alumno** | Thomas Escobar |
| **Docente** | Mauricio Velasquez |
| **Asignatura** | Ingeniería DevOps — DOY0101 |
| **Stack** | Spring Boot 3.3 · Java 21 · Maven · Spring Data JPA · H2 · springdoc-openapi |
| **Calidad** | JaCoCo cobertura LINE 100% · Cucumber (BDD) alineado a endpoints REST |
| **Entrega** | Docker / Docker Compose |

## Responsabilidad (SRP)

Administra los datos y la lógica del dominio de Seguidores del caso caso12 (DevConnect). Su base de datos es una **H2 en memoria** (un solo microservicio por base), cumpliendo aislamiento de datos por dominio.

## Página de presentación

Al ejecutar el servicio, `http://localhost:8080/` muestra la página de presentación del microservicio con documentación y enlaces a:

- **Swagger UI**: `/swagger-ui/index.html`
- **OpenAPI (yaml)**: `/v3/api-docs.yaml`
- **ReDoc**: `/redoc.html`
- **H2 Console**: `/h2-console`

## Endpoints

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/seguimientos` | Lista todos los recursos |
| GET | `/api/seguimientos/{id}` | Obtiene un recurso por id |
| POST | `/api/seguimientos` | Crea un recurso |
| PUT | `/api/seguimientos/{id}` | Actualiza un recurso |
| DELETE | `/api/seguimientos/{id}` | Elimina un recurso |

## Documentación del proyecto

La documentación completa está en la carpeta [`docs/`](docs/):

- [`docs/00_Resumen.md`](docs/00_Resumen.md) — propósito, responsabilidad y tecnologías
- [`docs/01_Arquitectura.md`](docs/01_Arquitectura.md) — componentes, arquitectura y patrones
- [`docs/02_API.md`](docs/02_API.md) — contrato REST y ejemplos curl
- [`docs/03_Pruebas.md`](docs/03_Pruebas.md) — tests unitarios, cobertura y Cucumber
- [`docs/04_Despliegue.md`](docs/04_Despliegue.md)
- [`docs/05_Justificacion.md`](docs/05_Justificacion.md) — justificación del servicio: RF/RNF/seguridad cubiertos, stack y por qué cada tecnología AWS
- [`docs/diagramas/`](docs/diagramas/) — C4 (contexto, contenedores, componentes), secuencia e infraestructura AWS — Docker, Docker Compose e integración

## Modelo de ramificacion y estructura

Modelo elegido: GitFlow

Elegimos GitFlow porque nos permite organizar el proyecto durante el semestre y mantener separadas las versiones estables de las que están en desarrollo.

| Rama       | Uso                                                   |
| ---------- | ----------------------------------------------------- |
| `main`     | Contiene las versiones estables y entregables.        |
| `develop`  | Integra los cambios antes de pasarlos a `main`.       |
| `feature/` | Para desarrollar nuevas funcionalidades.              |
| `hotfix/`  | Para corregir errores urgentes sin afectar `develop`. |

### Historial de Commits y Orden Cronológico

1. **`main`**
   - `feat: version inicial del microservicio seguidores`[cite: 1]

2. **`main`** (o `develop`)
   - `docs: documentar modelo de ramificacion GitFlow y su justificacion`[cite: 1]

3. **`feature/pagina-presentacion`** *(Pull Request hacia `develop`)*
   - `feat(ui): agregar pie de pagina con version del servicio`[cite: 1]

4. **`feature/changelog`** *(Pull Request hacia `develop`)*
   - `docs: agregar changelog del microservicio seguidores`[cite: 1]

5. **`hotfix/titulo-pagina`** *(Pull Request hacia `main` y merge a `develop`)*
   - `fix(ui): corregir titulo de la pagina principal`[cite: 1]

6. **`develop`**
   - `chore(ci): agregar workflow hola mundo (IE3/IE4)`[cite: 1]


## Cómo ejecutar localmente

```bash
mvn spring-boot:run
```

## Cómo ejecutar con Docker

```bash
docker compose up --build
# http://localhost:8080
```

## Cómo ejecutar las pruebas

```bash
mvn test      # unit tests + Cucumber
mvn verify    # + verificación de cobertura JaCoCo (100% LINE, falla si baja)
```
