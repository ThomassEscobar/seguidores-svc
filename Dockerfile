# ---- Etapa 1: build ----
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app

# Copiar solo el pom primero para aprovechar la caché de dependencias
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

# Copiar el código y compilar (sin tests para acelerar el build de la imagen)
COPY src ./src
RUN mvn -B -q clean package -DskipTests

# ---- Etapa 2: runtime ----
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Usuario no root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copiar el JAR generado (ajusta el nombre si tu build produce otro)
COPY --from=builder --chown=appuser:appgroup /app/target/*.jar app.jar

USER appuser
EXPOSE 8080

# HEALTHCHECK contra Spring Boot Actuator
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]