# ---- BUILD STAGE ----
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

# 1. Copy wrapper files with absolute paths
COPY gradlew .
COPY gradle/wrapper/gradle-wrapper.jar gradle/wrapper/
COPY gradle/wrapper/gradle-wrapper.properties gradle/wrapper/

# 2. Verify files exist in container
RUN echo "=== DEBUG START ===" && \
    pwd && \
    echo "--- Root ---" && ls -la && \
    echo "--- gradle ---" && ls -la gradle/ && \
    echo "--- gradle/wrapper ---" && ls -la gradle/wrapper/ && \
    [ -f gradle/wrapper/gradle-wrapper.jar ] || { \
        echo "FATAL: gradle-wrapper.jar missing!"; \
        find /app -name "*.jar"; \
        exit 1; \
    } && \
    echo "=== DEBUG END ==="

# 3. Make gradlew executable
RUN chmod +x gradlew

# 4. Test Gradle
RUN ./gradlew --version || { echo "Gradle test failed"; exit 1; }

# 5. Copy build files
COPY build.gradle .
COPY settings.gradle .
COPY src src

# 6. Build
RUN ./gradlew clean build -x test -x check --no-daemon

# ---- RUNTIME STAGE ----
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
CMD ["java", "-jar", "app.jar"]