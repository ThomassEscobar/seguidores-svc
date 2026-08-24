# Changelog — seguidores-svc

Todas las modificaciones notables de este proyecto serán documentadas en este archivo.

## [1.0.0] - 2026

### Añadido
- Versión inicial del microservicio `seguidores`.
- Página de presentación con Swagger UI, OpenAPI y ReDoc.
- Configuración básica para despliegue local.
- Estrategia y modelo de ramificación GitFlow implementado.
- Workflow de Integración Continua (CI) en GitHub Actions (`hola-mundo.yml`).

### Historial de Commits

- `feat: version inicial del microservicio seguidores`
- `docs: documentar modelo de ramificacion GitFlow y su justificacion`
- `feat(ui): agregar pie de pagina con version del servicio`
- `docs: agregar changelog del microservicio seguidores`
- `fix(ui): corregir titulo de la pagina principal`
- `chore(ci): agregar workflow hola mundo (IE3/IE4)`

| N° | Rama | Evento / Destino | Commit |
| :-: | :--- | :--- | :--- |
| **1** | `main` | Base inicial | `feat: version inicial del microservicio seguidores` |
| **2** | `main` | Documentación | `docs: documentar modelo de ramificacion GitFlow y su justificacion` |
| **3** | `feature/pagina-presentacion` | Pull Request $\rightarrow$ `develop` | `feat(ui): agregar pie de pagina con version del servicio` |
| **4** | `feature/changelog` | Pull Request $\rightarrow$ `develop` | `docs: agregar changelog del microservicio seguidores` |
| **5** | `hotfix/titulo-pagina` | Pull Request $\rightarrow$ `main` (y merge a `develop`) | `fix(ui): corregir titulo de la pagina principal` |
| **6** | `develop` | CI / Integration | `chore(ci): agregar workflow hola mundo (IE3/IE4)` |