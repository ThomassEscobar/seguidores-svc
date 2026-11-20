# Toma de Decisiones Técnicas Basada en Orquestación, Observabilidad y Auditoría

## 1. Propósito
Este documento explica cómo las herramientas implementadas en `k8s/`, `monitoring/`, `audit/` y el pipeline de CI/CD transforman métricas, trazas de auditoría y eventos de infraestructura en decisiones de ingeniería objetivas y reproducibles para el microservicio **`seguidores-svc`**.

---

## 2. Matriz de Evidencia y Decisiones Técnicas

| Herramienta / Componente | Señal / Evidencia Generada | Decisión Técnica Habilitada |
| :--- | :--- | :--- |
| **CloudWatch Container Insights** (`pod_cpu_utilization`, `pod_memory_utilization`) | Saturación sostenida de CPU (>70%) o memoria (>80% de `512Mi`) por pod. | **Escalamiento horizontal y Right-Sizing:** El HPA (`k8s/05-hpa.yaml`) escala automáticamente de 2 a 6 réplicas ante picos de carga. Si el uso base en reposo supera el 75% de `256Mi` por la JVM, se ajustan `requests` y parámetros `-XX:MaxRAMPercentage` del contenedor. |
| **Kubernetes Probes + RollingUpdate** (`/actuator/health/readiness` y `liveness`) | Fallo en `readinessProbe` durante el despliegue de una nueva versión o bloqueo de hilos en runtime. | **Protección de disponibilidad y Rollback automático:** `maxUnavailable: 0` impide retirar pods antiguos hasta que los nuevos pasen el healthcheck. Si el nuevo pod no estabiliza en 180s, el pipeline ejecuta `kubectl rollout undo` sin afectar a los usuarios. |
| **Fluent Bit + CloudWatch Logs Insights** (Logs estructurados + `parsers_java.conf`) | Incremento en la métrica `SeguidoresErrorCount` (HTTP 5xx o excepciones `StackTrace` agrupadas). | **Diagnóstico de causa raíz (MTTR):** Permite filtrar por `kubernetes.pod_name` y correlacionar exactamente qué commit (`IMAGE_TAG`) introdujo una regresión o falla de integración antes de que escale a caída total. |
| **Alarmas de CloudWatch** (`low-availability`, `high-memory`, `error-spike`) | Transición de estado `OK` → `ALARM` cuando `pod_number_of_running_containers < 2` o `OOMKilled`. | **Respuesta temprana ante incidentes:** Diferencia entre un fallo de infraestructura (nodo EC2 degradado → EKS reprograma pods) y un bug de aplicación (memory leak → revertir release). |
| **Trivy + Snyk + Checkov** (`security-and-audit` en GitHub Actions) | Detección de CVE críticos en dependencias Maven/Alpine o manifiestos K8s sin `securityContext` ni `limits`. | **Prevención de deuda técnica y riesgo en producción:** Bloquea la promoción de artefactos vulnerables hacia Amazon ECR antes de que lleguen al clúster. |
| **EKS Control Plane Audit Logs + RBAC + NetworkPolicy** (`audit/`) | Registros de auditoría de llamadas al API Server (`audit`) y bloqueo de tráfico no autorizado entre namespaces. | **Cumplimiento y contención de brechas:** Permite auditar quién modificó recursos en `seguidores-prod` y limita el radio de impacto (blast radius) si un contenedor resulta comprometido. |

---

## 3. Consideraciones Arquitectónicas de Estado (Stateless vs. Stateful)
Actualmente `seguidores-svc` utiliza **H2 en memoria** (`jdbc:h2:mem:seguidoresdb`). Al escalar horizontalmente a 2 o más réplicas en EKS, cada pod mantiene su propia instancia aislada en RAM.
* **Decisión operativa:** Para pruebas funcionales y validación de despliegue multi-réplica en EKS, la configuración actual es válida y autocontenida. Para persistencia transaccional compartida entre réplicas en producción, el siguiente paso arquitectónico es migrar el `SPRING_DATASOURCE_URL` del `Secret` (`k8s/02-secret.yaml`) hacia una instancia administrada de **Amazon RDS (PostgreSQL)** dentro de la misma VPC de EKS.