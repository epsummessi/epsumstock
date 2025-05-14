# ---- BUILD STAGE ----
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

# 1. First copy only build files (better caching)
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src

# 2. Make gradlew executable and verify wrapper
RUN chmod +x gradlew && \
    ./gradlew --version || { echo "Gradle wrapper verification failed"; exit 1; }

# 3. Build with dependency caching
RUN ./gradlew clean build -x test -x check --no-daemon

# ---- RUNTIME STAGE ----
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Environment configuration
ENV SPRING_PROFILES_ACTIVE=prod \
    PORT=8080

# Copy the built jar (with explicit name)
COPY --from=build /app/build/libs/*-SNAPSHOT.jar app.jar

# Health check (recommended for production)
HEALTHCHECK --interval=30s --timeout=3s \
    CMD wget -q -O /dev/null http://localhost:$PORT/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]