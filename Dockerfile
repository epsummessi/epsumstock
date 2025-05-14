# ---- BUILD STAGE ----
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

# 1. Copy wrapper files with explicit paths
COPY gradlew .
COPY gradle gradle

# 2. Verify files were copied correctly
RUN ls -la gradlew && \
    ls -la gradle/wrapper/ && \
    [ -f gradle/wrapper/gradle-wrapper.jar ] || { echo "ERROR: gradle-wrapper.jar missing!"; exit 1; }

# 3. Make gradlew executable
RUN chmod +x gradlew

# 4. Test Gradle wrapper
RUN ./gradlew --version || { echo "ERROR: Gradle wrapper failed"; exit 1; }

# 5. Copy remaining files
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