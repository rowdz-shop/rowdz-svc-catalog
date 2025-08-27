# Etapa 1: build
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -q -DskipTests package

# Etapa 2: runtime
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s CMD ["/bin/sh","-c","wget -qO- http://localhost:8080/actuator/health | grep 'UP' >/dev/null || exit 1"]
ENTRYPOINT ["java","-jar","/app/app.jar"]