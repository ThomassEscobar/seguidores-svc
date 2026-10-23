# Seguidores — Microservicio de riesgo seguidores

Microservicio correspondiente al **caso caso12 — DevConnect** (Red social de comunidad profesional) de la Evaluación Parcial N°1.

| Campo | Detalle |
| --- | --- |
| **Alumno** | Thomas Escobar, Nicolas Lagos |
| **Docente** | Mauricio Velasquez |
| **Asignatura** | Ingeniería DevOps — DOY0101 |
| **Stack** | Spring Boot 3.5.12 · Java 21 · Maven · Spring Data JPA · H2 · springdoc-openapi |
| **Calidad** | JaCoCo cobertura LINE 70% · Cucumber (BDD) alineado a endpoints REST |
| **Entrega** | Pipeline % Pruebas |

# Microservicio Seguidores - DevConnect

Este proyecto corresponde al caso 12 de la asignatura y consiste en un microservicio REST para la gestión de seguidores, construido con **Java 21** y **Spring Boot**. Implementa un pipeline de CI/CD completo, integrando pruebas automatizadas, análisis de seguridad, construcción de imágenes Docker optimizadas y despliegue automatizado.

## 🚀 1. Descripción y Ejecución Local

El microservicio expone endpoints para listar, crear, actualizar y eliminar seguidores. Utiliza una base de datos en memoria H2 para facilitar su ejecución local.

Para ejecutarlo localmente sin Docker:
```bash
mvn spring-boot:run

🐳 2. Dockerfile Explicado (IE1)
Se implementó un Dockerfile multi-stage para reducir el tamaño de la imagen final y mejorar la seguridad.

Etapa 1 (Build): Usa la imagen maven:3.9-eclipse-temurin-21 para compilar el proyecto con Maven. Al copiar primero el pom.xml y luego el código, se optimiza la caché de capas de Docker.

Etapa 2 (Runtime): Usa eclipse-temurin:21-jre-alpine, una imagen base ligera. Copia únicamente el archivo .jar generado en la etapa anterior.

Seguridad: Se crea un usuario no root (appuser) y se le asignan los permisos del directorio. El contenedor se ejecuta bajo este usuario.

HEALTHCHECK: Se define un healthcheck apuntando a /actuator/health para que el orquestador conozca el estado real del servicio.

El archivo .dockerignore excluye carpetas como target/, .git/ y docs/ para no enviar basura al contexto de construcción.

⚙️ 3. Pipeline CI/CD (IE1 - IE4)
El pipeline está definido en .github/workflows/docker-build.yml y se ejecuta en cada push a las ramas main y develop.

Etapas del Pipeline:
Test (IE2): Ejecuta mvn verify, corre las pruebas unitarias (JUnit + Mockito) y verifica la cobertura con JaCoCo (mínimo 70%). Sube los reportes como artefactos.

Security (IE3): Ejecuta Snyk (Open Source y SAST) para buscar vulnerabilidades. Si el pipeline falla por temas críticos, el despliegue se detiene.

Docker Build (IE4): Construye la imagen Docker y la etiqueta usando el SHA del commit (para trazabilidad). Guarda la imagen como artefacto .tar.

Deploy (IE4/IE5): Solo se ejecuta en la rama main. Descarga la imagen, levanta el servicio con Docker Compose y verifica que responda al endpoint /actuator/health.

🧪 4. Pruebas y Cobertura (IE2)
Se implementaron pruebas para las capas críticas del microservicio:

Pruebas de Servicio: Verifican la lógica de negocio usando Mockito.

Pruebas de Controlador: Usan MockMvc para validar rutas (200, 201, 204, 404) y validación de datos.

Pruebas de Repositorio: Usan @DataJpaTest para verificar el mapeo con H2.

Se configuró JaCoCo en el pom.xml con un umbral mínimo del 70% de cobertura de líneas. Si la cobertura es menor, el pipeline falla.

🛡️ 5. Seguridad (IE3)
Dependabot: Configurado en .github/dependabot.yml para revisar semanalmente las dependencias de Maven y GitHub Actions.

Snyk: Integrado en el pipeline. Se utiliza con continue-on-error: true para evitar que falsos positivos de vulnerabilidades en frameworks detengan el build, pero se cuenta con la capacidad de configurar --severity-threshold=critical para bloquear el pipeline ante fallos graves.

Política de Bloqueo (SECURITY.md): Si el análisis de seguridad detecta vulnerabilidades críticas explícitas, el job de docker-build no se ejecuta (se marca como skipped), deteniendo el despliegue.

📦 6. Despliegue y Trazabilidad (IE4)
Entorno simulado: El despliegue se realiza en el runner de GitHub Actions usando Docker Compose.

Trazabilidad: La imagen se etiqueta con el SHA corto del commit (mi-micro:a1b2c3d). Se inyecta esta etiqueta al despliegue mediante IMAGE_TAG.

Artefactos: Los reportes de JaCoCo y la imagen Docker (.tar) se guardan como artefactos de la ejecución.

☸️ 7. Orquestación y Escalabilidad (IE5)
El archivo docker-compose.yml define la orquestación del servicio.

Límites de recursos: Se definieron límites de CPU (0.50) y Memoria (512M) para evitar el consumo excesivo.

Réplicas: Aunque el pipeline despliega una instancia en el runner para evitar conflictos de puertos, el archivo de configuración está preparado para escalar horizontalmente (por ejemplo, en Docker Swarm o Kubernetes) usando múltiples réplicas.

Healthchecks: Configurados en el compose y en el Dockerfile para garantizar que el servicio solo reciba tráfico cuando esté listo.

🤖 8. Declaración de Uso de IA
Para el desarrollo de este proyecto, se utilizaron herramientas de Inteligencia Artificial (como ChatGPT) como asistentes de productividad.

¿Cómo se usó? Se utilizó para la generación de boilerplate del pipeline de GitHub Actions, la redacción inicial de los archivos de documentación y la resolución de errores de sintaxis en YAML y Docker.

¿Qué se validó manualmente? Todo el código de negocio Java, las pruebas unitarias y la configuración del pom.xml fueron revisados, adaptados y ejecutados localmente para asegurar su correcto funcionamiento. Las políticas de seguridad y bloqueo fueron diseñadas y comprendidas por el equipo.

Agradecimiento: Se agradece especialmente a la IA (ChatGPT) por su guía paso a paso en la configuración del pipeline, la depuración de errores de Docker y la estructuración de la documentación, lo cual facilitó enormemente el aprendizaje y la implementación de este proyecto.

💭 9. Conclusiones y Reflexiones Individuales
[Conclusión / Thomas Escobar]

A lo largo del desarrollo de este proyecto, mi principal aprendizaje y reflexión es que todo este conjunto de herramientas y conocimientos (CI/CD, Docker, seguridad y pruebas automatizadas) ayuda a comprender de manera profunda el proceso de cómo se manejan los pipelines y el despliegue de software en un nivel mucho más cercano a la realidad empresarial.

Antes de realizar este desarrollo, no tenía una visión clara ni la comprensión de cómo se interconectaban todas estas piezas para llevar un código desde el repositorio local hasta un entorno funcional y seguro. Ahora entiendo el valor de automatizar las pruebas, de escanear vulnerabilidades antes de desplegar, y de cómo herramientas como Docker y GitHub Actions garantizan que el software sea confiable, trazable y escalable. Esta experiencia me ha dado una perspectiva mucho más profesional y realista sobre la ingeniería de software moderna.