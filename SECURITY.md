# Política de Seguridad y Escalabilidad - Seguidores Svc

## 1. Escaneo de Dependencias (Dependabot)
- **Frecuencia:** Semanal (lunes).
- **Ecosistemas:** Maven (`pom.xml`) y GitHub Actions.
- **Acción:** Dependabot abrirá Pull Requests automáticos para actualizar dependencias vulnerables o desactualizadas.

## 2. Análisis de Seguridad en el Pipeline (Snyk)
- **Herramienta:** Snyk (Open Source + Code).
- **Momento de ejecución:** Después de los tests unitarios y antes del build de Docker.
- **Umbral de bloqueo:** Severidad **Alta** o **Crítica**.
- **Consecuencia:** Si Snyk detecta una vulnerabilidad que supere el umbral, el job `security` falla, el pipeline se detiene y **no se construye la imagen Docker** (bloqueo automático).

## 3. Escalabilidad (Orquestador)
- **Recursos del contenedor:** Se definen límites en el orquestador (IE5). Para este microservicio se recomienda:
  - **CPU:** 0.5 vCPU (límite), 0.25 vCPU (request).
  - **Memoria:** 512 MB (límite), 256 MB (request).
- **Réplicas:** Configurado para escalar horizontalmente (mínimo 2 réplicas en producción para alta disponibilidad).