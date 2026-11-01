FROM maven:3.9.9-eclipse-temurin-21-alpine AS build
WORKDIR /workspace
COPY pom.xml .
COPY src ./src
RUN mvn -B clean package -DskipTests

FROM eclipse-temurin:21-jre-alpine
LABEL org.opencontainers.image.source="https://github.com/${{ values.destinationOwner }}/${{ values.component_id }}"
WORKDIR /app
COPY --from=build /workspace/target/*.jar app.jar

ENV PORT=8080 \
    APP_NAME="${{ values.component_id }}" \
    FLUENTD_HOST="fluentd.logging.svc.cluster.local" \
    FLUENTD_PORT="24224"

EXPOSE 8080
ENTRYPOINT ["java", "-Xms128m", "-Xmx256m", "-jar", "/app/app.jar"]
