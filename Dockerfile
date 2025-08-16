# ========================
# 1. Build stage
# ========================
FROM maven:3.8.8-eclipse-temurin-17 AS build

# Directorio de trabajo
WORKDIR /app

# Copiar el descriptor de dependencias primero para cachear mejor
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar el código fuente
COPY src ./src

# Construir el jar (cambia 'app.jar' por el nombre real)
RUN mvn clean package -DskipTests

# ========================
# 2. Runtime stage
# ========================
FROM mcr.microsoft.com/openjdk/jdk:17-ubuntu as production

# Directorio de trabajo
WORKDIR /app

# Copiar solo el jar desde el build stage
COPY --from=build /app/target/*.jar app.jar

# Exponer el puerto de Spring Boot
EXPOSE 8080

# Comando de arranque
ENTRYPOINT ["java", "-jar", "/app.jar"]