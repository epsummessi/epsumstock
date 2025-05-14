# ---- BUILD STAGE ----
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

# 1. Copy wrapper files in separate operations
COPY gradlew .
COPY gradle/wrapper/gradle-wrapper.jar gradle/wrapper/
COPY gradle/wrapper/gradle-wrapper.properties gradle/wrapper/

# 2. Debug: Verify exact files in container
RUN echo "=== DEBUG: Current directory ===" && \
    pwd && ls -la && \
    echo "=== DEBUG: gradle/wrapper ===" && \
    ls -la gradle/wrapper/ && \
    [ -f gradle/wrapper/gradle-wrapper.jar ] || { \
        echo "MISSING FILES:"; \
        find . -type f -name "*.jar"; \
        exit 1; \
    }

# 3. Make gradlew executable
RUN chmod +x gradlew

# 4. Verify Gradle works
RUN ./gradlew --version || { echo "Gradle verification failed"; exit 1; }

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