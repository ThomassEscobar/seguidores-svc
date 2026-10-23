# Seguidores — Microservicio de riesgo seguidores

Microservicio correspondiente al **caso caso12 — DevConnect** (Red social de comunidad profesional) de la Evaluación Parcial N°1.

| Campo | Detalle |
| --- | --- |
| **Alumno** | Thomas Escobar, Nicolas Lagos |
| **Docente** | Mauricio Velasquez |
| **Asignatura** | Ingeniería DevOps — DOY0101 |
| **Stack** | Spring Boot 3.3 · Java 21 · Maven · Spring Data JPA · H2 · springdoc-openapi |
| **Calidad** | JaCoCo cobertura LINE 100% · Cucumber (BDD) alineado a endpoints REST |
| **Entrega** | Pipeline % Pruebas |

# Seguidores Microservice (DevConnect)

## Pipeline de CI/CD y Trazabilidad

Este proyecto cuenta con un pipeline de integración y despliegue continuo (CI/CD) implementado en GitHub Actions, el cual garantiza la calidad del código y la trazabilidad de los despliegues.

### 1. Diagrama del Pipeline
`Test` ➡️ `Security` ➡️ `Docker Build` ➡️ `Deploy`

1. **Test (Calidad):** Ejecuta pruebas unitarias con JUnit y verifica la cobertura con JaCoCo (mínimo 70%). Si falla, el pipeline se detiene.
2. **Security (Seguridad):** Ejecuta Snyk para buscar vulnerabilidades (OS y SAST). Configurado para alertar en severidades altas, pero con política de bloqueo.
3. **Docker Build (Empaquetado):** Construye la imagen Docker.
4. **Deploy (Despliegue):** Despliega en un entorno simulado con Docker Compose.

### 2. Trazabilidad
- **Versionado por Commit:** Cada imagen Docker se etiqueta automáticamente con el SHA corto del commit (`GITHUB_SHA`). Por ejemplo: `mi-micro:a1b2c3d`.
- **Logs y Artefactos:** Los reportes de cobertura (JaCoCo) y los resultados de los tests son subidos como artefactos descargables en cada ejecución de GitHub Actions.
- **Bloqueo por Seguridad:** El pipeline está configurado para no desplegar si los tests fallan o si el análisis de seguridad (Snyk) detecta vulnerabilidades críticas.

### 3. Ejecución Local
```bash
# Levantar el entorno local
docker compose up -d --build

# Verificar salud
curl http://localhost:8080/actuator/health


---

### 📸 Evidencia para el IE4

Una vez hagas push a `main` (recuerda que el deploy solo corre en `main`), ve a GitHub Actions y verifica:
1. El job `deploy` aparece en la lista de jobs y está en **verde** ✅.
2. Haz clic en `deploy` y toma captura de la sección **"Post-deploy Verification"** donde se ve el `curl` exitoso al `/actuator/health`.
3. Toma captura de tu `README.md` abierto en GitHub mostrando el diagrama y la sección de trazabilidad.
4. (Opcional) Muestra la lista de artefactos al final del run, donde aparecerá la imagen `docker-image.tar` y el `jacoco-report`.

¡Con esto tienes el IE4 cerrado y además dejaste preparado el `docker-compose.yml` con los límites de CPU y memoria para el IE5! 🚀