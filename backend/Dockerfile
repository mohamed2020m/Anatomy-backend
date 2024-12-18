# Stage 1: Build
FROM maven:3.9.4-eclipse-temurin-17 AS builder
WORKDIR /app
# Cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B
# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# Copy JAR from build stage
COPY --from=builder /app/target/*.jar app.jar
# Expose port
EXPOSE 8080
# Run application
ENTRYPOINT ["java", "-jar", "app.jar"]
